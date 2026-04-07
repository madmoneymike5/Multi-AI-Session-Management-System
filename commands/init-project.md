---
description: "Initialize a new project with the full session management system: CLAUDE.md, GEMINI.md, AGENTS.md, DEEPSEEK.md, docs/next-session.md, and memory directory. Run this once when starting any new project."
allowed-tools: Read, Write, Edit, Bash, Glob
---

You are initializing a new project with the full session management system. Do this carefully — you are setting up the foundation that every AI (Claude, Gemini, Codex, DeepSeek) will use to stay in sync across sessions.

## Step 1: Gather Project Info

Ask the user for the following if not already provided:
1. **Project name** — human-readable (e.g. "Flex Planner")
2. **Project description** — 2-3 sentences: what it is, who it's for, what problem it solves
3. **Tech stack** — languages, frameworks, key dependencies
4. **Architecture** — how the pieces fit together (even if rough)
5. **GitHub repo URL** — if it exists yet (can be "not yet")

If the user says "just use what you know" or is already in a project directory, read any existing files (package.json, README.md, existing CLAUDE.md, etc.) to infer what you can, then confirm with the user before writing anything.

## Step 2: Create or Update CLAUDE.md

Check if `CLAUDE.md` already exists.

**If it doesn't exist**, create it with this structure:
```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Working with the project owner
[Ask the user or infer from context — are they a professional dev, hobbyist, student?]

## Repo structure
[Fill in based on actual directory structure]

## Commands
[Fill in based on package.json scripts or Makefile targets]

## System architecture
[Fill in from user's description]

## Key design decisions
[Leave blank for now — will be filled in as decisions are made]

---

## Session Triggers

These triggers apply at ANY point in the conversation, not just the first message. Re-check on every user turn.

**Greeting trigger → run session-opener (with mid-session guard)**
If the user's message is a greeting ("good morning", "morning", "hi", "hello", "hey", "good afternoon", "good evening", "I'm back"):

1. **First, check whether you are already mid-session** — i.e., this conversation has substantive prior turns, files have been read, edits have been made, or context has accumulated beyond an initial greeting/briefing exchange.
2. **If mid-session:** Do NOT silently re-run session-opener. Instead, tell the user: "We're already mid-session — I have context loaded including [one-line summary of what we've been doing]. Want to `/clear` and get a fresh start-of-day briefing, or keep going from here? (You can also abort and just continue.)" Wait for their answer. The user must run `/clear` themselves — you cannot clear context for them. After they clear and greet again, the next turn will be a fresh session and the start-of-session branch below applies.
3. **If this is genuinely the start of the session** (first or second turn, no real work done yet): launch the `session-opener` agent via the Agent tool, then greet the user in the same response that delivers the brief.
4. **If session-opener has already run in this conversation** and no new context files have been touched since: just greet back briefly. Don't re-brief.

**End-of-day trigger → run session-closer**
If the user indicates they are done ("let's close this out", "I'm done for the day", "wrapping up", "goodnight", "see you tomorrow", "that's it for today", "calling it"), launch the `session-closer` agent via the Agent tool. Confirm with the user before any commits or pushes.

---

## Current State
<!-- Updated by session-closer each session -->
- Phase: Project initialization
- Last session: [TODAY'S DATE]
- Status: Fresh start — system initialized, no code yet
- Blocked on: Nothing

## Session History
<!-- Appended by session-closer — newest first -->

### Session [TODAY'S DATE]
- Accomplished: Project initialized with full session management system
- Decisions: [none yet]
- Next: [first real task]
```

**If CLAUDE.md already exists**, add the `## Session Triggers`, `## Current State`, and `## Session History` sections at the end if they're not already there. Do not modify any existing content.

## Step 3: Create docs/next-session.md

Create `docs/` if it doesn't exist. Create `docs/next-session.md`:

