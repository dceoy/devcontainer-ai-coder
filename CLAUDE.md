# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains Docker container configurations for AI coding agents. It provides a development environment with various AI tools pre-installed.

## Key Components

- **Dockerfile**: Defines a multi-stage build for creating an Ubuntu-based container with Python, Node.js, and various AI tools
- **compose.yml**: Docker Compose configuration for running the container
- **prompts/**: Directory containing example prompts for AI design document generation
- **deepresearch/**: Directory containing research on using AI for design document creation

## Available AI Tools

The container comes pre-installed with:
- Claude Code CLI (`@anthropic-ai/claude-code`)
- Gemini CLI (`@google/gemini-cli`)
- OpenAI Codex (`@openai/codex`)

## Working with the Repository

### Building the Container

```sh
# Build the container image
docker build -t devcontainer-ai-coder .

# Alternatively, pull from GitHub Container Registry
docker image pull ghcr.io/dceoy/devcontainer-ai-coder:latest
```

### Running the Container

```sh
# Using docker-compose
docker-compose up -d

# Using docker directly
docker run -v ${PWD}:/workspace -v ${HOME}/.aws:/home/cli/.aws -v ${HOME}/.gitconfig:/home/cli/.gitconfig -w /workspace --entrypoint /usr/bin/zsh -it dceoy/devcontainer-ai-coder:latest
```

### Working with AI Design Document Prompts

The repository contains examples for generating cloud system design documents using Large Language Models (LLMs):

1. Review the prompt templates in the `prompts/` directory
2. Use the research materials in `deepresearch/` for best practices
3. Customize prompts for your specific design document needs

## Environment Details

- Base OS: Ubuntu 24.04
- Python version: 3.13
- Pre-configured with various development tools:
  - Git and GitHub CLI
  - Vim with plugins
  - Oh My Zsh
  - AWS CLI
  - Node.js and npm

## Web Search Instructions

For tasks requiring web search, always use `gemini` command instead of the built-in web search tool.

### Usage

```sh
# Basic search query
gemini --prompt "WebSearch: <query>"

# Example: Search for latest news
gemini --prompt "WebSearch: What are the latest developments in AI?"
```

### Policy

When users request information that requires web search:

1. Use `gemini --prompt` command via terminal
2. Parse and present the Gemini response appropriately

This ensures consistent and reliable web search results through the Gemini API.
