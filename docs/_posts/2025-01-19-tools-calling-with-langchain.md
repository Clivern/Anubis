---
title: Tools Calling with Langchain
date: 2025-01-19 00:00:00
featured_image: https://images.unsplash.com/photo-1595066988978-c2686505d56f?q=90&fm=jpg&w=1000&fit=max
excerpt: When constructing a langchain agent, you can provide tools to allow the agent to access up-to-date information and tailor its answers based on the latest data.
keywords: langchain, langgraph, ai, agentic-systems
---

![](https://images.unsplash.com/photo-1595066988978-c2686505d56f?q=90&fm=jpg&w=1000&fit=max)

When constructing a langchain agent, you can provide tools to allow the agent to access up-to-date information and tailor its answers based on the latest data.

Tools in [langchain](https://python.langchain.com/docs/tutorials/) allows AI agents to interact with external functions and data sources, expanding their capabilities beyond simple text generation.

I am going to use the following packages to create tools for current date, time and weather.

```
langchain==0.3.21
langchain-openai==0.3.9
requests==2.32.3
openai==1.67.0
langchain-tools==0.1.34
pytz==2025.2
```

Below is a Python implementation of a Langchain agent:

```python
# main.py
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
        [Langchain.get_current_utc_date, Langchain.get_current_utc_time, Langchain.get_city_weather],
    )

    print(chain.invoke({"input": input}).get("output"))
```

To execute the script:

```zsh
$ export OPENAI_API_KEY=XXXXXXX
$ python main.py

The current UTC date is January 19, 2025.
```

You can see the [full source code here on github]https://github.com/Clivern/Matrix/tree/main/docs/_code/tools-calling-with-langchain) and very [detailed reference at langchain blog](https://blog.langchain.dev/tool-calling-with-langchain/)
