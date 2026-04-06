# deepseek.ps1 — DeepSeek/Ollama function for PowerShell
# The install script adds this to your $PROFILE automatically.
# To add manually, paste the function below into your PowerShell profile:
#   notepad $PROFILE
#
# Usage: deepseek                  -> uses deepseek-r1:8b (default)
#        deepseek deepseek-r1:32b  -> uses specified model

function deepseek {
    param([string]$Model = "deepseek-r1:8b")
    if (Test-Path "DEEPSEEK.md") {
        $context = Get-Content "DEEPSEEK.md" -Raw
        Write-Host "[Loading DEEPSEEK.md context for $Model...]"
        ollama run $Model --system $context
    } else {
        Write-Host "[No DEEPSEEK.md found in current directory -- starting without project context]"
        ollama run $Model
    }
}
