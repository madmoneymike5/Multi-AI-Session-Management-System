# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-06 by session-closer

> **DeepSeek (Ollama):** Run `deepseek` from this directory — auto-loads this file as system context.
> At the END of your session, update the `## Last DeepSeek Session` section at the bottom.

## What This Project Is

A distributable toolkit for keeping Claude, Gemini, Codex, and DeepSeek in sync across sessions. Contains personal Claude Code agents, install scripts, and shell functions. Others install it to get automatic session briefing, end-of-day sync, and an adversarial code reviewer.

## Architecture

```
agents/          → Claude Code personal agents (install to ~/.claude/agents/)
commands/        → Claude Code personal commands (install to ~/.claude/commands/)
shell/           → Shell functions for DeepSeek/Ollama (bash + PowerShell)
settings/        → Claude Code settings fragment (SessionStart hook)
install.sh       → One-command bash installer (Linux/macOS/Git Bash)
install.ps1      → One-command PowerShell installer (Windows)
```

## Current State
- Phase: Post-release bug fixes
- Last session: 2026-04-06
- Status: DeepSeek PowerShell function confirmed working; install.ps1 fixed for OneDrive; ready to push to GitHub
- Blocked on: Nothing — ready to push and test on clean machine

## What's Next
1. Push to GitHub and verify README install commands work
2. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive)
3. Test install.sh on Linux/macOS
4. Consider a thin `gemini` shell wrapper (low priority)

## Key Design Decisions (Do Not Revisit Without Good Reason)
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- Ollama uses temp Modelfile (ollama create/rm), NOT --system flag — more reliable
- install.ps1 uses `$PROFILE` not hardcoded `$env:USERPROFILE\Documents` — fixes OneDrive setups
- No `2>$null` on ollama calls in PowerShell — Go CLI programs on Windows break when stderr is redirected to null
- install.sh merges settings.json using node or python3 (no jq dependency)

## What We Are NOT Doing Yet
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI
- Packaging as npm/pip (future roadmap)

## Last Session Summary

**Session 2026-04-06 (second session)**

Two bugs in the DeepSeek PowerShell integration were diagnosed and fixed:

1. SessionStart hook error — determined to be a transient LLM call timeout/network issue. Hook format (matcher/hooks wrapper) is correct per schema. No config change made.

2. install.ps1 profile path bug — was hardcoding `$env:USERPROFILE\Documents\WindowsPowerShell\...` which breaks on OneDrive-synced machines. Fixed to use `$PROFILE` which resolves correctly in all cases.

3. Ollama approach changed — switched from `--system` flag (which was the original design decision) to creating a temporary Modelfile via `ollama create`. This is more reliable.

4. Removed `2>$null` from all `ollama create` and `ollama rm` calls — Go-based programs on Windows throw "failed to get console mode for stderr: The handle is invalid" when stderr is redirected to null. The error was swallowed silently before, now it surfaces properly.

5. Created PowerShell profile at `C:\Users\micha\OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` with the working deepseek function.

DeepSeek confirmed working end-to-end.

---

## Instructions for This AI

At the start of your session, read this file fully. Then check if CLAUDE.md or docs/next-session.md have newer information.

At the END of your session, update the relevant section below before closing.

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
