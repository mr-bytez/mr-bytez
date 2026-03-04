#!/usr/bin/env bash
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Statusline                     │
# └─────────────────────────────────────────────────────────┘
# Datei:        statusline.sh
# Pfad:         shared/etc/claude-code/statusline.sh
# Autor:        MR-ByteZ
# Version:      0.3.0
# Erstellt:     2026-03-03
# Aktualisiert: 2026-03-04
# Zweck:        Statusline fuer Claude Code CLI
#               Zeigt Model, Verzeichnis, Branch, Context,
#               Kosten (hypothetisch auch im Abo),
#               5h + 7d Nutzungslimits mit Reset-Zeit

# ANSI-Farben
green='\033[32m'
yellow='\033[33m'
red='\033[91m'
cyan='\033[36m'
gray='\033[90m'
reset='\033[0m'

# Balken-Funktion (10 Zeichen, 3 Farbschwellen)
make_bar() {
    local pct="$1"
    local filled=$((pct / 10))
    local empty=$((10 - filled))
    local bar=""
    local i=0
    while [ $i -lt $filled ]; do bar="${bar}▓"; i=$((i + 1)); done
    i=0
    while [ $i -lt $empty ]; do bar="${bar}░"; i=$((i + 1)); done
    local color
    if [ "$pct" -ge 80 ]; then
        color="$red"
    elif [ "$pct" -ge 50 ]; then
        color="$yellow"
    else
        color="$green"
    fi
    printf '%b' "${color}${bar} ${pct}%${reset}"
}

input=$(cat)

# 1. Modell
model=$(echo "$input" | jq -r '.model.display_name // "?"')

# 2. Verzeichnis (letztes Segment)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "?"')
dir_name=$(basename "$current_dir")

# 3. Git Branch (gecacht 5s)
git_cache="/tmp/mrbz-cc-git-cache"
branch=""
if [ -f "$git_cache" ] && [ $(($(date +%s) - $(stat -c %Y "$git_cache" 2>/dev/null || echo 0))) -lt 5 ]; then
    branch=$(cat "$git_cache")
else
    if [ -d "$current_dir/.git" ] || git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
        branch=$(git -C "$current_dir" symbolic-ref --short HEAD 2>/dev/null || echo "")
    fi
    printf '%s' "$branch" > "$git_cache" 2>/dev/null
fi

# 4. Context-Balken
ctx_raw=$(echo "$input" | jq -r '.context_window.used_percentage // "null"')
if [ "$ctx_raw" = "null" ] || [ -z "$ctx_raw" ]; then
    ctx_block="${green}ctx --% ${reset}"
else
    ctx_pct=$(echo "$ctx_raw" | cut -d. -f1)
    ctx_block="ctx $(make_bar "$ctx_pct")"
fi

# 5. Kosten
cost_raw=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost_fmt=$(LC_NUMERIC=C printf '%.2f' "$cost_raw")
cost_block="${yellow}\$${cost_fmt}${reset}"

# 6+7. OAuth Usage API (gecacht 60s)
usage_cache="/tmp/mrbz-cc-usage-cache"
creds_file="$HOME/.claude/.credentials.json"
five_block=""
seven_block=""

if [ -f "$creds_file" ]; then
    # Cache pruefen
    if [ -f "$usage_cache" ] && [ $(($(date +%s) - $(stat -c %Y "$usage_cache" 2>/dev/null || echo 0))) -lt 60 ]; then
        usage_data=$(cat "$usage_cache")
    else
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        if [ -n "$token" ]; then
            usage_data=$(curl -s --max-time 3 \
                -H "Authorization: Bearer $token" \
                -H "anthropic-beta: oauth-2025-04-20" \
                -H "Content-Type: application/json" \
                "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
            if [ -n "$usage_data" ] && echo "$usage_data" | jq -e '.five_hour' >/dev/null 2>&1; then
                printf '%s' "$usage_data" > "$usage_cache" 2>/dev/null
            else
                usage_data=""
            fi
        fi
    fi

    if [ -n "$usage_data" ]; then
        # 5h Block
        five_util=$(echo "$usage_data" | jq -r '.five_hour.utilization // "null"')
        if [ "$five_util" != "null" ] && [ -n "$five_util" ]; then
            five_pct=$(echo "$five_util" | cut -d. -f1)
            five_resets=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
            five_time=""
            if [ -n "$five_resets" ]; then
                five_time=$(date -d "$five_resets" +%H:%M 2>/dev/null)
            fi
            five_block="5h $(make_bar "$five_pct")"
            if [ -n "$five_time" ]; then
                five_block="${five_block} ${gray}@${five_time}${reset}"
            fi
        fi

        # 7d Block
        seven_util=$(echo "$usage_data" | jq -r '.seven_day.utilization // "null"')
        if [ "$seven_util" != "null" ] && [ -n "$seven_util" ]; then
            seven_pct=$(echo "$seven_util" | cut -d. -f1)
            seven_resets=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
            seven_day=""
            if [ -n "$seven_resets" ]; then
                seven_day=$(LC_TIME=de_DE.UTF-8 date -d "$seven_resets" +%a 2>/dev/null)
            fi
            seven_block="7d $(make_bar "$seven_pct")"
            if [ -n "$seven_day" ]; then
                seven_block="${seven_block} ${gray}@${seven_day}${reset}"
            fi
        fi
    fi
fi

# Ausgabe zusammenbauen
output="${green}[${model}]${reset} ${dir_name}"

if [ -n "$branch" ]; then
    output="${output} | ${cyan}${branch}${reset}"
fi

output="${output} | ${ctx_block} | ${cost_block}"

if [ -n "$five_block" ]; then
    output="${output} | ${five_block}"
fi

if [ -n "$seven_block" ]; then
    output="${output} | ${seven_block}"
fi

printf '%b\n' "$output"
