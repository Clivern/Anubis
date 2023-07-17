---
title: Building My Own RAG With OpenAI, Qdrant and LangChain
date: 2024-08-18 00:00:00
featured_image: https://images.unsplash.com/photo-1536936343740-68cb2a95f935
excerpt: RAG stands for Retrieval Augmented Generation. It enhances the large language models (LLMs) by integrating them with external data sources. This allows LLMs to generate more accurate and relevant responses by providing it with information from databases or knowledge bases, rather than relying on their pre-trained data.
---

![](https://images.unsplash.com/photo-1536936343740-68cb2a95f935)

RAG stands for Retrieval Augmented Generation. It enhances the large language models (LLMs) by integrating them with external data sources. This allows LLMs to generate more accurate and relevant responses by providing it with information from databases or knowledge bases, rather than relying on their pre-trained data.


### Why RAG?

- It allows LLMs to access and retrieve the most current and relevant data from external sources.
- It can be cost-effective than fine-tuning the models with your specific data.
- RAG can can provide LLMs with real-data context such as financial changes.


### How RAG Works?

The image below shows how a basic RAG system works. Before forwarding the question to the LLM, we have a layer that searches our knowledge base for some relevant data to answer the user query. Specifically, in this case, the spending data from the last month. Our LLM can now generate a relevant response about our budget.

![](/images/blog/how-rag-works.jpg)

There is two ways to fetch the relevant data, there is the traditional search and vector search. In traditional search, the approach relies on matching keywords directly from the user query to the content. while [vector search](https://qdrant.tech/documentation/overview/vector-search/) uses vector embeddings to catch the semantics of the data to perform a meaning-based approach.


### How to Build a RAG?

Imagine I have three random stories about three men who each had a unique experience on their Fridays. LLMs know nothing about them and we need to feed the relevant data to the LLM whenever a user asks for one of them. This article cover only the vector searching part and LLM prompt. It doesn't cover `Data Splitting` and `Chunking` but i will cover these later.

```
Joe Doe's Musical Revelation:
On a Friday evening, Joe Doe, a passionate guitarist, decided to visit a local music shop known for its unique instruments.
While browsing, he stumbled upon a vintage guitar that had an intriguing backstory. The shopkeeper shared how the guitar was
once owned by a famous musician who had played it during a legendary concert. Inspired by the guitar's history,
Joe decided to purchase it, believing it would bring a new depth to his music. That night, he spent hours playing and composing,
feeling a deep connection to the instrument and its past.


Rashid Brown's Community Service:
Rashid Brown, a dedicated volunteer, spent his Friday at a local community center, organizing a food drive for families in need.
He rallied a group of friends to help him sort through donations and prepare care packages. As they worked, Rashid shared stories
of the families they were helping, emphasizing the importance of community support. By the end of the day, they had assembled over
a hundred packages, and Rashid felt a profound sense of fulfillment, knowing they were making a tangible difference in their community.


Mark Felix's Unexpected Adventure:
On a seemingly ordinary Friday, Mark Felix, an office worker, decided to take a different route home from work.
As he walked, he discovered a small art gallery hosting an opening night for local artists. Intrigued, he stepped inside and was
captivated by the vibrant artwork. He struck up a conversation with one of the artists, who invited him to join a community art class.
Mark, who had always enjoyed painting but never pursued it seriously, took the leap and signed up. This spontaneous decision led to a
new passion that transformed his weekends into creative explorations.
```

Lets create a [python virtual environment](https://docs.python.org/3/library/venv.html). The following code is to explain the approach not for copy/paste & production use.

```zsh
$ python3 -m venv venv
$ source venv/bin/activate
```

Let's install the required python packages

```
langchain==0.2.14
langchain-openai==0.1.22
qdrant-client==1.11.0
openai==1.41.0
```

```
pip3 install -r requirements.txt
```

Here is a script to convert these stories into vector embedding using `OpenAI` API and store them on a remote [qdrant database](https://qdrant.tech/)

```python
import uuid
import os
from openai import OpenAI
from qdrant_client.models import PointStruct, VectorParams, Distance
from qdrant_client import QdrantClient

collection_name = "rag"

texts = [
	"On a Friday evening, Joe Doe, a passionate guitarist, decided to visit a local music shop known for its unique instruments. While browsing, he stumbled upon a vintage guitar that had an intriguing backstory. The shopkeeper shared how the guitar was once owned by a famous musician who had played it during a legendary concert. Inspired by the guitar's history, Joe decided to purchase it, believing it would bring a new depth to his music. That night, he spent hours playing and composing, feeling a deep connection to the instrument and its past.",
	"Rashid Brown, a dedicated volunteer, spent his Friday at a local community center, organizing a food drive for families in need. He rallied a group of friends to help him sort through donations and prepare care packages. As they worked, Rashid shared stories of the families they were helping, emphasizing the importance of community support. By the end of the day, they had assembled over a hundred packages, and Rashid felt a profound sense of fulfillment, knowing they were making a tangible difference in their community.",
	"On a seemingly ordinary Friday, Mark Felix, an office worker, decided to take a different route home from work. As he walked, he discovered a small art gallery hosting an opening night for local artists. Intrigued, he stepped inside and was captivated by the vibrant artwork. He struck up a conversation with one of the artists, who invited him to join a community art class. Mark, who had always enjoyed painting but never pursued it seriously, took the leap and signed up. This spontaneous decision led to a new passion that transformed his weekends into creative explorations."
]

oclient = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

response = oclient.embeddings.create(
    input=texts,
    model="text-embedding-3-small"
)

points = [
    PointStruct(
        id=str(uuid.uuid4()),
        vector=data.embedding,
        payload={"text": text, "doc_type": "stories"},
    )
    for _, (data, text) in enumerate(zip(response.data, texts))
]

qclient = QdrantClient(
	url=os.getenv("QDRANT_URL"),
	api_key=os.getenv("QDRANT_API_KEY")
)

# Create a collection
qclient.create_collection(
    collection_name,
    vectors_config=VectorParams(
        size=1536,  # Size of the embedding vector
        distance=Distance.COSINE  # Distance metric for searching
    )
)

# Insert points into Qdrant
qclient.upsert(collection_name, points)
```

Then define `OPENAI_API_KEY`, `QDRANT_URL` and `QDRANT_API_KEY` and run the script

```zsh
$ export OPENAI_API_KEY=....
$ export QDRANT_URL=.....
$ export QDRANT_API_KEY=...

$ python3 script1.py
```

Now lets query the vector database for the relevant data for this question `Who helped some families on his Friday? Give me his name only..`

```python
import os
from openai import OpenAI
from qdrant_client.models import PointStruct
from qdrant_client import QdrantClient, models

collection_name = "rag"

oclient = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

query_vector = oclient.embeddings.create(
    input="Who helped some families on his Friday? Give me his name only..",
    model="text-embedding-3-small"
).data[0].embedding

qclient = QdrantClient(
	url=os.getenv("QDRANT_URL"),
	api_key=os.getenv("QDRANT_API_KEY")
)


# Perform the search
search_results = qclient.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=models.Filter(
        must=[
            models.FieldCondition(
                key="doc_type",
                match=models.MatchValue(
                    value="stories",
                ),
            )
        ]
    ),
    limit=1
)

# Process search results
for result in search_results:
    print(f"ID: {result.id}, Score: {result.score}, Text: {result.payload['text']}")
```

```zsh
$ export OPENAI_API_KEY=....
$ export QDRANT_URL=.....
$ export QDRANT_API_KEY=...

$ python3 script2.py
```

Well i got this response

```
ID: ca20ca6e-e84f-4b5a-b112-8199dada5512, Score: 0.50621325, Text: Rashid Brown, a dedicated volunteer, spent his Friday at a local community center, organizing a food drive for families in need. He rallied a group of friends to help him sort through donations and prepare care packages. As they worked, Rashid shared stories of the families they were helping, emphasizing the importance of community support. By the end of the day, they had assembled over a hundred packages, and Rashid felt a profound sense of fulfillment, knowing they were making a tangible difference in their community
```

Now let's use [langchain](https://www.langchain.com/) to ask the LLM our question while providing the context we received from the vector database.

```python
import os
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from openai import OpenAI
from qdrant_client.models import PointStruct
from qdrant_client import QdrantClient, models


collection_name = "rag"

oclient = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

query_vector = oclient.embeddings.create(
    input="Who helped some families on his Friday? Give me his name only..",
    model="text-embedding-3-small"
).data[0].embedding

qclient = QdrantClient(
    url=os.getenv("QDRANT_URL"),
    api_key=os.getenv("QDRANT_API_KEY")
)

# Perform the search
search_results = qclient.search(
    collection_name=collection_name,
    query_vector=query_vector,
    query_filter=models.Filter(
        must=[
            models.FieldCondition(
                key="doc_type",
                match=models.MatchValue(
                    value="stories",
                ),
            )
        ]
    ),
    limit=1
)

# Process search results
for result in search_results:
    context = result.payload['text']
    question = "Who helped some families on his Friday? Give me his name only.."

    prompt_template = [
        ("system", "You are a helpful assistant that answers questions based on provided context."),
        ("system", f"context: {context}"),
        ("user", f"answer this question:\n{question}"),
    ]

    prompt = ChatPromptTemplate.from_messages(prompt_template)

    llm = ChatOpenAI(
        openai_api_key=os.getenv("OPENAI_API_KEY"),
        model_name="gpt-4o-mini",
        temperature=0
    )

    chain = prompt | llm | StrOutputParser()

    print(chain.invoke({}))
```

```zsh
$ export OPENAI_API_KEY=....
$ export QDRANT_URL=.....
$ export QDRANT_API_KEY=...

$ python3 script3.py
```

You will get his name like this

```
Rashid Brown
```

### References:

- [Langchain Documentation](https://python.langchain.com/v0.2/docs/introduction/)
- [OpenAI Embeddings](https://platform.openai.com/docs/guides/embeddings)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
