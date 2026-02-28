# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Function                              │
# └─────────────────────────────────────────────────────────┘
# Datei:       __mr_docker_status.fish
# Pfad:        shared/etc/fish/functions/__mr_docker_status.fish
# Autor:       MR-ByteZ
# Version:     0.3.1
# Erstellt:    2026-01-23
# Aktualisiert:2026-02-28
# Zweck:       Anzahl laufender Docker-Container fuer Prompt
# Abh.:        Keine

function __mr_docker_status
    # Prüfe ob Docker installiert und daemon läuft
    if not command -q docker
        return
    end
    
    # Zähle laufende Container (schnell, ohne sudo)
    set -l count (command docker ps -q 2>/dev/null | count)
    
    # Nur ausgeben wenn Container laufen
    if test "$count" -gt 0 2>/dev/null
        echo "$count"
    end
end
