#!/usr/bin/env bash
# install.sh — Multi-AI Session Management System installer
# Works on: Git Bash (Windows), Linux, macOS
# Usage: bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands"

echo ""
echo "Multi-AI Session Management System — Installer"
echo "================================================"
echo ""

# 1. Install Claude agents
echo "Installing Claude agents..."
mkdir -p "$AGENTS_DIR"
cp "$REPO_DIR/agents/"*.md "$AGENTS_DIR/"
echo "  ✓ session-closer.md   → $AGENTS_DIR"
echo "  ✓ session-opener.md   → $AGENTS_DIR"
echo "  ✓ brutal-critic.md    → $AGENTS_DIR"

# 2. Install Claude commands
echo "Installing Claude commands..."
mkdir -p "$COMMANDS_DIR"
cp "$REPO_DIR/commands/"*.md "$COMMANDS_DIR/"
echo "  ✓ init-project.md     → $COMMANDS_DIR"

# NOTE: There is intentionally no SessionStart auto-brief hook. We chose the
# greeting trigger in CLAUDE.md instead — it adds ~30s to launch only when
# invited (when the user actually says "good morning" / "hi"), instead of
# taxing every single launch. See CLAUDE.md "Session Triggers" section.

# 3. Add deepseek function to ~/.bashrc
echo "Adding deepseek function to ~/.bashrc..."
BASHRC="$HOME/.bashrc"
if grep -q "deepseek()" "$BASHRC" 2>/dev/null; then
  echo "  ✓ deepseek() already present in $BASHRC — skipping"
else
  echo "" >> "$BASHRC"
  echo "# DeepSeek/Ollama context loader (added by multi-ai-session-management installer)" >> "$BASHRC"
  cat "$REPO_DIR/shell/deepseek.sh" >> "$BASHRC"
  echo "  ✓ deepseek() added to $BASHRC"
fi

# 5. Create ~/.bash_profile if missing
if [ ! -f "$HOME/.bash_profile" ]; then
  cat > "$HOME/.bash_profile" <<'PROFILE'
# ~/.bash_profile — sources .bashrc for login shells
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
PROFILE
  echo "  ✓ Created ~/.bash_profile"
else
  echo "  ✓ ~/.bash_profile already exists — skipping"
fi

echo ""
echo "Installation complete!"
echo ""
echo "What was installed:"
echo "  ~/.claude/agents/    — session-closer, session-opener, brutal-critic"
echo "  ~/.claude/commands/  — init-project"
echo "  ~/.bashrc            — deepseek() function"
echo ""
echo "To activate in this terminal:  source ~/.bashrc"
echo "New terminals will load automatically."
echo ""
echo "To start a new project with this system: /init-project"
echo "To close a session:  @agent-session-closer"
echo "To get brutal feedback: @agent-brutal-critic"
echo ""
echo "DeepSeek (Ollama): cd into your project and run 'deepseek'"
echo "  CMD users: use PowerShell instead (run install.ps1 for that)"
