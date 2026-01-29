# ══════════════════════════════════════════════════════════════════════════════
# 70-server.fish - Server-Kategorie Aliases
# Host: n8-vps
# Bereich: 70-79 (Kategorie Server)
# ══════════════════════════════════════════════════════════════════════════════

# Server-Update (kein Flatpak)
alias upa="sudo pacman -Syu && yay -Syu"

# Docker-Monitoring
alias dps="docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\""
alias dlogs="docker logs -f"

# Systemd Services
alias sstat="sudo systemctl status"
alias srestart="sudo systemctl restart"
