---
title: Building a Secure MCP Server for Weather
date: 2025-07-17 00:00:00
featured_image: https://images.unsplash.com/photo-1643755338284-0a5a8be76483?q=90&fm=jpg&w=1000&fit=max
excerpt: Learn how to build a secure Model Context Protocol (MCP) server for weather data with authentication, geocoding, and production-ready deployment using FastMCP and Open-Meteo APIs.
keywords: mcp, model-context-protocol, weather,fastapi
---

![](https://images.unsplash.com/photo-1643755338284-0a5a8be76483?q=90&fm=jpg&w=1000&fit=max)

Ever wanted to build your own weather API that AI models can actually use? Today we're going to create a secure MCP (Model Context Protocol) server that gives AI assistants the power to check the weather anywhere in the world. We'll add proper authentication, geocoding (so you can just say "London" instead of coordinates), and make it production-ready with Docker.

#### What's MCP Anyway?

Think of MCP as a translator between AI models and the real world. It's a standard that lets AI assistants call functions, grab data, and interact with external systems in a secure way. Instead of AI models being stuck with their training data, they can now reach out and touch the real world - like checking the weather, reading files, or calling APIs.

#### Let's Get Started

First, let's create our project folder and get organized:

```bash
mkdir secure-weather-mcp-server
cd secure-weather-mcp-server
```

Create the project structure:

```
secure-weather-mcp-server/
├── core/
│   ├── __init__.py
│   ├── middleware/
│   │   ├── __init__.py
│   │   └── auth.py
│   └── tools/
│       ├── __init__.py
│       └── weather.py
├── app.py
├── pyproject.toml
├── Dockerfile
├── Makefile
└── README.md
```

#### Setting Up Dependencies

Let's create our `pyproject.toml` file to manage our Python packages:

```toml
[project]
name = "secure-weather-mcp-server"
version = "0.1.0"
description = "Secure MCP Server For Weather"
readme = "README.md"
requires-python = ">=3.11"
dependencies = [
    "fastmcp",
    "uvicorn[standard]",
    "fastapi",
    "requests"
]
```

#### Adding Security

We don't want just anyone calling our weather API! Let's create our authentication middleware in `core/middleware/auth.py`. Also this can be used to get the client API key and maybe use it to call third party service like their digitalocean account.

```python
import logging
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware

logger = logging.getLogger(__name__)

# Global variable to store the current request context
_current_request = None

def set_current_request(request: Request):
    """Set the current request for tools to access"""
    global _current_request
    _current_request = request

def get_api_key():
    """Get the current user's API key"""
    global _current_request

    if _current_request and hasattr(_current_request.state, "api_key"):
        return _current_request.state.api_key

    return None

class AuthMiddleware(BaseHTTPMiddleware):
    """Middleware for Handling Authentication and Authorization"""

    async def dispatch(self, request: Request, call_next):
        # Set the current request context for tools to access
        set_current_request(request)

        # Only require authentication for actual MCP tool calls
        if (
            request.url.path == "/mcp"
            and request.method == "POST"
            and "application/json" in request.headers.get("content-type", "")
        ):
            # Extract and store the API key from request headers
            api_key = request.headers.get("X-API-KEY")

            if api_key:
                # Store API key in request state for tools to access
                request.state.api_key = api_key
                logger.info(f"API key stored: {api_key}")
            else:
                request.state.api_key = None
                logger.info("No valid X-API-KEY header found for MCP tool call")
                raise HTTPException(
                    status_code=401,
                    detail="X-API-KEY header required for MCP tool calls",
                )
        else:
            # For non-tool-call requests, just log but don't require authentication
            logger.info(
                f"Non-tool-call request to {request.url.path} ({request.method}) - no authentication required"
            )
            request.state.api_key = None

        # Continue with the request
        response = await call_next(request)
        return response
```

#### Building the Weather Magic

Let's create our weather tools in `core/tools/weather.py`. This is where the real magic happens. We will turns "London" into actual coordinates using Open-Meteo's free geocoding API and then Grab current weather info using those coordinates.

```bash
$ curl -s "https://geocoding-api.open-meteo.com/v1/search?name=london&count=1&language=en&format=json" | jq .
{
  "results": [
    {
      "id": 2643743,
      "name": "London",
      "latitude": 51.50853,
      "longitude": -0.12574,
      "elevation": 25.0,
      "feature_code": "PPLC",
      "country_code": "GB",
      "admin1_id": 6269131,
      "admin2_id": 2648110,
      "timezone": "Europe/London",
      "population": 8961989,
      "country_id": 2635167,
      "country": "United Kingdom",
      "admin1": "England",
      "admin2": "Greater London"
    }
  ],
  "generationtime_ms": 0.6403923
}

$ curl -s "https://api.open-meteo.com/v1/forecast?latitude=51.50853&longitude=-0.12574&current_weather=true" | jq .
{
  "latitude": 51.5,
  "longitude": -0.120000124,
  "generationtime_ms": 0.053763389587402344,
  "utc_offset_seconds": 0,
  "timezone": "GMT",
  "timezone_abbreviation": "GMT",
  "elevation": 23.0,
  "current_weather_units": {
    "time": "iso8601",
    "interval": "seconds",
    "temperature": "°C",
    "windspeed": "km/h",
    "winddirection": "°",
    "is_day": "",
    "weathercode": "wmo code"
  },
  "current_weather": {
    "time": "2025-08-26T11:30",
    "interval": 900,
    "temperature": 21.9,
    "windspeed": 16.4,
    "winddirection": 241,
    "is_day": 1,
    "weathercode": 3
  }
}
```

Here is the tool I created using the above requests to get the weather from location.

```python
import logging
import requests
from typing import Dict, Optional, Tuple
from mcp.server.fastmcp import FastMCP
from core.middleware.auth import get_api_key

logger = logging.getLogger(__name__)

def get_coordinates_from_location(location: str) -> Optional[Tuple[float, float]]:
    """
    Get latitude and longitude coordinates from a location name using Open-Meteo's geocoding API.
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
```

#### Tying It All Together

Now let's create our main application file `app.py` that brings everything together:

```python
import argparse
import logging
from mcp.server.fastmcp import FastMCP
import uvicorn

# Import core modules
from core.middleware.auth import AuthMiddleware
from core.tools.weather import register_weather_tools

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create an MCP server
mcp = FastMCP("Weather MCP Server")

def register_all_components(mcp: FastMCP):
    """Register all MCP components"""
    register_weather_tools(mcp)
    logger.info("All MCP components registered successfully")

# Register components
register_all_components(mcp)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run MCP server")
    parser.add_argument("--host", default="0.0.0.0", help="Host to bind to")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind to")

    args = parser.parse_args()

    # Create the HTTP app and add middleware
    app = mcp.streamable_http_app()
    app.add_middleware(AuthMiddleware)

    # Run as HTTP server
    print(f"Starting MCP HTTP server on {args.host}:{args.port}")
    print("Authentication middleware enabled - Authorization header required")
    uvicorn.run(app, host=args.host, port=args.port)
```

#### Making Development Easier

Let's create a `Makefile` so we don't have to remember all these commands. You need to install [uv](https://docs.astral.sh/uv/getting-started/installation/)

```makefile
.PHONY: help install run run-custom clean

help: ## Show this help message
	@echo "Available commands:"
	@echo "  install     - Install dependencies using uv sync"
	@echo "  run         - Run the server on localhost:8000"
	@echo "  run-custom  - Run the server with custom host and port"
	@echo "  clean       - Clean up any temporary files"
	@echo ""
	@echo "Examples:"
	@echo "  make install"
	@echo "  make run"
	@echo "  make run-custom HOST=0.0.0.0 PORT=9000"

install: ## Install dependencies
	uv sync

run: ## Run the server on localhost:8000
	uv run python app.py

run-custom: ## Run the server with custom host and port (e.g., make run-custom HOST=0.0.0.0 PORT=9000)
	uv run python app.py --host $(HOST) --port $(PORT)

clean: ## Clean up temporary files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type f -name "*.log" -delete
```

Now let's start up our server:

```bash
make install
make run
```

#### Testing the Server

Test the server with `Cursor AI` IDE or other AI IDEs like Github `Copilot`, `Trae` AI ... etc:

```json
{
  "mcpServers": {
    "luchian": {
      "url": "http://localhost:8000/mcp",
      "headers": {
        "X-API-KEY": "315bbc9c-7441-415e-a68a-070b93ff2c0e"
      }
    }
  }
}
```

#### Running with Docker

Let's create a `Dockerfile` so we can deploy this thing anywhere:

```dockerfile
FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml ./

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e .

# Copy application code
COPY . .

# Expose the port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "app.py", "--host", "0.0.0.0", "--port", "8000"]
```

Now let's build and run our container:

```bash
docker build -t weather-mcp-server .
docker run -p 8000:8000 weather-mcp-server
```

#### Resources

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [FastMCP GitHub Repository](https://github.com/jlowin/fastmcp)
- [Open-Meteo API Documentation](https://open-meteo.com/en/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)

You can see the [full source code here on github](https://github.com/Clivern/Anubis/tree/main/docs/_code/building-secure-mcp-server-for-weather)