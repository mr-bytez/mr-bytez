# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Pacman & Yay (Headless-Basis)                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/aliases/60-pacman.fish     ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Zweck:    System-Updates für Arch + AUR (OHNE Flatpak)                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Hinweise:
# - Diese Basis-Version ist für ALLE Hosts (inkl. headless Server)
# - Desktop-Hosts überschreiben diese Aliases via 70-desktop.fish (MIT Flatpak)
# - Für Repo-Check wird "pacman-contrib" benötigt (checkupdates)

# ══════════════════════════════════════════════════════════════════════════════
# 🔄 STANDARD-UPDATES
# ══════════════════════════════════════════════════════════════════════════════

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
# Hinweis: Desktop-Override erweitert um Flatpak-Check
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
