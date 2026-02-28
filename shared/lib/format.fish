#!/usr/bin/env fish
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Library                               │
# │  Datei:    format.fish                                  │
# │  Pfad:     shared/lib/format.fish                       │
# │  Zweck:    Zentrale Formatting-Funktionen               │
# │  Version:  0.1.0                                        │
# │  Autor:    MR-ByteZ                                     │
# │  Erstellt: 2026-02-28                                   │
# └─────────────────────────────────────────────────────────┘
#
# Einheitliches Look & Feel fuer alle Fish-Scripts.
# Farb-Schema: Gruvbox (yellow, green, red, cyan, brblack)
#
# Verwendung:
#   source /mr-bytez/shared/lib/format.fish
#   # oder ueber Anker:
#   source /opt/mr-bytez/current/shared/lib/format.fish

# ── Banner laden ──────────────────────────────────────────

set -l _format_dir (dirname (status filename))
set -l _banner_path "$_format_dir/banner.fish"
if test -f "$_banner_path"
    source "$_banner_path"
end

# ── Basis-Funktionen ─────────────────────────────────────

function _msg --description "Info-Meldung (cyan)"
    set_color cyan
    echo "→ $argv"
    set_color normal
end

function _success --description "Erfolgs-Meldung (gruen)"
    set_color green
    echo "✅ $argv"
    set_color normal
end

function _error --description "Fehler-Meldung (rot, stderr)"
    set_color red
    echo "❌ $argv" >&2
    set_color normal
end

function _warn --description "Warnung (gelb)"
    set_color yellow
    echo "⚠️  $argv"
    set_color normal
end

function _skip --description "Uebersprungen (brblack)"
    set_color brblack
    echo "⊘ $argv"
    set_color normal
end

# ── Erweiterte Funktionen ────────────────────────────────

function _section --description "Sektions-Header mit Linie"
    echo ""
    set_color yellow
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $argv"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    set_color normal
end

function _link --description "Symlink-Aktion"
    set_color cyan
    echo "🔗 $argv"
    set_color normal
end

function _copy --description "Copy-Aktion"
    set_color cyan
    echo "📋 $argv"
    set_color normal
end

function _box --description "Zusammenfassungs-Box mit Rahmen"
    # Verwendung: _box "Zeile 1" "Zeile 2" ...
    echo ""
    set_color yellow
    echo "┌────────────────────────────────────────┐"
    set_color normal
    for line in $argv
        set_color yellow
        echo -n "│ "
        set_color normal
        echo "$line"
    end
    set_color yellow
    echo "└────────────────────────────────────────┘"
    set_color normal
end
