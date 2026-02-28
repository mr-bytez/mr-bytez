# Fish Shell — ROADMAP

> **Pfad:** `shared/etc/fish/ROADMAP.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-10
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ

> **Zweck:** Planungsuebersicht fuer das Fish DRY-Refactoring (A2)

---

## Aktuelle Phase: 5 (Testen + Deploy)

## Phasen-Uebersicht

| Phase | Beschreibung | Status |
|-------|-------------|--------|
| 0 | Vorbereitung + Docs | ✅ Erledigt |
| 1 | Alias-Umbenennung (cat→bcat, ls→el, ...) | ✅ Erledigt |
| 2 | Nummerierung + Host-Flags (008-host-flags.fish) | ✅ Erledigt |
| 3 | Conditionals + DRY (050-gui, 055-dev, format.fish) | ✅ Erledigt |
| 4 | Loader umbauen (000-loader.fish, einschleifig) | ✅ Erledigt |
| 5 | Testen + Deploy (n8-kiste, n8-vps, n8-station, ...) | ⬜ Geplant |
| 6 | Docs + Cleanup (shell.md, deployment.md, Skills) | ⬜ Geplant |

## Naechste Schritte (Phase 5)

- n8-kiste testen (lokal, GUI+DEV)
- n8-vps testen (SSH, headless)
- n8-station testen (SSH, GUI+DEV)
- Restliche deployed Hosts (n8-book, n8-archstick)
- deploy-agent fuer SSH-Deployment

## Referenz

- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring_v3.md`
