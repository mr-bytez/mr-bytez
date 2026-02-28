#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:       handoff-lifecycle-check.sh
# Pfad:        /mr-bytez/.claude/hooks/handoff-lifecycle-check.sh
# Autor:       MR-ByteZ
# Version:     0.1.0
# Erstellt:    2026-02-26
# Aktualisiert:2026-02-26
# Zweck:       Prueft ob erledigte Handoffs geloescht/archiviert wurden
# Event:       PreToolUse (Matcher: Bash)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Nur bei git commit reagieren
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit'; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-/mr-bytez}"
HANDOFF_DIR="$PROJECT_DIR/.claude/context/handoffs"

# Prüfe ob es Handoffs gibt die als "Erledigt" markiert sind
# (Suche nach Markern wie "✅ erledigt", "Status: Erledigt", "[x]" am Anfang)
if [ -d "$HANDOFF_DIR" ]; then
  COMPLETED=""
  for handoff in "$HANDOFF_DIR"/HANDOFF_*.md; do
    [ -f "$handoff" ] || continue
    BASENAME=$(basename "$handoff")
    
    # Prüfe ob Handoff als erledigt markiert ist (nur Status-Zeile mit ✅ in den ersten 10 Zeilen)
    if head -10 "$handoff" | grep -qiE 'status.*✅.*(erledigt|done|completed|abgeschlossen)'; then
      # Prüfe ob dieser Handoff NICHT im Staging zum Löschen ist
      if ! git diff --cached --name-only --diff-filter=D 2>/dev/null | grep -q "$BASENAME"; then
        COMPLETED="${COMPLETED}📋 ${BASENAME} ist als erledigt markiert aber nicht gelöscht/archiviert!\n"
      fi
    fi
  done
  
  if [ -n "$COMPLETED" ]; then
    REASON="Handoff-Lifecycle: Erledigte Handoffs müssen VOR dem Commit gelöscht oder archiviert werden (selber Commit)! $(echo -e "$COMPLETED" | tr '\n' ' ')"
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
fi

# Alles okay
exit 0
