# deepseek.ps1 — DeepSeek/Ollama function for PowerShell
# The install script adds this to your $PROFILE automatically.
# To add manually, paste the function below into your PowerShell profile:
#   notepad $PROFILE
#
# Usage: deepseek                  -> uses deepseek-r1:8b (default)
#        deepseek deepseek-r1:32b  -> uses specified model
#
# How it works: creates a temporary Ollama model with DEEPSEEK.md as the
# system prompt, runs it interactively, then cleans up the temp model.

function deepseek {
    param([string]$Model = "deepseek-r1:8b")
    if (Test-Path "DEEPSEEK.md") {
        $context = Get-Content "DEEPSEEK.md" -Raw
        Write-Host "[Loading DEEPSEEK.md context for $Model...]"
        $tmpModel = "deepseek-ctx-$PID"
        $tmpFile = [System.IO.Path]::GetTempFileName()
        $modelfile = @"
FROM $Model
SYSTEM """
$context
"""
"@
        Set-Content -Path $tmpFile -Value $modelfile
        ollama create $tmpModel -f $tmpFile 2>$null
        Remove-Item $tmpFile -Force
        ollama run $tmpModel
        ollama rm $tmpModel 2>$null
    } else {
        Write-Host "[No DEEPSEEK.md found in current directory -- starting without project context]"
        ollama run $Model
    }
}
