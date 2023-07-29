---
title: LangGraph In Action
date: 2025-03-07 00:00:00
featured_image: https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max
excerpt: It took me a while to figure out why i need `LangGraph` if I can use `Langchain` to build the agents. From the documentation `Langchain` provides integrations and composable components to streamline `LLM` application development while `LangGraph` library enables agent orchestration — offering customizable architectures, long-term memory, and human-in-the-loop to reliably handle complex tasks.
keywords: langchain, langgraph, ai, agentic-systems
---

![](https://images.unsplash.com/photo-1431440869543-efaf3388c585?q=75&fm=jpg&w=1000&fit=max)

It took me a while to figure out why i need `LangGraph` if I can use `Langchain` to build the agents. From the documentation `Langchain` provides integrations and composable components to streamline `LLM` application development while `LangGraph` library enables agent orchestration — offering customizable architectures, long-term memory, and human-in-the-loop to reliably handle complex tasks.

`LangChain` focuses on LLMs interactions while providing tools to build a simple workflows like content generation or customer support. `LangGraph` on the other hand used to build complex workflows using a graph-based approach, suitable for managing multiple agents and conditional logic.

Imagine we are building a chatbot for a travel company, here is few examples of chats we expect to be receiving:

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

From the chats above, you can see that the bot is supposed to handle different workflows:
- a flow to cancel flights.
- a flow to answer general questions like support number or other things.
- a flow to check the flight status.

Well the above needs `LangChain` and `LangGraph`. `LangGraph` will be used to build all the needed workflows and `LangChain` can be used handle LLM interactions. There will be a lot of LLM interactions, things like getting user intention, format user inputs.

Now i will be building a smaller agent that shall answer questions about the weather and termperature. The same things we do can be applied to a bigger chat agent. Here is a graph of what i want to achieve.

