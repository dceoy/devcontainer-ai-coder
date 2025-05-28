# GitHub Copilot Instructions
_This file guides GitHub Copilot (Chat & Completions) when working in this
repository.
Treat every rule in this document as **high-priority** unless otherwise noted._

---

## 1. Project Memory

1. **Always load `CLAUDE.md` first.**
   - Assume it contains the most up-to-date project knowledge, commands,
     conventions, and architectural notes.
   - When suggesting code or answers, cross-check with its content.
2. **Never overwrite `CLAUDE.md` silently.**
   - All edits to `CLAUDE.md` must be proposed _explicitly_ in chat or via
     a code suggestion so a human can review.

---

## 2. Completions & Chat Guidance

### 2.1 General Behavior
| Guideline | Example |
|-----------|---------|
| Follow the commands in **`CLAUDE.md` → “Commands”** for build, test & deploy. | If asked “How do I build?”, answer with the `npm run build` script listed there. |
| Obey **code-style** & **lint rules** documented in `CLAUDE.md`. | Suggest 2-space indentation (not tabs) if `CLAUDE.md` says so. |
| Prefer **existing utilities / helpers** over reinventing logic. | If a `Logger` class exists, propose using it for all logging. |
| Provide reasons when offering multiple approaches. | “Option A uses memoization ✅ faster; Option B is simpler but slower.” |

### 2.2 Code Suggestions
- **Imports:** Use absolute or relative paths exactly as shown in existing files.
- **Tests:** Generate tests side-by-side with new code (same folder if pattern
  exists).
- **Comments:** Brief but descriptive.
  _Do not_ insert large generated explanations inside the code.

---

## 3. Workflow Conventions

1. **Branch names** → `feat/<slug>` or `fix/<slug>` (lower-case, no spaces).
2. **Commit messages** → Conventional Commits style
   (`feat:`, `fix:`, `docs:` …).
3. **Pull Requests**
   - Auto-fill the PR template if present.
   - Include a checklist of tests added/updated.
4. **Changelogs** → If the repo has a `CHANGELOG.md`, append a new entry
   under “Unreleased” in the same format.

---

## 4. Updating `CLAUDE.md`

> **IMPORTANT:** All updates must be _human-approved_. Never apply changes
> automatically.

### 4.1 When to Propose an Update
- A new command, script, or convention is introduced.
- An existing rule in `CLAUDE.md` is no longer correct.
- Repeated confusion in suggestions indicates missing memory.

### 4.2 How to Propose
1. In Copilot Chat, prefix with **“Update CLAUDE.md:”** then describe the bullet(s)
   to add/modify.
2. Or supply a code diff suggestion that edits `CLAUDE.md` only.

---

## 5. Constraints Checklist

- **No secrets** in code or `CLAUDE.md`. Use placeholder env vars (e.g.
  `${API_KEY}`).
- **No destructive commands** (`rm -rf`, `git push --force`) in suggestions
  unless explicitly asked.
- **Context size:** Keep answers concise; summarize long file paths or logs.
- **License headers:** If a new file type requires a header, include it.

---

## 6. Escalation

If uncertain or conflicting rules arise:

1. Re-read `CLAUDE.md` top-to-bottom.
2. If still unclear, **ask the user** for clarification _before_ generating
   code.

---

_© 2025 — Repository maintainers.
Last updated: 2025-05-29_

