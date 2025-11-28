import asyncio
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client
import json

# Define the MCP server configuration
# We use 'npx' to run the weather server directly from npm
server_params = StdioServerParameters(
    command="npx",
    args=["-y", "@philschmid/weather-mcp"],
    env=None
)

async def explore_mcp_server():
    print("Connecting to weather server... (this may take a moment to download the npx package)")

    # Establish the connection via Stdio (Standard Input/Output)
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            # Initialize the MCP session
            await session.initialize()
            print(f"✓ Connected to MCP weather server!\n")

            # List available tools provided by the server
            tools_result = await session.list_tools()
            tools = tools_result.tools

            print(f"→ Available Tools:")
            for tool in tools:
                print(f"  • {tool.name}: {tool.description}")
                print(f"    Parameters: {json.dumps(tool.inputSchema, indent=6)}\n")

if __name__ == "__main__":
    asyncio.run(explore_mcp_server())
