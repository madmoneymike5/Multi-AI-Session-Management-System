# install.ps1 — Multi-AI Session Management System installer for PowerShell (Windows)
# Usage: .\install.ps1
#
# If you get a script execution policy error, run first:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#
# Note: This script uses $PROFILE to find your PowerShell profile, which correctly
# resolves to the right path whether your Documents folder is local or synced to
# OneDrive. You do not need to do anything special for OneDrive setups.

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"
$AgentsDir = "$ClaudeDir\agents"
$CommandsDir = "$ClaudeDir\commands"

Write-Host ""
Write-Host "Multi-AI Session Management System -- Installer (PowerShell)"
Write-Host "============================================================="
Write-Host ""

# 1. Install Claude agents
Write-Host "Installing Claude agents..."
New-Item -ItemType Directory -Force -Path $AgentsDir | Out-Null
Copy-Item "$RepoDir\agents\*.md" $AgentsDir -Force
Write-Host "  OK session-closer.md   -> $AgentsDir"
Write-Host "  OK session-opener.md   -> $AgentsDir"
Write-Host "  OK brutal-critic.md    -> $AgentsDir"

# 2. Install Claude commands
Write-Host "Installing Claude commands..."
New-Item -ItemType Directory -Force -Path $CommandsDir | Out-Null
Copy-Item "$RepoDir\commands\*.md" $CommandsDir -Force
Write-Host "  OK init-project.md     -> $CommandsDir"

# NOTE: There is intentionally no SessionStart auto-brief hook. We chose the
# greeting trigger in CLAUDE.md instead — it adds ~30s to launch only when
# invited (when the user actually says "good morning" / "hi"), instead of
# taxing every single launch. See CLAUDE.md "Session Triggers" section.

# 3. Add deepseek function to PowerShell profile
Write-Host "Adding deepseek function to PowerShell profile..."
$deepseekFunc = Get-Content "$RepoDir\shell\deepseek.ps1" -Raw
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
if (Test-Path $profilePath) {
    $existing = Get-Content $profilePath -Raw
    if ($existing -match "function deepseek") {
        Write-Host "  OK deepseek already in $profilePath -- skipping"
    } else {
        Add-Content -Path $profilePath -Value "`n# DeepSeek/Ollama context loader (added by multi-ai-session-management installer)"
        Add-Content -Path $profilePath -Value $deepseekFunc
        Write-Host "  OK deepseek() added to $profilePath"
    }
} else {
    New-Item -ItemType File -Force -Path $profilePath | Out-Null
    Add-Content -Path $profilePath -Value "# DeepSeek/Ollama context loader (added by multi-ai-session-management installer)"
    Add-Content -Path $profilePath -Value $deepseekFunc
    Write-Host "  OK deepseek() added to $profilePath"
}

Write-Host ""
Write-Host "Installation complete!"
Write-Host ""
Write-Host "What was installed:"
Write-Host "  ~/.claude/agents/    -- session-closer, session-opener, brutal-critic"
Write-Host "  ~/.claude/commands/  -- init-project"
Write-Host "  PowerShell profiles  -- deepseek() function"
Write-Host ""
Write-Host "To activate in this terminal:  . `$PROFILE"
Write-Host "New terminals will load automatically."
Write-Host ""
Write-Host "To start a new project with this system: /init-project"
Write-Host "To close a session:  @agent-session-closer"
Write-Host "To get brutal feedback: @agent-brutal-critic"
Write-Host ""
Write-Host "DeepSeek (Ollama): cd into your project and run 'deepseek'"
