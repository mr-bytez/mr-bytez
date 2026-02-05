# ============================================
# __mr_docker_status.fish - Docker Status Helper
# Pfad: shared/etc/fish/functions/
# Author: Michael Rohwer
# Created: 2026-01-23
# Version: 1.0.0
# Purpose: Gibt Anzahl laufender Docker-Container zurück
# ============================================

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
