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

import json
import langchain
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser


class Langchain:
    @staticmethod
    def create_chat_chain(
        openai_api_key,
        model_name="gpt-4o-mini",
        temperature=0,
        prompt_template=None,
        callbacks=[],
    ):
        prompt = ChatPromptTemplate.from_messages(prompt_template)

        llm = ChatOpenAI(
            openai_api_key=openai_api_key,
            model_name=model_name,
            temperature=temperature,
            callbacks=callbacks,
        )

        chain = prompt | llm | StrOutputParser()

        return chain


def get_coordinates_from_location(
    openai_api_key,
    location,
    model_name="gpt-4o-mini",
    temperature=0,
):
    chain = Langchain.create_chat_chain(
        openai_api_key,
        model_name,
        temperature,
        [
            (
                "system",
                "You are a helpful assistant that provides geographical coordinates in provided format.",
            ),
            (
                "user",
                f"Provide the longitude and latitude of {location} in this format: latitude=xx&latitude=xx",
            ),
        ],
        [],
    )
    return extract_coordinates(chain.invoke({}))


def extract_wind_speed_from_weather_data(
    openai_api_key,
    weather_data,
    model_name="gpt-4o-mini",
    temperature=0,
):
    weather_data = json.dumps(weather_data).replace("{", "{{").replace("}", "}}")

    chain = Langchain.create_chat_chain(
        openai_api_key,
        model_name,
        temperature,
        [
            (
                "system",
                "You are a helpful assistant that provides weather updates in a friendly manner.",
            ),
            (
                "user",
                "Generate a friendly message about the wind speed from this JSON response: {weather_data}",
            ),
        ],
        [],
    )
    return chain.invoke({"weather_data": weather_data})


def extract_temperature_from_weather_data(
    openai_api_key,
    weather_data,
    model_name="gpt-4o-mini",
    temperature=0,
):
    weather_data = json.dumps(weather_data).replace("{", "{{").replace("}", "}}")

    chain = Langchain.create_chat_chain(
        openai_api_key,
        model_name,
        temperature,
        [
            (
                "system",
                "You are a helpful assistant that provides weather updates in a friendly manner.",
            ),
            (
                "user",
                f"Generate a friendly message about the temperature from this JSON response: {weather_data}",
            ),
        ],
        [],
    )
    return chain.invoke({})


def extract_coordinates(text):
    # Split the text into parts based on '&' and '='
    parts = text.split("&")

    # Extract latitude and longitude
    for part in parts:
        if "latitude" in part:
            latitude = part.split("=")[1].rstrip(".")
        elif "longitude" in part:
            longitude = part.split("=")[1].rstrip(".")

    return {"latitude": latitude, "longitude": longitude}


if __name__ == "__main__":
    langchain.verbose = False
    langchain.debug = False
    langchain.llm_cache = False
