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
| DeepSeek/Ollama loads context | `deepseek` shell command injects `DEEPSEEK.md` as system prompt via Modelfile |
| End-of-session sync | `@agent-session-closer` updates all 4 files, commits to git, optionally pushes |
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

### Activating in your current terminal

The installer sets up your shell profile, but **new functions only load when you open a new terminal**. To activate immediately in your current window without reopening:

| Shell | Command |
|-------|---------|
| PowerShell | `. $PROFILE` |
| Git Bash | `source ~/.bash_profile` |
| CMD | Not supported — open PowerShell instead |

> **Note:** `. $PROFILE` is a PowerShell command. It will fail if you run it in Git Bash. Make sure you're in the right shell before running these.
>
> **OneDrive users (common on Windows 11):** If your Documents folder syncs to OneDrive, your PowerShell profile lives at `C:\Users\[you]\OneDrive\Documents\PowerShell\...` not `C:\Users\[you]\Documents\...`. The install script handles this automatically via `$PROFILE` — but if you're editing your profile manually, make sure you're editing the right file. Run `$PROFILE` in PowerShell to see the exact path.

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

## Updating

This system improves over time — better agent prompts, bug fixes, support for new AI tools. When a new version is available, here's how to get it.

**Step 1: Pull the latest version**

Navigate to the folder where you originally cloned this repo, then run:

PowerShell (Windows):
```powershell
cd path\to\Multi-AI-Session-Management-System
git pull
```

Bash (macOS / Linux / Git Bash on Windows):
```bash
cd path/to/Multi-AI-Session-Management-System
git pull
```

> **Not sure where you cloned it?** Search your computer for a folder called `Multi-AI-Session-Management-System`. You only need to clone it once — after that, just `git pull` from that folder whenever you want to update.

**Step 2: Re-run the installer**

PowerShell:
```powershell
.\install.ps1
```

Bash:
```bash
bash install.sh
```

**What gets updated — and what doesn't**

The installer is designed to be safe to run more than once:

| What | Updated? |
|------|----------|
| Claude agents (`session-closer`, `session-opener`, `brutal-critic`) | ✅ Always — replaced with the latest version |
| `/init-project` command | ✅ Always — replaced with the latest version |
| `deepseek` shell function | ✅ Only if it isn't already in your profile |
| `settings.json` SessionStart hook | ✅ Only if it isn't already present |
| Your project files (`CLAUDE.md`, `GEMINI.md`, etc.) | ❌ Never touched |
| Your git history or any work in your projects | ❌ Never touched |

In other words: the system itself gets upgraded, but nothing inside your actual projects changes. Your work stays exactly as you left it.

---

## Usage

### Starting a new project
In Claude Code, from your project directory:
```
/init-project
```
Creates `CLAUDE.md`, `GEMINI.md`, `AGENTS.md`, `DEEPSEEK.md`, `docs/next-session.md`, and the Claude memory directory. All AI tools are briefed from day one.

### Adding to an existing project

Already have a project in progress? Run the same command:
```
/init-project
```
It's safe to run on a project you've already been working on. If a `CLAUDE.md` already exists, it won't be overwritten — the command will read it and use it as the source of truth. Any missing context files (`GEMINI.md`, `AGENTS.md`, `DEEPSEEK.md`, `docs/next-session.md`) will be created and populated from your existing `CLAUDE.md`. Think of it as "catch the other AIs up to where Claude already is."

### Daily workflow

**Morning (session start):**
Claude briefs you automatically. No prompt needed.

**During the day:**
Work normally. Use whichever AI tool fits the task.

**End of day (session close):**
Just tell Claude you're done — "let's wrap up", "close out the session", "end of day" all work. Or call it explicitly:
```
@agent-session-closer
```
Claude summarizes the session, updates all context files, commits to git, and asks whether you want to push to GitHub.

**Starting Gemini or Codex:**
Just `cd` into your project and open the tool. They auto-load their context files.

**Starting DeepSeek:**
```bash
cd your-project
deepseek                      # uses deepseek-r1:8b by default
deepseek deepseek-r1:14b      # use any installed model by name
```

The model argument accepts any model name that `ollama list` shows. You must have pulled the model first (`ollama pull modelname`). The default is `deepseek-r1:8b` — change this by editing the `param` line in your shell profile if you want a different default.

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

Any AI that does work updates its own file at session end. The next time you open Claude, the session-opener agent checks timestamps and flags if another AI updated context since Claude's last session.

### Concurrent sessions

This system is designed around sequential use — one AI working at a time. If you need to run two AIs at the same time, here's how to stay sane:

**Short-term awareness — `WORKING.md`:** Each AI writes a brief note to `WORKING.md` in your project root when it starts a session, and clears it when done. The note includes which AI is working and what it's focused on. Claude's session-opener will warn you if it finds an active `WORKING.md` entry when you open a new session. This is a soft signal, not a hard lock — it tells you "someone else may be working" so you can coordinate manually.

**File-level safety — git branches:** `WORKING.md` can't actually prevent two AIs from editing the same file at the same time. The real solution is to put each AI on its own git branch. When both are done, merge the branches. Git will catch any overlapping changes and let you resolve them — the same way any two developers would work together on the same codebase.

> **Tip:** If you're running Gemini and Claude at the same time, a clean split is: "Gemini owns research and docs on branch `gemini/research`, Claude owns implementation on `main`." They rarely touch the same files that way.

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
