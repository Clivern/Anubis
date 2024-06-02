# MIT License
#
# Copyright (c) 2025 Clivern
#
# This software is licensed under the MIT License. The full text of the license
# is provided below.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import logging
import requests
from typing import Dict, Optional, Tuple
from mcp.server.fastmcp import FastMCP
from core.middleware.auth import get_api_key

logger = logging.getLogger(__name__)


def get_coordinates_from_location(location: str) -> Optional[Tuple[float, float]]:
    """
    Get latitude and longitude coordinates from a location name using Open-Meteo's geocoding API.

    Args:
        location: The location name (e.g., "London", "New York", "Tokyo")

    Returns:
        Tuple of (latitude, longitude) if found, None otherwise
    """
    try:
        # Use Open-Meteo's geocoding API
        geocoding_url = "https://geocoding-api.open-meteo.com/v1/search"

        params = {"name": location, "count": 1, "language": "en", "format": "json"}

        response = requests.get(geocoding_url, params=params, timeout=10)
        response.raise_for_status()

        data = response.json()

        if "results" in data and len(data["results"]) > 0:
            result = data["results"][0]
            latitude = result["latitude"]
            longitude = result["longitude"]
            logger.info(f"Found coordinates for '{location}': {latitude}, {longitude}")
            return latitude, longitude
        else:
            logger.info(f"No coordinates found for location: {location}")
            return None

    except Exception as e:
        logger.error(f"Error parsing geocoding response for '{location}': {e}")
        return None


def get_weather_by_coordinates(latitude: float, longitude: float) -> Optional[Dict]:
    """
    Get current weather data using latitude and longitude coordinates.

    Args:
        latitude: The latitude coordinate
        longitude: The longitude coordinate

    Returns:
        Weather data dictionary if successful, None otherwise
    """
    try:
        weather_url = "https://api.open-meteo.com/v1/forecast"

        params = {
            "latitude": latitude,
            "longitude": longitude,
            "current_weather": "true",
        }

        response = requests.get(weather_url, params=params, timeout=10)
        response.raise_for_status()

        data = response.json()
        logger.info(f"Weather data retrieved for coordinates {latitude}, {longitude}")

        return data

    except Exception as e:
        logger.error(f"Error fetching weather data: {e}")
        return None


def register_weather_tools(mcp: FastMCP):
    """Register weather-related tools with the MCP server"""

    @mcp.tool()
    def get_weather(location: str) -> Dict:
        """
        Get current weather for a location.

        Args:
            location: The location name (e.g., "London", "New York", "Tokyo")

        Returns:
            Dictionary containing weather information
        """
        # Get the current user's token
        api_key = get_api_key()
        logger.info(f"Tool 'get_weather' called for location: {location}")

        # Get coordinates from location name
        coordinates = get_coordinates_from_location(location)
        if not coordinates:
            return {
                "error": f"Could not find coordinates for location: {location}",
                "success": False,
            }

        latitude, longitude = coordinates

        # Get weather data using coordinates
        weather_data = get_weather_by_coordinates(latitude, longitude)
        if not weather_data:
            return {
                "error": f"Could not fetch weather data for {location}",
                "success": False,
            }

        # Extract current weather information
        current_weather = weather_data.get("current_weather", {})
        weather_units = weather_data.get("current_weather_units", {})

        return {
            "location": location,
            "coordinates": {"latitude": latitude, "longitude": longitude},
            "temperature": f"{current_weather.get('temperature')} {weather_units.get('temperature', '°C')}",
            "windspeed": f"{current_weather.get('windspeed')} {weather_units.get('windspeed', 'km/h')}",
            "winddirection": f"{current_weather.get('winddirection')} {weather_units.get('winddirection', '°')}",
            "weathercode": current_weather.get("weathercode"),
            "time": current_weather.get("time"),
            "success": True,
        }
