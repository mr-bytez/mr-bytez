# ══════════════════════════════════════════════════════════════════════════════
# 70-desktop.fish - Desktop-Kategorie Aliases
# Host: n8-maxx
# Bereich: 70-79 (Kategorie Desktop)
# ══════════════════════════════════════════════════════════════════════════════

# Flatpak-Integration
alias upfl="flatpak update -y"
alias upa="sudo pacman -Syu && yay -Syu && sudo flatpak update -y"

# Flatpak-Apps
alias flathub="flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
