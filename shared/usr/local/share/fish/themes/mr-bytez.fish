# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Theme - Dark Tech Style                                            ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/usr/local/share/fish/themes/mr-bytez.fish       ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-26                                                        ║
# ║  Zweck:    Offizielles mr-bytez Dark Theme mit Cyan-Akzenten                ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 🎨 THEME METADATEN
# ══════════════════════════════════════════════════════════════════════════════

set -g theme_name      "mr-bytez"
set -g theme_version   "1.0.0"
set -g theme_author    "Michael Rohwer"
set -g theme_style     "dark"

# ══════════════════════════════════════════════════════════════════════════════
# 🎨 SEMANTISCHE FARBEN (für Helper-Funktionen wie __msg, __success, etc.)
# ══════════════════════════════════════════════════════════════════════════════

set -g theme_primary    00afff      # Helles Cyan - Hauptfarbe
set -g theme_secondary  0087d7      # Dunkleres Cyan - Sekundär
set -g theme_success    00d787      # Mint-Grün - Erfolg
set -g theme_warning    ffaf00      # Orange-Gelb - Warnung
set -g theme_error      ff5f5f      # Korallen-Rot - Fehler
set -g theme_accent     af87ff      # Lila - Akzent
set -g theme_muted      6c7086      # Grau - Gedämpft
set -g theme_text       cdd6f4      # Helles Grau - Text

# ══════════════════════════════════════════════════════════════════════════════
# 🔷 POWERLINE SEPARATOREN
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_SEP_LEFT      (printf '\ue0b0')   # Powerline Separator links
set -g MR_SEP_RIGHT     (printf '\ue0b2')   # Powerline Separator rechts
set -g MR_SEP_THIN_L    (printf '\ue0b1')   # Dünner Separator links
set -g MR_SEP_THIN_R    (printf '\ue0b3')   # Dünner Separator rechts

# ══════════════════════════════════════════════════════════════════════════════
# 📁 ICONS (Nerd Fonts)
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_ICON_FOLDER   (printf '\uf07b')   # Ordner
set -g MR_ICON_GIT      (printf '\uf418')   # Git Branch
set -g MR_ICON_DOCKER   (printf '\uf308')   # Docker Wal
set -g MR_ICON_TIMER    (printf '\uf017')   # Timer/Uhr
set -g MR_ICON_VI       "❯❯"        # Vi-Mode Indikator
set -g MR_ICON_PROMPT   "❯"        # Standard Prompt
set -g MR_ICON_ROOT     "#"         # Root Prompt
set -g MR_ICON_SUCCESS  "✔"         # Erfolg
set -g MR_ICON_ERROR    "✖"         # Fehler
set -g MR_ICON_WARN     "⚠"         # Warnung
set -g MR_ICON_INFO     "ℹ"         # Info

# ══════════════════════════════════════════════════════════════════════════════
# 👤 USER@HOST BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_BG_USER       1e1e2e      # Dunkler Hintergrund (Catppuccin Base)
set -g MR_COLOR_USER    00d7ff      # Cyan für Username
set -g MR_COLOR_HOST    6c7086      # Grau für Hostname (dezent)

# User-Farben je nach Typ (Username + Prefix gleiche Farbe, bold)
set -g MR_COLOR_USER_ROOT       ff5555      # Rot für Root (Warnung!)
set -g MR_COLOR_USER_SUDO       00d7ff      # Orange für Sudo-User
set -g MR_COLOR_USER_NORMAL     50a060      # Cyan für normale User

# ══════════════════════════════════════════════════════════════════════════════
# 📂 PATH BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_BG_PATH       313244      # Etwas heller als User-Block
set -g MR_TEXT_PRIMARY  cdd6f4      # Heller Text für gute Lesbarkeit

# ══════════════════════════════════════════════════════════════════════════════
# 📏 PATH ANZEIGE (Smart PWD)
# ══════════════════════════════════════════════════════════════════════════════

