# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — mrbz_aud Docs-Audit-Bot                   │
# └─────────────────────────────────────────────────────────┘
Name:          mrbz_aud
Version:       0.1.0
Beschreibung:  Automatisierter Docs-Audit-Bot fuer das mr-bytez Repository
Autor:         MR-ByteZ
Erstellt:      2026-03-06
Aktualisiert:  2026-03-06

---

# mrbz_aud — Docs-Audit-Bot

Automatisierter Bot der das gesamte mr-bytez Repository auf
Dokumentations-Konsistenz, 5-5-3 Pattern-Konformitaet und
inhaltliche Aktualitaet prueft.

## Pipeline-Architektur

```
Phase 1: AUDIT (8 Module, je eigener Claude Code Aufruf)
  │
  ├── Modul 01: Struktur-Inventar
  ├── Modul 02: 5-5-3 Vollstaendigkeit
  ├── Modul 03: Header + Versionierung
  ├── Modul 04: ROADMAP/CHANGELOG Aktualitaet
  ├── Modul 05: Cross-References + Redundanz
  ├── Modul 06: Context inhaltlicher Abgleich
  ├── Modul 07: Secrets Struktur
  └── Modul 08: Secrets Freshness
  │
  ↓ schreibt Reports nach reports/
  │
Phase 2: VERIFIKATION (1 Aufruf)
  │
  ↓ konsolidiert zu reports/mrbz_aud-09-gesamt-report.md
  │
Phase 3: FIX/WORKER (1 Aufruf, manuell getriggert)
  │
  ↓ arbeitet Report ab, committed mit [BOT_AUD]
  ↓ raeumt alle temporaeren Dateien auf
```

## Module (Phase 1)

| Modul | Report-Datei | Scope |
|-------|-------------|-------|
| 01 | mrbz_aud-01-struktur-inventar.md | Alle .md/.txt/.info/.sh/.fish Dateien: Pfad, Typ, letztes Aenderungsdatum |
| 02 | mrbz_aud-02-5-5-3-vollstaendigkeit.md | Pro Ebene pruefen: Fehlen Docs? Alle 5 Docs + 5 Ordner vorhanden? |
| 03 | mrbz_aud-03-header-versionierung.md | Korrekter Header: Box-Header, SemVer, Erstellt/Aktualisiert-Datum |
| 04 | mrbz_aud-04-roadmap-changelog-aktualitaet.md | ROADMAP-Status vs. Realitaet, CHANGELOG-Konsistenz |
| 05 | mrbz_aud-05-cross-references-redundanz.md | Tote Links, redundante Inhalte, verwaiste Dateien |
| 06 | mrbz_aud-06-context-inhaltlicher-abgleich.md | Context-Dateien vs. aktuellem System-Status |
| 07 | mrbz_aud-07-secrets-struktur.md | Secrets-Repo Struktur (NUR listing, NIE Inhalte!) |
| 08 | mrbz_aud-08-secrets-freshness.md | Timestamp-Vergleich: entpackte vs. gepackte .age Dateien |

## Severity-Stufen

| Severity | Bedeutung |
|----------|-----------|
| KRITISCH | Sofort beheben — Sicherheitsrisiko oder Datenverlust |
| MITTEL | Sollte behoben werden — Inkonsistenz, fehlende Docs |
| INFO | Zur Kenntnis — Optimierungspotenzial |
| NEEDS_REVIEW | Bot kann nicht eigenstaendig entscheiden — menschliche Pruefung noetig |

## Dateien

```
.claude/agents/bot/mrbz_aud/
├── mrbz_aud-README.md              # Diese Datei
├── mrbz_aud-agent_audit.md         # Agent-Prompt Phase 1 (Read-Only Audit)
├── mrbz_aud-agent_verify.md        # Agent-Prompt Phase 2 (Verifikation)
├── mrbz_aud-agent_fix.md           # Agent-Prompt Phase 3 (Worker/Fix)
├── mrbz_aud-orchestrator.fish      # Fish-Script: Pipeline-Steuerung
├── reports/                         # Temporaere Modul-Reports (werden nach Phase 3 geloescht)
│   └── .gitkeep
└── logs/                            # Bot-Logs
    └── .gitkeep
```

## Ausfuehrung

### Manuell (einzelnes Modul)

```fish
# Phase 1 — Modul 01 ausfuehren
claude -p --agent .claude/agents/bot/mrbz_aud/mrbz_aud-agent_audit.md \
  "Modul 01: Struktur-Inventar"
```

### Manuell (komplette Pipeline Phase 1+2)

```fish
fish .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
```

### Manuell (Phase 3 — Fix/Worker)

```fish
claude -p --agent .claude/agents/bot/mrbz_aud/mrbz_aud-agent_fix.md \
  "Arbeite den Gesamt-Report ab"
```

### Cron (woechentlicher Nachtlauf)

```fish
# In crontab eintragen (auskommentiert bis Bot stabil laeuft):
# 0 3 * * 1 cd /mr-bytez && fish .claude/agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish
```

## Konfiguration

| Parameter | Default | Beschreibung |
|-----------|---------|-------------|
| MODULE_TIMEOUT | 1800 (30 Min) | Timeout pro Modul in Sekunden |
| TOTAL_TIMEOUT | 18000 (5 Std) | Gesamt-Timeout fuer Pipeline |
| REPORTS_DIR | reports/ | Ablage fuer Modul-Reports |
| LOGS_DIR | logs/ | Ablage fuer Bot-Logs |

## Fehlerbehandlung

- Bei Timeout eines Moduls: Fehlerbericht in `logs/`, Pipeline bricht ab
- Bei fehlendem Claude Code CLI: Sofortiger Abbruch mit Fehlermeldung
- Abgebrochener Lauf: Reports im `reports/` Ordner manuell loeschen, dann neu starten
- Phase 3 nur starten wenn `reports/mrbz_aud-09-gesamt-report.md` existiert

## Naming-Konvention

- Alle Dateien tragen `mrbz_aud-` Prefix
- Reports: `mrbz_aud-XX-name.md` (XX = Modulnummer 01-09)
- Logs: `mrbz_aud-YYYY-MM-DD.log` / `mrbz_aud-error-YYYY-MM-DD.log`
- Commits: `[BOT_AUD]` + thematische Tags aus `.claude/context/tags.md`

## Sicherheit

- Phase 1+2 Agents sind **Read-Only** (Hooks blockieren schreibende Operationen)
- `.secrets/` darf NUR gelistet werden (`find`, `ls`), NIEMALS `cat`/`read` auf Inhalte
- Phase 3 Agent darf schreiben, aber keine Secrets-Inhalte lesen
- Alle Agents respektieren die Source of Truth in `.claude/context/`
