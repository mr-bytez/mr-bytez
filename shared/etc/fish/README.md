# MR-ByteZ Fish Shell Konfiguration

> **Pfad:** `shared/etc/fish/`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-28
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ
> **Zweck:** Zentrale Fish Shell Konfiguration fuer alle 8 Hosts

---

## Uebersicht

DRY Fish-Konfiguration mit Feature-Flags, Shared Conditionals und einheitlicher Nummerierung.
Verwaltet 8 Arch Linux Hosts ueber ein zentrales Konfigurations-System.

## Verzeichnisstruktur

```
shared/etc/fish/
├── aliases/          Shared Aliases (010-055, nummeriert)
├── conf.d/           Loader (000) + Theme (005) + Host-Flags (008)
├── functions/        Fish Functions (Prompt, Helpers, mr-bytez-info)
├── themes/           Theme-Dateien (Gruvbox)
├── variables/        Shared Variablen (010-paths)
├── skills/           Schritt-fuer-Schritt Anleitungen (3 Skills)
├── .claude/context/  Fish-spezifische Policies
├── CLAUDE.md         Claude Code Kontext
├── CHANGELOG.md      Aenderungshistorie
├── DEPLOYMENT.md     Deployment-Anleitung
├── README.md         Diese Datei
└── ROADMAP.md        Planungsuebersicht
```

## Nummerierungsschema

| Bereich | Nummern | Beschreibung |
|---------|---------|-------------|
| Shared | 000-099 | Alle Hosts laden diese Dateien |
| Host | 100-200 | Nur der jeweilige Host |

Wichtige Dateien:
- `000-loader.fish` — Laedt alles numerisch sortiert
- `005-theme.fish` — Prompt, Farben, Theme-System
- `008-host-flags.fish` — Feature-Flags per switch/case
- `050-gui.fish` — GUI-Conditionals (Self-Check Pattern)
- `055-dev.fish` — Dev-Conditionals (Self-Check Pattern)

## Feature-Flags

| Flag | Werte | Beschreibung |
|------|-------|-------------|
| MR_HAS_GUI | true/false | Hat der Host eine GUI? |
| MR_IS_DEV | true/false | Ist der Host ein Dev-Host? |
| MR_DISPLAY_TYPE | 4k/1920/headless | Display-Aufloesung |

## Referenzen

- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring_v3.md`
- Architektur: `.claude/context/ARCHITEKTUR.md`
- Host-Matrix: `.claude/context/HOST_MATRIX.md`
- Migration: `.claude/context/MIGRATION.md`
- Shell-Policies: `.claude/context/shell.md`
