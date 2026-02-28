# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Config — Host Feature-Flags                                 ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/conf.d/008-host-flags.fish                   ║
# ║  Autor:       MR-ByteZ                                                     ║
# ║  Version:     0.2.0                                                        ║
# ║  Erstellt:    2026-02-28                                                   ║
# ║  Aktualisiert:2026-02-28                                                   ║
# ║  Zweck:       Feature-Flags + Display-Skalierung pro Host                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# Host Feature-Flags
# ══════════════════════════════════════════════════════════════════════════════
# Muss VOR 050-gui.fish und 055-dev.fish geladen werden (008 < 050).
# Flags steuern, welche Conditionals aktiv sind.
#
# Flags:
#   MR_HAS_GUI       — Hat der Host eine grafische Oberflaeche?
#   MR_IS_DEV        — Ist der Host ein Entwicklungs-Host?
#   MR_DISPLAY_TYPE  — Display-Aufloesung (4k, 1920, headless)
#
# Display-Skalierung (aus ehemaligen 10-display.fish konsolidiert):
#   GDK_SCALE        — GTK HiDPI Skalierung
#   QT_SCALE_FACTOR  — Qt HiDPI Skalierung

switch (hostname)
    case n8-kiste
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE 4k
        # GDK_SCALE/QT_SCALE_FACTOR: 4K, aktuell nicht gesetzt (Wayland)

    case n8-station
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE 4k
        # GDK_SCALE/QT_SCALE_FACTOR: 4K, aktuell nicht gesetzt (Wayland)

    case n8-book
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE 1920
        # GDK_SCALE/QT_SCALE_FACTOR: 1920p, aktuell nicht gesetzt

    case n8-vps
        set -gx MR_HAS_GUI false
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE headless

    case n8-maxx
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE 4k
        set -gx GDK_SCALE 2
        set -gx QT_SCALE_FACTOR 2

    case n8-bookchen
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE 1920
        set -gx GDK_SCALE 1
        set -gx QT_SCALE_FACTOR 1

    case n8-broker
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE 4k
        set -gx GDK_SCALE 1
        set -gx QT_SCALE_FACTOR 1

    case n8-archstick
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE 1920

    case '*'
        # Unbekannter Host: Sicherer Default
        set -gx MR_HAS_GUI false
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE headless
end
