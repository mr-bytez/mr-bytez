# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Theme System                                                  ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/conf.d/00-theme.fish       ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.1.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Update:   2026-01-26 - MR_* Prompt-Variablen hinzugefügt                   ║
# ║  Zweck:    Lädt Theme-Farben + Fallback + Helper-Funktionen                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 🎨 THEME-VARIABLEN (Globale Definitionen)
# ══════════════════════════════════════════════════════════════════════════════
# Themes können diese Variablen überschreiben.
# Format: set -g theme_<name> <fish-color>
#
# Semantische Variablen (für Helper-Funktionen):
#   theme_primary    - Hauptfarbe (Standard: cyan)
#   theme_secondary  - Sekundärfarbe (Standard: blue)
#   theme_success    - Erfolg/OK (Standard: green)
#   theme_warning    - Warnung (Standard: yellow)
#   theme_error      - Fehler (Standard: red)
#   theme_accent     - Akzent/Highlight (Standard: magenta)
#   theme_muted      - Gedämpft/Info (Standard: brblack)
#   theme_text       - Normaler Text (Standard: normal)
#
# Prompt-Variablen (MR_*) für fish_prompt.fish:
#   MR_BG_*          - Hintergrundfarben für Prompt-Blöcke
#   MR_COLOR_*       - Textfarben für Prompt-Elemente
#   MR_ICON_*        - Icons (Nerd Fonts)
#   MR_SEP_*         - Powerline Separatoren
#   MR_VI_*          - Vi-Mode Farben
#   MR_PROMPT_*      - Prompt-Symbol Farben
#
# ══════════════════════════════════════════════════════════════════════════════

# ── Fallback-Farben (Standard Fish-Palette) ──────────────────────────────────
# Diese werden gesetzt, falls kein Theme geladen ist

function __theme_set_defaults --description "Setzt Standard-Farbpalette (Fallback)"
    # ── Theme Metadaten ──────────────────────────────────────────────────────
    set -g theme_name      "default"
    set -g theme_version   "1.0.0"
    set -g theme_author    "mr-bytez"
    set -g theme_style     "dark"

    # ── Semantische Farben (für Helper-Funktionen) ───────────────────────────
    set -g theme_primary   cyan
    set -g theme_secondary blue
    set -g theme_success   green
    set -g theme_warning   yellow
    set -g theme_error     red
    set -g theme_accent    magenta
    set -g theme_muted     brblack
    set -g theme_text      normal

    # ── Zusätzliche Styles ───────────────────────────────────────────────────
    set -g theme_bold      --bold
    set -g theme_dim       --dim
    set -g theme_italic    --italics

    # ══════════════════════════════════════════════════════════════════════════
    # 🔷 PROMPT-VARIABLEN (MR_*) - Fallback für fish_prompt.fish
    # ══════════════════════════════════════════════════════════════════════════

    # ── Powerline Separatoren ────────────────────────────────────────────────
    set -g MR_SEP_LEFT      ""
    set -g MR_SEP_RIGHT     ""
    set -g MR_SEP_THIN_L    ""
    set -g MR_SEP_THIN_R    ""

    # ── Icons (Nerd Fonts) ───────────────────────────────────────────────────
    set -g MR_ICON_FOLDER   ""
    set -g MR_ICON_GIT      ""
    set -g MR_ICON_DOCKER   ""
    set -g MR_ICON_VI       "❯"
    set -g MR_ICON_PROMPT   "❯"
    set -g MR_ICON_ROOT     "#"
    set -g MR_ICON_SUCCESS  "✔"
    set -g MR_ICON_ERROR    "✖"
    set -g MR_ICON_WARN     "⚠"
    set -g MR_ICON_INFO     "ℹ"

    # ── User@Host Block ──────────────────────────────────────────────────────
    set -g MR_BG_USER       black
    set -g MR_COLOR_USER    cyan
    set -g MR_COLOR_HOST    brblack

    # ── Path Block ───────────────────────────────────────────────────────────
    set -g MR_BG_PATH       brblack
    set -g MR_TEXT_PRIMARY  white

    # ── Git Block ────────────────────────────────────────────────────────────
    set -g MR_BG_GIT_CLEAN  green
    set -g MR_BG_GIT_DIRTY  yellow
    set -g MR_COLOR_GIT     black

    # ── Docker Block ─────────────────────────────────────────────────────────
    set -g MR_BG_DOCKER     blue
    set -g MR_COLOR_DOCKER  white

    # ── Vi-Mode Farben ───────────────────────────────────────────────────────
    set -g MR_VI_NORMAL     red
    set -g MR_VI_INSERT     green
    set -g MR_VI_REPLACE    yellow
    set -g MR_VI_VISUAL     magenta

    # ── Prompt Symbole ───────────────────────────────────────────────────────
    set -g MR_PROMPT_SUCCESS cyan
    set -g MR_PROMPT_ERROR   red

    # ── Zusätzliche Elemente ─────────────────────────────────────────────────
    set -g MR_BG_TIME       brblack
    set -g MR_COLOR_TIME    white
    set -g MR_BG_STATUS     red
    set -g MR_COLOR_STATUS  white

    # ── EZA Farben ───────────────────────────────────────────────────────────
    set -g MR_EZA_DIRS      cyan
    set -g MR_EZA_EXEC      green
    set -g MR_EZA_SYMLINK   magenta
    set -g MR_EZA_ARCHIVE   yellow
