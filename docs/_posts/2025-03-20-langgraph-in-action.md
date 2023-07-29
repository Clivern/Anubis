---
title: LangGraph In Action
date: 2025-03-20 00:00:00
featured_image: https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max
excerpt: It took me a while to figure out why i need `LangGraph` if I can use `Langchain` to build the agents. From the documentation `Langchain` provides integrations and composable components to streamline `LLM` application development while `LangGraph` library enables agent orchestration — offering customizable architectures, long-term memory, and human-in-the-loop to reliably handle complex tasks.
keywords: langchain, langgraph, ai, agentic-systems
---

![](https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max)

It took me a while to understand why I need `LangGraph` when I can use `LangChain` to build agents. According to the documentation, `LangChain` provides integrations and composable components to streamline Large Language Model (LLM) application development, while the `LangGraph` library enables agent orchestration—offering customizable architectures, long-term memory, and human-in-the-loop capabilities to reliably handle complex tasks.

`LangChain` focuses on `LLM` interactions and provides tools for building simple workflows, such as content generation or customer support. On the other hand, `LangGraph` is used to build complex workflows using a `graph-based` approach, suitable for managing multiple `agents` and conditional logic.

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
- a flow to cancel flights.
- A flow to answer general questions, such as providing a support number.
- a flow to check the flight status.

Both `LangChain` and `LangGraph` are necessary for this setup. `LangGraph` will be used to build all the required workflows, while `LangChain` can handle `LLM` interactions. There will be many `LLM` interactions, such as determining user intent and formatting user inputs.

Now i will be building a smaller agent that shall answer questions about the weather and termperature. The same things we do can be applied to a bigger chat agent. Here is a graph of what i want to achieve.

![](/images/blog/langgraph_graph01.png)

As you can see, we need to build two graphs with `LangGraph`:
- `Weather` graph to handle weather queries.
- `Termperature` graph to handle termperature queries.

Then we build a `router` that sends the user to the appropriate graph based on their `intent`.

Before we build our first graph, let's explain some key `LangGraph` concepts:

- `State`: A shared data structure that represents the current snapshot of your application.
- `Nodes`: Python functions that encode the logic of your agents. They receive the current state as input, perform some computation or side-effect, and return an updated state.
- `Edges`: Python functions that determine which node to execute next based on the current state. They can be conditional branches or fixed transitions.

Lets build a graph to handle weather queries:

```python
```

Then we build a graph to handle termperature queries:

```python
```

Finally we build a router that forward the user to the right workflow:

```python
```

You can see the [full source code here on github]()
