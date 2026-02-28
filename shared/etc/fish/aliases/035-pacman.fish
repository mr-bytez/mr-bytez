# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Aliases — Pacman & Yay (Headless-Basis)                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/aliases/035-pacman.fish                       ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.4.0                                                         ║
# ║  Erstellt:    2026-01-25                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       System-Updates fuer Arch + AUR (OHNE Flatpak)               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Hinweise:
# - Diese Basis-Version ist fuer ALLE Hosts (inkl. headless Server)
# - Desktop-Hosts ueberschreiben upa/upchk via 050-gui.fish (MIT Flatpak)
# - Fuer Repo-Check wird "pacman-contrib" benoetigt (checkupdates)

# ══════════════════════════════════════════════════════════════════════════════
# 🔄 STANDARD-UPDATES
# ══════════════════════════════════════════════════════════════════════════════

# upa: Interaktives Voll-Update (Repos + AUR) — OHNE --noconfirm
# Desktop-Hosts ueberschreiben upa via 050-gui.fish (MIT Flatpak)
alias upa='sudo pacman -Syu; and yay -Syu'

# upp: Normales Repo-Update (ohne AUR)
alias upp='sudo pacman -Syu --color=auto'

# upy: Interaktives Update mit yay (deckt Repos + AUR ab)
alias upy='yay -Syu --color=auto'

# ══════════════════════════════════════════════════════════════════════════════
# ⚡ FORCE & REFRESH
# ══════════════════════════════════════════════════════════════════════════════

# upf: Force-Refresh (vollständiger Neuabgleich) + Upgrade
#  -Syyu nur bei Mirror-Wechsel/DB-Problemen/seltenen Updates nötig
alias upf='sudo pacman -Syyu --color=auto'

# ══════════════════════════════════════════════════════════════════════════════
# 🧹 CACHE & CLEANUP
# ══════════════════════════════════════════════════════════════════════════════

# upc: Cache aufräumen (schonend)
#  - pacman -Sc: löscht NICHT installierte Paketdateien
#  - yay -Sc: räumt AUR-Build-Cache
alias upc='sudo pacman -Sc && yay -Sc'

# ══════════════════════════════════════════════════════════════════════════════
# 🔍 CHECK (ohne Install)
# ══════════════════════════════════════════════════════════════════════════════

# upchk: Nur prüfen, was ansteht (kein Install)
#  - checkupdates (Repo; Paket pacman-contrib erforderlich)
#  - yay -Qua (AUR)
# Hinweis: Desktop-Hosts ueberschreiben upchk via 050-gui.fish (+Flatpak)
alias upchk='checkupdates; and yay -Qua'


# ══════════════════════════════════════════════════════════════════════════════
# 📦 PAKET-VERWALTUNG
# ══════════════════════════════════════════════════════════════════════════════

# ── install: Paket installieren ──────────────────────────────────────────────
#  Beispiel: install bat
alias painstall='sudo pacman -S --color=auto'

# ── remove: Paket + ungenutzte Abhängigkeiten entfernen ──────────────────────
#  Beispiel: remove bat
alias paremove='sudo pacman -Rs --color=auto'

# ── search: Paket in Repos suchen ────────────────────────────────────────────
#  Beispiel: search bat
alias pasearch='pacman -Ss --color=auto'

# ── pinfo: Paket-Details anzeigen ────────────────────────────────────────────
#  Beispiel: pinfo bat
alias painfo='pacman -Qi --color=auto'
