---
title: Text Chunking Techniques With Langchain
date: 2024-09-13 00:00:00
featured_image: https://images.unsplash.com/photo-1579004464832-0c014afa448c
excerpt: In this article we explain different ways to split a long document into smaller chunks that can fit into your model's context window. LangChain has a number of built-in transformers that make it easy to split, combine, filter, and otherwise manipulate documents.
---

![](https://images.unsplash.com/photo-1579004464832-0c014afa448c)

In this article we explain different ways to split a long document into smaller chunks that can fit into your model's context window. `LangChain` has a number of built-in transformers that make it easy to split, combine, filter long documents.


### Text splitters

Ideally, you want to keep the semantically related pieces of text together.

At a high level, text splitters work as following:

1. Split the text up into small, semantically meaningful chunks.
2. Start combining these small chunks into a larger chunk until you reach a certain size.
3. Once you reach that size, make that chunk its own piece of text and then start creating a new chunk of text with some overlap (to keep context between chunks).


### References:

- [Langchain Text Splitters Documentation](https://python.langchain.com/v0.1/docs/modules/data_connection/document_transformers/)
