# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Configuration Loader                                         ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/conf.d/000-loader.fish                        ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.5.0                                                         ║
# ║  Erstellt:    2026-01-26                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       Laedt Shared + Host-spezifische Configs (einschleifig)       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Nummerierungsschema:
#   000-099  Shared (alle Hosts)
#            conf.d:    005-theme, 008-host-flags
#            aliases:   010-nav, 015-eza, ..., 050-gui, 055-dev
#            variables: 010-paths
#   100-200  Host-spezifisch
#            aliases:   110-n8-*.fish
#
# Lade-Reihenfolge (eine Schleife, 6 Verzeichnisse):
#   Shared conf.d → Shared aliases → Shared variables →
#   Host conf.d   → Host aliases   → Host variables
#
# Innerhalb jedes Verzeichnisses: Glob sortiert numerisch (zero-padded).
# Shared (005-099) laedt immer VOR Host (100-200).
#
# Debug-Modus:
#   set -g FISH_LOADER_DEBUG 1   → Zeigt geladene Dateien
#
# ══════════════════════════════════════════════════════════════════════════════

# ── Pfade ermitteln (mit realpath fuer Symlinks!) ─────────────────────────
set -l shared_base (dirname (realpath (status filename)))/..
set -l host_base /mr-bytez/projects/infrastructure/(hostname)/root/home/(whoami)/.config/fish

# ── Debug-Helper ─────────────────────────────────────────────────────────
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
# Einschleifiges Laden: Shared (000-099) → Host (100-200)
# ══════════════════════════════════════════════════════════════════════════════
#
# 6 Verzeichnisse in fester Reihenfolge:
#   1. Shared conf.d    (005-theme, 008-host-flags)
#   2. Shared aliases   (010-055)
#   3. Shared variables (010-paths)
#   4. Host conf.d      (zukunftssicher, aktuell leer)
#   5. Host aliases     (110-n8-*.fish)
#   6. Host variables   (zukunftssicher, aktuell leer)

set -l source_dirs \
    $shared_base/conf.d \
    $shared_base/aliases \
    $shared_base/variables \
    $host_base/conf.d \
    $host_base/aliases \
    $host_base/variables

for dir in $source_dirs
    if test -d $dir
        for f in $dir/*.fish
            if test -f $f; and test (basename $f) != "000-loader.fish"
                __loader_debug (basename $f)
                source $f
            end
        end
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# Functions (fish_function_path — keine Nummerierung)
# ══════════════════════════════════════════════════════════════════════════════

# Shared Functions (Prompt, Helpers, mr-bytez-info)
if test -d $shared_base/functions
    if not contains $shared_base/functions $fish_function_path
        set -gp fish_function_path $shared_base/functions
        __loader_debug "Function-Pfad (shared): $shared_base/functions"
    end
end

# Host Functions (Vorrang vor shared)
if test -d $host_base/functions
    if not contains $host_base/functions $fish_function_path
        set -gp fish_function_path $host_base/functions
        __loader_debug "Function-Pfad (host): $host_base/functions"
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# Aufraeumen + Done
# ══════════════════════════════════════════════════════════════════════════════

functions -e __loader_debug

if set -q FISH_LOADER_DEBUG; and test "$FISH_LOADER_DEBUG" = "1"
    set -l G (set_color green)
    set -l N (set_color normal)
    echo $G"✔"$N" mr-bytez Fish-Config geladen (einschleifig, Shared + Host)" >&2
end
