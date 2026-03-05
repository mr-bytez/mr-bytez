#!/bin/bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Hook                           │
# └─────────────────────────────────────────────────────────┘
# Datei:       pre-commit-docs-check.sh
# Pfad:        /mr-bytez/.claude/hooks/pre-commit-docs-check.sh
# Autor:       MR-ByteZ
# Version:     0.2.0
# Erstellt:    2026-02-26
# Aktualisiert:2026-03-05
# Zweck:       Prueft VOR git commit ob CHANGELOG/ROADMAP im Staging sind
#              Dynamische Pruefung fuer alle Ordner mit eigenen CHANGELOGs
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

# Legacy/Fremd-Pfade die ignoriert werden (keine eigenen CHANGELOGs)
EXCLUDE_PATTERN="^projects/web/"

# Gestagte Dateien filtern (ohne Legacy)
RELEVANT_STAGED=$(echo "$STAGED" | grep -v "$EXCLUDE_PATTERN")

if [ -z "$RELEVANT_STAGED" ]; then
  exit 0
fi

# Dynamisch: Finde alle CHANGELOG.md im Repo (ohne Legacy/vendor)
ALL_CHANGELOGS=$(find "$PROJECT_DIR" \
  -path "*/node_modules" -prune -o \
  -path "*/vendor" -prune -o \
  -path "$PROJECT_DIR/projects/web/*" -prune -o \
  -name "CHANGELOG.md" -print 2>/dev/null | \
  sed "s|^$PROJECT_DIR/||")

# Fuer jede gestagte Datei: Suche den naechsten Ordner mit eigenem CHANGELOG
# und pruefe ob dieser CHANGELOG ebenfalls gestaged ist
MISSING_CHANGELOGS=""

for changelog in $ALL_CHANGELOGS; do
  changelog_dir=$(dirname "$changelog")

  # Pruefe ob Dateien unter diesem Pfad gestaged sind (aber nicht der CHANGELOG selbst)
  if [ "$changelog_dir" = "." ]; then
    # Root CHANGELOG — immer pruefen wenn irgendwas gestaged ist
    if ! echo "$STAGED" | grep -q "^CHANGELOG.md$"; then
      MISSING_CHANGELOGS="${MISSING_CHANGELOGS}  - CHANGELOG.md (Root)\n"
    fi
  else
    # Projekt-CHANGELOG — nur pruefen wenn Dateien in diesem Ordner gestaged sind
    has_staged_files=$(echo "$RELEVANT_STAGED" | grep "^${changelog_dir}/" | grep -v "CHANGELOG.md" | grep -v "ROADMAP.md" | head -1)
    if [ -n "$has_staged_files" ]; then
      if ! echo "$STAGED" | grep -q "^${changelog}$"; then
        MISSING_CHANGELOGS="${MISSING_CHANGELOGS}  - ${changelog}\n"
      fi
    fi
  fi
done

if [ -n "$MISSING_CHANGELOGS" ]; then
  WARNINGS="${WARNINGS}⚠️ CHANGELOG(s) fehlen im Staging:\n${MISSING_CHANGELOGS}"
fi

# ROADMAP Prüfung — warnen wenn Handoff-Dateien geändert wurden
if echo "$STAGED" | grep -q "handoffs/"; then
  if ! echo "$STAGED" | grep -q "ROADMAP.md"; then
    WARNINGS="${WARNINGS}⚠️ Handoff geaendert aber ROADMAP.md nicht im Staging! Tasks erledigt? → ROADMAP aktualisieren.\n"
  fi
fi

# Cross-Repo Prüfung — Secrets-Repo beteiligt?
if echo "$STAGED" | grep -q "^\.secrets/"; then
  WARNINGS="${WARNINGS}ℹ️ Secrets-Submodule geaendert! Cross-Repo-Regel beachten: Auch Secrets-Repo CHANGELOG/ROADMAP pruefen.\n"
fi

# Wenn Warnungen: Blockieren mit Begründung
if [ -n "$WARNINGS" ]; then
  REASON=$(printf '%b' "$WARNINGS" | tr '\n' ' ')
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
