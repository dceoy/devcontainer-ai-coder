# Copilot Agent Instructions

In GitHub Copilot agent mode, no state is preserved between sessions. All past work and decisions must be documented in Markdown files within the "memory-bank" directory (the Memory Bank), which serves as the sole source of project information.

## Memory Bank Structure

- **projectbrief.md**: Project objectives, requirements, and goals. The foundation for everything.
- **productContext.md**: Product background, problems to solve, and user experience goals.
- **activeContext.md**: Current work focus, recent changes, next steps, key decisions, and learnings.
- **systemPatterns.md**: System architecture, design patterns, and major technical decisions.
- **techContext.md**: Technologies used, development environment, constraints, and dependencies.
- **progress.md**: Progress, remaining tasks, known issues, and decision history.

Create additional Markdown files as needed to organize feature specifications, API docs, testing strategies, deployment procedures, etc.

## Core Workflow

### 1. At the Start of Each Task
- Always read all files in the memory-bank to understand the current state and plan your approach.
- If any files are missing, plan to create them and share the plan in chat.

### 2. While Executing Tasks
- Record the latest status and decisions in activeContext.md and progress.md, updating the memory-bank as you go.
- When making significant changes or discovering new patterns, update all relevant files.

### 3. When to Update the Memory Bank
- When new designs, patterns, or learnings are discovered
- After major implementations or decisions
- When the user requests "update memory bank" (in this case, review and update all files as needed)
- When clarification of context is required

## Notes
- The Copilot agent relies solely on the memory-bank for context. Incomplete documentation will result in less accurate assistance.
- Keep activeContext.md and progress.md especially up to date.
- Since the agent resets completely between sessions, the accuracy and completeness of the memory-bank is critical for project continuity.