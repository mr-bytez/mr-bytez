# ══════════════════════════════════════════════════════════════════════════════
# 80-n8archstick.fish - Host-spezifische Aliases
# Host: n8-archstick (USB Stick)
# Bereich: 80-89 (Host-spezifisch)
# ══════════════════════════════════════════════════════════════════════════════

# SSH zu anderen Hosts
alias ssh-vps="ssh mrohwer@136.243.101.223 -p 61020"
alias ssh-kiste="ssh mrohwer@10.10.10.1"

# Portable-Modus
alias portable-sync="rsync -avz ~/portable/ /mnt/backup/"
