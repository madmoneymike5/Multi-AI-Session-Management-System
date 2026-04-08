# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-08 by session-closer

> **Gemini CLI:** This file is loaded automatically. Check `docs/next-session.md` for current priorities.
> At the END of your session, update the `## Last Gemini Session` section at the bottom.

## What This Project Is

A distributable toolkit for keeping Claude, Gemini, Codex, and DeepSeek in sync across sessions. Contains personal Claude Code agents, install scripts, and shell functions. Others install it to get automatic session briefing, end-of-day sync, and an adversarial code reviewer.

## Architecture

```
agents/          → Claude Code personal agents (install to ~/.claude/agents/)
commands/        → Claude Code personal commands (install to ~/.claude/commands/)
shell/           → Shell functions for DeepSeek/Ollama (bash + PowerShell)
install.sh       → One-command bash installer (Linux/macOS/Git Bash)
install.ps1      → One-command PowerShell installer (Windows)
```

## Current State
- Phase: Post-release bug fixes + simplification
- Last session: 2026-04-08
- Status: Two brutal-critic runs completed. All 11 bugs from the brutal-critic queue have been fixed or retired. GitHub issues #1–#6 opened and closed. Context files synced. Pushed to GitHub.
- Blocked on: Nothing — remaining work is clean-machine install testing

## What's Next
1. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive setups)
2. Test install.sh on a fresh Linux or macOS machine
3. Consider a `gemini` shell function (thin wrapper to confirm context loaded)

## Key Design Decisions (Do Not Revisit Without Good Reason)
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- Ollama uses temp Modelfile (ollama create/rm), NOT --system flag — more reliable
- install.ps1 uses `$PROFILE` not hardcoded `$env:USERPROFILE\Documents` — fixes OneDrive setups
- No `2>$null` on ollama calls in PowerShell — Go CLI programs on Windows break when stderr is redirected to null
- Session Triggers implemented in CLAUDE.md (reloaded every turn), NOT via UserPromptSubmit hook — simpler, version-controlled, no settings.json changes needed
- **No SessionStart auto-brief hook, ever.** Tried twice, removed for good. The launch tax (~30s on every startup, even when no brief is needed) is not worth paying when the greeting trigger handles the same job opt-in. Also, `additionalContext` from a SessionStart hook is treated as background context, not as a reliable instruction the model acts on. The greeting trigger in CLAUDE.md is the canonical mechanism.
- Sentinel marker pattern (# BEGIN/END deepseek-maisms) chosen over function-name grep for safe idempotent upgrades in both bash and PowerShell
- Dynamic version detection (grep from source file) instead of hardcoded string — one source of truth
- Session-opener AI-activity check reads narrative ## Last [AI] Session summaries, not fragile date strings

## What We Are NOT Doing Yet
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI
- Packaging as npm/pip (future roadmap)
- SessionStart auto-brief hook (intentionally removed — see Key Design Decisions)

## Last Session Summary

**Session 2026-04-08 — Full bug-fix session, two brutal-critic runs**

Two brutal-critic runs were performed. All 11 bugs from the brutal-critic queue were fixed or retired.

**First brutal-critic run — 5 code bugs fixed:**
- Bug 2: README personality names updated to describe the 27-type library correctly
- Bug 3: deepseek.sh — removed 2>/dev/null, added || error check on ollama create with diagnostic message
- Bug 4: deepseek.sh + install.sh — added # deepseek v2 version stamp, sentinel markers (# BEGIN/END deepseek-maisms), dynamic version detection via grep, sed removal of stale blocks with .bashrc.bak backup
- Bug 5: session-closer.md — replaced git add -A with explicit file list + inline comment
- Bug 8: README.md + commands/init-project.md — added private-repo warning about AI context files in public repos

**Second brutal-critic run — 6 bugs fixed (GitHub issues #1–#6, all closed):**
- #1: deepseek.ps1 — added $LASTEXITCODE check after ollama create
- #2: deepseek.ps1 + install.ps1 — added # deepseek-ps1 v2 stamp, sentinel markers, dynamic version detection, profile backup (.bak), regex block removal on upgrade
- #3: install.sh — fixed step numbering gap (# 5. → # 4.)
- #4: session-closer.md — moved WORKING.md deletion to before commit, added git rm staging step
- #5: session-opener.md — replaced unparseable date comparison with ## Last [AI] Session narrative check
- #6: README.md — "27-type library" → "ever-growing library (currently 27 types, expanding via Self-Expansion Protocol)"

Bug 7 (stale GEMINI.md / AGENTS.md / DEEPSEEK.md) resolved by running this session-closer.

**Key decisions made:**
- Sentinel marker pattern chosen over function-name grep for idempotent upgrades
- Dynamic version detection (grep from source) over hardcoded strings
- Session-opener now reads narrative summaries for AI-activity detection, not date strings

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

Note: `WORKING.md` is a soft signal, not a hard lock. If two AIs truly need to work on the same files at the same time, the right approach is to use separate git branches and merge when done.

---

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
