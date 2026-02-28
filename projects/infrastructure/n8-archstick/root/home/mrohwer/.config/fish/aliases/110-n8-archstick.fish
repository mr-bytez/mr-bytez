# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ Fish Config                                   │
# │  Datei:    110-n8-archstick.fish                        │
# │  Pfad:     aliases/110-n8-archstick.fish                │
# │  Zweck:    n8-archstick-spezifische Aliases             │
# │  Version:  0.1.0                                        │
# │  Autor:    MR-ByteZ                                     │
# │  Erstellt: 2026-02-28                                   │
# │  Aktualisiert: 2026-02-28                               │
# └─────────────────────────────────────────────────────────┘

# SSH zu anderen Hosts
alias ssh-vps="ssh mrohwer@136.243.101.223 -p 61020"
alias ssh-kiste="ssh mrohwer@10.10.10.1"

# Portable-Modus
alias portable-sync="rsync -avz ~/portable/ /mnt/backup/"
