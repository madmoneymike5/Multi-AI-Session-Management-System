# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## What This Repo Is

A distributable system for keeping multiple AI tools (Claude, Gemini, Codex, DeepSeek) in sync across sessions. Contains three personal Claude Code agents, a slash command, install scripts, shell functions, and documentation.

This repo IS the system — it doesn't use the system on itself, it IS the system. Changes here affect every project that installs from it.

## Repo Structure

```
agents/          → Claude Code personal agents (install to ~/.claude/agents/)
  session-closer.md
  session-opener.md
  brutal-critic.md

commands/        → Claude Code personal commands (install to ~/.claude/commands/)
  init-project.md

shell/           → Shell functions
  deepseek.sh    → bash (Git Bash, Linux, macOS)
  deepseek.ps1   → PowerShell (Windows)

settings/        → Claude Code settings fragment
  hook-fragment.json

install.sh       → One-command bash installer
install.ps1      → One-command PowerShell installer
README.md        → Public documentation
```

## Key Design Decisions

- **Agents are personal, not project-level** — they go in `~/.claude/agents/`, not `.claude/agents/` in any project
- **Four identical context files** — CLAUDE.md / GEMINI.md / AGENTS.md / DEEPSEEK.md all contain the same project state; session-closer is the source of truth
- **install.sh uses node or python3 for JSON merging** — avoids requiring `jq` which isn't standard on Windows
- **Ollama uses temp Modelfile (ollama create), not --system flag** — more reliable; --system flag was replaced this session
- **install.ps1 uses $PROFILE for profile path** — not hardcoded $env:USERPROFILE\Documents, which breaks on OneDrive-synced machines
- **No 2>$null on ollama calls in PowerShell** — Go-based CLI programs on Windows throw "failed to get console mode for stderr: The handle is invalid" when stderr is redirected to null

## What We Are NOT Doing

- Building a web UI or dashboard
- Supporting proprietary/closed AI tools without CLI access
- Auto-updating installed agents (user controls their own ~/.claude/)

---

## Current State
- Phase: Post-release bug fixes
- Last session: 2026-04-06
- Status: DeepSeek PowerShell function confirmed working; install.ps1 fixed for OneDrive; pushed to GitHub
- Blocked on: Nothing — next is testing install scripts on a clean machine

## Session History

### Session 2026-04-06 (second)
- Accomplished: Fixed DeepSeek PowerShell integration — confirmed working end-to-end; fixed install.ps1 profile path for OneDrive; removed 2>$null from ollama calls; created PowerShell profile at correct OneDrive path
- Decisions: Switch Ollama approach from --system flag to temp Modelfile (ollama create/rm); use $PROFILE not hardcoded path; never redirect stderr to null for Go CLI tools on Windows; SessionStart hook error was transient (no config change needed)
- Next: Test install scripts on a clean machine (GitHub push already done)

### Session 2026-04-06
- Accomplished: Created full repo structure — agents, commands, shell functions, install scripts (bash + PowerShell), README, AI context files, CLAUDE.md
- Decisions: Use --system flag for Ollama (cleaner than pipe); install.sh handles JSON merge with node/python3 fallback; README credits NetworkChuck
- Next: Create GitHub repo, push, verify install scripts work on a clean machine
