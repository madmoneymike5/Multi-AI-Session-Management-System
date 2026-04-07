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

## Session Triggers

These triggers apply at ANY point in the conversation, not just the first message. Re-check on every user turn.

**Greeting trigger → run session-opener (with mid-session guard)**
If the user's message is a greeting ("good morning", "morning", "hi", "hello", "hey", "good afternoon", "good evening", "I'm back"):

1. **First, check whether you are already mid-session** — i.e., this conversation has substantive prior turns, files have been read, edits have been made, or context has accumulated beyond the initial SessionStart brief.
2. **If mid-session:** Do NOT silently re-run session-opener. Instead, tell the user: "We're already mid-session — I have context loaded including [one-line summary of what we've been doing]. Want to `/clear` and get a fresh start-of-day briefing, or keep going from here? (You can also abort and just continue.)" Wait for their answer. The user must run `/clear` themselves — you cannot clear context for them. After they clear and greet again, the next turn will be a fresh session and the start-of-session branch below applies.
3. **If this is genuinely the start of the session** (first or second turn, no real work done yet): launch the `session-opener` agent via the Agent tool, then greet the user in the same response that delivers the brief.
4. **If session-opener has already run in this conversation** and no new context files have been touched since: just greet back briefly. Don't re-brief.

**End-of-day trigger → run session-closer**
If the user indicates they are done ("let's close this out", "I'm done for the day", "wrapping up", "goodnight", "see you tomorrow", "that's it for today", "calling it"), launch the `session-closer` agent via the Agent tool. Confirm with the user before any commits or pushes.

These triggers exist because this repo IS the session management system — it must demonstrate the behavior it ships.

---

## What We Are NOT Doing

- Building a web UI or dashboard
- Supporting proprietary/closed AI tools without CLI access
- Auto-updating installed agents (user controls their own ~/.claude/)

---

## Current State
- Phase: Post-release bug fixes + Session Triggers feature
- Last session: 2026-04-07
- Status: Session Triggers added to CLAUDE.md and init-project.md; brutal-critic ran and found 9 bugs all queued in next-session.md; local commit only (no push)
- Blocked on: Nothing — immediate next step is testing Session Triggers on a fresh session restart

## Session History

### Session 2026-04-07
- Accomplished: Ran brutal-critic — found 9 issues, all added to docs/next-session.md; implemented Session Triggers feature in CLAUDE.md (greeting/goodbye detection with mid-session guard); mirrored Session Triggers into commands/init-project.md so new projects inherit the behavior automatically; fixed duplicate Task 1/Task 2 stub in next-session.md
- Decisions: Use CLAUDE.md (reloaded every turn) for continuous trigger detection rather than UserPromptSubmit hook — simpler, version-controlled, no settings.json changes; SessionStart hook stays as-is; greeting trigger discovered to never have been continuous anywhere before — this was the first real implementation; no push this session (user wants to test fresh session trigger behavior before pushing)
- Next: Test Session Triggers on a fresh session start; fix the 9 brutal-critic bugs from next-session.md; clean-machine install testing

### Session 2026-04-06 (second)
- Accomplished: Fixed DeepSeek PowerShell integration — confirmed working end-to-end; fixed install.ps1 profile path for OneDrive; removed 2>$null from ollama calls; created PowerShell profile at correct OneDrive path
- Decisions: Switch Ollama approach from --system flag to temp Modelfile (ollama create/rm); use $PROFILE not hardcoded path; never redirect stderr to null for Go CLI tools on Windows; SessionStart hook error was transient (no config change needed)
- Next: Test install scripts on a clean machine (GitHub push already done)

### Session 2026-04-06
- Accomplished: Created full repo structure — agents, commands, shell functions, install scripts (bash + PowerShell), README, AI context files, CLAUDE.md
- Decisions: Use --system flag for Ollama (cleaner than pipe); install.sh handles JSON merge with node/python3 fallback; README credits NetworkChuck
- Next: Create GitHub repo, push, verify install scripts work on a clean machine
