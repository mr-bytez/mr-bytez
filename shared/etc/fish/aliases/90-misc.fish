# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Misc                                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/aliases/90-misc.fish       ║
# ║  Autor:    MR-ByteZ                                                          ║
# ║  Version:     0.3.1                                                          ║
# ║  Erstellt:    2026-01-25                                                     ║
# ║  Aktualisiert:2026-02-28                                                     ║
# ║  Zweck:    Diverse Komfort-Wraps und System-Shortcuts                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 💾 SPEICHER & FESTPLATTEN
# ══════════════════════════════════════════════════════════════════════════════

# ── duf: Moderne Festplatten-Anzeige ─────────────────────────────────────────
#  -hide loops,binds = versteckt unwichtige Mounts (cleaner!)
#  Original df bleibt unveraendert (coreutils)
alias duf='command duf -hide loops,binds'

# ── dust: Moderne Ordner-Groesse ────────────────────────────────────────────
#  -r = reverse (groesste oben)
#  Original du bleibt unveraendert (coreutils)
alias dust='command dust -r'

# ── dus: Ordner-Größe mit Summe ──────────────────────────────────────────────
#  Beispiel: dus /var/log/*
alias dus='command du -hsc'


# ══════════════════════════════════════════════════════════════════════════════
# 🎨 FARBIGE AUSGABEN
# ══════════════════════════════════════════════════════════════════════════════

# ── diff: Farbiger Datei-Vergleich ───────────────────────────────────────────
alias diff='diff --color=auto'

# ── ip: Farbige Netzwerk-Infos ───────────────────────────────────────────────
alias ip='ip -c'

# ── less: Farben durchreichen (für Pipes) ────────────────────────────────────
alias less='less -R'

# ── bcat: Syntax-Highlighting (bat) ──────────────────────────────────────────
# Original cat bleibt unveraendert (coreutils)
alias bcat='bat --paging=never --style=numbers --theme="gruvbox-dark" --tabs=4 --wrap=never --color=auto'
alias bcatn='bat --paging=auto --style=numbers --theme="gruvbox-dark" --tabs=4 --wrap=never --color=auto'

# ══════════════════════════════════════════════════════════════════════════════
# 🔎 SUCHEN
# ══════════════════════════════════════════════════════════════════════════════

# grep: KEIN Alias — bleibt unveraenderte coreutils
# Fuer moderne Suche: rg (ripgrep) direkt verwenden

# ══════════════════════════════════════════════════════════════════════════════
# 📊 SYSTEM-MONITORING
# ══════════════════════════════════════════════════════════════════════════════

# top: htop als Ersatz für top
function top --description "Interaktiver Prozessmonitor (htop)"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " top: 📊 starte htop"
    end
    command htop
end

# cpu: CPU-Infos
function cpu --description "CPU-Infos (lscpu)"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " cpu: 🧠 CPU-Infos (lscpu)"
    end
    command lscpu
end

# mem: RAM-/Swap-Nutzung
function mem --description "RAM-/Swap-Nutzung (free -h)"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " mem: 🧪 RAM-/Swap-Nutzung (free -h)"
    end
    command free -h
end

# ══════════════════════════════════════════════════════════════════════════════
# ✏️ EDITOREN
# ══════════════════════════════════════════════════════════════════════════════

# e: micro editor
function e --description "Editor: micro"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " e: ✏️  starte micro"
    end
    command micro $argv
end

# v: vim editor
function v --description "Editor: vim"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " v: ✏️  starte vim"
    end
    command vim $argv
end

# ══════════════════════════════════════════════════════════════════════════════
# 🔧 SONSTIGES
# ══════════════════════════════════════════════════════════════════════════════

# path: Zeigt $PATH übersichtlich (eine Zeile pro Eintrag)
function path --description "Zeigt PATH übersichtlich"
    string split : $PATH
end

# reload: Fish-Config neu laden
function reload --description "Fish-Config neu laden"
    exec fish
    set_color green; echo "✅ Fish-Config neu geladen"; set_color normal
end
