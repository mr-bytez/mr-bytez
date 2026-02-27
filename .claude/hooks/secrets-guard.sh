#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:    secrets-guard.sh
# Pfad:     /mr-bytez/.claude/hooks/secrets-guard.sh
# Autor:    MR-ByteZ
# Version:  0.1.0
# Erstellt: 2026-02-26
# Zweck:    Blockiert Read-Zugriff auf entschlüsselte Secrets
# Event:    PreToolUse (Matcher: Read)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Leerer Pfad = kein Eingriff
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Verbotene Pfade (entschlüsselte Secrets, .env Dateien)
BLOCKED=false
REASON=""

# Entschlüsselte Secrets aus dem Archiv
if echo "$FILE_PATH" | grep -qE '\.secrets/mrohwer/'; then
  BLOCKED=true
  REASON="Zugriff auf entschlüsselte Secrets blockiert! Pfad: $FILE_PATH"
fi

# .env Dateien
if echo "$FILE_PATH" | grep -qE '\.env($|\.)'; then
  BLOCKED=true
  REASON="Zugriff auf .env Datei blockiert! Pfad: $FILE_PATH"
fi

# Private SSH-Keys
if echo "$FILE_PATH" | grep -qE '\.ssh/id_'; then
  BLOCKED=true
  REASON="Zugriff auf SSH Private Key blockiert! Pfad: $FILE_PATH"
fi

# Secrets-Verzeichnisse in /srv
if echo "$FILE_PATH" | grep -qE '/srv/.*/secrets/'; then
  BLOCKED=true
  REASON="Zugriff auf Docker Secrets blockiert! Pfad: $FILE_PATH"
fi

if [ "$BLOCKED" = "true" ]; then
  cat <<ENDJSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "🔒 ${REASON}"
  }
}
ENDJSON
  exit 0
fi

# Alles okay
exit 0
