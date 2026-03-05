# .claude/ Roadmap

**Version:** 0.4.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-03-05
**Autor:** MR-ByteZ

---

## Phase 1: Foundation ✅ DONE

- [x] `.claude/` Struktur definiert (5-5-3 Pattern)
- [x] Migration-Plan erstellt (`archive/migration.md`, ehemals context/)
- [x] Struktur-Definition erstellt (`context/structure.md`)

**Abgeschlossen:** 2026-02-05

---

## Phase 2: Migration ✅ DONE

- [x] `context/` mit 11 Dateien erstellt (aus PROJECT_NOTES.md + neue)
- [x] `plans/` → `archive/` umbenannt
- [x] `PROJECT_NOTES.md` aufgeteilt und entfernt
- [x] `.gitignore.bak` entfernt
- [x] Autor überall: MR-ByteZ
- [x] `archive/`, `skills/`, `configs/` Ordner angelegt

**Abgeschlossen:** 2026-02-10

---

## Phase 3: Root-Dateien + Aufräumen ✅ DONE

- [x] `.claude/CLAUDE.md` erstellt (eigene Version, ersetzt /init)
- [x] `.claude/CHANGELOG.md` erstellt
- [x] `.claude/ROADMAP.md` erstellt (diese Datei)
- [x] `.claude/README.md` aktualisiert
- [x] Root `CLAUDE.md` entfernt (war /init-Artefakt)
- [x] Root `README.md` aktualisiert (PROJECT_NOTES Referenz)
- [x] Root `CHANGELOG.md` ergänzt (Phase 2+3 Eintrag)
- [x] Root `ROADMAP.md` aktualisiert (Phase 2 erledigt)
- [x] Root `DEPLOYMENT.md` gefixt (PROJECT_NOTES Referenz)
- [x] `.gitignore` erweitert (Sanitization-Patterns)

**Abgeschlossen:** 2026-02-10

---

## Phase 4: Nutzung & Erweiterung 📌 GEPLANT

- [x] Secrets-Submodule auf 5-5-3 Pattern migrieren → A1 ✅
- [x] `symlinks.db` ins private Submodule verschieben → D9 ✅
- [ ] Skills entwickeln (`.claude/skills/`) → inkrementell pro A-Projekt
- [x] Hooks erweitern (`.claude/hooks/`) → 7 Hooks aktiv (Session-Start, Secrets-Guard, Fish-Syntax, Dual-Push, Docs-Check, Handoff-Lifecycle, Bash-Logger)
- [ ] Projekt-Level `.claude/` befuellen → inkrementell pro A-Projekt (n8-vps ✅, A3: mrbz-dev, A4: MCP)

**ETA:** Q1-Q2 2026

---

## Phase 5: Automatisierung 📌 GEPLANT

- [ ] MCP Server Integration → Projekt A4 in Root `ROADMAP.md`
- [ ] Claude Development Container (`.claude/` Mount) → Projekt A3 in Root `ROADMAP.md`
- [ ] Pre-Commit Hooks fuer Doku-Konsistenz → B11 unter A3
- [ ] Automatische Context-Synchronisation → D17 unter A4
- [ ] mrbz_aud Docs-Audit-Bot → Projekt A7 in Root `ROADMAP.md`
- [ ] mrbz_dep/mrbz_cov Deploy-Coverage-Bot → Projekt A8 in Root `ROADMAP.md`
- [ ] Master-Key Automatisierung → Projekt A9 in Root `ROADMAP.md`

**ETA:** Q2 2026

---

## Gesamtbild

Fuer die vollstaendige Projekt-Uebersicht (A1-A5, B-Tasks, D-Tasks, Timing-Matrix):
→ Siehe Root `ROADMAP.md`
