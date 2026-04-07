# Next Session — Work Queue

## Current Priority

1. Test that Session Triggers fire correctly on a fresh session restart (greeting → session-opener, goodbye → session-closer).
2. Fix the remaining brutal-critic bugs queued below.
3. Test install scripts on a clean machine.

---

## Completed

- [x] Created full repo structure (agents, commands, shell, install scripts, README, AI context files)
- [x] Fixed DeepSeek PowerShell function — switched from --system flag to temp Modelfile approach (ollama create/rm)
- [x] Fixed install.ps1 profile path — uses $PROFILE instead of hardcoded $env:USERPROFILE\Documents path (fixes OneDrive setups)
- [x] Removed 2>$null from ollama calls — Go CLI programs on Windows throw "failed to get console mode for stderr: The handle is invalid" when stderr is null
- [x] Confirmed DeepSeek is working end-to-end on Windows with OneDrive profile
- [x] Pushed to GitHub — repo is live
- [x] Ran brutal-critic on this repo — 9 bugs found and queued in this file
- [x] Implemented Session Triggers in CLAUDE.md (greeting/goodbye detection with mid-session guard)
- [x] Mirrored Session Triggers into commands/init-project.md so new projects inherit the behavior
- [x] Fixed duplicate Task 1/Task 2 stub in next-session.md
- [x] Fixed "SessionStart:startup hook error" on Windows — converted invalid `type: prompt` hook to `type: command` via ~/.claude/session-start-hook.ps1; fixed PSObject bloat and em-dash mojibake bugs during testing
- [x] **Removed SessionStart auto-brief hook entirely** (2026-04-07 third session) — the hook fired but `additionalContext` is background context, not an imperative, so the briefing never appeared. Decided the greeting trigger in CLAUDE.md is sufficient and the ~30s launch tax of an always-on hook isn't worth it. Deleted `settings/` dir, hook fragment, hook script, context file; ripped out hook section from install.sh / install.ps1; updated README, CLAUDE.md, agents/session-opener.md, commands/init-project.md. Also retired Bug 1 and Bug 6 from the brutal-critic list — both were about the now-deleted hook code.

---

## Work Queue

### Task 0 — Test Session Triggers on a fresh session restart
> Greet Claude with "good morning" or "hi".
> Verify:
> - session-opener runs automatically
> - The briefing is delivered before any other response
> - If you greet again mid-session, Claude offers the `/clear` option instead of re-briefing silently
> - Saying "goodnight" or "I'm done for today" triggers session-closer
>
> Also test init-project: run `/init-project` on a scratch project and verify the Session Triggers block appears in the generated CLAUDE.md.

### Task 1 — Test install.ps1 on a clean Windows machine
> Run `.\install.ps1` on a Windows machine without anything pre-installed. Verify:
> - PowerShell profile gets the deepseek function at the correct path (OneDrive or local)
> - Agents are copied to ~/.claude/agents/
> - `deepseek` command works after `. $PROFILE`
> - settings.json is NOT touched (no hook is installed anymore)

### Task 3 — Test install.sh on Linux/macOS
> Run `bash install.sh` on a fresh Linux or macOS machine. Verify all files land in correct locations and settings.json is correctly merged.

### Task 4 — Consider a `gemini` shell function
> Gemini CLI already auto-loads GEMINI.md, so no shell wrapper is needed for context. But a thin wrapper that confirms context was loaded could be a nice UX addition.

---

## Bugs Found by Brutal Critic (2026-04-07)

### ~~Bug 1~~ — RETIRED 2026-04-07 (third session)
> Was: install.sh / install.ps1 overwrite existing SessionStart hooks instead of merging.
> Resolution: Both installers no longer touch settings.json at all — the SessionStart hook was removed in favor of the greeting trigger in CLAUDE.md.

### Bug 2 — README describes brutal-critic personalities that no longer exist
> README says "Paranoid Architect, Code Assassin, Product Skeptic." Those names were replaced by the 27-type Personality Library. Public docs lie about actual behavior.
> Fix: Update README to describe the real system: project type detection, personality library, cross-type borrowing.

### Bug 3 — deepseek.sh suppresses stderr on ollama calls (violates CLAUDE.md decision)
> Lines 26 and 29 use `2>/dev/null` on `ollama create` and `ollama rm`. CLAUDE.md explicitly documents not doing this. A failed `ollama create` silently produces a missing model, then `ollama run` fires against it with a confusing error.
> Fix: Remove `2>/dev/null`. Add explicit failure check: if `ollama create` fails, print a useful error and return 1.

### Bug 4 — install.sh won't update an existing deepseek() function
> Greps for function name presence only — so reinstalling after a bug fix won't update an already-installed version. Old broken function stays in ~/.bashrc forever.
> Fix: Version-stamp the function (e.g., `# deepseek v2`) and grep for the stamp, not just the name.

### Bug 5 — session-closer.md uses `git add -A`
> Stages everything in the working directory including secrets, .env files, and debug artifacts. The agent runs in users' actual project directories — this is a data exposure risk.
> Fix: Replace with an explicit file list: `git add CLAUDE.md GEMINI.md AGENTS.md DEEPSEEK.md docs/next-session.md WORKING.md`

### ~~Bug 6~~ — RETIRED 2026-04-07 (third session)
> Was: hook prompt text hardcoded in three places (install.sh, install.ps1, settings/hook-fragment.json) with no single source of truth.
> Resolution: All three locations were deleted along with the hook itself. There is no hook prompt anymore.

### Bug 7 — GEMINI.md / AGENTS.md / DEEPSEEK.md have stale "ready to push" state
> These context files still say "ready to push to GitHub" — the push is done. This is the sync failure this system exists to prevent, happening in its own repo.
> Fix: Run session-closer on this repo to sync all three context files.

### Bug 8 — init-project commits AGENTS.md to user project repos with no warning
> AGENTS.md contains session history, architecture decisions, and project state. It goes into public git history of every project using /init-project. Silent information disclosure for proprietary projects.
> Fix: Warn users in init-project.md and README.md. Suggest adding AGENTS.md to .gitignore for private projects.

---

## What We Are NOT Doing
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI

---

## Future Roadmap
- Package as a proper CLI tool (npm/pip) for even easier installation
- Add more AI tools as they gain CLI support
