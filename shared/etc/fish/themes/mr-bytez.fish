# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Theme — Dark Tech Style                                     ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/themes/mr-bytez.fish                          ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.3.1                                                         ║
# ║  Erstellt:    2026-01-26                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       Offizielles mr-bytez Dark Theme mit Host-Farben              ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 🎨 THEME METADATEN
# ══════════════════════════════════════════════════════════════════════════════

set -g theme_name      "mr-bytez"
set -g theme_version   "2.0.0"
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
set -g MR_ICON_VI       "❯❯"                # Vi-Mode Indikator
set -g MR_ICON_PROMPT   "❯"                 # Standard Prompt
set -g MR_ICON_ROOT     "#"                 # Root Prompt
set -g MR_ICON_SUCCESS  "✔"                 # Erfolg
set -g MR_ICON_ERROR    "✖"                 # Fehler
set -g MR_ICON_WARN     "⚠"                 # Warnung
set -g MR_ICON_INFO     "ℹ"                 # Info

# ══════════════════════════════════════════════════════════════════════════════
# 👤 USER@HOST BLOCK
# ══════════════════════════════════════════════════════════════════════════════

# User-Teil (statisch)
set -g MR_COLOR_BG_USER         1e1e2e      # Dunkler Hintergrund
set -g MR_COLOR_TEXT_USER_ROOT  ff5555      # Rot für Root (Warnung!)
set -g MR_COLOR_TEXT_USER_SUDO  ffb86c      # Orange für Sudo-User
set -g MR_COLOR_TEXT_USER_NORMAL 50a060     # Grün für normale User

# Host-Teil (DYNAMISCH - wird aus Theme-Variablen gelesen)
# Default-Textfarbe (wird host-spezifisch überschrieben)
set -g MR_COLOR_TEXT_HOST       ffffff      # Weiß (Default)

# ── Host-spezifische Farben (BG + TEXT für optimale Lesbarkeit) ──────────────

# n8-kiste: Storage/Cloud
set -g MR_COLOR_BG_HOST_KISTE       3498db  # 🟦 Blau (mittel)
set -g MR_COLOR_TEXT_HOST_KISTE     ffffff  # Weiß (gut lesbar auf Blau)

# n8-vps: Production Server
set -g MR_COLOR_BG_HOST_VPS         e74c3c  # 🟥 Rot (WARNUNG Production!)
set -g MR_COLOR_TEXT_HOST_VPS       ffffff  # Weiß (maximaler Kontrast)

# n8-station: Development Workstation
set -g MR_COLOR_BG_HOST_STATION     2ecc71  # 🟩 Grün (mittel)
set -g MR_COLOR_TEXT_HOST_STATION   1e1e2e  # Dunkel (besser lesbar als weiß auf grün)

# n8-book: Laptop
set -g MR_COLOR_BG_HOST_BOOK        f39c12  # 🟨 Gelb/Orange (hell!)
set -g MR_COLOR_TEXT_HOST_BOOK      1e1e2e  # Dunkel (Kontrast auf hellem Gelb)

# n8-bookchen: Small Laptop
set -g MR_COLOR_BG_HOST_BOOKCHEN    9b59b6  # 🟣 Lila (mittel)
set -g MR_COLOR_TEXT_HOST_BOOKCHEN  ffffff  # Weiß (gut lesbar)

# n8-maxx: Gaming PC
set -g MR_COLOR_BG_HOST_MAXX        e67e22  # 🟧 Orange (mittel)
set -g MR_COLOR_TEXT_HOST_MAXX      1e1e2e  # Dunkel (Kontrast)

# n8-broker: Trading Workstation
set -g MR_COLOR_BG_HOST_BROKER      16a085  # 🟢 Türkis/Grün (Trading = Money)
set -g MR_COLOR_TEXT_HOST_BROKER    ffffff  # Weiß

# n8-archstick: Portable USB
set -g MR_COLOR_BG_HOST_ARCHSTICK   8e44ad  # 🟣 Dunkellila (Portable)
set -g MR_COLOR_TEXT_HOST_ARCHSTICK ffffff  # Weiß

# Default: Unknown Host
set -g MR_COLOR_BG_HOST_DEFAULT     6c7086  # ⚫ Grau (unbekannt)
set -g MR_COLOR_TEXT_HOST_DEFAULT   ffffff  # Weiß

# ══════════════════════════════════════════════════════════════════════════════
# 📂 PATH BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_BG_PATH         313244      # Etwas heller als User-Block
set -g MR_COLOR_TEXT_PATH       cdd6f4      # Heller Text für gute Lesbarkeit

