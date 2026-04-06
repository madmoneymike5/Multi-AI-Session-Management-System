# Multi-AI Session Management System — AI Context Briefing
Last updated: 2026-04-06 by session-closer

> **Codex/OpenAI Agents:** This file is loaded automatically. Check `docs/next-session.md` for current priorities.
> At the END of your session, update the `## Last Gemini Session` section at the bottom.

## What This Project Is

A distributable toolkit for keeping Claude, Gemini, Codex, and DeepSeek in sync across sessions. Contains personal Claude Code agents, install scripts, and shell functions. Others install it to get automatic session briefing, end-of-day sync, and an adversarial code reviewer.

## Current State
- Phase: Initial release — ready to publish
- Last session: 2026-04-06
- Status: All files written, ready to push to GitHub

## What's Next
1. Create public GitHub repo and push
2. Test install scripts on a clean machine
3. Iterate based on real use

## Key Design Decisions
- Agents are personal (`~/.claude/agents/`), not project-level
- Four identical context files updated by session-closer each session
- `--system` flag for Ollama (cleaner than stdin pipe)
- install.sh merges settings.json using node or python3 (no jq dependency)

## Last Gemini Session
_Not yet used_

## Last Codex Session
_Not yet used_

## Last DeepSeek Session
_Not yet used_
