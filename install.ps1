# install.ps1 — Multi-AI Session Management System installer for PowerShell (Windows)
# Usage: .\install.ps1
#
# If you get a script execution policy error, run first:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

$ErrorActionPreference = "Stop"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"
$AgentsDir = "$ClaudeDir\agents"
$CommandsDir = "$ClaudeDir\commands"
$SettingsFile = "$ClaudeDir\settings.json"

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

# 3. Merge SessionStart hook into settings.json
Write-Host "Configuring Claude Code SessionStart hook..."
New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
if (-not (Test-Path $SettingsFile)) {
    '{}' | Set-Content $SettingsFile
}

$hookPrompt = "A new Claude Code session has just started. Before responding to the user's first message, silently act as the session-opener agent: (1) read the memory index at ~/.claude/projects/[current-project-slug]/memory/MEMORY.md and any files it references, (2) read docs/next-session.md if it exists in the current project, (3) read the '## Current State' section and the most recent 2 entries in '## Session History' from CLAUDE.md if it exists. The project slug is the cwd path with slashes replaced by dashes and colons removed. Then deliver a brief status update covering: current phase, last session summary, top 3 next items, and any blockers. If no context files are found, say so honestly."

$settings = Get-Content $SettingsFile -Raw | ConvertFrom-Json
if (-not $settings.hooks) {
    $settings | Add-Member -NotePropertyName hooks -NotePropertyValue ([PSCustomObject]@{})
}
$hookEntry = @(
    [PSCustomObject]@{
        matcher = "*"
        hooks = @(
            [PSCustomObject]@{
                type = "prompt"
                prompt = $hookPrompt
            }
        )
    }
)
$settings.hooks | Add-Member -NotePropertyName SessionStart -NotePropertyValue $hookEntry -Force
$settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile
Write-Host "  OK SessionStart hook added to $SettingsFile"

# 4. Add deepseek function to PowerShell profiles
Write-Host "Adding deepseek function to PowerShell profiles..."
$deepseekFunc = Get-Content "$RepoDir\shell\deepseek.ps1" -Raw
$profilePaths = @(
    "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1",
    "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
)
foreach ($profilePath in $profilePaths) {
    $profileDir = Split-Path -Parent $profilePath
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    if (Test-Path $profilePath) {
        $existing = Get-Content $profilePath -Raw
        if ($existing -match "function deepseek") {
            Write-Host "  OK deepseek already in $profilePath -- skipping"
            continue
        }
    }
    Add-Content -Path $profilePath -Value "`n# DeepSeek/Ollama context loader (added by multi-ai-session-management installer)"
    Add-Content -Path $profilePath -Value $deepseekFunc
    Write-Host "  OK deepseek() added to $profilePath"
}

Write-Host ""
Write-Host "Installation complete!"
Write-Host ""
Write-Host "What was installed:"
Write-Host "  ~/.claude/agents/    -- session-closer, session-opener, brutal-critic"
Write-Host "  ~/.claude/commands/  -- init-project"
Write-Host "  ~/.claude/settings.json -- SessionStart auto-brief hook"
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
