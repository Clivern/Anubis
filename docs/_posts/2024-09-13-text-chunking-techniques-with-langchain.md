---
title: Text Chunking Techniques With Langchain Part 1
date: 2024-09-13 00:00:00
featured_image: https://images.unsplash.com/photo-1579004464832-0c014afa448c
excerpt: In this article we explain different ways to split a long document into smaller chunks that can fit into your model's context window. LangChain has a number of built-in transformers that make it easy to split, combine, filter, and otherwise manipulate documents.
keywords: langchain, langchain-text-splitters, chunking-techniques
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

```python
from langchain_text_splitters import RecursiveCharacterTextSplitter


data = """
Balloons are pretty and come in different colors, different shapes, different sizes,
and they can even adjust sizes as needed. But don't make them too big or they might just pop,
and then bye-bye balloon. It'll be gone and lost for the rest of mankind.
They can serve a variety of purposes, from decorating to water balloon wars.
You just have to use your head to think a little bit about what to do with them.
"""

text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=100,
    chunk_overlap=20,
    length_function=len,
    is_separator_regex=False,
)
texts = text_splitter.create_documents([data])
print(texts)
```

```
[
    Document(metadata={}, page_content='Balloons are pretty and come in different colors, different shapes, different sizes,'),
    Document(metadata={}, page_content="and they can even adjust sizes as needed. But don't make them too big or they might just pop,"),
    Document(metadata={}, page_content="and then bye-bye balloon. It'll be gone and lost for the rest of mankind."),
    Document(metadata={}, page_content='They can serve a variety of purposes, from decorating to water balloon wars.'),
    Document(metadata={}, page_content='You just have to use your head to think a little bit about what to do with them.')
]
```

### Split by HTML Header or Sections

`HTMLHeaderTextSplitter` and `HTMLSectionSplitter` are designed to split `HTML` documents into manageable chunks, but they differ in their approach and specific use cases.

- `HTMLHeaderTextSplitter` divides the `HTML` content based on header elements (like `<h1>`, `<h2>`, etc.). It is particularly useful for documents where the structure is defined by these headers.
- `HTMLSectionSplitter` divides content based on sections defined in the `HTML`. However, it may take into account other structural elements beyond just headers.

```python
from langchain_text_splitters import HTMLHeaderTextSplitter


html_string = """
<!DOCTYPE html>
<html>
<body>
    <div>
        <h1>Foo</h1>
        <p>Some intro text about Foo.</p>
        <div>
            <h2>Bar main section</h2>
            <p>Some intro text about Bar.</p>
            <h3>Bar subsection 1</h3>
            <p>Some text about the first subtopic of Bar.</p>
            <h3>Bar subsection 2</h3>
            <p>Some text about the second subtopic of Bar.</p>
        </div>
        <div>
            <h2>Baz</h2>
            <p>Some text about Baz</p>
        </div>
        <br>
        <p>Some concluding text about Foo</p>
    </div>
</body>
</html>
"""

headers_to_split_on = [
    ("h1", "Header 1"),
    ("h2", "Header 2"),
    ("h3", "Header 3"),
]

html_splitter = HTMLHeaderTextSplitter(headers_to_split_on)
html_header_splits = html_splitter.split_text(html_string)
html_header_splits
```

```
[
    Document(metadata={}, page_content='Foo'),
    Document(metadata={'Header 1': 'Foo'}, page_content='Some intro text about Foo.  \nBar main section Bar subsection 1 Bar subsection 2'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Bar main section'}, page_content='Some intro text about Bar.'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Bar main section', 'Header 3': 'Bar subsection 1'}, page_content='Some text about the first subtopic of Bar.'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Bar main section', 'Header 3': 'Bar subsection 2'}, page_content='Some text about the second subtopic of Bar.'),
    Document(metadata={'Header 1': 'Foo'}, page_content='Baz'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Baz'}, page_content='Some text about Baz'),
    Document(metadata={'Header 1': 'Foo'}, page_content='Some concluding text about Foo')
]
```

```python
from langchain_text_splitters import HTMLSectionSplitter


html_string = """
    <!DOCTYPE html>
    <html>
    <body>
        <div>
            <h1>Foo</h1>
            <p>Some intro text about Foo.</p>
            <div>
                <h2>Bar main section</h2>
                <p>Some intro text about Bar.</p>
                <h3>Bar subsection 1</h3>
                <p>Some text about the first subtopic of Bar.</p>
                <h3>Bar subsection 2</h3>
                <p>Some text about the second subtopic of Bar.</p>
            </div>
            <div>
                <h2>Baz</h2>
                <p>Some text about Baz</p>
            </div>
            <br>
            <p>Some concluding text about Foo</p>
        </div>
    </body>
    </html>
"""

headers_to_split_on = [
    ("h1", "Header 1"),
    ("h2", "Header 2")
]

html_splitter = HTMLSectionSplitter(headers_to_split_on)
html_header_splits = html_splitter.split_text(html_string)
html_header_splits
```

