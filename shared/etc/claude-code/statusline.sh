#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Statusline                     │
# └─────────────────────────────────────────────────────────┘
# Datei:        statusline.sh
# Pfad:         shared/etc/claude-code/statusline.sh
# Autor:        MR-ByteZ
# Version:      0.1.0
# Erstellt:     2026-03-03
# Zweck:        Statusline fuer Claude Code CLI
#               Zeigt Model, Verzeichnis, Branch, Kosten, Lines

input=$(cat)

# Werte extrahieren
model=$(echo "$input" | jq -r '.model.display_name // "?"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "?"')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Nur letztes Verzeichnis-Segment
dir_name=$(basename "$current_dir")

# Git-Branch ermitteln (falls in Git-Repo)
branch=""
if [ -d "$current_dir/.git" ] || git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" symbolic-ref --short HEAD 2>/dev/null || echo "")
fi

# Kosten auf 4 Dezimalstellen (LC_NUMERIC=C fuer Punkt statt Komma)
cost_fmt=$(LC_NUMERIC=C printf '%.4f' "$cost")

# ANSI-Farben
green='\033[32m'
cyan='\033[36m'
yellow='\033[33m'
magenta='\033[35m'
reset='\033[0m'

# Ausgabe zusammenbauen
output="${green}[${model}]${reset} ${dir_name}"

if [ -n "$branch" ]; then
    output="${output} | ${cyan}${branch}${reset}"
fi

output="${output} | ${yellow}\$${cost_fmt}${reset}"
output="${output} | ${magenta}+${lines_added} -${lines_removed}${reset}"

printf '%b\n' "$output"
