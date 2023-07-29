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
from .langchain import extract_temperature_from_weather_data


class TemperatureState(TypedDict):
    location: str
    longitude: str
    latitude: str
    weather: str
    temperature: str
    messages: list[Dict[str, str]]


def collect_location(state: TemperatureState) -> TemperatureState:
    if not state.get("location"):
        state["location"] = input("Please enter the city name: ")

    state["messages"].append({"role": "user", "content": state.get("location")})
    return state


def get_coordinates(state: TemperatureState) -> TemperatureState:
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


def fetch_temperature_with_coordinates(state: TemperatureState) -> TemperatureState:
    if state.get("latitude") and state.get("longitude"):
        try:
            weather_data = get_weather_data(
                state.get("latitude"), state.get("longitude")
            )
            state["weather"] = json.dumps(weather_data)
        except Exception:
            pass
    return state


def format_temperature_output(state: TemperatureState) -> TemperatureState:
    if state.get("weather"):
        try:
            state["temperature"] = extract_temperature_from_weather_data(
                os.environ.get("OPENAI_API_KEY"), state.get("weather")
            )
        except Exception:
            pass
    state["messages"].append({"role": "system", "content": state.get("temperature")})
    return state


temperature_graph = StateGraph(TemperatureState)

temperature_graph.add_node("collect_location", collect_location)
temperature_graph.add_node("get_coordinates", get_coordinates)
temperature_graph.add_node(
    "fetch_temperature_with_coordinates", fetch_temperature_with_coordinates
)
temperature_graph.add_node("format_temperature_output", format_temperature_output)

temperature_graph.add_edge(START, "collect_location")
temperature_graph.add_edge("collect_location", "get_coordinates")
temperature_graph.add_edge("get_coordinates", "fetch_temperature_with_coordinates")
temperature_graph.add_edge(
    "fetch_temperature_with_coordinates", "format_temperature_output"
)
temperature_graph.add_edge("format_temperature_output", END)
