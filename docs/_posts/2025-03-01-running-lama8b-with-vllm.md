---
title: Running Llama-3.1-8B Locally With vLLM
date: 2025-03-01 00:00:00
featured_image: https://images.unsplash.com/photo-1417144527634-653e3dec77b2?q=75&fm=jpg&w=1000&fit=max
excerpt: In this guide, I'll show you how to run Llama-3.1 8B locally on a Mac using vLLM. This is just for testing, not for a production setup.
keywords: vllm, llama, llama-8B
---

![](https://images.unsplash.com/photo-1417144527634-653e3dec77b2?q=75&fm=jpg&w=1000&fit=max)

In this guide, I'll show you how to run Llama-3.1 8B locally on a Mac using vLLM. This is just for testing, not for a production setup.

### Requirements

Before you begin, please ensure you have the following:

- A `Hugging Face` account.
- Access to the `Meta Llama 3` models on [Hugging Face](https://huggingface.co/meta-llama/Llama-3.1-8B). You'll need to agree to their license terms and share contact information to gain access.
- `Python` 3.8 or higher installed. I will be using `Python` 3.11
- `pip` package installer.
- A `Hugging Face` account token, You can generate a new one from [token settings page](https://huggingface.co/settings/tokens)

### Setting Up Your Local Environment

Create a new python virtual environment

```zsh
$ python -m venv venv
$ source venv/bin/activate
```

Install the Hugging Face Hub CLI and `vLLM` using `pip`:

```zsh
$ pip install -U "huggingface_hub[cli]"
$ pip install vllm
```

Login into Hugging faces with READ Token.

```zsh
huggingface-cli login
```

Start the `vLLM` Server. The `--max-model-len` argument specifies the maximum context length for the model.

```zsh
$ vllm serve "meta-llama/Llama-3.1-8B" --max-model-len 3000
```

Open a new terminal window and use curl to send a request to the `vLLM` server. This example asks the model "How to split text in python?".

```zsh
$ curl -X POST "http://localhost:8000/v1/completions" \
        -H "Content-Type: application/json" \
        --data '{
                "model": "meta-llama/Llama-3.1-8B",
                "prompt": "How to split text in python?",
                "max_tokens": 512,
                "temperature": 0
        }' | jq .

{
  "id": "cmpl-c3fdbfed3eff4bb2b82eae20e011619c",
  "object": "text_completion",
  "created": 1742217186,
  "model": "meta-llama/Llama-3.1-8B",
  "choices": [
    {
      "index": 0,
      "text": " Python split() method is used to split the given string into substrings based on the delimiter passed as a parameter. The split() method returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a parameter to the split() method. The separator can be a single character or a string. The separator is not included in the resulting list. The split() method is a string method and returns a list of strings after breaking the given string by the specified separator. The separator is passed as a",
      "logprobs": null,
      "finish_reason": "length",
      "stop_reason": null,
      "prompt_logprobs": null
    }
  ],
  "usage": {
    "prompt_tokens": 8,
    "total_tokens": 520,
    "completion_tokens": 512,
    "prompt_tokens_details": null
  }
}
```
