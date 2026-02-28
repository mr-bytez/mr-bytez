# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ Fish Config                                  │
# │  Datei:    055-dev.fish                                 │
# │  Pfad:     shared/etc/fish/aliases/055-dev.fish         │
# │  Zweck:    DEV-spezifische Aliases und Funktionen       │
# │  Version:  0.1.0                                        │
# │  Autor:    MR-ByteZ                                     │
# │  Erstellt: 2026-02-28                                   │
# └─────────────────────────────────────────────────────────┘
#
# Self-Check: Nur laden wenn DEV-Host
# Hosts: n8-kiste, n8-station, n8-book, n8-vps
# Nicht: n8-maxx, n8-bookchen, n8-broker, n8-archstick

test "$MR_IS_DEV" != "true"; and return

# Platzhalter — Inhalt wird ergaenzt wenn konkrete Dev-Aliases definiert sind
