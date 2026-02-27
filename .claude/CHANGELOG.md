# .claude/ Changelog

**Erstellt:** 2026-02-10
**Autor:** MR-ByteZ

---

## [2.0.0] - 2026-02-27

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
- `context/structure.md` v2.0.0: Komplett auf 5-5-3 umgestellt
- `context/documentation.md`: 5-3-3 Referenzen → 5-5-3
- `context/claude-ai-projektanweisungen.txt`: 5-5-3, Hooks/Agents-Uebersicht ergaenzt

### Removed
- `configs/` Ordner geloescht (ungenutzt, Konfigurationen liegen in context/)
- `projects/sensitive-data-cleanup/` geloescht (A5 Placeholder, nie genutzt)

---

## [1.2.1] - 2026-02-11

### Added
- `context/handoffs/HANDOFF_[Secrets][Structure]_a1-secrets-repo-restrukturierung.md`

### Changed
- `context/claude-ai-projektanweisungen.txt`: C1+C2 erledigt, A1 aktuell

---

## [1.2.0] - 2026-02-11

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

## [1.1.0] - 2026-02-10

### Added
- `.claude/CLAUDE.md` als zentrale Steuerung (ersetzt Root /init-Version)
- `.claude/CHANGELOG.md` (diese Datei)
- `.claude/ROADMAP.md` für .claude/-spezifische Planung
- 2 zusätzliche context/ Dateien: `migration.md`, `structure.md`

### Changed
- `.claude/README.md` aktualisiert (neue Struktur, plans/ Referenz entfernt)
- Root `CLAUDE.md` entfernt (war von `/init`, gehört nach `.claude/`)
- Root `README.md` aktualisiert (PROJECT_NOTES.md Referenz entfernt)
- Root `DEPLOYMENT.md` aktualisiert (PROJECT_NOTES.md Referenz entfernt)
- Root `CHANGELOG.md` mit Phase 2+3 Migration Eintrag ergänzt
- Root `ROADMAP.md` Phase 2 Migration als erledigt markiert
- `.gitignore` erweitert (Sanitization-Patterns)

### Removed
- Root `CLAUDE.md` (war /init-Artefakt)

---

## [1.0.0] - 2026-02-10

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
- `README.md` (Struktur-Übersicht)
- `plans/` mit `mrbz-dev-plan.md`
- `archive/` mit `.gitkeep`