```
[
    Document(metadata={'Header 1': 'Foo'}, page_content='Foo \n Some intro text about Foo.'),
    Document(metadata={'Header 2': 'Bar main section'}, page_content='Bar main section \n Some intro text about Bar. \n Bar subsection 1 \n Some text about the first subtopic of Bar. \n Bar subsection 2 \n Some text about the second subtopic of Bar.'),
    Document(metadata={'Header 2': 'Baz'}, page_content='Baz \n Some text about Baz \n \n \n Some concluding text about Foo')
]
```

### Split Markdown by Headers

The `MarkdownHeadingTextSplitter` from LangChain splits Markdown text into chunks based on heading levels (e.g., `#`, `##`, `###`).

```python
from langchain_text_splitters import MarkdownHeaderTextSplitter


headers_to_split_on = [
    ("#", "Header 1"),
    ("##", "Header 2"),
    ("###", "Header 3"),
]

markdown_document = """
# Foo
Some intro text about Foo.

## Bar
Some intro text about Bar.

### Baz
Some text about Baz
"""
markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on)
md_header_splits = markdown_splitter.split_text(markdown_document)
print(md_header_splits)
```

```
[
    Document(metadata={'Header 1': 'Foo'}, page_content='Some intro text about Foo.'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Bar'}, page_content='Some intro text about Bar.'),
    Document(metadata={'Header 1': 'Foo', 'Header 2': 'Bar', 'Header 3': 'Baz'}, page_content='Some text about Baz')
]
```

### Split JSON

The `RecursiveJsonSplitter` splits json data while allowing control over chunk sizes. It tries to keep nested json objects whole but will split them if needed to keep chunks between a `min_chunk_size` and the `max_chunk_size`.

If the value is a very big string, the string won't be split. You can use text splitter to split those chunks.

```python
from langchain_text_splitters import RecursiveJsonSplitter

# Suppose the json is quite big
json_data = {
    "message": "Hello, Mireya! Your order number is: #48",
    "phoneNumber": "878.358.3458 x6225",
    "phoneVariation": "+90 388 601 10 24",
    "status": "active",
    "name": {
        "first": "Christiana",
        "middle": "Arden",
        "last": "Jacobson"
    },
    "username": "Christiana-Jacobson",
    "password": "EAec_4Wgy3x4CDo",
    "emails": [
        "Elmo97@gmail.com",
        "Felicita.Rempel@gmail.com"
    ],
    "location": {
        "street": "65905 Delores Estate",
        "city": "Fort Smith",
        "state": "Montana",
        "country": "Nicaragua",
        "zip": "92331",
        "coordinates": {
            "latitude": "44.1785",
            "longitude": "111.2521"
        }
    },
    "website": "https://wrathful-reason.com",
    "domain": "dead-fatigues.name",
    "job": {
        "title": "Human Creative Specialist",
        "descriptor": "Senior",
        "area": "Accounts",
        "type": "Executive",
        "company": "Howe - Kuhn"
    },
    "creditCard": {
        "number": "4661937304512",
        "cvv": "547",
        "issuer": "jcb"
    },
    "uuid": "e352f4e2-f10a-4ef8-adeb-ee94ecf24fa6",
    "objectId": "66e9bb4035b9062a57ddc0c1"
}

splitter = RecursiveJsonSplitter(max_chunk_size=30)
json_chunks = splitter.split_json(json_data=json_data)
print(json_chunks)
```

```
[
    {'message': 'Hello, Mireya! Your order number is: #48'},
    {'phoneNumber': '878.358.3458 x6225', 'phoneVariation': '+90 388 601 10 24'},
    {'status': 'active', 'name': {'first': 'Christiana'}},
    {'name': {'middle': 'Arden', 'last': 'Jacobson'}, 'username': 'Christiana-Jacobson'},
    {'password': 'EAec_4Wgy3x4CDo', 'emails': ['Elmo97@gmail.com', 'Felicita.Rempel@gmail.com']},
    {'location': {'street': '65905 Delores Estate', 'city': 'Fort Smith'}},
    {'location': {'state': 'Montana', 'country': 'Nicaragua'}},
    {'location': {'zip': '92331', 'coordinates': {'latitude': '44.1785'}}},
    {'location': {'coordinates': {'longitude': '111.2521'}}},
    {'website': 'https://wrathful-reason.com', 'domain': 'dead-fatigues.name'},
    {'job': {'title': 'Human Creative Specialist', 'descriptor': 'Senior'}},
    {'job': {'area': 'Accounts', 'type': 'Executive'}},
    {'job': {'company': 'Howe - Kuhn'}, 'creditCard': {'number': '4661937304512'}},
    {'creditCard': {'cvv': '547', 'issuer': 'jcb'}, 'uuid': 'e352f4e2-f10a-4ef8-adeb-ee94ecf24fa6'},
    {'objectId': '66e9bb4035b9062a57ddc0c1'}
]
```

### References:

- [Langchain Text Splitters Documentation](https://python.langchain.com/docs/how_to/#text-splitters)

