#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:       pre-commit-docs-check.sh
# Pfad:        /mr-bytez/.claude/hooks/pre-commit-docs-check.sh
# Autor:       MR-ByteZ
# Version:     0.1.0
# Erstellt:    2026-02-26
# Aktualisiert:2026-02-26
# Zweck:       Prueft VOR git commit ob CHANGELOG/ROADMAP im Staging sind
# Event:       PreToolUse (Matcher: Bash)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Nur bei git commit reagieren
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit'; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-/mr-bytez}"
cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Gestaged Dateien prüfen
STAGED=$(git diff --cached --name-only 2>/dev/null)

if [ -z "$STAGED" ]; then
  exit 0
fi

WARNINGS=""

# 1. CHANGELOG.md Prüfung
if ! echo "$STAGED" | grep -q "CHANGELOG.md"; then
  WARNINGS="${WARNINGS}⚠️ CHANGELOG.md fehlt im Staging! Regel: CHANGELOG VOR dem Commit aktualisieren.\n"
fi

# 2. ROADMAP.md Prüfung — nur warnen wenn Handoff-Dateien geändert wurden
#    (Hinweis auf mögliche Task-Erledigung)
if echo "$STAGED" | grep -q "handoffs/"; then
  if ! echo "$STAGED" | grep -q "ROADMAP.md"; then
    WARNINGS="${WARNINGS}⚠️ Handoff geändert aber ROADMAP.md nicht im Staging! Tasks erledigt? → ROADMAP aktualisieren.\n"
  fi
fi

# 3. Cross-Repo Prüfung — Secrets-Repo beteiligt?
if echo "$STAGED" | grep -q "^\.secrets/"; then
  WARNINGS="${WARNINGS}ℹ️ Secrets-Submodule geändert! Cross-Repo-Regel beachten: Auch Secrets-Repo CHANGELOG/ROADMAP prüfen.\n"
fi

# Wenn Warnungen: Blockieren mit Begründung
if [ -n "$WARNINGS" ]; then
  # Zusammenbauen als JSON — deny mit Reason
  REASON=$(echo -e "$WARNINGS" | tr '\n' ' ' | sed 's/\\n/ /g')
  cat <<ENDJSON
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "${REASON}"
  }
}
ENDJSON
  exit 0
fi

# Alles okay — Commit darf durchlaufen
exit 0
