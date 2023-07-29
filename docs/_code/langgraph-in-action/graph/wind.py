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

import os
import json
from typing import TypedDict, Dict
from langgraph.graph import StateGraph, START, END
from .langchain import get_coordinates_from_location
from .api import get_weather_data
from .langchain import extract_wind_speed_from_weather_data


class WindState(TypedDict):
    location: str
    longitude: str
    latitude: str
    weather: str
    wind: str
    messages: list[Dict[str, str]]


def collect_location(state: WindState) -> WindState:
    if not state.get("location"):
        state["location"] = input("Please enter the city name: ")

    state["messages"].append({"role": "user", "content": state.get("location")})
    return state


def get_coordinates(state: WindState) -> WindState:
    if state.get("location"):
        try:
            coordinates = get_coordinates_from_location(
                os.environ.get("OPENAI_API_KEY"), state.get("location")
            )
            state["latitude"] = coordinates.get("latitude")
            state["longitude"] = coordinates.get("longitude")
        except Exception:
            state["location"] = ""
    state["messages"].append(
        {
            "role": "user",
            "content": f"latitude: {state.get('latitude')}, longitude: {state.get('longitude')}",
        }
    )
    return state


def fetch_wind_with_coordinates(state: WindState) -> WindState:
    if state.get("latitude") and state.get("longitude"):
        try:
            weather_data = get_weather_data(
                state.get("latitude"), state.get("longitude")
            )
            state["weather"] = json.dumps(weather_data)
        except Exception:
            pass
    return state


def format_wind_output(state: WindState) -> WindState:
    if state.get("weather"):
        try:
            state["wind"] = extract_wind_speed_from_weather_data(
                os.environ.get("OPENAI_API_KEY"), state.get("weather")
            )
        except Exception:
            pass
    state["messages"].append({"role": "system", "content": state.get("wind")})
    return state


wind_graph = StateGraph(WindState)

wind_graph.add_node("collect_location", collect_location)
wind_graph.add_node("get_coordinates", get_coordinates)
wind_graph.add_node("fetch_wind_with_coordinates", fetch_wind_with_coordinates)
wind_graph.add_node("format_wind_output", format_wind_output)

wind_graph.add_edge(START, "collect_location")
wind_graph.add_edge("collect_location", "get_coordinates")
wind_graph.add_edge("get_coordinates", "fetch_wind_with_coordinates")
wind_graph.add_edge("fetch_wind_with_coordinates", "format_wind_output")
wind_graph.add_edge("format_wind_output", END)
