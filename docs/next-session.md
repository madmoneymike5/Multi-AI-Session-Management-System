# Next Session — Work Queue

## Current Priority

Verify install scripts work correctly on a clean machine.

---

## Work Queue

### Task 1 — Test install.sh on Linux/macOS
**Problem:** Install script was written on Windows — needs real-world testing on Unix systems.
> Test on a fresh Linux or macOS machine: clone, run `bash install.sh`, verify all files land in correct locations and settings.json is correctly merged.

### Task 2 — Test install.ps1 on a clean Windows machine
> Run `.\install.ps1` on a Windows machine without the system pre-installed. Verify PowerShell profile gets the deepseek function, agents are copied, and hook is added to settings.json.

### Task 3 — Consider a `gemini` shell function
> Gemini CLI already auto-loads GEMINI.md, so no shell wrapper is needed. But a `gemini` wrapper that confirms context was loaded could be a nice addition.

---

## What We Are NOT Doing
- Web UI or dashboard
- Auto-update mechanism for installed agents
- Support for tools without a CLI

---

## Future Roadmap
- Package as a proper CLI tool (npm/pip) for even easier installation
- Add more AI tools as they gain CLI support
