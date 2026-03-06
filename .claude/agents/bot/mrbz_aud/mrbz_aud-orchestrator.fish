#!/usr/bin/env fish
# ============================================
# mrbz_aud-orchestrator.fish — Pipeline-Steuerung fuer den Docs-Audit-Bot
# Pfad: .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
# Autor: MR-ByteZ
# Erstellt: 2026-03-06
# Version: 0.1.0
# Zweck: Fuehrt Phase 1 (8 Module) und Phase 2 (Verifikation) nacheinander aus.
#         Phase 3 (Fix) wird NICHT automatisch gestartet — manueller Trigger.
# ============================================

# --- Konfiguration ---
set -l REPO_DIR /mr-bytez
set -l BOT_DIR $REPO_DIR/.claude/agents/bot/mrbz_aud
set -l REPORTS_DIR $BOT_DIR/reports
set -l LOGS_DIR $BOT_DIR/logs
set -l AUDIT_AGENT $BOT_DIR/mrbz_aud-agent_audit.md
set -l VERIFY_AGENT $BOT_DIR/mrbz_aud-agent_verify.md
set -l MODULE_TIMEOUT 1800
set -l TOTAL_TIMEOUT 18000
set -l DATE_STR (date +%Y-%m-%d)
set -l LOG_FILE $LOGS_DIR/mrbz_aud-$DATE_STR.log
set -l ERROR_LOG $LOGS_DIR/mrbz_aud-error-$DATE_STR.log

# --- Module ---
set -l MODULE_NAMES \
    "Modul 01: Struktur-Inventar" \
    "Modul 02: 5-5-3 Vollstaendigkeit" \
    "Modul 03: Header + Versionierung" \
    "Modul 04: ROADMAP/CHANGELOG Aktualitaet" \
    "Modul 05: Cross-References + Redundanz" \
    "Modul 06: Context inhaltlicher Abgleich" \
    "Modul 07: Secrets Struktur" \
    "Modul 08: Secrets Freshness"

# --- Funktionen ---

