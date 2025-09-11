import os
from openai import OpenAI

client = OpenAI(api_key="")


# SYSTEM_PROMPT를 변수로 정의
SYSTEM_PROMPT = """
"""

if __name__ == "__main__":
    response = client.responses.create(
        model="gpt-4",
        input=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": "1+2 는?"}
                ]
    )
    output_text = response.output_text

    print(output_text)