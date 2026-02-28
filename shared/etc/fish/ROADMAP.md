# Fish Shell — ROADMAP

> **Pfad:** `shared/etc/fish/ROADMAP.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-10
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ

> **Zweck:** Planungsuebersicht fuer das Fish DRY-Refactoring (A2)

---

## Aktuelle Phase: 0 (Vorbereitung)

## Phasen-Uebersicht

| Phase | Beschreibung | Status |
|-------|-------------|--------|
| 0 | Vorbereitung + Docs | 🟡 In Arbeit |
| 1 | Alias-Umbenennung (cat→bcat, ls→el, ...) | ⬜ Geplant |
| 2 | Nummerierung + Host-Flags (008-host-flags.fish) | ⬜ Geplant |
| 3 | Conditionals + DRY (050-gui, 055-dev, format.fish) | ⬜ Geplant |
| 4 | Loader umbauen (000-loader.fish, einschleifig) | ⬜ Geplant |
| 5 | Testen + Deploy (n8-kiste, n8-vps, n8-station, ...) | ⬜ Geplant |
| 6 | Docs + Cleanup (shell.md, deployment.md, Skills) | ⬜ Geplant |

## Naechste Schritte (Phase 1)

- HOCH-Risiko Alias-Umbenennungen: cat→bcat, ls→el, grep→rg, df→duf, du→dust
- MITTEL-Risiko: rm→rmi, cp→cpi, mv→mvi
- Originale komplett alias-frei machen
- Deploy + Test auf n8-kiste

## Referenz

- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring_v3.md`
