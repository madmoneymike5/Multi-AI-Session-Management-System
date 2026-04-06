#!/usr/bin/env bash
# install.sh — Multi-AI Session Management System installer
# Works on: Git Bash (Windows), Linux, macOS
# Usage: bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

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

# 3. Merge SessionStart hook into settings.json
echo "Configuring Claude Code SessionStart hook..."
mkdir -p "$CLAUDE_DIR"
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# Use node to merge JSON if available, otherwise fall back to python3
HOOK_PROMPT="A new Claude Code session has just started. Before responding to the user's first message, silently act as the session-opener agent: (1) read the memory index at ~/.claude/projects/[current-project-slug]/memory/MEMORY.md and any files it references, (2) read docs/next-session.md if it exists in the current project, (3) read the '## Current State' section and the most recent 2 entries in '## Session History' from CLAUDE.md if it exists. The project slug is the cwd path with slashes replaced by dashes and colons removed. Then deliver a brief status update covering: current phase, last session summary, top 3 next items, and any blockers. If no context files are found, say so honestly."

if command -v node &>/dev/null; then
  node - "$SETTINGS_FILE" "$HOOK_PROMPT" <<'EOF'
const fs = require('fs');
const [,, settingsPath, hookPrompt] = process.argv;
const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
if (!settings.hooks) settings.hooks = {};
settings.hooks.SessionStart = [{ matcher: '*', hooks: [{ type: 'prompt', prompt: hookPrompt }] }];
fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
EOF
  echo "  ✓ SessionStart hook added to $SETTINGS_FILE"
elif command -v python3 &>/dev/null; then
  python3 - "$SETTINGS_FILE" "$HOOK_PROMPT" <<'EOF'
import sys, json
settings_path, hook_prompt = sys.argv[1], sys.argv[2]
with open(settings_path) as f:
    settings = json.load(f)
if 'hooks' not in settings:
    settings['hooks'] = {}
settings['hooks']['SessionStart'] = [{'matcher': '*', 'hooks': [{'type': 'prompt', 'prompt': hook_prompt}]}]
with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
EOF
  echo "  ✓ SessionStart hook added to $SETTINGS_FILE"
else
  echo "  ⚠ Could not find node or python3 to merge settings.json automatically."
  echo "    Manually add the hook from: $REPO_DIR/settings/hook-fragment.json"
fi

# 4. Add deepseek function to ~/.bashrc
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
echo "  ~/.claude/settings.json — SessionStart auto-brief hook"
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
