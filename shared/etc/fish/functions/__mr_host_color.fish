# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Function                              │
# └─────────────────────────────────────────────────────────┘
# Datei:       __mr_host_color.fish
# Pfad:        shared/etc/fish/functions/__mr_host_color.fish
# Autor:       MR-ByteZ
# Version:     0.3.1
# Erstellt:    2026-01-23
# Aktualisiert:2026-02-28
# Zweck:       Host-Farben [BG, TEXT] aus Theme fuer Prompt
# Abh.:        005-theme.fish

function __mr_host_color --description "Gibt Host-Farben [BG, TEXT] aus Theme zurück"
    # Hostname normalisieren: n8-kiste → KISTE (ohne n8- Prefix!)
    set -l hostname_raw (hostname -s)
    set -l host_normalized (string replace 'n8-' '' $hostname_raw | string upper)

    # Variablennamen konstruieren
    set -l bg_var "MR_COLOR_BG_HOST_$host_normalized"
    set -l text_var "MR_COLOR_TEXT_HOST_$host_normalized"

    # Prüfen ob Host-spezifische Farben existieren
    if set -q $bg_var
        # Host-Farben gefunden - Rückgabe: [BG, TEXT]
        echo $$bg_var
        echo $$text_var
    else
        # Default-Farben - Rückgabe: [BG, TEXT]
        echo $MR_COLOR_BG_HOST_DEFAULT
        echo $MR_COLOR_TEXT_HOST_DEFAULT
    end
end
