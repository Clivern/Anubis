---
title: Text Chunking Techniques With Langchain
date: 2024-09-13 00:00:00
featured_image: https://images.unsplash.com/photo-1579004464832-0c014afa448c
excerpt: In this article we explain different ways to split a long document into smaller chunks that can fit into your model's context window. LangChain has a number of built-in transformers that make it easy to split, combine, filter, and otherwise manipulate documents.
---

![](https://images.unsplash.com/photo-1579004464832-0c014afa448c)

In this article we explain different ways to split a long document into smaller chunks that can fit into your model's context window. `LangChain` has a number of built-in transformers that make it easy to split, combine, filter long documents.

To install langchain text splitters, use the following package:

```zsh
$ pip install langchain-text-splitters
```

Ideally, you want to keep the semantically related pieces of text together.

At a high level, text splitters work as following:

1. Split the text up into small, semantically meaningful chunks.
2. Start combining these small chunks into a larger chunk until you reach a certain size.
3. Once you reach that size, make that chunk its own piece of text and then start creating a new chunk of text with some overlap (to keep context between chunks).


### Recursive Character Text Splitter

`RecursiveCharacterTextSplitter` is used to split large texts into smaller, manageable chunks. It does this recursively, ensuring that the splits respect certain constraints like chunk size and overlap. The text is split by list of characters `["\n\n", "\n", " ", ""]` and the chunk size is measured by number of characters.

```zsh
from langchain_text_splitters import RecursiveCharacterTextSplitter


with open("~/docs/runbook.txt", "r") as file:
	text_splitter = RecursiveCharacterTextSplitter(
		chunk_size=1000,
		chunk_overlap=200,
		length_function=len,
		is_separator_regex=False,
	)
	texts = text_splitter.create_documents([file.read()])
	print(texts)
```


### Split by HTML Header

To split text by `HTML` headers, you can use the `HtmlTextSplitter` from `LangChain`. It splits the text based on HTML tags like `<h1>`, `<h2>`, etc.


### Split by HTML Sections

The `HtmlWebPageTextSplitter` from `LangChain` can be used to split an `HTML` web page into sections based on semantic HTML tags like `<section>`, `<article>`, etc.


### Split by Character

The `CharacterTextSplitter` from `LangChain` splits the text into chunks based on a specified character count, without considering any semantic structure.


### Split Code

For splitting code, you can use the `MarkdownCodeBlockSplitter` from `LangChain`, which splits the text into chunks based on code blocks delimited by triple backticks (```).


### Split Markdown by Headers

The `MarkdownHeadingTextSplitter` from LangChain splits Markdown text into chunks based on heading levels (e.g., `#`, `##`, `###`).


### Split JSON

To split JSON data, you can use the `JsonlNewlineTextSplitter` from `LangChain`, which splits the text by newlines, assuming each line contains a valid `JSON` object.


### Split Text into Semantic Chunk

The `NLTKTextSplitter` from `LangChain` uses `NLTK` (Natural Language Toolkit) to split the text into semantic chunks based on sentences or paragraphs.


### Split by Tokens

The `TokenTextSplitter` from `LangChain` splits the text into chunks based on a specified token count, similar to `CharacterTextSplitter` but using a tokenizer.


### References:

- [Langchain Text Splitters Documentation](https://python.langchain.com/v0.1/docs/modules/data_connection/document_transformers/)
