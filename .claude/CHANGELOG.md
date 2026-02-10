# .claude/ Changelog

**Erstellt:** 2026-02-10
**Autor:** MR-ByteZ

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
