# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-07 by session-closer

> **Codex/OpenAI Agents:** This file is loaded automatically. Check `docs/next-session.md` for current priorities.
> At the END of your session, update the `## Last Codex Session` section at the bottom.

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
- Last session: 2026-04-07 (third)
- Status: Removed the SessionStart auto-brief hook entirely from both personal `~/.claude/` and the repo. Briefing now happens only via the greeting trigger in CLAUDE.md. Bug 1 and Bug 6 from the brutal-critic list retired (both were about hook code that no longer exists). 7 brutal-critic bugs still queued. No push.
- Blocked on: Nothing

## What's Next
1. Test the greeting trigger on a fresh session restart (say "good morning" → session-opener should run; say "goodnight" → session-closer should run)
2. Fix the remaining 7 brutal-critic bugs queued in docs/next-session.md (Bugs 2, 3, 4, 5, 7, 8, and 9 — Bugs 1 and 6 are retired)
3. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive); confirm settings.json is NOT touched anymore
4. Test install.sh on Linux/macOS

## Key Design Decisions (Do Not Revisit Without Good Reason)
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- Ollama uses temp Modelfile (ollama create/rm), NOT --system flag — more reliable
- install.ps1 uses `$PROFILE` not hardcoded `$env:USERPROFILE\Documents` — fixes OneDrive setups
- No `2>$null` on ollama calls in PowerShell — Go CLI programs on Windows break when stderr is redirected to null
- Session Triggers implemented in CLAUDE.md (reloaded every turn), NOT via UserPromptSubmit hook — simpler, version-controlled, no settings.json changes needed
- **No SessionStart auto-brief hook, ever.** Tried twice, removed for good. The launch tax (~30s on every startup, even when no brief is needed) is not worth paying when the greeting trigger handles the same job opt-in. Also, `additionalContext` from a SessionStart hook is treated as background context, not as a reliable instruction the model acts on. The greeting trigger in CLAUDE.md is the canonical mechanism.

## What We Are NOT Doing Yet
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI
- Packaging as npm/pip (future roadmap)
- SessionStart auto-brief hook (intentionally removed — see Key Design Decisions)

## Last Session Summary

**Session 2026-04-07 (third)**

Diagnosed why the SessionStart hook fired without error but produced no briefing — `additionalContext` from a hook is delivered as background context, not as a reliable imperative for the model. Decided to remove the hook entirely rather than try to make it more imperative.

Removed from personal `~/.claude/`:
- `session-start-hook.ps1`
- `session-start-context.txt`
- The SessionStart block from `settings.json`

Removed from the repo:
- `settings/` directory (hook fragment, hook script, context file — all three files plus the dir itself)
- The hook installation section from both `install.sh` and `install.ps1`
- The `node`/`python3` prerequisite line from README (no JSON merge needed anymore)
- All SessionStart references in README (feature table, install tree, update table, daily workflow morning section, manual install steps, repo structure)
- The "auto-briefs via SessionStart hook" line from `commands/init-project.md`
- The "Invoked automatically via SessionStart hook" phrase from `agents/session-opener.md` description
- Bug 1 and Bug 6 from `docs/next-session.md` (both retired — they described problems with hook code that no longer exists)

Updated CLAUDE.md, GEMINI.md, AGENTS.md, DEEPSEEK.md to reflect the new "no hook" reality, with a strong "do not re-add this" note in Key Design Decisions.

Decisions: **No SessionStart auto-brief hook, ever.** The greeting trigger in CLAUDE.md is the canonical session-briefing mechanism. Earlier-session knowledge about hook quirks (`type: command` not `prompt`, no shell expansion of env vars, `[string]` cast for Get-Content) preserved as historical context in CLAUDE.md, in case anyone is ever tempted to re-add it.

Next immediate step: test the greeting trigger on a fresh restart and confirm it briefs correctly without any launch-time tax.

---

## Instructions for This AI

At the start of your session, read this file fully. Then check if CLAUDE.md or docs/next-session.md have newer information.

**When you start working:**
1. Write `WORKING.md` in the project root with your name, the current time, and what you're focused on:
   ```
   AI: Codex
   Started: [date and time]
   Focus: [what you're working on]
   ```
2. If `WORKING.md` already exists with another AI's name and a recent timestamp (same day), stop and tell the user: another AI may be in an active session. Ask whether to proceed or coordinate first.

**When you finish working:**
1. Update the `## Last Codex Session` section below with a summary of what you did.
2. Delete `WORKING.md` from the project root.

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
