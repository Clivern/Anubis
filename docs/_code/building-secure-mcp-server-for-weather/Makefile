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

.PHONY: help install run run-custom clean

help: ## Show this help message
	@echo "Available commands:"
	@echo "  install     - Install dependencies using uv sync"
	@echo "  run         - Run the server on localhost:8000"
	@echo "  run-custom  - Run the server with custom host and port"
	@echo "  clean       - Clean up any temporary files"
	@echo ""
	@echo "Examples:"
	@echo "  make install"
	@echo "  make run"
	@echo "  make run-custom HOST=0.0.0.0 PORT=9000"

install: ## Install dependencies
	uv sync

run: ## Run the server on localhost:8000
	uv run python app.py

run-custom: ## Run the server with custom host and port (e.g., make run-custom HOST=0.0.0.0 PORT=9000)
	uv run python app.py --host $(HOST) --port $(PORT)

clean: ## Clean up temporary files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type f -name "*.log" -delete
