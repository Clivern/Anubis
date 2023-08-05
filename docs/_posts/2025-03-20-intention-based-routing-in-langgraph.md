---
title: Intention Based Routing in Langgraph
date: 2025-03-20 00:00:00
featured_image: https://images.unsplash.com/photo-1553912545-a3f690923c32?q=75&fm=jpg&w=1000&fit=max
excerpt: Intention-based routing in langgraph involves using conditional logic to direct the flow within the graph based on user intention.
keywords: langchain, langgraph, ai, agentic-systems
---

![](https://images.unsplash.com/photo-1553912545-a3f690923c32?q=75&fm=jpg&w=1000&fit=max)

Intention-based routing in `langgraph` involves using conditional logic to direct the flow within the graph based on user intention. We can use the `LLM` to capture the user intent and use `langgraph` routing features to send the request to the appropriate node or subgraph.

As usual, here is a graph of what we are going to build. It is super simple but it shows the routing capabilities in `langgraph`

![](/images/blog/langgraph-chat-01.png)

I am going to use the following packages.

```
langchain==0.3.21
langchain-openai==0.3.9
langgraph==0.3.18
openai==1.67.0
```

Lets create the utils function to use in our graph.

```python
# api.py
import langchain
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser


langchain.verbose = False
langchain.debug = False
langchain.llm_cache = False


class Langchain:
    """Langchain Class"""

    @staticmethod
    def create_chat_chain(
        openai_api_key: str,
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


def get_user_intent(
    openai_api_key: str,
    prompt: str,
    intents: list[str],
    model_name="gpt-4o-mini",
    temperature=0,
) -> str:
    chain = Langchain.create_chat_chain(
        openai_api_key,
        model_name,
        temperature,
        [
            (
                "system",
                "You are a helpful assistant that provides the user intent from a list of intents.",
            ),
            (
                "user",
                f"Provide the intent value ONLY of user prompt {prompt} from these intent list {intents}",
            ),
        ],
        [],
    )
    return chain.invoke({})


def answer_general_user_question(
    openai_api_key: str,
    prompt: str,
    model_name="gpt-4o-mini",
    temperature=0,
) -> str:
    chain = Langchain.create_chat_chain(
        openai_api_key,
        model_name,
        temperature,
        [
            (
                "system",
                "You are a helpful assistant that answers general user questions.",
            ),
            (
                "user",
                f"Provide an answer to this prompt and make it less formal {prompt}",
            ),
        ],
        [],
    )
    return chain.invoke({})
```

and then, lets build the graph itself.

```python
# graph.py
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
        ["get_company_phone", "get_company_email"]
    )
    state["messages"].append({"role": "system", "content": intent})
    return state


def decide(state: MainState) -> MainState:
    if state.get("messages")[-1].get("content") not in ["get_company_email", "get_company_phone"]:
        return "unknown"

    return state.get("messages")[-1].get("content")


def get_company_phone(state: MainState) -> MainState:
    state["messages"].append({"role": "assistant", "content": "The company phone is +2352553423"})
    return state


def get_company_email(state: MainState) -> MainState:
    state["messages"].append({"role": "assistant", "content": "The company email is support@langgraph.com"})
    return state


def unknown(state: MainState) -> MainState:
    answer = answer_general_user_question(
        os.environ.get("OPENAI_API_KEY"),
        state.get("messages")[-1].get("content")
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
```

and to run the graph

```
$ export OPENAI_API_KEY=XXXXXXX
$ python main.py

Hi there, How can i help you?
What is langgraph company phone number?
The company phone is +2352553423
```
```
$ export OPENAI_API_KEY=XXXXXXX
$ python main.py

Hi there, How can i help you?
What is the email address?
The company email is support@langgraph.com
```

You can see the [full source code here on github](https://github.com/Clivern/Anubis/tree/main/docs/_code/intention-based-routing-in-langgraph)
