#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:       dual-push-reminder.sh
# Pfad:        /mr-bytez/.claude/hooks/dual-push-reminder.sh
# Autor:       MR-ByteZ
# Version:     0.1.0
# Erstellt:    2026-02-26
# Aktualisiert:2026-02-26
# Zweck:       Erinnert nach git push origin an Codeberg-Push
# Event:       PostToolUse (Matcher: Bash)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Nur bei git push reagieren
if ! echo "$COMMAND" | grep -q "git push"; then
  exit 0
fi

# Prüfe ob nur zu einem Remote gepusht wurde
if echo "$COMMAND" | grep -q "git push origin" && ! echo "$COMMAND" | grep -q "codeberg"; then
  cat <<ENDJSON
{
  "additionalContext": "⚠️ DUAL-PUSH REGEL: Du hast nur zu origin (GitHub) gepusht! Jetzt auch zu Codeberg pushen: git push codeberg main"
}
ENDJSON
  exit 0
fi

if echo "$COMMAND" | grep -q "git push codeberg" && ! echo "$COMMAND" | grep -q "origin"; then
  cat <<ENDJSON
{
  "additionalContext": "⚠️ DUAL-PUSH REGEL: Du hast nur zu codeberg gepusht! Jetzt auch zu origin (GitHub) pushen: git push origin main"
}
ENDJSON
  exit 0
fi

exit 0
