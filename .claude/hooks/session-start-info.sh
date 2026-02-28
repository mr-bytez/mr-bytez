#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:       session-start-info.sh
# Pfad:        /mr-bytez/.claude/hooks/session-start-info.sh
# Autor:       MR-ByteZ
# Version:     0.1.0
# Erstellt:    2026-02-26
# Aktualisiert:2026-02-26
# Zweck:       Zeigt beim Session-Start offene Handoffs und Git-Status
# Event:       SessionStart

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-/mr-bytez}"
HANDOFF_DIR="$PROJECT_DIR/.claude/context/handoffs"
CONTEXT=""

# 1. Offene Handoffs zählen und auflisten
if [ -d "$HANDOFF_DIR" ]; then
  HANDOFFS=$(find "$HANDOFF_DIR" -maxdepth 1 -name "HANDOFF_*.md" 2>/dev/null)
  HANDOFF_COUNT=$(echo "$HANDOFFS" | grep -c "HANDOFF_" 2>/dev/null || echo "0")
  
  if [ "$HANDOFF_COUNT" -gt 0 ]; then
    HANDOFF_LIST=""
    for h in $HANDOFFS; do
      [ -f "$h" ] || continue
      BASENAME=$(basename "$h")
      # Status aus Datei extrahieren
      STATUS=$(grep -m1 -oE 'Status.*' "$h" 2>/dev/null | head -1)
      HANDOFF_LIST="${HANDOFF_LIST}\n  - ${BASENAME} (${STATUS:-Status unbekannt})"
    done
    CONTEXT="${CONTEXT}📋 ${HANDOFF_COUNT} aktive Handoffs:${HANDOFF_LIST}\n\n"
  fi
  
  # 2. Reports zählen
  REPORTS=$(find "$HANDOFF_DIR" -maxdepth 1 -name "REPORT_*.md" 2>/dev/null)
  REPORT_COUNT=$(echo "$REPORTS" | grep -c "REPORT_" 2>/dev/null || echo "0")
  
  if [ "$REPORT_COUNT" -gt 0 ]; then
    REPORT_LIST=""
    for r in $REPORTS; do
      [ -f "$r" ] || continue
      REPORT_LIST="${REPORT_LIST}\n  - $(basename "$r")"
    done
    CONTEXT="${CONTEXT}📊 ${REPORT_COUNT} Reports vorhanden:${REPORT_LIST}\n\n"
  fi
fi

# 3. Git Status kurz
cd "$PROJECT_DIR" 2>/dev/null
if command -v git &>/dev/null; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  DIRTY=$(git status --porcelain 2>/dev/null | wc -l)
  UNPUSHED=$(git log --oneline origin/main..HEAD 2>/dev/null | wc -l)
  
  GIT_INFO="🔀 Branch: ${BRANCH:-unknown}"
  [ "$DIRTY" -gt 0 ] && GIT_INFO="${GIT_INFO} | ${DIRTY} ungespeicherte Änderungen"
  [ "$UNPUSHED" -gt 0 ] && GIT_INFO="${GIT_INFO} | ${UNPUSHED} ungepushte Commits"
  CONTEXT="${CONTEXT}${GIT_INFO}\n"
fi

# 4. Aktuelle Roadmap-Phase
if [ -f "$PROJECT_DIR/ROADMAP.md" ]; then
  # Aktuelle Phase extrahieren (erster nicht-erledigter A-Task)
  CURRENT_TASK=$(grep -m1 -E '###\s+A[0-9]+:' "$PROJECT_DIR/ROADMAP.md" 2>/dev/null | head -1)
  if [ -n "$CURRENT_TASK" ]; then
    CONTEXT="${CONTEXT}🗺️ Aktuelle Roadmap: ${CURRENT_TASK}\n"
  fi
fi

# Output als additionalContext (wird Claude als Kontext gegeben)
if [ -n "$CONTEXT" ]; then
  # JSON-safe machen
  SAFE_CONTEXT=$(echo -e "$CONTEXT" | sed 's/"/\\"/g' | tr '\n' ' ')
  cat <<ENDJSON
{
  "additionalContext": "${SAFE_CONTEXT}"
}
ENDJSON
fi

exit 0
