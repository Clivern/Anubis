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
from typing import TypedDict, Dict
from langgraph.graph import StateGraph, START, END
from api import answer_general_user_question
from api import get_user_intent


class MainState(TypedDict):
    messages: list[Dict[str, str]]


def ask(state: MainState) -> MainState:
    msg = "Hi there, How can i help you?"
    prompt = input(f"{msg}\n")
    state["messages"].append({"role": "assistant", "content": msg})
    state["messages"].append({"role": "user", "content": prompt})
    return state


def get_intent(state: MainState) -> MainState:
    intent = get_user_intent(
        os.environ.get("OPENAI_API_KEY"),
        state.get("messages")[-1].get("content"),
        ["get_company_phone", "get_company_email"],
    )
    state["messages"].append({"role": "system", "content": intent})
    return state


def decide(state: MainState) -> MainState:
    if state.get("messages")[-1].get("content") not in [
        "get_company_email",
        "get_company_phone",
    ]:
        return "unknown"

    return state.get("messages")[-1].get("content")


def get_company_phone(state: MainState) -> MainState:
    state["messages"].append(
        {"role": "assistant", "content": "The company phone is +2352553423"}
    )
    return state


def get_company_email(state: MainState) -> MainState:
    state["messages"].append(
        {"role": "assistant", "content": "The company email is support@langgraph.com"}
    )
    return state


def unknown(state: MainState) -> MainState:
    answer = answer_general_user_question(
        os.environ.get("OPENAI_API_KEY"), state.get("messages")[-1].get("content")
    )
    state["messages"].append({"role": "assistant", "content": answer})
    return state


main_graph = StateGraph(MainState)
main_graph.add_node("ask", ask)
main_graph.add_node("get_intent", get_intent)
main_graph.add_node("decide", decide)
main_graph.add_node("get_company_email", get_company_email)
main_graph.add_node("get_company_phone", get_company_phone)
main_graph.add_node("unknown", unknown)

main_graph.add_edge(START, "ask")
main_graph.add_edge("ask", "get_intent")
main_graph.add_conditional_edges("get_intent", decide)
main_graph.add_edge("get_company_email", END)
main_graph.add_edge("get_company_phone", END)
main_graph.add_edge("unknown", END)

main_graph.set_entry_point("ask")
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
                and value.get("messages")[-1].get("role") == "assistant"
            ):
                print(value.get("messages")[-1].get("content"), "\n")
    break
