# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Systemd & Journalctl                                ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/aliases/50-systemd.fish    ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  2.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Geändert: 2026-01-27                                                        ║
# ║  Zweck:    Komfort-Aliase für Systemd, Journalctl & Service-Management      ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Hinweise:
# - Service-Aliase beginnen mit 's' (sstart, sstop, sstatus, ...)
# - Boot-Aliase beginnen mit 'b' (blog, blast, blist, ...)
# - Für ältere Boots nutze die Indexe aus `blist`. Negative Werte zählen rückwärts
# - Viele Befehle verwenden `sudo`, da Kernel-/System-Logs Root erfordern

# ══════════════════════════════════════════════════════════════════════════════
# 🔧 SERVICE-MANAGEMENT
# ══════════════════════════════════════════════════════════════════════════════

# ── Basis-Befehle ────────────────────────────────────────────────────────────
alias sstart='sudo systemctl start'
alias sstop='sudo systemctl stop'
alias srestart='sudo systemctl restart'
alias sreload='sudo systemctl reload'
alias sstatus='systemctl status'

# ── Aktivierung ──────────────────────────────────────────────────────────────
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias smask='sudo systemctl mask'
alias sunmask='sudo systemctl unmask'

# ── Daemon-Reload (nach Unit-Datei-Änderungen) ───────────────────────────────
alias sdreload='sudo systemctl daemon-reload'

# ══════════════════════════════════════════════════════════════════════════════
# 📋 SERVICE-LOGS
# ══════════════════════════════════════════════════════════════════════════════

# ── Follow Logs für Service (Beispiel: slog nginx) ───────────────────────────
alias slog='journalctl -fu'

# ── Logs seit Boot für Service ───────────────────────────────────────────────
alias slogb='journalctl -b -u'

# ── Logs mit Zeitfilter (letzte Stunde) ──────────────────────────────────────
alias slog1h='journalctl --since "1 hour ago" -u'

# ══════════════════════════════════════════════════════════════════════════════
# 🔍 TROUBLESHOOTING
# ══════════════════════════════════════════════════════════════════════════════

# ── Failed Units anzeigen ────────────────────────────────────────────────────
alias sfailed='systemctl --failed'

# ── Alle Services auflisten ──────────────────────────────────────────────────
alias slist='systemctl list-units --type=service'

# ── Nur aktive Services ──────────────────────────────────────────────────────
alias slistrun='systemctl list-units --type=service --state=running'

# ── Timer auflisten ──────────────────────────────────────────────────────────
alias stimers='systemctl list-timers --all'

# ── Unit-Datei anzeigen ──────────────────────────────────────────────────────
alias scat='systemctl cat'

# ── Unit-Dependencies ────────────────────────────────────────────────────────
alias sdeps='systemctl list-dependencies'

# ══════════════════════════════════════════════════════════════════════════════
# 📋 BOOT-LISTE
# ══════════════════════════════════════════════════════════════════════════════

# ── Liste aller Boots mit Index und Zeit ─────────────────────────────────────
alias blist='sudo journalctl --list-boots'

# ══════════════════════════════════════════════════════════════════════════════
# 🔴 ERROR-LOGS
# ══════════════════════════════════════════════════════════════════════════════

# ── Aktueller Boot: nur Errors (err+) ────────────────────────────────────────
alias blog='sudo journalctl -b -p err --no-pager'

# ── Letzter Boot: nur Errors ─────────────────────────────────────────────────
alias blast='sudo journalctl -b -1 -p err --no-pager'

# ── Aktueller Boot: Warnings + höher ─────────────────────────────────────────
alias bwarn='sudo journalctl -b -p warning --no-pager'

# ══════════════════════════════════════════════════════════════════════════════
# 📜 VOLLSTÄNDIGE LOGS
# ══════════════════════════════════════════════════════════════════════════════

# ── Aktueller Boot: vollständiges Log (alle Prioritäten) ─────────────────────
alias bfull='sudo journalctl -b --no-pager'

# ── Kernel-Logs (dmesg-Ersatz) ───────────────────────────────────────────────
alias bkernel='sudo journalctl -b -k --no-pager'

# ══════════════════════════════════════════════════════════════════════════════
# 📺 LIVE-STREAM
# ══════════════════════════════════════════════════════════════════════════════

# ── Live-Stream: Warnungen+höher (ab warning) ────────────────────────────────
alias blive='sudo journalctl -f -p warning'

# ── Live-Stream: Alles ───────────────────────────────────────────────────────
alias bliveall='sudo journalctl -f'

# ══════════════════════════════════════════════════════════════════════════════
# 🔄 MULTI-BOOT ANALYSE
# ══════════════════════════════════════════════════════════════════════════════

# ── Errors der letzten N Boots zusammenfassen (Default: 5) ───────────────────
# Aufruf: `ball` oder `ball 10`
function ball --description 'Zeige Errors der letzten N Boots (Default 5)'
    set -l n 5
    if test (count $argv) -ge 1
        set n $argv[1]
    end

    for i in (seq -$n 0)
        echo
        set_color --bold cyan
        echo "===== BOOT $i ====="
        set_color normal
        sudo journalctl -b $i -p err --no-pager
    end
end

# ══════════════════════════════════════════════════════════════════════════════
# ⚡ SYSTEM-POWER
# ══════════════════════════════════════════════════════════════════════════════

alias reboot='sudo systemctl reboot'
alias poweroff='sudo systemctl poweroff'
alias suspend='sudo systemctl suspend'
alias hibernate='sudo systemctl hibernate'

# ══════════════════════════════════════════════════════════════════════════════
# 📖 QUICK-REFERENCE (als Kommentar)
# ══════════════════════════════════════════════════════════════════════════════
#
# SERVICE-MANAGEMENT:
#   sstart nginx     → Service starten
#   sstop nginx      → Service stoppen
#   srestart nginx   → Service neustarten
#   sreload nginx    → Service Config neu laden (ohne Neustart)
#   sstatus nginx    → Status anzeigen
#   senable nginx    → Autostart aktivieren
#   sdisable nginx   → Autostart deaktivieren
#   smask nginx      → Service komplett sperren
#   sunmask nginx    → Sperre aufheben
#   sdreload         → Daemon-Reload (nach Unit-Änderungen!)
#
# SERVICE-LOGS:
#   slog nginx       → Logs live folgen (tail -f Style)
#   slogb nginx      → Logs seit Boot
#   slog1h nginx     → Logs letzte Stunde
#
# TROUBLESHOOTING:
#   sfailed          → Zeige kaputte Services
#   slist            → Alle Services auflisten
#   slistrun         → Nur laufende Services
#   stimers          → Alle Timer anzeigen
#   scat nginx       → Unit-Datei anzeigen
#   sdeps nginx      → Dependencies anzeigen
#
# BOOT-ANALYSE:
#   blist            → Alle Boots auflisten
#   blog             → Errors aktueller Boot
#   blast            → Errors letzter Boot
#   bwarn            → Warnings aktueller Boot
#   bfull            → Komplettes Log aktueller Boot
#   bkernel          → Kernel-Logs (wie dmesg)
#   blive            → Live-Stream (Warnings+)
#   bliveall         → Live-Stream (alles)
#   ball             → Errors der letzten 5 Boots
#   ball 10          → Errors der letzten 10 Boots
#
# SYSTEM-POWER:
#   reboot           → Neustart
#   poweroff         → Herunterfahren
#   suspend          → Standby
#   hibernate        → Ruhezustand
