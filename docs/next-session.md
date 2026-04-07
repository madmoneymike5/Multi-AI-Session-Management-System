# Next Session — Work Queue

## Current Priority

Push to GitHub and verify install scripts work correctly on a clean machine.

---

## Completed

- [x] Created full repo structure (agents, commands, shell, install scripts, README, AI context files)
- [x] Fixed DeepSeek PowerShell function — switched from --system flag to temp Modelfile approach (ollama create/rm)
- [x] Fixed install.ps1 profile path — uses $PROFILE instead of hardcoded $env:USERPROFILE\Documents path (fixes OneDrive setups)
- [x] Removed 2>$null from ollama calls — Go CLI programs on Windows throw "failed to get console mode for stderr: The handle is invalid" when stderr is null
- [x] Confirmed DeepSeek is working end-to-end on Windows with OneDrive profile

---

## Work Queue

### Task 1 — Push to GitHub
> Create the public GitHub repo and push. Verify the README renders correctly and the install commands in it work.

### Task 2 — Test install.ps1 on a clean Windows machine
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

## What We Are NOT Doing
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI

---

## Future Roadmap
- Package as a proper CLI tool (npm/pip) for even easier installation
- Add more AI tools as they gain CLI support
