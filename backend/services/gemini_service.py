"""Gemini LLM service — shared across all agents."""

from google import genai
import json
import os
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

# 1. NEW SYNTAX: Initialize the client instead of using 'configure'
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY", ""))

async def ask_gemini(prompt: str, system_instruction: str = "") -> dict:
    """Send prompt to Gemini and get structured JSON response."""
    full_prompt = ""
    if system_instruction:
        full_prompt = f"SYSTEM: {system_instruction}\n\n"
    full_prompt += f"{prompt}\n\nRespond ONLY with valid JSON. No markdown, no code fences."

    try:
        # 2. NEW SYNTAX: Call generate_content from the client and pass the model name here
        response = client.models.generate_content(
            model='gemini-3.1-flash-lite',
            contents=full_prompt
        )
        
        text = response.text.strip()
        
        # Clean markdown fences if present (Kept exactly as you wrote it)
        if text.startswith("```"):
            text = text.split("\n", 1)[1] if "\n" in text else text[3:]
            if text.endswith("```"):
                text = text[:-3]
            if text.startswith("json"):
                text = text[4:]
            text = text.strip()
            
        return json.loads(text)
        
    except json.JSONDecodeError:
        return {"raw_response": response.text, "parse_error": True}
    except Exception as e:
        return {"error": str(e), "failed": True}
