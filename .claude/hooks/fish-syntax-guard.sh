#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:    fish-syntax-guard.sh
# Pfad:     /mr-bytez/.claude/hooks/fish-syntax-guard.sh
# Autor:    MR-ByteZ
# Version:  0.1.0
# Erstellt: 2026-02-26
# Zweck:    Blockiert Heredocs/EOF und typische Bash-Syntax-Fallen
# Event:    PreToolUse (Matcher: Bash)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

REASON=""

# 1. Heredoc/EOF erkennen (VERBOTEN in Fish!)
if echo "$COMMAND" | grep -qE '<<\s*-?\s*(EOF|END|HEREDOC|EOT|EOL)'; then
  REASON="🐟 FISH-REGEL VERLETZT: Heredocs (<<EOF) funktionieren NICHT in Fish! Nutze printf/echo oder Editor für Datei-Erstellung."
fi

# 2. Bash export statt Fish set -x
if echo "$COMMAND" | grep -qE '^\s*export\s+[A-Z_]+='; then
  REASON="🐟 FISH-REGEL VERLETZT: 'export VAR=value' ist Bash-Syntax! In Fish: 'set -gx VAR value'"
fi

# 3. Bash $() statt Fish ()
if echo "$COMMAND" | grep -qE '\$\([^)]+\)'; then
  # Ausnahme: Wenn es in einem bash -c "" Wrapper ist, okay
  if ! echo "$COMMAND" | grep -q "bash -c"; then
    REASON="🐟 FISH-WARNUNG: \$(command) ist Bash-Syntax. In Fish: (command). Wenn absichtlich Bash: bash -c verwenden."
  fi
fi

# 4. && Verkettung (Fish nutzt ; and)
if echo "$COMMAND" | grep -qE '\s&&\s'; then
  # Nur warnen, nicht blockieren (manchmal bewusst Bash)
  # Kein deny, nur Hinweis via additionalContext
  cat <<ENDJSON
{
  "additionalContext": "🐟 Hinweis: '&&' ist Bash-Syntax. In Fish nutze '; and' oder Befehle untereinander. Falls Bash-Kontext: ignorieren."
}
ENDJSON
  exit 0
fi

if [ -n "$REASON" ]; then
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

exit 0
