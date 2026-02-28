# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Configuration Loader                                         ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/conf.d/000-loader.fish                        ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.3.1                                                         ║
# ║  Erstellt:    2026-01-26                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       Laedt Shared + Host-spezifische Configs nach Nummerierung    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Lade-Reihenfolge (Nummer = Priorität, höher überschreibt):
#   00-09  Theme + Basis (nur shared)
#   10-69  Shared DANN Host (aliases, variables)
#   70-79  Host Kategorie (Desktop/Server) - conf.d, aliases, variables
#   80-199 Host-spezifisch (Overrides) - conf.d, aliases, variables (temporaer, Phase 4)
#   90-99  User-Tweaks (shared + host)
#
# Debug-Modus:
#   set -g FISH_LOADER_DEBUG 1   → Zeigt geladene Dateien
#
# ══════════════════════════════════════════════════════════════════════════════

# ── Pfade ermitteln (mit realpath für Symlinks!) ─────────────────────────────
set -l shared_base (dirname (realpath (status filename)))/..
set -l host_base /mr-bytez/projects/infrastructure/(hostname)/root/home/(whoami)/.config/fish

# ── Debug-Helper ─────────────────────────────────────────────────────────────
function __loader_debug --argument msg
    if set -q FISH_LOADER_DEBUG; and test "$FISH_LOADER_DEBUG" = "1"
        set -l D (set_color brblack)
        set -l N (set_color normal)
        echo $D"[loader] $msg"$N >&2
    end
end

__loader_debug "Shared-Pfad: $shared_base"
__loader_debug "Host-Pfad: $host_base"

# ══════════════════════════════════════════════════════════════════════════════
# 1⃣  THEME-SYSTEM LADEN (00-09)
# ══════════════════════════════════════════════════════════════════════════════

set -l theme_file $shared_base/conf.d/005-theme.fish
if test -f $theme_file
    __loader_debug "Theme laden: 005-theme.fish"
    source $theme_file
end

# ══════════════════════════════════════════════════════════════════════════════
# 1.5⃣  HOST-FLAGS LADEN (008)
# ══════════════════════════════════════════════════════════════════════════════
# Muss VOR Aliases/Conditionals laden (008 < 050/055)

set -l flags_file $shared_base/conf.d/008-host-flags.fish
if test -f $flags_file
    __loader_debug "Host-Flags laden: 008-host-flags.fish"
    source $flags_file
end

# ══════════════════════════════════════════════════════════════════════════════
# 2⃣  SHARED ALIASES LADEN (10-69)
# ══════════════════════════════════════════════════════════════════════════════

if test -d $shared_base/aliases
    for f in $shared_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 10; and test $num -lt 70
                __loader_debug "Shared Alias: "(basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 3⃣  SHARED VARIABLES LADEN (10-69)
# ══════════════════════════════════════════════════════════════════════════════

if test -d $shared_base/variables
    for f in $shared_base/variables/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 10; and test $num -lt 70
                __loader_debug "Shared Variable: "(basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 4⃣  HOST ALIASES + VARIABLES LADEN (10-69) - Ergänzend zu Shared
# ══════════════════════════════════════════════════════════════════════════════

if test -d $host_base/aliases
    for f in $host_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 10; and test $num -lt 70
                __loader_debug "Host Alias (10-69): "(basename $f)
                source $f
            end
        end
    end
end

if test -d $host_base/variables
    for f in $host_base/variables/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 10; and test $num -lt 70
                __loader_debug "Host Variable (10-69): "(basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 5⃣  SHARED FUNCTIONS (fish_function_path)
# ══════════════════════════════════════════════════════════════════════════════

if test -d $shared_base/functions
    if not contains $shared_base/functions $fish_function_path
        set -gp fish_function_path $shared_base/functions
        __loader_debug "Function-Pfad (shared): $shared_base/functions"
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 6⃣  HOST KATEGORIE LADEN (70-79) - Desktop/Server
# ══════════════════════════════════════════════════════════════════════════════

# Host conf.d (70-79)
if test -d $host_base/conf.d
    for f in $host_base/conf.d/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 70; and test $num -lt 80
                __loader_debug "Host Kategorie conf.d: "(basename $f)
                source $f
            end
        end
    end
end

# Host aliases (70-79)
if test -d $host_base/aliases
    for f in $host_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 70; and test $num -lt 80
                __loader_debug "Host Kategorie alias: "(basename $f)
                source $f
            end
        end
    end
end

# Host variables (70-79)
if test -d $host_base/variables
    for f in $host_base/variables/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 70; and test $num -lt 80
                __loader_debug "Host Kategorie variable: "(basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 7⃣  HOST-SPEZIFISCH LADEN (80-199)
# HINWEIS: Temporaer auf 80-199 erweitert (Phase 3), wird in Phase 4 ersetzt
# ══════════════════════════════════════════════════════════════════════════════

# Host conf.d (80-199)
if test -d $host_base/conf.d
    for f in $host_base/conf.d/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 80; and test $num -lt 200
                __loader_debug "Host Config: "(basename $f)
                source $f
            end
        end
    end
end

# Host aliases (80-199)
if test -d $host_base/aliases
    for f in $host_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 80; and test $num -lt 200
                __loader_debug "Host Alias: "(basename $f)
                source $f
            end
        end
    end
end

# Host variables (80-199)
if test -d $host_base/variables
    for f in $host_base/variables/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 80; and test $num -lt 200
                __loader_debug "Host Variable: "(basename $f)
                source $f
            end
        end
    end
end

# Host functions (Vorrang vor shared)
if test -d $host_base/functions
    if not contains $host_base/functions $fish_function_path
        set -gp fish_function_path $host_base/functions
        __loader_debug "Function-Pfad (host): $host_base/functions"
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 8⃣  USER-TWEAKS LADEN (90-99) - Optional
# ══════════════════════════════════════════════════════════════════════════════

# Shared aliases 90-99 (z.B. 90-misc.fish)
if test -d $shared_base/aliases
    for f in $shared_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 90
                __loader_debug "Shared Misc: "(basename $f)
                source $f
            end
        end
    end
end

# Host conf.d 90-99
if test -d $host_base/conf.d
    for f in $host_base/conf.d/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 90
                __loader_debug "Host Misc: "(basename $f)
                source $f
            end
        end
    end
end

# Host aliases 90-99
if test -d $host_base/aliases
    for f in $host_base/aliases/*.fish
        if test -f $f
            set -l num (string match -r '^\d+' (basename $f))
            if test -n "$num"; and test $num -ge 90
                __loader_debug "Host Alias (90+): "(basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# 🧹 AUFRÄUMEN
# ══════════════════════════════════════════════════════════════════════════════

functions -e __loader_debug

# ══════════════════════════════════════════════════════════════════════════════
# ✅ LOADER ABGESCHLOSSEN
# ══════════════════════════════════════════════════════════════════════════════

if set -q FISH_LOADER_DEBUG; and test "$FISH_LOADER_DEBUG" = "1"
    set -l G (set_color green)
    set -l N (set_color normal)
    echo $G"✔"$N" mr-bytez Fish-Config v2.1 geladen (Shared + Host)" >&2
end
