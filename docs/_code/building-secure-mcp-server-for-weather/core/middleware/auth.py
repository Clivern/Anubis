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

import logging
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware

logger = logging.getLogger(__name__)

# Global variable to store the current request context
_current_request = None


def set_current_request(request: Request):
    """Set the current request for tools to access"""
    global _current_request
    _current_request = request


def get_api_key():
    """Get the current user's API key"""
    global _current_request

    if _current_request and hasattr(_current_request.state, "api_key"):
        return _current_request.state.api_key

    return None


class AuthMiddleware(BaseHTTPMiddleware):
    """Middleware for Handling Authentication and Authorization"""

    async def dispatch(self, request: Request, call_next):
        # Set the current request context for tools to access
        set_current_request(request)

        # Only require authentication for actual MCP tool calls (POST requests with JSON body)
        if (
            request.url.path == "/mcp"
            and request.method == "POST"
            and "application/json" in request.headers.get("content-type", "")
        ):
            # Extract and store the API key from request headers
            api_key = request.headers.get("X-API-KEY")

            if api_key:
                # Store API key in request state for tools to access
                request.state.api_key = api_key
                logger.info(f"API key stored: {api_key}")
            else:
                request.state.api_key = None
                logger.info("No valid X-API-KEY header found for MCP tool call")
                raise HTTPException(
                    status_code=401,
                    detail="X-API-KEY header required for MCP tool calls",
                )
        else:
            # For non-tool-call requests, just log but don't require authentication
            logger.info(
                f"Non-tool-call request to {request.url.path} ({request.method}) - no authentication required"
            )
            request.state.api_key = None

        # Continue with the request
        response = await call_next(request)

        return response
