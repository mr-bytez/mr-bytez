# ============================================
# __mr_host_color.fish - Host-Farben Lookup
# Pfad: shared/usr/local/share/fish/functions/
# Author: Michael Rohwer
# Created: 2026-01-23
# Version: 1.0.0
# Purpose: Gibt Hintergrundfarbe basierend auf Hostname zurück
# ============================================

function __mr_host_color
    # Host-Farben für mr-bytez Infrastruktur
    # ROT = Production (Vorsicht!)
    
    switch (hostname -s)
        case 'n8-kiste' 'n8kiste'
            echo '3498db'  # 🟦 Blau - Storage/Cloud
        case 'n8-vps'
            echo 'e74c3c'  # 🟥 Rot - Production!
        case 'n8-station'
            echo '2ecc71'  # 🟩 Grün - Development
        case 'n8-book'
            echo 'f39c12'  # 🟨 Gelb - Mobile
        case 'n8-bookchen'
            echo '9b59b6'  # 🟣 Lila - Mobile Light
        case '*'
            echo 'e67e22'  # 🟧 Orange - Unknown/Default
    end
end
