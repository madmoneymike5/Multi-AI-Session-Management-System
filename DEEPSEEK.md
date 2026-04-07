# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-07 by session-closer

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
- Phase: Post-release bug fixes + Session Triggers feature
- Last session: 2026-04-07
- Status: Session Triggers added to CLAUDE.md and init-project.md; brutal-critic ran and found 8 bugs all queued in next-session.md; local commit only (no push)
- Blocked on: Nothing — immediate next step is testing Session Triggers on a fresh session restart

## What's Next
1. Test Session Triggers on a fresh session restart (greeting → session-opener, goodbye → session-closer)
2. Fix the 8 brutal-critic bugs queued in docs/next-session.md
3. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive)
4. Test install.sh on Linux/macOS
5. Consider a thin `gemini` shell wrapper (low priority)

## Key Design Decisions (Do Not Revisit Without Good Reason)
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- Ollama uses temp Modelfile (ollama create/rm), NOT --system flag — more reliable
- install.ps1 uses `$PROFILE` not hardcoded `$env:USERPROFILE\Documents` — fixes OneDrive setups
- No `2>$null` on ollama calls in PowerShell — Go CLI programs on Windows break when stderr is redirected to null
- install.sh merges settings.json using node or python3 (no jq dependency)
- Session Triggers implemented in CLAUDE.md (reloaded every turn), NOT via UserPromptSubmit hook — simpler, version-controlled, no settings.json changes needed
- SessionStart hook stays as-is; Session Triggers are a separate layer on top

## What We Are NOT Doing Yet
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI
- Packaging as npm/pip (future roadmap)

## Last Session Summary

**Session 2026-04-07**

Three things happened this session:

1. Brutal-critic audit — ran brutal-critic against this repo. Found 8 bugs. All catalogued in docs/next-session.md under "Bugs Found by Brutal Critic (2026-04-07)". Key findings: install scripts overwrite hooks instead of merging, README describes old personality names, deepseek.sh suppresses stderr in violation of a CLAUDE.md decision, session-closer uses `git add -A` (data exposure risk), hook prompt text is duplicated in three places out of sync.

2. Session Triggers feature — added a `## Session Triggers` block to CLAUDE.md. This makes Claude detect greetings and goodbyes at any point in the conversation (not just SessionStart) and run session-opener or session-closer automatically. Includes a mid-session guard: if a greeting arrives when context is already loaded, Claude offers the user a `/clear` option instead of silently re-briefing. This was the first real implementation — what the user thought was already working in another project was only the one-shot SessionStart hook.

3. init-project propagation — mirrored the Session Triggers block into commands/init-project.md so every new project bootstrapped via /init-project gets the behavior automatically. Also updated the "if CLAUDE.md already exists" branch to inject the section if missing.

Decision: CLAUDE.md is reloaded every turn by the harness, making it the right place for continuous trigger logic. No UserPromptSubmit hook needed.

No push this session — user wants to exit and test fresh-session trigger behavior before pushing to GitHub.

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
