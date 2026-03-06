# Handoff: mrbz_aud Phase 2+3 Test

**Erstellt:** 2026-03-06
**Kontext:** mrbz_aud Docs-Audit-Bot Entwicklung (Projekt A7)
**Letzter Commit:** `47f6bcb` — Bot komplett erstellt + Phase 1 getestet

---

## Was wurde erledigt

### Bot komplett gebaut
- 3-Phasen-Pipeline: Audit (8 Module) → Verifikation → Fix/Worker
- 3 Agent-Prompts mit Read-Only Hooks und Secrets-Schutz
- Fish-Orchestrator-Script fuer Pipeline-Steuerung
- Bot-README mit Dokumentation
- Alle Dateien unter `.claude/agents/bot/mrbz_aud/`

### Phase 1 — Alle 8 Module einzeln getestet
- Modul 01-08 in separaten Claude Code Tasks getestet
- 51 Findings gesamt (1 KRITISCH, 23 MITTEL, 26 INFO, 1 NEEDS_REVIEW)
- KRITISCH: ROADMAP Widerspruch public/privat (Done sagt "public", A5 sagt "privat")
- Secrets-Schutz eingehalten bei allen Modulen

### Docs-Stufen Policy erstellt
- In `.claude/context/structure.md` verankert
- Voll-5-5-3 (5 Docs): n8-vps, n8-kiste, n8-station, fish, hwi
- Minimal (2 Docs: README + CHANGELOG): n8-book, n8-bookchen, n8-broker, n8-maxx, n8-archstick

### Orchestrator-Bugs gefixt
- **CLAUDECODE Nesting-Guard:** `env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT` vor jedem claude-Aufruf
- **Terminal SIGTTIN:** `< /dev/null` an jeden claude-Aufruf (verhindert Tl-Status)
- Beide Fixes sind im Orchestrator eingebaut aber NOCH NICHT COMMITTED

### Modul-Definitionen iterativ verbessert
- Modul 01: Konkrete Befehle vorgeben (2 find-Kommandos statt freies Improvisieren)
- Modul 01: projects/web/ komplett ausgeschlossen, reports/ ausgeschlossen
- Modul 02: Docs-Stufen (Voll vs. Minimal) mit Severity-Differenzierung
- Modul 02: CLAUDE.md Platzierung klargestellt (Projekt-Root)

---

## Was laeuft gerade

### Orchestrator End-to-End Test (Phase 1 + 2)
- Gestartet um 11:12 Uhr am 2026-03-06
- Laeuft in separatem Terminal auf n8-kiste
- Module 01-04 fertig, Modul 05+ laeuft
- Reports landen in `.claude/agents/bot/mrbz_aud/reports/`
- Logs in `.claude/agents/bot/mrbz_aud/logs/mrbz_aud-2026-03-06.log`

**Status pruefen:**
```fish
ls .claude/agents/bot/mrbz_aud/reports/*.md
ps aux | grep "claude -p" | grep -v grep
command cat .claude/agents/bot/mrbz_aud/logs/mrbz_aud-2026-03-06.log | tail -20
```

---

## Was noch zu tun ist

### Erledigt (2026-03-06)
1. ✅ Pipeline-Ergebnis geprueft: Alle 9 Reports vorhanden (01-08 + 09 Gesamt)
2. ✅ Gesamt-Report gelesen: 58 Findings (0 KRITISCH, 20 MITTEL, 32 INFO, 6 NEEDS_REVIEW)
3. ✅ NEEDS_REVIEW Entscheidungen getroffen (im Chat mit Claude AI verglichen)
4. ✅ NEEDS_REVIEW umgesetzt: Docs-Stufen, Header-Formate, Pfade, CHANGELOG-Releases, ROADMAP ETA
5. ⬜ Orchestrator-Fixes committen (im selben Commit wie NEEDS_REVIEW)

### Phase 3 manuell testen
```fish
cd /mr-bytez; env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT claude -p \
    --agent .claude/agents/bot/mrbz_aud/mrbz_aud-agent_fix.md \
    --dangerously-skip-permissions \
    "Arbeite den Gesamt-Report ab" < /dev/null
```
- Pruefe ob Fix-Agent korrekt committed
- Pruefe ob Reports am Ende aufgeraeumt werden
- Pruefe ob CHANGELOG/ROADMAP aktualisiert werden

### Cron aktivieren (erst nach stabilen Laeufen)
```fish
# In crontab:
# 0 3 * * 1 cd /mr-bytez && fish .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
```

---

## Uncommitted Changes

```
geaendert: .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
  - env -u CLAUDECODE -u CLAUDE_CODE_ENTRYPOINT (Nesting-Guard Fix)
  - < /dev/null (stdin Fix, verhindert SIGTTIN)
  - Kommentare mit Referenz auf GitHub Issue #25434
```

---

## Wichtige Erkenntnisse (Referenz)

→ Memory: `/home/mrohwer/.claude/projects/-mr-bytez/memory/mrbz_aud-erkenntnisse.md`

Kurzfassung:
- `claude -p` aus Scripts braucht `env -u CLAUDECODE` + `< /dev/null`
- Modul-Definitionen muessen konkrete Befehle vorgeben (sonst improvisiert der Agent)
- projects/web/ immer ausschliessen (2500+ irrelevante Framework-Dateien)
- `--dangerously-skip-permissions` ueberspringt auch globale Hooks — Sicherheit nur durch Agent-Hooks

---

## Dateien-Uebersicht

```
.claude/agents/bot/mrbz_aud/
├── mrbz_aud-README.md              # Bot-Dokumentation
├── mrbz_aud-agent_audit.md         # Phase 1 Agent (Read-Only, 8 Module)
├── mrbz_aud-agent_verify.md        # Phase 2 Agent (Konsolidierung)
├── mrbz_aud-agent_fix.md           # Phase 3 Agent (Fixes + Commit)
├── mrbz_aud-orchestrator.fish      # Pipeline-Steuerung (UNCOMMITTED FIXES!)
├── reports/                         # Temporaere Reports (werden nach Phase 3 geloescht)
└── logs/                            # Bot-Logs
```