# Erste N Ordner vollständig anzeigen
set -g MR_PWD_FIRST_FULL  2

# Letzte N Ordner vollständig anzeigen
set -g MR_PWD_LAST_FULL   2

# Mitte auf N Zeichen kürzen
set -g MR_PWD_MID_LENGTH  1

# ══════════════════════════════════════════════════════════════════════════════
# 🌿 GIT BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_BG_GIT_CLEAN  1e3a2f      # Dunkles Grün (clean)
set -g MR_BG_GIT_DIRTY  3a2f1e      # Dunkles Orange (dirty/modified)
set -g MR_COLOR_GIT     a6e3a1      # Grün für Git-Text

# ══════════════════════════════════════════════════════════════════════════════
# 🐳 DOCKER BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_BG_DOCKER     1e2d3a      # Dunkles Blau
set -g MR_COLOR_DOCKER  89b4fa      # Hellblau für Docker-Text

# ══════════════════════════════════════════════════════════════════════════════
# ⌨️  VI-MODE FARBEN
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_VI_NORMAL     f38ba8      # Rosa - Normal Mode
set -g MR_VI_INSERT     a6e3a1      # Grün - Insert Mode
set -g MR_VI_REPLACE    fab387      # Pfirsich - Replace Mode
set -g MR_VI_VISUAL     cba6f7      # Lila - Visual Mode

# ══════════════════════════════════════════════════════════════════════════════
# ❯ PROMPT SYMBOLE
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_PROMPT_SUCCESS 50a060     # Dunkelgrün bei Erfolg (bold) (letzter Befehl OK)
set -g MR_PROMPT_ERROR   ff5f5f     # Rot bei Fehler (letzter Befehl failed)

# ══════════════════════════════════════════════════════════════════════════════
# 🔧 ZUSÄTZLICHE PROMPT-ELEMENTE
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_BG_TIME       45475a      # Hintergrund für Zeit (falls verwendet)
set -g MR_COLOR_TIME    bac2de      # Farbe für Zeit

set -g MR_BG_STATUS     f38ba8      # Hintergrund für Error-Status
set -g MR_COLOR_STATUS  1e1e2e      # Text für Error-Status (dunkel auf hell)

# Prompt-Prefix je nach User-Typ
set -g MR_PROMPT_PREFIX_ROOT "  #"              # Root User
set -g MR_PROMPT_PREFIX_ROOT_COLOR ff5555     # Rot (Warnung!)
set -g MR_PROMPT_PREFIX_SUDO "  %"              # User mit sudo-Rechten
set -g MR_PROMPT_PREFIX_SUDO_COLOR ffb86c     # Orange
set -g MR_PROMPT_PREFIX_USER "  \$"             # Normaler User
set -g MR_PROMPT_PREFIX_USER_COLOR 6c6c6c     # Grau

set -g MR_ICON_ERROR    "✘"         # Fehler-Symbol
set -g MR_BG_ERROR      ff5f5f      # Hintergrund bei Fehler (rot)

set -g MR_ICON_SUCCESS  "✔"         # Erfolg-Symbol
set -g MR_BG_SUCCESS    5faf5f      # Hintergrund bei Erfolg (grün)
set -g MR_TEXT_SUCCESS  ffffff      # Weiß für Erfolg-Text

# ══════════════════════════════════════════════════════════════════════════════
# 📊 EZA / LS FARBEN (optional, für konsistentes Look)
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_EZA_DIRS      00d7ff      # Ordner in Cyan
set -g MR_EZA_EXEC      a6e3a1      # Executables in Grün
set -g MR_EZA_SYMLINK   cba6f7      # Symlinks in Lila
set -g MR_EZA_ARCHIVE   fab387      # Archive in Pfirsich

# ══════════════════════════════════════════════════════════════════════════════
# 🎯 THEME GELADEN
# ══════════════════════════════════════════════════════════════════════════════

if set -q THEME_DEBUG
    echo "🎨 Theme geladen: $theme_name v$theme_version"
end
