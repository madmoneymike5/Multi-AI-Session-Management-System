# Next Session — Work Queue

## Current Priority

1. Test install.ps1 on a clean Windows machine (OneDrive and non-OneDrive setups).
2. Test install.sh on a fresh Linux or macOS machine.
3. Consider a `gemini` shell function (thin wrapper to confirm context loaded).

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
- [x] **Two brutal-critic runs, all 11 bugs fixed or retired** (2026-04-08) — Bugs 2–5, 7, 8 fixed first run; GitHub issues #1–#6 opened and closed second run (deepseek.ps1 $LASTEXITCODE check, sentinel markers + version stamps in PS1/install.ps1, install.sh step numbering, session-closer WORKING.md timing, session-opener date comparison replaced with narrative check, README library description). All AI context files synced. Pushed to GitHub.

---

## Work Queue

### ~~Task 0~~ — ✅ DONE (2026-04-07 fourth session)
> Greeting trigger confirmed working: "good morning" → session-opener fired, briefing delivered.
> Mid-session guard not yet tested (would need a second greeting mid-session).
> `/init-project` Session Triggers block: not re-tested this session — was verified in session 2026-04-07.

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

### ~~Bug 2~~ — ✅ FIXED (2026-04-07 fourth session)
> README updated to describe real system: 27-type library, 5 tailored personalities, cross-type borrowing.

### ~~Bug 3~~ — ✅ FIXED (2026-04-07 fourth session)
> Removed `2>/dev/null` from `ollama create` and `ollama rm`. Added `||` error check on `ollama create` with a diagnostic message and early return.

### ~~Bug 4~~ — ✅ FIXED (2026-04-07 fourth session)
> Added `# deepseek v2` stamp to `deepseek.sh`. `install.sh` now greps for the stamp instead of `deepseek()`, and uses `sed` to remove a stale old-version block before appending the new one.

### ~~Bug 5~~ — ✅ FIXED (2026-04-07 fourth session)
> Replaced `git add -A` with explicit list: `git add CLAUDE.md GEMINI.md AGENTS.md DEEPSEEK.md docs/next-session.md`. Added inline comment to add other session-managed files if needed.

### ~~Bug 6~~ — RETIRED 2026-04-07 (third session)
> Was: hook prompt text hardcoded in three places (install.sh, install.ps1, settings/hook-fragment.json) with no single source of truth.
> Resolution: All three locations were deleted along with the hook itself. There is no hook prompt anymore.

### ~~Bug 7~~ — ✅ FIXED (2026-04-08)
> GEMINI.md / AGENTS.md / DEEPSEEK.md were stale. Resolved by running session-closer which synced all three context files with the current state.

### ~~Bug 8~~ — ✅ FIXED (2026-04-07 fourth session)
> Added private-repo warning to both `README.md` (after "Starting a new project") and `commands/init-project.md` (after Step 6). Warns that `AGENTS.md`, `GEMINI.md`, `DEEPSEEK.md` contain session history and should be `.gitignore`d in public repos.

---

## What We Are NOT Doing
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI

---

## Future Roadmap
- Package as a proper CLI tool (npm/pip) for even easier installation
- Add more AI tools as they gain CLI support
