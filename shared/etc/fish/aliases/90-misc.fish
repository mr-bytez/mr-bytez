# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Misc                                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/aliases/90-misc.fish       ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Zweck:    Diverse Komfort-Wraps und System-Shortcuts                       ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 💾 SPEICHER & FESTPLATTEN
# ══════════════════════════════════════════════════════════════════════════════

# ── df: Moderne Festplatten-Anzeige (duf) ────────────────────────────────────
#  -hide loops,binds = versteckt unwichtige Mounts (cleaner!)
#  Original erreichbar via: command df -h
alias df='duf -hide loops,binds'

# ── du: Moderne Ordner-Größe (dust) ──────────────────────────────────────────
#  -r = reverse (größte oben), -d 3 = max 3 Ebenen tief
#  Original erreichbar via: command du -h
alias du='dust -r'

# ── dus: Ordner-Größe mit Summe ──────────────────────────────────────────────
#  Beispiel: dus /var/log/*
alias dus='command du -hsc'

# ── duf: Moderne Festplatten-Anzeige (farbig) ────────────────────────────────
#  Falls installiert: install duf
# (kein Alias nötig, duf ist bereits perfekt)

# ══════════════════════════════════════════════════════════════════════════════
# 🎨 FARBIGE AUSGABEN
# ══════════════════════════════════════════════════════════════════════════════

# ── diff: Farbiger Datei-Vergleich ───────────────────────────────────────────
alias diff='diff --color=auto'

# ── ip: Farbige Netzwerk-Infos ───────────────────────────────────────────────
alias ip='ip -c'

# ── less: Farben durchreichen (für Pipes) ────────────────────────────────────
alias less='less -R'

# ── bat: Syntax-Highlighting für cat ─────────────────────────────────────────
alias cat='bat --paging=never --style=numbers --theme="gruvbox-dark" --tabs=4 --wrap=never --color=auto'
alias catn='cat --paging=auto' # Vollversion mit Zeilennummern & Paging

# ══════════════════════════════════════════════════════════════════════════════
# 🔎 SUCHEN
# ══════════════════════════════════════════════════════════════════════════════

# grep: farbiges Hervorheben
function grep --wraps=grep --description "grep farbig (--color=auto)"
    if set -q THEME_QUIET; or set -q MISC_SILENT
        # Silent mode
    else
        set_color cyan; echo -n "ℹ"; set_color normal
        echo " grep: 🔎 farbiges Hervorheben (--color=auto)"
    end
    command grep --color=auto $argv
end

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
