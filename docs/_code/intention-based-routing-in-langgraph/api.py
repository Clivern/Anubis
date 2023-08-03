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
                "You are a helpful assistant that provides general user questions.",
            ),
            (
                "user",
                f"Provide an answer to this prompt and make it less formal {prompt}",
            ),
        ],
        [],
    )
    return chain.invoke({})
