import asyncio
import os
import json
from datetime import datetime
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client
from litellm import completion
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
DEFAULT_MODEL = os.getenv("DEFAULT_MODEL")

import litellm
import logging

# --- CONFIGURATION TO SILENCE NOISE ---
litellm.suppress_debug_info = True
logging.getLogger("litellm").setLevel(logging.CRITICAL)

server_params = StdioServerParameters(
    command="npx",
    args=["-y", "@philschmid/weather-mcp"],
    env=None
)

async def run_agent():
    print("Starting MCP Agent Workflow...")
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            # 1. Get Tools
            tools_result = await session.list_tools()
            tools = tools_result.tools
            tools_desc = "\n".join([f"- {t.name}: {t.description} (Params: {json.dumps(t.inputSchema)})" for t in tools])

            # 2. Context Grounding: Get Current Date
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M")
            print(f"[System] Current Time: {current_time}")

            # 3. Ask AI to pick a tool
            question = "What is the weather in Berlin today?"
            print(f"\nUser Question: {question}")

            prompt = f"""System: You are a helpful assistant. The current date and time is {current_time}.

Available tools:
{tools_desc}

User question: {question}

Respond ONLY with JSON: {{"tool": "tool_name", "parameters": {{...}}}}"""

            response = completion(model=DEFAULT_MODEL, messages=[{"role": "user", "content": prompt}])
            content = response.choices[0].message.content

            try:
                # Clean up potential markdown code blocks
                clean_content = content.replace("```json", "").replace("```", "").strip()
                action = json.loads(clean_content)

                tool_name = action["tool"]
                tool_args = action["parameters"]
                print(f"\nAI Decided to call: {tool_name} with {tool_args}")

                # 4. Call the tool via MCP
                result = await session.call_tool(tool_name, tool_args)
                tool_output = result.content[0].text
                print(f"Tool Output: {tool_output}")

                # 5. Final Answer
                final_prompt = f"Question: {question}\nData: {tool_output}\nProvide a natural answer."
                final_res = completion(model=DEFAULT_MODEL, messages=[{"role": "user", "content": final_prompt}])
                print(f"\nFINAL ANSWER: {final_res.choices[0].message.content}")

            except Exception as e:
                print(f"Error parsing or executing: {e}")

if __name__ == "__main__":
    asyncio.run(run_agent())
