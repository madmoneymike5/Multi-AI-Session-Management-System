# deepseek.sh — DeepSeek/Ollama shell function for bash
# Source this file in your ~/.bashrc or ~/.bash_profile:
#   source /path/to/deepseek.sh
#
# Or let the install script add it automatically.
#
# Usage: deepseek                  → uses deepseek-r1:8b (default)
#        deepseek deepseek-r1:32b  → uses specified model

deepseek() {
  local model="${1:-deepseek-r1:8b}"
  if [ -f "DEEPSEEK.md" ]; then
    echo "[Loading DEEPSEEK.md context for $model...]"
    ollama run "$model" --system "$(cat DEEPSEEK.md)"
  else
    echo "[No DEEPSEEK.md found in current directory — starting without project context]"
    ollama run "$model"
  fi
}
