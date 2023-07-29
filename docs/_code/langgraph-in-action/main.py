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
# SOFTWARE

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
