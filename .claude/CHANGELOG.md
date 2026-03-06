# .claude/ Changelog

**Erstellt:** 2026-02-10
**Autor:** MR-ByteZ

---

## [Unreleased]

### Added
- `agents/bot/mrbz_aud/` — Kompletter Docs-Audit-Bot (Projekt A7):
  - `mrbz_aud-agent_audit.md` — Read-Only Audit-Agent (Phase 1, 8 Module)
  - `mrbz_aud-agent_verify.md` — Verifikations-Agent (Phase 2, Konsolidierung)
  - `mrbz_aud-agent_fix.md` — Fix/Worker-Agent (Phase 3, Fixes + Commit)
  - `mrbz_aud-orchestrator.fish` — Fish-Script fuer Pipeline-Steuerung
  - `mrbz_aud-README.md` — Bot-Dokumentation
  - `reports/` + `logs/` Verzeichnisse mit .gitkeep
  - Hooks: Secrets-Schutz, Read-Only Enforcement, Reports-Only Write

### Changed
- `context/structure.md` v0.5.0: Docs-Stufen erweitert auf 3 Stufen (Voll/Erweitert/Minimal), n8-kiste → Erweitert, n8-station → Minimal
- `context/documentation.md` v0.2.0: Mini-Header Format (6-Zeilen) + Schwellen-Regel (~30 Zeilen), Pfad-Konvention (relativ)
- `agents/manual/docs-agent.md`: Relative Pfade als Standard, Mini-Header Regel ergaenzt
- `agents/bot/mrbz_aud/reports/`: 9 Audit-Reports (Module 01-08 + Gesamt 09) + NEEDS_REVIEW Dokumente
- `agents/bot/mrbz_aud/mrbz_aud-orchestrator.fish`: Nesting-Guard + stdin-Fix
- Vorheriger Eintrag: `context/structure.md` Docs-Stufen Policy (Voll-5-5-3 vs. Minimal mit 2 Docs)
- `CLAUDE.md`: mrbz_aud Bot-Status auf "Bereit" aktualisiert, Beschreibung erweitert
- `context/handoffs/HANDOFF_[VPS][SEC]_crowdsec-traefik-authentik-deployment.md`:
  Forward-Auth Provider + Dashboard-Test + Secret-Key Bugfix + Stack-Haertung als erledigt markiert

## [0.6.0] - 2026-03-05

### Added
- `agents/manual/` — Unterordner fuer interaktive Einzeldatei-Agents (4 bestehende verschoben)
- `agents/bot/` — Unterordner fuer automatisierte Multi-File Bots (bereit fuer mrbz_aud)
- `context/tags.md`: [Bot] Tag (Index: BOT) mit Suffix-Konvention (_AUD, _FIX, _DEP), jetzt 68 Tags
- `context/webfetch-domains.md`: Source of Truth fuer WebFetch-Domains (56 Domains, kategorisiert)
- `settings.json`: Neue Datei (Team-weit, in Git) mit allen Permissions (allow/deny/ask, 64 WebFetch-Domains)

### Changed
- `context/webfetch-domains.md` v0.2.0: Status-Spalte, Sync-Pflicht-Kommentar, 10 neue Domains, Gesamt 64
- `settings.local.json`: Permissions-Block entfernt (migriert nach settings.json), nur noch Hooks + includeCoAuthoredBy
- `CLAUDE.md`: Agents-Sektion erweitert (manual/ + bot/ Tabellen, Bot-Uebersicht)
- `ROADMAP.md`: Phase 5 um Bot-Projekte A7/A8/A9 erweitert
- `context/structure.md`: agents/-Baum aktualisiert (manual/ + bot/ Unterordner)
- `context/claude-ai-projektanweisungen.txt`: Agents-Sektion + BOT-Tag-Konvention
- `README.md`: Agents-Baum aktualisiert
- `CLAUDE.md`: mrbz-dev aus "Aktive Projekte" entfernt (Placeholder geloescht)
- `context/policies.md`: CHANGELOG-Pflicht pro Ordner als Policy verankert (6 Orte)
- `hooks/pre-commit-docs-check.sh` v0.2.0: Dynamische CHANGELOG-Pruefung fuer alle Ordner
- 8 Dateien: Referenzen auf alte Agent-Pfade aktualisiert

### Versions-Korrektur
- Alle Versionen von 1.x/2.x auf 0.x.x korrigiert (Versionierungs-Policy: 1.0.0 erst nach 6 Monaten ohne Aenderung)

### Policy-Entscheidung
- `.claude/CHANGELOG.md` trackt ab sofort ALLE Aenderungen an `.claude/` — eigene Perspektive,
  kein 1:1 Copy vom Root-CHANGELOG. Fehlende Eintraege seit 2026-02-27 werden nicht nachgetragen,
  das erledigt der mrbz_aud Bot spaeter.

---

## [0.5.0] - 2026-02-27

