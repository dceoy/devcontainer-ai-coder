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

## Code Refactoring Guidelines (Kent Beck's Tidying)

Follow Kent Beck's "Tidying" approach when refactoring code. The philosophy is: **"Make the change easy, then make the easy change."**

### Core Principles

1. **Small, Safe Steps** - Make changes that are easily reversible and won't introduce bugs
2. **Separate Commits** - Never mix structural changes (tidying) with behavioral changes (features/fixes)
3. **Economic Decision** - Tidy when it makes the immediate task easier

### Key Tidying Operations

1. **Guard Clause** - Replace nested conditionals with early returns
2. **Dead Code Removal** - Delete unused code, comments, or imports
3. **Explaining Variables** - Introduce variables for complex expressions
4. **Explaining Constants** - Replace magic numbers with named constants
5. **Extract Helper** - Move chunks of code into separate functions
6. **Normalize Symmetries** - Make similar code look the same
7. **Rationalize Names** - Improve variable/function names for clarity

### When to Tidy

- Before adding features to messy code
- When you're already reading and understanding code
- As part of daily development workflow
- Keep each tidying small and focused
- Ensure tests pass after each tidying

### Tidying Workflow

1. Identify needed behavioral change
2. Examine the code - if messy, tidy first
3. Commit tidyings as separate structural changes
4. Implement behavioral change in clean code
5. Commit behavioral change separately

Remember: All tidyings are refactorings, but keep them small (minutes, not hours) and low-risk.
