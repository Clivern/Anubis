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
import pytz
import langchain
from datetime import datetime
from langchain_core.tools import tool
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain.agents import create_tool_calling_agent, AgentExecutor


langchain.verbose = True
langchain.debug = True
langchain.llm_cache = False


class Langchain:
    """Langchain Class"""

    @staticmethod
    def create_an_agent(
        openai_api_key: str,
        prompt_template: list,
        tools: list = [],
        model_name: str = "gpt-4o-mini",
        temperature: int = 0,
        callbacks: list = [],
        verbose: bool = True,
    ):
        prompt = ChatPromptTemplate.from_messages(prompt_template)

        llm = ChatOpenAI(
            openai_api_key=openai_api_key,
            model_name=model_name,
            temperature=temperature,
            callbacks=callbacks,
        )

        agent = create_tool_calling_agent(llm, tools, prompt)
        executor = AgentExecutor(agent=agent, tools=tools, verbose=verbose)
        return executor

    @staticmethod
    @tool
    def get_current_utc_time() -> str:
        """Get the current UTC time."""
        utc_now = datetime.now(pytz.utc).strftime("%H:%M:%S")
        return f"The current UTC time is {utc_now}"

    @staticmethod
    @tool
    def get_current_utc_date() -> str:
        """Get the current UTC date."""
        utc_now = datetime.now(pytz.utc).strftime("%Y-%m-%d")
        return f"The current UTC date is {utc_now}"

    @staticmethod
    @tool
    def get_city_weather(city_name: str) -> str:
        """Get the weather of a city

        Args:
            city_name (str): The city name
        """
        # update to use an API
        return "it is sunny 20 celsius"


if __name__ == "__main__":
    input = "What is the current date?"

    chain = Langchain.create_an_agent(
        os.environ.get("OPENAI_API_KEY"),
        [
            (
                "system",
                "you're a helpful assistant",
            ),
            (
                "user",
                "{input}",
            ),
            ("placeholder", "{agent_scratchpad}"),
        ],
        [
            Langchain.get_current_utc_date,
            Langchain.get_current_utc_time,
            Langchain.get_city_weather,
        ],
    )

    print(chain.invoke({"input": input}).get("output"))
