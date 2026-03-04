#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Statusline                     │
# └─────────────────────────────────────────────────────────┘
# Datei:        statusline.sh
# Pfad:         shared/etc/claude-code/statusline.sh
# Autor:        MR-ByteZ
# Version:      0.2.1
# Erstellt:     2026-03-03
# Aktualisiert: 2026-03-04
# Zweck:        Statusline fuer Claude Code CLI
#               Zeigt Model, Verzeichnis, Branch, Context-Verbrauch

input=$(cat)

# Werte extrahieren
model=$(echo "$input" | jq -r '.model.display_name // "?"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "?"')

# Nur letztes Verzeichnis-Segment
dir_name=$(basename "$current_dir")

# Git-Branch ermitteln (falls in Git-Repo)
branch=""
if [ -d "$current_dir/.git" ] || git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" symbolic-ref --short HEAD 2>/dev/null || echo "")
fi

# Context-Verbrauch
ctx_raw=$(echo "$input" | jq -r '.context_window.used_percentage // "null"')

if [ "$ctx_raw" = "null" ] || [ -z "$ctx_raw" ]; then
    ctx_bar="ctx --%"
    ctx_color='\033[32m'
else
    ctx_pct=$(echo "$ctx_raw" | cut -d. -f1)
    # Balken berechnen (10 Zeichen breit)
    filled=$((ctx_pct / 10))
    empty=$((10 - filled))
    bar=""
    i=0; while [ $i -lt $filled ]; do bar="${bar}▓"; i=$((i + 1)); done
    i=0; while [ $i -lt $empty ]; do bar="${bar}░"; i=$((i + 1)); done
    # Farbschwellen (4 Stufen)
    if [ "$ctx_pct" -ge 90 ]; then
        ctx_color='\033[91m'       # Rot
    elif [ "$ctx_pct" -ge 70 ]; then
        ctx_color='\033[38;5;208m' # Orange
    elif [ "$ctx_pct" -ge 50 ]; then
        ctx_color='\033[33m'       # Gelb
    else
        ctx_color='\033[32m'       # Gruen
    fi
    ctx_bar="ctx ${bar} ${ctx_pct}%"
fi

# ANSI-Farben
green='\033[32m'
cyan='\033[36m'
reset='\033[0m'

# Ausgabe zusammenbauen
output="${green}[${model}]${reset} ${dir_name}"

if [ -n "$branch" ]; then
    output="${output} | ${cyan}${branch}${reset}"
fi

output="${output} | ${ctx_color}${ctx_bar}${reset}"

printf '%b\n' "$output"
