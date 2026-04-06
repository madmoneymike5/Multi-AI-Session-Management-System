# deepseek.sh — DeepSeek/Ollama shell function for bash
# Source this file in your ~/.bashrc or ~/.bash_profile:
#   source /path/to/deepseek.sh
#
# Or let install.sh add it automatically.
#
# Usage: deepseek                  → uses deepseek-r1:8b (default)
#        deepseek deepseek-r1:32b  → uses specified model
#
# How it works: creates a temporary Ollama model with DEEPSEEK.md as the
# system prompt, runs it interactively, then cleans up the temp model.

deepseek() {
  local model="${1:-deepseek-r1:8b}"
  if [ -f "DEEPSEEK.md" ]; then
    echo "[Loading DEEPSEEK.md context for $model...]"
    local tmp_model="deepseek-ctx-$$"
    local tmp_file
    tmp_file=$(mktemp)
    {
      printf 'FROM %s\n' "$model"
      printf 'SYSTEM """\n'
      cat DEEPSEEK.md
      printf '\n"""\n'
    } > "$tmp_file"
    ollama create "$tmp_model" -f "$tmp_file" 2>/dev/null
    rm -f "$tmp_file"
    ollama run "$tmp_model"
    ollama rm "$tmp_model" 2>/dev/null
  else
    echo "[No DEEPSEEK.md found in current directory — starting without project context]"
    ollama run "$model"
  fi
}