end

# ── Theme laden ──────────────────────────────────────────────────────────────
# Prüft ob ein Theme gesetzt ist und lädt es

function __theme_load --description "Lädt aktives Theme oder Fallback"
    # Basis-Pfad für Themes
    set -l theme_base (dirname (status filename))/../themes

    # Aktives Theme aus Variable oder Datei
    if not set -q FISH_THEME
        # Prüfe ob Theme in Datei gespeichert
        set -l theme_file ~/.config/fish/.active_theme
        if test -f $theme_file
            set -g FISH_THEME (cat $theme_file | string trim)
        end
    end

    # Default Theme falls weder Variable noch Datei gesetzt
    if not set -q FISH_THEME; or test -z "$FISH_THEME"
        set -g FISH_THEME "mr-bytez"
    end

    # Theme laden
    if set -q FISH_THEME; and test -n "$FISH_THEME"
        set -l theme_path "$theme_base/$FISH_THEME.fish"
        if test -f $theme_path
            source $theme_path
            return 0
        else
            # Theme nicht gefunden - Warnung aber kein Fehler
            # (wird nur beim ersten Mal angezeigt)
            if not set -q __theme_warning_shown
                echo "⚠  Theme '$FISH_THEME' nicht gefunden, nutze Fallback" >&2
                set -g __theme_warning_shown 1
            end
        end
    end

    # Fallback auf Standard-Farben
    __theme_set_defaults
end

# ══════════════════════════════════════════════════════════════════════════════
# 🔧 FARB-HELPER FUNKTIONEN
# ══════════════════════════════════════════════════════════════════════════════

# ── __cvars: Liefert ANSI-Farbsequenzen ──────────────────────────────────────
# Nutzt Theme-Variablen mit Fallback auf Standard-Farben
# Rückgabe: "BOLD|NORMAL|CYAN|GREEN|YELLOW|RED|MAGENTA" (pipe-separiert)

function __cvars --description "Liefert Theme-aware ANSI-Farbsequenzen"
    # Theme-Variablen mit Fallback
    set -l _primary   $theme_primary;   or set _primary cyan
    set -l _success   $theme_success;   or set _success green
    set -l _warning   $theme_warning;   or set _warning yellow
    set -l _error     $theme_error;     or set _error red
    set -l _accent    $theme_accent;    or set _accent magenta

    # Farbcodes generieren
    set -l B   (set_color --bold)
    set -l N   (set_color normal)
    set -l C1  (set_color $_primary)
    set -l G   (set_color $_success)
    set -l Y   (set_color $_warning)
    set -l R   (set_color $_error)
    set -l M   (set_color $_accent)

    # Pipe-separierter String (kompatibel mit bestehenden Aliases)
    echo "$B|$N|$C1|$G|$Y|$R|$M"
end

# ── __msg: Farbige Info-Zeile ────────────────────────────────────────────────
# Unterdrückbar via MISC_SILENT=1 oder THEME_QUIET=1

function __msg --description "Kurze, farbige Infozeile (Theme-aware)"
    # Silent-Mode prüfen
    if test "$MISC_SILENT" = "1"; or test "$THEME_QUIET" = "1"
        return
    end

    # Theme-Farbe mit Fallback
    set -l _primary $theme_primary; or set _primary cyan

    # Farbcodes
    set -l C1 (set_color $_primary)
    set -l N  (set_color normal)

    # Ausgabe mit Info-Emoji
    printf "%sℹ%s %s\n" $C1 $N (string join " " $argv)
end

# ── __success: Erfolgs-Nachricht ─────────────────────────────────────────────

function __success --description "Erfolgs-Nachricht (grün)"
    set -l _success $theme_success; or set _success green
    set -l G (set_color $_success)
    set -l N (set_color normal)
    printf "%s✔%s %s\n" $G $N (string join " " $argv)
end

# ── __warn: Warn-Nachricht ───────────────────────────────────────────────────

function __warn --description "Warn-Nachricht (gelb)"
    set -l _warning $theme_warning; or set _warning yellow
    set -l Y (set_color $_warning)
    set -l N (set_color normal)
    printf "%s⚠%s %s\n" $Y $N (string join " " $argv) >&2
end

# ── __error: Fehler-Nachricht ────────────────────────────────────────────────

function __error --description "Fehler-Nachricht (rot)"
    set -l _error $theme_error; or set _error red
    set -l R (set_color $_error)
    set -l N (set_color normal)
    printf "%s✖%s %s\n" $R $N (string join " " $argv) >&2
end

# ── __header: Abschnitts-Header ──────────────────────────────────────────────

function __header --description "Farbiger Abschnitts-Header"
    set -l _primary $theme_primary; or set _primary cyan
    set -l B (set_color --bold)
    set -l C (set_color $_primary)
    set -l N (set_color normal)
    printf "\n%s%s══ %s ══%s\n" $B $C (string join " " $argv) $N
end

# ══════════════════════════════════════════════════════════════════════════════
# 🚀 INITIALISIERUNG
# ══════════════════════════════════════════════════════════════════════════════

# Theme beim Laden der Datei initialisieren
__theme_load