# ══════════════════════════════════════════════════════════════════════════════
# 📏 PATH ANZEIGE (Smart PWD)
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_PWD_FIRST_FULL  2                 # Erste N Ordner vollständig
set -g MR_PWD_LAST_FULL   2                 # Letzte N Ordner vollständig
set -g MR_PWD_MID_LENGTH  1                 # Mitte auf N Zeichen kürzen

# ══════════════════════════════════════════════════════════════════════════════
# 🌿 GIT BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_BG_GIT_CLEAN    1e3a2f      # Dunkles Grün (clean)
set -g MR_COLOR_BG_GIT_DIRTY    3a2f1e      # Dunkles Orange (dirty/modified)
set -g MR_COLOR_TEXT_GIT        a6e3a1      # Grün für Git-Text

# ══════════════════════════════════════════════════════════════════════════════
# 🐳 DOCKER BLOCK
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_BG_DOCKER       1e2d3a      # Dunkles Blau
set -g MR_COLOR_TEXT_DOCKER     89b4fa      # Hellblau für Docker-Text

# ══════════════════════════════════════════════════════════════════════════════
# ⌨️  VI-MODE FARBEN
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_VI_NORMAL       f38ba8      # Rosa - Normal Mode
set -g MR_COLOR_VI_INSERT       a6e3a1      # Grün - Insert Mode
set -g MR_COLOR_VI_REPLACE      fab387      # Pfirsich - Replace Mode
set -g MR_COLOR_VI_VISUAL       cba6f7      # Lila - Visual Mode

# ══════════════════════════════════════════════════════════════════════════════
# ❯ PROMPT SYMBOLE
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_PROMPT_SUCCESS  50a060      # Dunkelgrün bei Erfolg (letzter Befehl OK)
set -g MR_COLOR_PROMPT_ERROR    ff5f5f      # Rot bei Fehler (letzter Befehl failed)

# Prompt-Prefix je nach User-Typ
set -g MR_PROMPT_PREFIX_ROOT    "  #"       # Root User
set -g MR_COLOR_PROMPT_PREFIX_ROOT ff5555   # Rot (Warnung!)
set -g MR_PROMPT_PREFIX_SUDO    "  %"       # User mit sudo-Rechten
set -g MR_COLOR_PROMPT_PREFIX_SUDO ffb86c   # Orange
set -g MR_PROMPT_PREFIX_USER    "  \$"      # Normaler User
set -g MR_COLOR_PROMPT_PREFIX_USER 6c6c6c   # Grau

# ══════════════════════════════════════════════════════════════════════════════
# 🔧 RIGHT PROMPT ELEMENTE
# ══════════════════════════════════════════════════════════════════════════════

# Zeit
set -g MR_COLOR_BG_TIME         45475a      # Hintergrund für Zeit
set -g MR_COLOR_TEXT_TIME       bac2de      # Text für Zeit

# Erfolg/Fehler Indikator
set -g MR_COLOR_BG_SUCCESS      5faf5f      # Hintergrund bei Erfolg (grün)
set -g MR_COLOR_TEXT_SUCCESS    ffffff      # Weiß für Erfolg-Text
set -g MR_COLOR_BG_ERROR        ff5f5f      # Hintergrund bei Fehler (rot)
set -g MR_COLOR_TEXT_ERROR      ffffff      # Weiß für Fehler-Text

# Status (falls verwendet)
set -g MR_COLOR_BG_STATUS       f38ba8      # Hintergrund für Error-Status
set -g MR_COLOR_TEXT_STATUS     1e1e2e      # Text für Error-Status (dunkel auf hell)

# ══════════════════════════════════════════════════════════════════════════════
# 📊 EZA / LS FARBEN (optional, für konsistentes Look)
# ══════════════════════════════════════════════════════════════════════════════

set -g MR_COLOR_EZA_DIRS        00d7ff      # Ordner in Cyan
set -g MR_COLOR_EZA_EXEC        a6e3a1      # Executables in Grün
set -g MR_COLOR_EZA_SYMLINK     cba6f7      # Symlinks in Lila
set -g MR_COLOR_EZA_ARCHIVE     fab387      # Archive in Pfirsich

# ══════════════════════════════════════════════════════════════════════════════
# 🎯 THEME GELADEN
# ══════════════════════════════════════════════════════════════════════════════

if set -q THEME_DEBUG
    echo "🎨 Theme geladen: $theme_name v$theme_version"
end
