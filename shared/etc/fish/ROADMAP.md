# Fish Shell — ROADMAP

> **Pfad:** `shared/etc/fish/ROADMAP.md`
> **Version:** 0.2.0
> **Erstellt:** 2026-02-10
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ

> **Zweck:** Planungsuebersicht fuer das Fish DRY-Refactoring (A2)

---

## Status: ✅ Abgeschlossen

A2 Fish DRY-Refactoring ist abgeschlossen (Phase 0-6).

## Phasen-Uebersicht

| Phase | Beschreibung | Status |
|-------|-------------|--------|
| 0 | Vorbereitung + Docs | ✅ Erledigt |
| 1 | Alias-Umbenennung (cat→bcat, ls→el, ...) | ✅ Erledigt |
| 2 | Nummerierung + Host-Flags (008-host-flags.fish) | ✅ Erledigt |
| 3 | Conditionals + DRY (050-gui, 055-dev, format.fish) | ✅ Erledigt |
| 4 | Loader umbauen (000-loader.fish, einschleifig) | ✅ Erledigt |
| 5 | Testen + Deploy (n8-kiste, n8-vps, n8-station) | ✅ Erledigt |
| 6 | Docs + Cleanup (shell.md, deployment.md, Skills) | ✅ Erledigt |

## Restposten

- n8-book + n8-archstick: Testen bei naechstem physischen Zugang
- deploy-agent: Verschoben (nicht in A2 Scope, eigener Task)

## Referenz

- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring.md`
- Shell-Policies: `.claude/context/shell.md`
