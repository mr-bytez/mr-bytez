# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Theme Switcher                                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/usr/local/share/fish/functions/theme.fish       ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Zweck:    Theme-Verwaltung (list, set, preview, reset)                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

function theme --description "🎨 Fish Theme Manager"
    # ── Konfiguration ────────────────────────────────────────────────────────
    set -l theme_base /mr-bytez/shared/usr/local/share/fish/themes
    set -l theme_file ~/.config/fish/.active_theme
    
    # Fallback-Pfad falls mr-bytez nicht existiert (für lokale Entwicklung)
    if not test -d $theme_base
        set theme_base (dirname (status filename))/../themes
    end
    
    # ── Farben ───────────────────────────────────────────────────────────────
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l C  (set_color cyan)
    set -l G  (set_color green)
    set -l Y  (set_color yellow)
    set -l R  (set_color red)
    set -l M  (set_color magenta)
    set -l D  (set_color brblack)
    
    # ── Keine Argumente: Zeige aktuelles Theme ───────────────────────────────
    if test (count $argv) -eq 0
        __theme_show_current
        return 0
    end
    
    # ── Subcommand-Handling ──────────────────────────────────────────────────
    switch $argv[1]
        case list ls
            __theme_list
            
        case set use
            if test (count $argv) -lt 2
                echo $R"✖"$N" Fehlendes Argument: theme set <name>"
                return 1
            end
            __theme_set $argv[2]
            
        case preview pre
            if test (count $argv) -lt 2
                echo $R"✖"$N" Fehlendes Argument: theme preview <name>"
                return 1
            end
            __theme_preview $argv[2]
            
        case reset default
            __theme_reset
            
        case reload
            __theme_reload
            
        case help -h --help
            __theme_help
            
        case '*'
            # Direkter Theme-Name ohne Subcommand
            __theme_set $argv[1]
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 📋 SUBCOMMAND-FUNKTIONEN
# ══════════════════════════════════════════════════════════════════════════════

function __theme_show_current --description "Zeigt aktuelles Theme"
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l C  (set_color cyan)
    set -l G  (set_color green)
    set -l D  (set_color brblack)
    
    echo
    echo $B"🎨 Aktuelles Theme"$N
    echo $D"─────────────────────────────────"$N
    
    if set -q theme_name
        echo "   Name:    "$C$theme_name$N
    else
        echo "   Name:    "$C"default"$N
    end
    
    if set -q theme_version
        echo "   Version: "$D$theme_version$N
    end
    
    echo
    echo $B"   Farbpalette:"$N
    printf "   %-12s %s██████%s\n" "Primary:"   (set_color $theme_primary)   $N
    printf "   %-12s %s██████%s\n" "Success:"   (set_color $theme_success)   $N
    printf "   %-12s %s██████%s\n" "Warning:"   (set_color $theme_warning)   $N
    printf "   %-12s %s██████%s\n" "Error:"     (set_color $theme_error)     $N
    printf "   %-12s %s██████%s\n" "Accent:"    (set_color $theme_accent)    $N
    printf "   %-12s %s██████%s\n" "Muted:"     (set_color $theme_muted)     $N
    echo
end

