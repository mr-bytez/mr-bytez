# ============================================
# 50-n8kiste.fish - n8-kiste Host-Config
# Pfad: projects/infrastructure/n8-kiste/root/home/mrohwer/.config/fish/conf.d/
# Author: Michael Rohwer
# Created: 2026-01-23
# Version: 1.0.0
# Purpose: n8-kiste spezifische Variablen und Aliases
# ============================================

# ─────────────────────────────────────────
# n8-kiste spezifische Variablen
# ─────────────────────────────────────────
set -gx N8_HOST 'n8-kiste'
set -gx N8_ROLE 'storage-cloud'

# Storage-Pfade
set -gx SAMBA_SHARE_PATH /srv/samba
set -gx CLOUD_STORAGE_ROOT /mnt/cloud
set -gx MEDIA_ROOT /srv/media

# ─────────────────────────────────────────
# Samba Management
# ─────────────────────────────────────────
alias smb-status='sudo systemctl status smbd nmbd'
alias smb-restart='sudo systemctl restart smbd nmbd'
alias smb-reload='sudo smbcontrol all reload-config'
alias smb-users='sudo pdbedit -L'

# ─────────────────────────────────────────
# rclone Cloud-Sync
# ─────────────────────────────────────────
alias rclone-ls='rclone lsd'
alias rclone-sync='rclone sync -P'
alias rclone-check='rclone check'

# ─────────────────────────────────────────
# Desktop-Manager (n8-desktop)
# ─────────────────────────────────────────
if test -d /opt/n8-desktop
    fish_add_path /opt/n8-desktop/bin
    alias desk-reset='/opt/n8-desktop/bin/reset-desktop.fish'
    alias desk-status='/opt/n8-desktop/bin/status.fish'
end

# ─────────────────────────────────────────
# Schnell-Navigation
# ─────────────────────────────────────────
alias cdsamba='cd /srv/samba'
alias cdmedia='cd /srv/media'
alias cdcloud='cd /mnt/cloud'

# ─────────────────────────────────────────
# SSH zu anderen Hosts
# ─────────────────────────────────────────
alias ssh-vps='ssh mrohwer@136.243.101.223 -p 61020'

# ─────────────────────────────────────────
# n8-kiste spezifisches Greeting (optional)
# ─────────────────────────────────────────
# function fish_greeting
#     set_color cyan
#     echo "🖥️  n8-kiste | Storage & Cloud | "(date +"%Y-%m-%d %H:%M")
#     set_color normal
# end

# ═══════════════════════════════════════════════════════════════════════════════
# 🧪 HOST-TEST
# ═══════════════════════════════════════════════════════════════════════════════

function n8kiste-test --description "Test ob n8-kiste Config geladen"
    set_color green
    echo "✔ n8-kiste Host-Config aktiv!"
    set_color normal
    echo ""
    echo "Host-spezifische Aliases:"
    echo "  cdcloud   → cd /mnt/cloud"
    echo "  ssh-vps   → ssh mrohwer@136.243.101.223 -p 61020"
end