function log_msg
    set -l timestamp (date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $argv" | tee -a $LOG_FILE
end

function log_error
    set -l timestamp (date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] FEHLER: $argv" | tee -a $LOG_FILE >> $ERROR_LOG
end

# --- Voraussetzungen pruefen ---

# Claude Code Nesting-Guard umgehen: env CLAUDECODE= vor jedem claude-Aufruf
# (noetig weil der Orchestrator aus einer laufenden Claude Code Session gestartet werden kann)
# Siehe: https://github.com/anthropics/claude-code/issues/25434

if not command -q claude
    log_error "Claude Code CLI nicht gefunden! Abbruch."
    exit 1
end

if not test -d $REPO_DIR
    log_error "Repository $REPO_DIR nicht gefunden! Abbruch."
    exit 1
end

if not test -f $AUDIT_AGENT
    log_error "Audit-Agent $AUDIT_AGENT nicht gefunden! Abbruch."
    exit 1
end

if not test -f $VERIFY_AGENT
    log_error "Verify-Agent $VERIFY_AGENT nicht gefunden! Abbruch."
    exit 1
end

# --- Start ---

set -l pipeline_start (date +%s)
log_msg "=== mrbz_aud Pipeline gestartet ==="
log_msg "Repo: $REPO_DIR"
log_msg "Module: "(count $MODULE_NAMES)
log_msg "Modul-Timeout: $MODULE_TIMEOUT Sekunden"
log_msg "Gesamt-Timeout: $TOTAL_TIMEOUT Sekunden"

cd $REPO_DIR

# --- Phase 1: Audit-Module ---

log_msg "--- Phase 1: Audit (8 Module) ---"

for i in (seq 1 (count $MODULE_NAMES))
    set -l module_name $MODULE_NAMES[$i]
    set -l module_num (printf '%02d' $i)
    set -l module_start (date +%s)

    # Gesamt-Timeout pruefen
    set -l elapsed (math (date +%s) - $pipeline_start)
    if test $elapsed -ge $TOTAL_TIMEOUT
        log_error "Gesamt-Timeout ($TOTAL_TIMEOUT s) erreicht bei Modul $module_num! Abbruch."
        exit 1
    end

    log_msg "Starte $module_name ..."

    # Claude Code mit Agent und Timeout ausfuehren
    # env -u CLAUDECODE: Nesting-Guard umgehen (erlaubt Start aus Claude-Session heraus)
    # < /dev/null: stdin schliessen (verhindert Terminal-Zugriff → SIGTTIN/Tl-Status)
    timeout $MODULE_TIMEOUT env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT claude -p \
        --agent $AUDIT_AGENT \
        --dangerously-skip-permissions \
        "$module_name" \
        < /dev/null >> $LOG_FILE 2>&1

    set -l exit_code $status

    set -l module_elapsed (math (date +%s) - $module_start)
    set -l module_minutes (math "round($module_elapsed / 60)")

    if test $exit_code -ne 0
        if test $exit_code -eq 124
            log_error "$module_name: Timeout nach $MODULE_TIMEOUT Sekunden! Abbruch."
        else
            log_error "$module_name: Fehlgeschlagen (Exit-Code: $exit_code)! Abbruch."
        end
        exit 1
    end

    # Pruefen ob Report erstellt wurde
    set -l report_file $REPORTS_DIR/mrbz_aud-$module_num-*.md
    if not test -f $report_file[1] 2>/dev/null
        log_error "$module_name: Kein Report erstellt! Abbruch."
        exit 1
    end

    log_msg "$module_name abgeschlossen ($module_minutes Min)"
end

log_msg "--- Phase 1 abgeschlossen: Alle 8 Module erfolgreich ---"

# --- Phase 2: Verifikation ---

log_msg "--- Phase 2: Verifikation ---"

set -l verify_start (date +%s)

# Gesamt-Timeout pruefen
set -l elapsed (math (date +%s) - $pipeline_start)
if test $elapsed -ge $TOTAL_TIMEOUT
    log_error "Gesamt-Timeout ($TOTAL_TIMEOUT s) erreicht vor Phase 2! Abbruch."
    exit 1
end

timeout $MODULE_TIMEOUT env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT claude -p \
    --agent $VERIFY_AGENT \
    --dangerously-skip-permissions \
    "Konsolidiere alle 8 Modul-Reports zum Gesamt-Report" \
    < /dev/null >> $LOG_FILE 2>&1

set -l exit_code $status

set -l verify_elapsed (math (date +%s) - $verify_start)
set -l verify_minutes (math "round($verify_elapsed / 60)")

if test $exit_code -ne 0
    log_error "Phase 2 Verifikation fehlgeschlagen (Exit-Code: $exit_code)! Abbruch."
    exit 1
end

if not test -f $REPORTS_DIR/mrbz_aud-09-gesamt-report.md
    log_error "Phase 2: Gesamt-Report nicht erstellt! Abbruch."
    exit 1
end

log_msg "Phase 2 abgeschlossen ($verify_minutes Min)"

# --- Pipeline-Ende ---

set -l total_elapsed (math (date +%s) - $pipeline_start)
set -l total_minutes (math "round($total_elapsed / 60)")

log_msg "=== mrbz_aud Pipeline abgeschlossen ($total_minutes Min) ==="
log_msg "Gesamt-Report: $REPORTS_DIR/mrbz_aud-09-gesamt-report.md"
log_msg ""
log_msg "Phase 3 (Fix/Worker) manuell starten mit:"
log_msg "  claude -p --agent $BOT_DIR/mrbz_aud-agent_fix.md \"Arbeite den Gesamt-Report ab\""
log_msg ""
log_msg "Oder interaktiv:"
log_msg "  claude --agent $BOT_DIR/mrbz_aud-agent_fix.md"

# Cron-Eintrag (auskommentiert — erst aktivieren wenn Bot stabil laeuft):
# 0 3 * * 1 cd /mr-bytez && fish .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
