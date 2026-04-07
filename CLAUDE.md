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
- **No SessionStart auto-brief hook** — we tried it (twice). The launch tax (~30s on every startup, even when you don't need a brief) outweighed the benefit, and `additionalContext` from a hook is treated as background context, not as an instruction the model reliably acts on. The greeting trigger in this file is the chosen mechanism — it runs `session-opener` only when the user actually says "good morning" / "hi" / etc. If you find yourself tempted to re-add the hook, re-read this bullet. (Historical Claude Code knowledge worth keeping anyway: if you ever DO write a SessionStart hook, it must be `type: "command"` not `type: "prompt"`, the command string is not shell-expanded so `%USERPROFILE%` won't work without `cmd /c`, and Get-Content output must be cast to `[string]` before ConvertTo-Json or PSObject note-properties will inflate the JSON.)

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

These triggers exist because this repo IS the session management system — it must demonstrate the behavior it ships.

---

## What We Are NOT Doing

- Building a web UI or dashboard
- Supporting proprietary/closed AI tools without CLI access
- Auto-updating installed agents (user controls their own ~/.claude/)

---

## Current State
- Phase: Post-release bug fixes + simplification
- Last session: 2026-04-07 (third)
- Status: Removed the SessionStart auto-brief hook entirely from both personal `~/.claude/` and the repo. Briefing now happens only via the greeting trigger in this file. Bug 1 and Bug 6 from the brutal-critic list retired (both were about hook code that no longer exists). 7 brutal-critic bugs still queued. No push.
- Blocked on: Nothing

## Session History

### Session 2026-04-07 (third)
- Accomplished: Diagnosed why the SessionStart hook fired without error but produced no briefing — `additionalContext` from a hook is delivered as background context, not as a reliable imperative for the model. Decided to remove the hook entirely rather than try to make it more imperative. Deleted `~/.claude/session-start-hook.ps1`, `~/.claude/session-start-context.txt`, and the SessionStart block from `~/.claude/settings.json`. In the repo: deleted `settings/` directory (hook fragment, hook script, context file), ripped out the hook installation section from both `install.sh` and `install.ps1`, dropped the `node`/`python3` prerequisite line from README, updated the README feature table / install tree / update table / daily workflow / manual install / repo structure / prerequisites sections, updated `agents/session-opener.md` description, updated `commands/init-project.md` boilerplate output, retired Bug 1 and Bug 6 from `docs/next-session.md`.
- Decisions: **No SessionStart auto-brief hook, ever.** The launch tax (~30s on every startup) is not worth paying when the greeting trigger handles the same job opt-in. `additionalContext` is background info, not an instruction. The greeting trigger in CLAUDE.md is the canonical session-briefing mechanism. Earlier-session knowledge about hook quirks (`type: command` not `prompt`, no shell expansion of env vars, `[string]` cast for Get-Content) preserved as historical context in the Key Design Decisions bullet, in case anyone is ever tempted to re-add it.
- Next: Test the greeting trigger on a fresh restart; resume remaining 7 brutal-critic bugs; clean-machine install testing.

### Session 2026-04-07 (second)
- Accomplished: Fixed "SessionStart:startup hook error" on Windows — root cause was `type: "prompt"` in settings.json which is not a valid Claude Code hook type; converted to `type: "command"` via a new PowerShell script (~/.claude/session-start-hook.ps1) that reads briefing prose from ~/.claude/session-start-context.txt and emits `hookSpecificOutput` JSON; fixed two bugs during testing (PSObject note-property bloat in ConvertTo-Json, em-dash mojibake from system codepage)
- Decisions: Claude Code SessionStart hooks only support `type: "command"`, never `type: "prompt"`; pattern for Windows command hooks is prose in .txt → .ps1 reads it and wraps in JSON → settings.json points at .ps1; always cast Get-Content output to [string] before ConvertTo-Json to strip PSObject metadata; all changes in personal ~/.claude/ — zero repo changes this session
- Next: Quit and relaunch Claude Code to verify hook error is gone; then resume 9 brutal-critic bugs from next-session.md and clean-machine install testing

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
