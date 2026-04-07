# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-07 by session-closer

> **Gemini CLI:** This file is loaded automatically. Check `docs/next-session.md` for current priorities.
> At the END of your session, update the `## Last Gemini Session` section at the bottom.

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
- Phase: Post-release bug fixes + SessionStart hook fix
- Last session: 2026-04-07
- Status: Fixed SessionStart hook error on Windows — converted invalid `type: prompt` hook to `type: command` via a PowerShell script; all changes in ~/.claude/ (outside repo); 9 brutal-critic bugs still queued; no push
- Blocked on: Verify fix by quitting and relaunching Claude Code — "SessionStart:startup hook error" should be gone

## What's Next
1. Quit and relaunch Claude Code to verify "SessionStart:startup hook error" is gone
2. Test that Session Triggers fire correctly on a fresh session restart (greeting → session-opener, goodbye → session-closer)
3. Fix the 9 brutal-critic bugs queued in docs/next-session.md
4. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive)
5. Test install.sh on Linux/macOS

## Key Design Decisions (Do Not Revisit Without Good Reason)
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- Ollama uses temp Modelfile (ollama create/rm), NOT --system flag — more reliable
- install.ps1 uses `$PROFILE` not hardcoded `$env:USERPROFILE\Documents` — fixes OneDrive setups
- No `2>$null` on ollama calls in PowerShell — Go CLI programs on Windows break when stderr is redirected to null
- install.sh merges settings.json using node or python3 (no jq dependency)
- Session Triggers implemented in CLAUDE.md (reloaded every turn), NOT via UserPromptSubmit hook — simpler, version-controlled, no settings.json changes needed
- SessionStart hook stays as-is; Session Triggers are a separate layer on top
- Claude Code SessionStart hooks require `type: "command"`, not `type: "prompt"` — use a .ps1/.sh script to emit `hookSpecificOutput` JSON with `additionalContext`
- Cast Get-Content to `[string]` before ConvertTo-Json — PSObject note-properties (PSPath, PSDrive, etc.) otherwise expand into hundreds of KB

## What We Are NOT Doing Yet
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI
- Packaging as npm/pip (future roadmap)

## Last Session Summary

**Session 2026-04-07 (second)**

Investigated and fixed the "SessionStart:startup hook error" that appeared on every Claude Code launch.

Root cause: ~/.claude/settings.json had a SessionStart hook with `"type": "prompt"`, which is not a valid Claude Code hook type. Only `"type": "command"` is supported. The harness rejected it at startup silently with the error banner.

Fix (all in ~/.claude/, outside the repo — no repo files changed this session):
- Created ~/.claude/session-start-context.txt — holds the briefing instruction prose
- Created ~/.claude/session-start-hook.ps1 — reads the context file and emits `hookSpecificOutput` JSON with `additionalContext`
- Edited ~/.claude/settings.json — converted hook to `type: "command"` pointing at the .ps1

Two bugs were caught during testing before declaring done:
1. `Get-Content -Raw` attached PSObject note-properties (PSPath, PSDrive, etc.) that ConvertTo-Json expanded into a 374KB blob. Fixed with `[string]` cast.
2. Em-dash mojibake from system codepage. Fixed with `-Encoding utf8`.

Script now produces clean single-string `additionalContext` JSON. Hook fix is Windows-only (PowerShell), but lives in personal ~/.claude/ so it has zero impact on Linux/Mac users installing MAISMS.

Decisions: Claude Code SessionStart hooks only support `type: "command"`; the prose-in-.txt / script-wraps-to-JSON / settings-points-at-script pattern is clean and recommended for Windows; always cast Get-Content to [string] before ConvertTo-Json.

Next immediate step: quit and relaunch Claude Code to confirm the error banner is gone.

---

## Instructions for This AI

At the start of your session, read this file fully. Then check if CLAUDE.md or docs/next-session.md have newer information.

**When you start working:**
1. Write `WORKING.md` in the project root with your name, the current time, and what you're focused on:
   ```
   AI: Gemini
   Started: [date and time]
   Focus: [what you're working on]
   ```
2. If `WORKING.md` already exists with another AI's name and a recent timestamp (same day), stop and tell the user: another AI may be in an active session. Ask whether to proceed or coordinate first.

**When you finish working:**
1. Update the `## Last Gemini Session` section below with a summary of what you did.
2. Delete `WORKING.md` from the project root.

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