```markdown
# Next Session — Work Queue

This file contains the current master plan and ready-to-paste instructions.
Updated by session-closer at end of each session.

---

## Current Priority

[What is the single most important thing to accomplish right now?]

---

## Work Queue

### Task 1 — [First task name]
**Problem:** [What needs to be done and why]

**Instructions for Claude:**
> [Ready-to-paste prompt — fill this in once you know what the task is]

---

## What We Are NOT Doing Yet
- [Scope boundary 1]
- [Scope boundary 2]

---

## Future Roadmap
[Things that matter eventually but not now]
```

## Step 4: Create the AI Context Files

Create three identical files in the project root. All three get the same content — they differ only in their header instruction to the AI reading them.

Generate content based on everything gathered in Step 1 and Step 2.

**`GEMINI.md`** — header: "Gemini CLI reads this automatically. Update `## Last Gemini Session` at end of your session."
**`AGENTS.md`** — header: "Codex/OpenAI agents read this automatically. Update `## Last Codex Session` at end of your session."
**`DEEPSEEK.md`** — header: "Paste this at the start of any DeepSeek/Ollama session (any version). Update `## Last DeepSeek Session` at end of your session."

Body of all three:
```markdown
# [Project Name] — AI Context Briefing
Last updated: [TODAY'S DATE] — project initialization

> [AI-specific header instruction above]

## What This Project Is
[2-3 sentence summary]

## Architecture
[Tech stack and how pieces connect]

## Current State
- Phase: Project initialization
- Last session: [TODAY'S DATE]
- Status: Fresh start
- Blocked on: Nothing

## What's Next
[Top items from docs/next-session.md]

## Key Design Decisions
[None yet — will be filled in as the project develops]

## What We Are NOT Doing Yet
[From docs/next-session.md]

## Last Session Summary
Project initialized with full session management system.

---

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
```

## Step 5: Initialize Memory Directory

The memory directory path is:
`~/.claude/projects/[SLUG]/memory/`

Where SLUG = the current working directory path with backslashes/forward slashes replaced by `-` and colons removed.
Example: `C:\Dev\my-project` → `C--Dev-my-project`

Create the directory and an initial `MEMORY.md`:
```markdown
# Memory Index

- [Project Overview](project_overview.md) — [Project name]: initial setup and goals
```

Create `project_overview.md` in the same directory:
```markdown
---
name: Project Overview
description: [Project name] — initial architecture, goals, and constraints
type: project
---

[Fill in from what was gathered in Step 1]

**Why:** [What problem this solves for the user]
**How to apply:** At session start, use this to understand project purpose before suggesting approaches.
```

## Step 6: Initialize Git (if needed)

Check if `.git` exists. If not, ask: "Initialize a git repository for this project? (yes/no)"

If yes:
```bash
git init
git branch -M main
```

Then create a `.gitignore` appropriate for the tech stack if one doesn't exist.

## Step 7: Initial Commit

```bash
git add CLAUDE.md GEMINI.md AGENTS.md DEEPSEEK.md docs/next-session.md
git commit -m "[Project Name] — Project initialized with session management system"
```

## Step 8: Confirm

Report what was created:
```
Project initialized.

Created:
  ✓ CLAUDE.md (with Current State + Session History)
  ✓ GEMINI.md  (auto-loaded by Gemini CLI)
  ✓ AGENTS.md  (auto-loaded by Codex)
  ✓ DEEPSEEK.md (paste at Ollama session start)
  ✓ docs/next-session.md
  ✓ ~/.claude/projects/[slug]/memory/ (Claude memory directory)

All AI tools are ready. Greet Claude ("good morning", "hi") and the greeting
trigger in CLAUDE.md will run the session-opener agent to brief you.
Gemini and Codex auto-load their files. DeepSeek: run `deepseek` from this directory.

Run `@agent-session-closer` at the end of each session.
Run `@agent-brutal-critic` when you want unfiltered feedback.
```