### Added
- `hooks/` Ordner mit 7 Claude Code Event-Hooks:
  - `session-start-info.sh` — SessionStart: offene Handoffs + Git-Status
  - `secrets-guard.sh` — PreToolUse/Read: blockiert Secrets-Zugriff
  - `fish-syntax-guard.sh` — PreToolUse/Bash: blockiert Heredocs/EOF
  - `dual-push-reminder.sh` — PostToolUse/Bash: Codeberg-Push-Erinnerung
  - `pre-commit-docs-check.sh` — PreToolUse/Bash: CHANGELOG/ROADMAP im Staging
  - `handoff-lifecycle-check.sh` — PreToolUse/Bash: erledigte Handoffs bereinigt
  - `bash-command-logger.sh` — PreToolUse/Bash: Audit-Trail in .claude/logs/
- `agents/` Ordner mit 4 Claude Code Agents:
  - `docs-agent.md` — Dokumentation pflegen (5-5-3, Additive-Only, Tags)
  - `audit-agent.md` — Read-only Auditor (Bestandsaufnahmen, Reports)
  - `deploy-agent.md` — Deployment auf Hosts (Anker-System, Fish-first)
  - `scaffold-agent.md` — Neue Dateien mit korrektem Header/Banner erstellen

### Changed
- **5-3-3 → 5-5-3 Pattern:** 5 Docs, 5 Ordner (context, skills, hooks, agents, archive), 3 Ebenen
- `CLAUDE.md`: Hooks + Agents Uebersicht mit Tabellen, Verweise-Tabelle aktualisiert
- `context/structure.md` v0.5.0: Komplett auf 5-5-3 umgestellt
- `context/documentation.md`: 5-3-3 Referenzen → 5-5-3
- `context/claude-ai-projektanweisungen.txt`: 5-5-3, Hooks/Agents-Uebersicht ergaenzt

### Removed
- `configs/` Ordner geloescht (ungenutzt, Konfigurationen liegen in context/)
- `projects/sensitive-data-cleanup/` geloescht (A5 Placeholder, nie genutzt)

---

## [0.4.1] - 2026-02-11

### Added
- `context/handoffs/HANDOFF_[Secrets][Structure]_a1-secrets-repo-restrukturierung.md`

### Changed
- `context/claude-ai-projektanweisungen.txt`: C1+C2 erledigt, A1 aktuell

---

## [0.4.0] - 2026-02-11

### Changed
- `context/structure.md`: tasks/-Verweis entfernt, Typ 3 Community-Projekte,
  Wann-was-wohin erweitert
- `context/integration.md`: Context-Management + MCP Server Kandidaten
- `context/policies.md`: Delegation-Abschnitt bei Handoff-Policy
- `context/git.md`: CHANGELOG-Regel + Handoff-Bereinigung (VOR Commit) + Validierungs-Checkliste
- `context/policies.md`: Handoff-Lifecycle praezisiert (Bereinigung im selben Commit)
- `context/claude-ai-projektanweisungen.txt`: Beide neue Regeln ergaenzt
- `README.md`: Aktualisiert-Datum

### Removed
- `tasks/` Ordner komplett geloescht (redundant mit Handoff-System)

---

## [0.3.0] - 2026-02-10

### Added
- `.claude/CLAUDE.md` als zentrale Steuerung (ersetzt Root /init-Version)
- `.claude/CHANGELOG.md` (diese Datei)
- `.claude/ROADMAP.md` fuer .claude/-spezifische Planung
- 2 zusaetzliche context/ Dateien: `migration.md`, `structure.md`

### Changed
- `.claude/README.md` aktualisiert (neue Struktur, plans/ Referenz entfernt)
- Root `CLAUDE.md` entfernt (war von `/init`, gehoert nach `.claude/`)
- Root `README.md` aktualisiert (PROJECT_NOTES.md Referenz entfernt)
- Root `DEPLOYMENT.md` aktualisiert (PROJECT_NOTES.md Referenz entfernt)
- Root `CHANGELOG.md` mit Phase 2+3 Migration Eintrag ergaenzt
- Root `ROADMAP.md` Phase 2 Migration als erledigt markiert
- `.gitignore` erweitert (Sanitization-Patterns)

### Removed
- Root `CLAUDE.md` (war /init-Artefakt)

---

## [0.2.0] - 2026-02-10

### Added
- Neue Struktur implementiert (5-3-3 Pattern)
- `context/` mit 11 Dateien erstellt:
  - `policies.md`, `shell.md`, `security.md`, `git.md`
  - `docker.md`, `deployment.md`, `documentation.md`
  - `integration.md`, `infrastructure.md`
  - `migration.md`, `structure.md`
- `archive/`, `skills/`, `configs/` Ordner angelegt

### Changed
- `plans/` → `archive/` umbenannt
- `mrbz-dev-plan.md` → `archive/mrbz-dev-plan_2026-02-05.md`

### Removed
- `PROJECT_NOTES.md` (aufgeteilt in `context/`)
- `.gitignore.bak`

---

## [0.1.0] - 2026-02-04

### Added
- `.claude/` Verzeichnis erstellt
- `README.md` (Struktur-Uebersicht)
- `plans/` mit `mrbz-dev-plan.md`
- `archive/` mit `.gitkeep`
