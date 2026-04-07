# Next Session — Work Queue

## Current Priority

1. Quit and relaunch Claude Code — verify "SessionStart:startup hook error" is gone and the new briefing context appears cleanly.
2. Test that Session Triggers fire correctly on a fresh session restart (greeting → session-opener, goodbye → session-closer).
3. Fix the 9 brutal-critic bugs queued below.
4. Test install scripts on a clean machine.

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

---

## Work Queue

### Task 0a — Verify SessionStart hook fix (IMMEDIATE — do this first)
> Quit Claude Code and relaunch it in this repo. Verify:
> - The "SessionStart:startup hook error" banner is gone
> - The briefing context (from ~/.claude/session-start-context.txt) appears in Claude's initial context
> - No 374KB JSON blobs or mojibake in the hook output
>
> If still broken: check ~/.claude/settings.json has `"type": "command"` (not `"type": "prompt"`) and the `command` field points to `pwsh -File ~/.claude/session-start-hook.ps1`.

### Task 0b — Test Session Triggers on a fresh session restart
> After verifying Task 0a, greet Claude with "good morning" or "hi".
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
> - Hook is added correctly to settings.json
> - `deepseek` command works after `. $PROFILE`

### Task 3 — Test install.sh on Linux/macOS
> Run `bash install.sh` on a fresh Linux or macOS machine. Verify all files land in correct locations and settings.json is correctly merged.

### Task 4 — Consider a `gemini` shell function
> Gemini CLI already auto-loads GEMINI.md, so no shell wrapper is needed for context. But a thin wrapper that confirms context was loaded could be a nice UX addition.

---

## Bugs Found by Brutal Critic (2026-04-07)

### Bug 1 — install.sh / install.ps1 overwrite existing hooks instead of merging
> Both installers replace the entire `SessionStart` array in settings.json rather than appending. Users with pre-existing hooks lose them silently on re-install.
> Fix: Read the existing array first. If the hook is already present, skip. Otherwise append — don't replace.

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

### Bug 6 — Hook prompt text hardcoded in three places with no single source of truth
> install.sh, install.ps1, and settings/hook-fragment.json each have slightly different copies of the hook prompt. One change requires three updates, and they are already out of sync.
> Fix: Have install.sh and install.ps1 read the prompt from hook-fragment.json. That file exists for this purpose.

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
