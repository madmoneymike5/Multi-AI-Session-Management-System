# Multi-AI Session Management System

Keep Claude, Gemini, Codex, and DeepSeek in sync across sessions — automatically.

Every AI starts each session knowing exactly where you left off. Every AI ends each session leaving a clean handoff. One brutal critic agent tells you the truth when you need it.

Inspired by [NetworkChuck's AI terminal workflow](https://www.youtube.com/watch?v=MsQACpcuTkU).

---

## What This Does

**The problem:** AI tools start each session cold. You waste the first 10 minutes re-explaining context. When you use multiple AI tools (Claude for architecture, Gemini for research, DeepSeek locally), they have no idea what the others did.

**The solution:** Three personal Claude Code agents + a shared context file system + shell functions that load context automatically.

| What | How |
|------|-----|
| Claude auto-briefs at session start | `SessionStart` hook reads your project files |
| Gemini loads project context | Auto-reads `GEMINI.md` from your project root |
| Codex loads project context | Auto-reads `AGENTS.md` from your project root |
| DeepSeek/Ollama loads context | `deepseek` shell command pipes `DEEPSEEK.md` as system prompt |
| End-of-session sync | `@agent-session-closer` updates all 4 files + commits to git |
| Honest quality feedback | `@agent-brutal-critic` reviews your work with zero flattery |

---

## Prerequisites

- [Claude Code CLI](https://claude.ai/code) — required
- [Ollama](https://ollama.com) + a DeepSeek model — optional, only needed for DeepSeek support
- Git — for session commit/push feature
- `node` or `python3` — for the install script to merge `settings.json`

---

## Installation

### Windows (PowerShell)
```powershell
git clone https://github.com/madmoneymike5/Multi-AI-Session-Management-System.git
cd Multi-AI-Session-Management-System
.\install.ps1
```

If you get a script execution error:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### macOS / Linux / Git Bash (Windows)
```bash
git clone https://github.com/madmoneymike5/Multi-AI-Session-Management-System.git
cd Multi-AI-Session-Management-System
bash install.sh
```

### What gets installed

```
~/.claude/agents/
  session-closer.md    ← end-of-day ritual
  session-opener.md    ← morning briefing
  brutal-critic.md     ← adversarial reviewer

~/.claude/commands/
  init-project.md      ← new project bootstrapper

~/.claude/settings.json
  SessionStart hook    ← auto-brief on every session open

~/.bashrc / PowerShell $PROFILE
  deepseek()           ← Ollama wrapper with auto-context loading
```

---

## Usage

### Starting a new project
In Claude Code, from your project directory:
```
/init-project
```
Creates `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `DEEPSEEK.md`, `docs/next-session.md`, and the Claude memory directory. All AI tools are briefed from day one.

### Daily workflow

**Morning (session start):**
Claude briefs you automatically. No prompt needed.

**During the day:**
Work normally. Use whichever AI tool fits the task.

**End of day (session close):**
```
@agent-session-closer
```
Claude summarizes the session, updates all context files, and commits + pushes to git.

**Starting Gemini or Codex:**
Just `cd` into your project and open the tool. They auto-load their context files.

**Starting DeepSeek:**
```bash
cd your-project
deepseek                    # uses r1:8b by default
deepseek deepseek-r1:32b    # use a specific model
```

**When you want unfiltered feedback:**
```
@agent-brutal-critic to roast what we did today
```
Three independent reviewer personalities (Paranoid Architect, Code Assassin, Product Skeptic). Hard to please by design.

---

## How the Context Sync Works

At end of each session, `@agent-session-closer` writes identical project state to four files:

- `CLAUDE.md` — gains a `## Session History` entry and updated `## Current State`
- `GEMINI.md` — Gemini CLI reads this automatically at session start
- `AGENTS.md` — Codex reads this automatically at session start
- `DEEPSEEK.md` — loaded as system prompt by the `deepseek` shell function

Any AI that does work updates its own file at session end. The session-opener agent checks timestamps and flags if another AI updated context since Claude's last session.

---

## Repo Structure

```
agents/          → install to ~/.claude/agents/
commands/        → install to ~/.claude/commands/
shell/           → shell functions for bash and PowerShell
settings/        → settings.json hook fragment (for manual install)
install.sh       → bash installer
install.ps1      → PowerShell installer
```

---

## Manual Installation

If you prefer not to run the install script:

1. Copy `agents/*.md` to `~/.claude/agents/`
2. Copy `commands/*.md` to `~/.claude/commands/`
3. Merge the `hooks` block from `settings/hook-fragment.json` into `~/.claude/settings.json`
4. Add the function from `shell/deepseek.sh` to your `~/.bashrc`, or `shell/deepseek.ps1` to your PowerShell `$PROFILE`

---

## Contributing

This system was built for personal use and shared as-is. If you improve it — better agent prompts, support for new AI tools, smarter install scripts — PRs are welcome.
