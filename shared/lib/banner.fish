#!/usr/bin/env fish
# ============================================
# banner.fish - MR-ByteZ Banner/Logo
# Pfad: /mr-bytez/shared/lib/banner.fish
# Autor: MR-ByteZ
# Erstellt: 2026-02-25
# Version: 1.0.0
# Zweck: Logo-Ausgabe fuer Skripte
# ============================================

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
