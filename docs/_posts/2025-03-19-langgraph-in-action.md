---
title: Langgraph In Action
date: 2025-03-19 00:00:00
featured_image: https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max
excerpt: LangGraph library enables agent orchestration — offering customizable architectures, long-term memory, and human-in-the-loop to reliably handle complex tasks.
keywords: langchain, langgraph, ai, agentic-systems
---

![](https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max)

It took me a while to understand why I need [LangGraph](https://langchain-ai.github.io/langgraph/) when I can use [LangChain](https://python.langchain.com/docs/introduction/) to build agents.

According to the documentation, [LangChain]](https://python.langchain.com/docs/introduction/) provides integrations and composable components to streamline Large Language Model (LLM) application development.

While the [LangGraph](https://langchain-ai.github.io/langgraph/) library enables agent orchestration—offering customizable architectures, long-term memory, and human-in-the-loop capabilities to reliably handle complex tasks.

[LangChain](https://python.langchain.com/docs/introduction/) focuses on `LLM` interactions and provides tools for building simple workflows, such as content generation or customer support.

On the other hand, [LangGraph](https://langchain-ai.github.io/langgraph/) is used to build complex workflows using a `graph-based` approach, suitable for managing multiple `agents` and conditional logic.

Imagine we are building a chatbot for a travel company. Here are a few examples of the types of conversations we expect to receive:

```
Customer A: Hey there
Bot: Hey there, How can i help you today!

Customer A: I need to check my flight status
Bot: What is the itinerary id?

Customer A: The itinerary id is 37hstgdss
Bot: Well, your flight will be on time on 1 April 2025 .... etc

Customer A: Thanks
Bot: Most welcome!
```

```
Customer B: Hey there
Bot: Hey there, How can i help you today!

Customer B: I need to cancel my flight
Bot: What is the itinerary id?

Customer B: The itinerary id is 37hstgdss
Bot: I found it, are your sure?

Customer B: Yes
Bot: Okay cancelled, We will send an email with the refund steps!

Customer B: Thanks
Bot: Most welcome!
```

```
Customer C: Hey there
Bot: Hey there, How can i help you today!

Customer C: I need a number to call the support team
Bot: You can reach our support team with this number +23339726632

Customer C: Thanks
Bot: Most welcome!
```

From these conversations, you can see that the bot needs to handle different workflows:
- A flow to cancel flights.
- A flow to answer general questions, such as providing a support number.
- A flow to check the flight status.

Both [LangChain](https://python.langchain.com/docs/introduction/) and [LangGraph](https://langchain-ai.github.io/langgraph/) are necessary for this setup. [LangGraph](https://langchain-ai.github.io/langgraph/) will be used to build all the required workflows, while [LangChain](https://python.langchain.com/docs/introduction/) can handle `LLM` interactions. There will be many `LLM` interactions, such as determining user intent and formatting user inputs.

Now i will be building a smaller agent that shall answer questions about the wind and termperature. The same things we do can be applied to a bigger chat agent. Here is a graph of what i want to achieve.

![](/images/blog/langgraph_graph01.png)

As you can see, we need to build two graphs with [LangGraph](https://langchain-ai.github.io/langgraph/):
- `Wind` graph to handle wind queries.
- `Termperature` graph to handle termperature queries.

Then we build a `router` that sends the user to the appropriate graph based on their `intent`.

Before we build our first graph, let's explain some key [LangGraph](https://langchain-ai.github.io/langgraph/) concepts:

- `State`: A shared data structure that represents the current snapshot of your application.
- `Nodes`: Python functions that encode the logic of your agents. They receive the current state as input, perform some computation or side-effect, and return an updated state.
- `Edges`: Python functions that determine which node to execute next based on the current state. They can be conditional branches or fixed transitions.

We will need langgraph, langchain, openai and requests as dependencies (`requirements.txt`).

```
langchain==0.3.21
langchain-openai==0.3.9
langgraph==0.3.18
requests==2.32.3
openai==1.67.0
```

Also we need an API to fetch the termperature and wind.

```
$ curl "https://api.open-meteo.com/v1/forecast?latitude=52.37&longitude=4.89&current_weather=true" -s | jq .

{
  "latitude": 52.366,
  "longitude": 4.901,
  "generationtime_ms": 0.04220008850097656,
  "utc_offset_seconds": 0,
  "timezone": "GMT",
  "timezone_abbreviation": "GMT",
  "elevation": 11.0,
  "current_weather_units": {
    "time": "iso8601",
    "interval": "seconds",
    "temperature": "°C",
    "windspeed": "km/h",
    "winddirection": "%",
    "is_day": "",
    "weathercode": "wmo code"
  },
  "current_weather": {
    "time": "2025-03-20T15:15",
    "interval": 900,
    "temperature": 18.3,
    "windspeed": 6.5,
    "winddirection": 322,
    "is_day": 1,
    "weathercode": 0
  }
}
```

First lets build some required functions to interact with LLM and weather API

```python
# graph/api.py
import requests


def get_weather_data(latitude, longitude):
    url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current_weather=true"
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()
    return data
```

{% raw %}
```python
# graph/langchain.py
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
```
{% endraw %}

Then we build a graph to handle wind queries:

```python
# graph/wind.py
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
```

Then we build a graph to handle termperature queries:

```python
# graph/temperature.py
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
```

Finally we build a router that forward the user to the right workflow:

```python
# main.py
from typing import TypedDict, Dict
from graph.wind import wind_graph
from graph.temperature import temperature_graph
from langgraph.graph import StateGraph, START, END


class RouterState(TypedDict):
    messages: list[Dict[str, str]]


def router(state: RouterState):
    message = input(
        "How can I help you today? Would you like information about temperature or wind? "
    )

    state["messages"] = [{"role": "user", "content": message}]

    if len(state["messages"]) > 0 and state["messages"][-1]["role"] == "user":
        last_message = state["messages"][-1]["content"].lower()

        if "wind" in last_message:
            return {"next": "wind_graph"}
        elif "temperature" in last_message:
            return {"next": "temperature_graph"}
        else:
            return {"next": "unknown"}

    return {"next": "unknown"}


def unknown(state: RouterState):
    return {
        "messages": state["messages"]
        + [
            {
                "role": "system",
                "content": "I'm sorry, I didn't understand. Would you like information about temperature or wind?",
            }
        ]
    }


main_graph = StateGraph(RouterState)
main_graph.add_node("router", router)
main_graph.add_node("wind_graph", wind_graph.compile())
main_graph.add_node("temperature_graph", temperature_graph.compile())
main_graph.add_node("unknown", unknown)

main_graph.add_edge(START, "router")
main_graph.add_conditional_edges(
    "router",
    lambda x: x["next"],
    {
        "wind_graph": "wind_graph",
        "temperature_graph": "temperature_graph",
        "unknown": "unknown",
    },
)
main_graph.add_edge("wind_graph", END)
main_graph.add_edge("temperature_graph", END)
main_graph.add_edge("unknown", "router")

main_graph.set_entry_point("router")

app = main_graph.compile()

while True:
    for event in app.stream(
        {
            "messages": [],
        }
    ):
        for value in event.values():
            if (
                value
                and len(value["messages"]) > 0
                and value["messages"][-1]["role"] == "system"
            ):
                print(value["messages"][-1]["content"])
    break
```

Now we can run the agent from the command line

```
$ export OPENAI_API_KEY=XXXXXXX

$ python main.py

How can I help you today? Would you like information about temperature or wind? wind
Please enter the city name: Cairo
Hello there! 🌬️

I hope you're having a lovely day! Just a quick update on the wind conditions: currently, the wind is blowing at a gentle speed of 3.9 km/h. It's a nice, light breeze coming from the northwest, so it should feel quite pleasant outside. Enjoy your day, and don’t forget to take a moment to appreciate the fresh air! 😊
```

```
$ export OPENAI_API_KEY=XXXXXXX

$ python main.py

How can I help you today? Would you like information about temperature or wind? temperature
Please enter the city name: Amsterdam
Hello there! 🌟

Right now, the temperature is a cozy 10.6°C. Perfect for a light jacket if you're heading out! The winds are gently blowing at about 11.9 km/h from the east. Enjoy your evening! 😊
```

You can see the [full source code here on github](https://github.com/Clivern/Anubis/tree/main/docs/_code/langgraph-in-action)
