#!/usr/bin/env fish
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Library                               │
# └─────────────────────────────────────────────────────────┘
# Datei:       banner.fish
# Pfad:        shared/lib/banner.fish
# Autor:       MR-ByteZ
# Version:     0.3.1
# Erstellt:    2026-02-25
# Aktualisiert:2026-02-28
# Zweck:       Logo-Ausgabe fuer Skripte
# Abh.:        Keine

set -g MRBYTEZ_VERSION "2.0.0"

function mr_bytez_banner
    # --compact: Einzeilige Version
    if contains -- --compact $argv
        set_color yellow
        echo "→ MR-ByteZ v$MRBYTEZ_VERSION"
        set_color normal
        return
    end

    # Volles Logo (Gruvbox yellow)
    set_color yellow
    echo '▄▄▄      ▄▄▄ ▄▄▄▄▄▄▄        ▄▄▄▄▄▄▄                     ▄▄▄▄▄▄▄▄▄'
    echo '████▄  ▄████ ███▀▀███▄      ███▀▀███▄        ██         ▀▀▀▀▀████'
    echo '███▀████▀███ ███▄▄███▀      ███▄▄███▀ ██ ██ ▀██▀▀ ▄█▀█▄    ▄███▀ '
    echo '███  ▀▀  ███ ███▀▀██▄ ▀▀▀▀▀ ███  ███▄ ██▄██  ██   ██▄█▀  ▄███▀   '
    echo '███      ███ ███  ▀███      ████████▀  ▀██▀  ██   ▀█▄▄▄ █████████'
    echo '                                        ██                       '
    echo '                                      ▀▀▀'
    set_color normal
end
