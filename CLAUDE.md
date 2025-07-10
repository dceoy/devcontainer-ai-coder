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
gemini --sandbox --prompt "WebSearch: <query>"

# Example: Search for latest news
gemini --sandbox --prompt "WebSearch: What are the latest developments in AI?"
```

### Policy

When users request information that requires web search:

1. Use `gemini --sandbox --prompt` command via terminal
2. Parse and present the Gemini response appropriately

This ensures consistent and reliable web search results through the Gemini API.

## Development Methodology

This section combines essential guidance from Martin Fowler's refactoring, Kent Beck's tidying, and t_wada's TDD approaches.

### Core Philosophy

- **Small, safe, behavior-preserving changes** - Every change should be tiny, reversible, and testable
- **Separate concerns** - Never mix adding features with refactoring/tidying
- **Test-driven workflow** - Tests provide safety net and drive design
- **Economic justification** - Only refactor/tidy when it makes immediate work easier

### The Development Cycle

1. **Red** - Write a failing test first (TDD)
2. **Green** - Write minimum code to pass the test
3. **Refactor/Tidy** - Clean up without changing behavior
4. **Commit** - Separate commits for features vs refactoring

### Essential Practices

#### Before Coding

- Create TODO list for complex tasks
- Ensure test coverage exists
- Identify code smells (long functions, duplication, etc.)

#### While Coding

- **Test-First**: Write the test before the implementation
- **Small Steps**: Each change should be easily reversible
- **Run Tests Frequently**: After each small change
- **Two Hats**: Either add features OR refactor, never both

#### Refactoring Techniques

1. **Extract Function/Variable** - Improve readability
2. **Rename** - Use meaningful names
3. **Guard Clauses** - Replace nested conditionals
4. **Remove Dead Code** - Delete unused code
5. **Normalize Symmetries** - Make similar code consistent

#### TDD Strategies

1. **Fake It** - Start with hardcoded values
2. **Obvious Implementation** - When solution is clear
3. **Triangulation** - Multiple tests to find general solution

### When to Apply

- **Rule of Three**: Refactor on third duplication
- **Preparatory**: Before adding features to messy code
- **Comprehension**: As you understand code better
- **Opportunistic**: Small improvements during daily work

### Key Reminders

- One assertion per test
- Commit refactoring separately from features
- Delete redundant tests
- Focus on making code understandable to humans

Quote: "Make the change easy, then make the easy change." - Kent Beck
