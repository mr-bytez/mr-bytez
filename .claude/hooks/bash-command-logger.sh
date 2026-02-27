#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:    bash-command-logger.sh
# Pfad:     /mr-bytez/.claude/hooks/bash-command-logger.sh
# Autor:    MR-ByteZ
# Version:  0.1.0
# Erstellt: 2026-02-26
# Zweck:    Loggt alle Bash-Commands als Audit-Trail
# Event:    PreToolUse (Matcher: Bash)

# Log-Verzeichnis sicherstellen
LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/claude-code-commands.log"

# Input von stdin lesen (JSON von Claude Code)
INPUT=$(cat)

# Command und Beschreibung extrahieren
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // "unknown"')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "keine Beschreibung"')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# In Log-Datei schreiben
echo "[$TIMESTAMP] $COMMAND — $DESCRIPTION" >> "$LOG_FILE"

# Kein Output = kein Eingriff, Command läuft normal weiter
exit 0
