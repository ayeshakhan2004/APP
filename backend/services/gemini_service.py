"""Gemini LLM service — shared across all agents."""

from google import genai
import json
import os
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

# 1. READ FROM ENVIRONMENT: Pull the GCP project ID from your .env file
# (When running on Cloud Run, GCP sets 'GOOGLE_CLOUD_PROJECT' automatically too!)
PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT", "your-gcp-project-id-fallback")

# 2. UPDATE INITIALIZATION: Tell the new client syntax to use Vertex AI with your project credit balance
# No API key string is needed here anymore!
client = genai.Client(
    vertexai=True,
    project=PROJECT_ID,
    location="us-central1"
)

async def ask_gemini(prompt: str, system_instruction: str = "") -> dict:
    """Send prompt to Gemini and get structured JSON response."""
    full_prompt = ""
    if system_instruction:
        full_prompt = f"SYSTEM: {system_instruction}\n\n"
    full_prompt += f"{prompt}\n\nRespond ONLY with valid JSON. No markdown, no code fences."

    try:
        # 3. VERTEX MODE: Call generate_content from the credit-backed client
        response = client.models.generate_content(
            model='gemini-2.5-flash',  # Vertex matches standard production naming
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