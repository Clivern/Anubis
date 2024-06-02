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

import argparse
import logging
from mcp.server.fastmcp import FastMCP
import uvicorn

# Import core modules
from core.middleware.auth import AuthMiddleware
from core.tools.weather import register_weather_tools

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create an MCP server
mcp = FastMCP("Weather MCP Server")


# Register all tools, resources, and prompts
def register_all_components(mcp: FastMCP):
    """Register all MCP components"""
    register_weather_tools(mcp)
    logger.info("All MCP components registered successfully")


# Register components
register_all_components(mcp)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run MCP server")
    parser.add_argument("--host", default="0.0.0.0", help="Host to bind to")
    parser.add_argument("--port", type=int, default=8000, help="Port to bind to")

    args = parser.parse_args()

    # Create the HTTP app and add middleware
    app = mcp.streamable_http_app()
    app.add_middleware(AuthMiddleware)

    # Run as HTTP server
    print(f"Starting MCP HTTP server on {args.host}:{args.port}")
    print("Authentication middleware enabled - Authorization header required")
    uvicorn.run(app, host=args.host, port=args.port)