function __theme_list --description "Listet verfügbare Themes"
    set -l theme_base /mr-bytez/shared/usr/local/share/fish/themes
    if not test -d $theme_base
        set theme_base (dirname (status filename))/../themes
    end
    
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l C  (set_color cyan)
    set -l G  (set_color green)
    set -l D  (set_color brblack)
    set -l Y  (set_color yellow)
    
    echo
    echo $B"🎨 Verfügbare Themes"$N
    echo $D"─────────────────────────────────"$N
    
    # Default immer auflisten
    if test "$theme_name" = "default"; or not set -q theme_name
        echo "   "$G"● "$N"default "$D"(aktiv)"$N
    else
        echo "   "$D"○ "$N"default"
    end
    
    # Theme-Dateien auflisten
    if test -d $theme_base
        for theme_file in $theme_base/*.fish
            if test -f $theme_file
                set -l name (basename $theme_file .fish)
                if test "$theme_name" = "$name"
                    echo "   "$G"● "$N$name" "$D"(aktiv)"$N
                else
                    echo "   "$D"○ "$N$name
                end
            end
        end
    end
    
    # Hinweis wenn keine Themes vorhanden
    set -l theme_count (count $theme_base/*.fish 2>/dev/null)
    if test $theme_count -eq 0
        echo
        echo "   "$Y"ℹ"$N" Keine Custom-Themes in:"
        echo "     "$D$theme_base$N
    end
    
    echo
    echo $D"   Nutzung: theme <name> | theme preview <name>"$N
    echo
end

function __theme_set --argument name --description "Setzt Theme"
    set -l theme_base /mr-bytez/shared/usr/local/share/fish/themes
    set -l theme_file ~/.config/fish/.active_theme
    
    if not test -d $theme_base
        set theme_base (dirname (status filename))/../themes
    end
    
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l G  (set_color green)
    set -l R  (set_color red)
    set -l Y  (set_color yellow)
    
    # Verzeichnis erstellen falls nötig
    mkdir -p (dirname $theme_file)
    
    # Default-Theme
    if test "$name" = "default"
        rm -f $theme_file
        set -e FISH_THEME
        __theme_set_defaults
        echo $G"✔"$N" Theme zurückgesetzt auf "$B"default"$N
        echo $Y"ℹ"$N" Neue Shell starten für vollständige Anwendung"
        return 0
    end
    
    # Theme-Datei prüfen
    set -l theme_path "$theme_base/$name.fish"
    if not test -f $theme_path
        echo $R"✖"$N" Theme nicht gefunden: "$B$name$N
        echo "   Verfügbare Themes: "$Y"theme list"$N
        return 1
    end
    
    # Theme aktivieren
    echo $name > $theme_file
    set -g FISH_THEME $name
    source $theme_path
    
    echo $G"✔"$N" Theme aktiviert: "$B$name$N
    echo $Y"ℹ"$N" Neue Shell starten für vollständige Anwendung"
end

function __theme_preview --argument name --description "Vorschau eines Themes"
    set -l theme_base /mr-bytez/shared/usr/local/share/fish/themes
    if not test -d $theme_base
        set theme_base (dirname (status filename))/../themes
    end
    
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l R  (set_color red)
    set -l D  (set_color brblack)
    
    # Theme-Datei prüfen
    set -l theme_path "$theme_base/$name.fish"
    if test "$name" != "default"; and not test -f $theme_path
        echo $R"✖"$N" Theme nicht gefunden: "$B$name$N
        return 1
    end
    
    # Aktuelle Werte sichern
    set -l _old_primary   $theme_primary
    set -l _old_success   $theme_success
    set -l _old_warning   $theme_warning
    set -l _old_error     $theme_error
    set -l _old_accent    $theme_accent
    set -l _old_muted     $theme_muted
    set -l _old_name      $theme_name
    
    # Theme temporär laden
    if test "$name" = "default"
        __theme_set_defaults
    else
        source $theme_path
    end
    
    echo
    echo $B"🎨 Preview: $name"$N
    echo $D"─────────────────────────────────"$N
    echo
    
    # Farbpalette anzeigen
    printf "   %-12s %s████████████████%s\n" "Primary:"   (set_color $theme_primary)   $N
    printf "   %-12s %s████████████████%s\n" "Success:"   (set_color $theme_success)   $N
    printf "   %-12s %s████████████████%s\n" "Warning:"   (set_color $theme_warning)   $N
    printf "   %-12s %s████████████████%s\n" "Error:"     (set_color $theme_error)     $N
    printf "   %-12s %s████████████████%s\n" "Accent:"    (set_color $theme_accent)    $N
    printf "   %-12s %s████████████████%s\n" "Muted:"     (set_color $theme_muted)     $N
    
    echo
    echo $B"   Beispiel-Ausgaben:"$N
    set -l P (set_color $theme_primary)
    set -l G (set_color $theme_success)
    set -l Y (set_color $theme_warning)
    set -l R (set_color $theme_error)
    echo "   "$P"ℹ"$N" Dies ist eine Info-Nachricht"
    echo "   "$G"✔"$N" Dies ist eine Erfolgs-Nachricht"
    echo "   "$Y"⚠"$N" Dies ist eine Warnung"
    echo "   "$R"✖"$N" Dies ist ein Fehler"
    echo
    
    echo $D"   Aktivieren: theme $name"$N
    echo
    
    # Alte Werte wiederherstellen
    set -g theme_primary   $_old_primary
    set -g theme_success   $_old_success
    set -g theme_warning   $_old_warning
    set -g theme_error     $_old_error
    set -g theme_accent    $_old_accent
    set -g theme_muted     $_old_muted
    set -g theme_name      $_old_name
end

function __theme_reset --description "Setzt Theme auf Default zurück"
    set -l theme_file ~/.config/fish/.active_theme
    
    set -l G  (set_color green)
    set -l N  (set_color normal)
    set -l B  (set_color --bold)
    set -l Y  (set_color yellow)
    
    rm -f $theme_file
    set -e FISH_THEME
    __theme_set_defaults
    
    echo $G"✔"$N" Theme zurückgesetzt auf "$B"default"$N
    echo $Y"ℹ"$N" Neue Shell starten für vollständige Anwendung"
end

function __theme_reload --description "Lädt aktuelles Theme neu"
    set -l G  (set_color green)
    set -l N  (set_color normal)
    set -l B  (set_color --bold)
    
    __theme_load
    echo $G"✔"$N" Theme neu geladen: "$B$theme_name$N
end

function __theme_help --description "Zeigt Hilfe"
    set -l B  (set_color --bold)
    set -l N  (set_color normal)
    set -l C  (set_color cyan)
    set -l D  (set_color brblack)
    set -l Y  (set_color yellow)
    
    echo
    echo $B"🎨 Fish Theme Manager"$N
    echo $D"─────────────────────────────────"$N
    echo
    echo $B"Befehle:"$N
    echo "   "$C"theme"$N"                 Zeigt aktuelles Theme"
    echo "   "$C"theme list"$N"            Listet verfügbare Themes"
    echo "   "$C"theme <name>"$N"          Aktiviert Theme"
    echo "   "$C"theme set <name>"$N"      Aktiviert Theme (explizit)"
    echo "   "$C"theme preview <name>"$N"  Vorschau ohne Aktivierung"
    echo "   "$C"theme reset"$N"           Zurück zum Default-Theme"
    echo "   "$C"theme reload"$N"          Lädt aktuelles Theme neu"
    echo "   "$C"theme help"$N"            Diese Hilfe"
    echo
    echo $B"Theme-Variablen:"$N
    echo "   "$Y"theme_primary"$N"         Hauptfarbe (cyan)"
    echo "   "$Y"theme_secondary"$N"       Sekundärfarbe (blue)"
    echo "   "$Y"theme_success"$N"         Erfolg/OK (green)"
    echo "   "$Y"theme_warning"$N"         Warnung (yellow)"
    echo "   "$Y"theme_error"$N"           Fehler (red)"
    echo "   "$Y"theme_accent"$N"          Akzent (magenta)"
    echo "   "$Y"theme_muted"$N"           Gedämpft (brblack)"
    echo
    echo $B"Theme-Pfad:"$N
    echo "   "$D"/mr-bytez/shared/usr/local/share/fish/themes/"$N
    echo
end
