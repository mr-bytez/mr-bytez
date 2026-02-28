# Fish Shell — CHANGELOG

> **Pfad:** `shared/etc/fish/CHANGELOG.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-10
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ

> **Zweck:** Aenderungshistorie der Fish Shell Konfiguration

---

## [0.5.0] — 2026-02-28

### Phase 4: Loader-Umbau (einschleifig)

- 000-loader.fish v0.5.0: 8 Sektionen → 1 Schleife ueber 6 Verzeichnisse
- Kein Range-Filter mehr — Glob-Sortierung + Zero-Padding reicht
- `10-paths.fish` → `010-paths.fish` umbenannt (Konsistenz)
- mr-bytez-info.fish v0.4.0: Feature-Flags in Diagnose, MR_HAS_GUI-Check

---

## [0.4.0] — 2026-02-28

### Phase 3: Conditionals + DRY + format.fish

- `shared/lib/format.fish` erstellt: Zentrale Formatting-Library (10 Funktionen, Gruvbox)
- `050-gui.fish` erstellt: GUI-Conditionals mit Self-Check (MR_HAS_GUI)
- `055-dev.fish` erstellt: DEV-Conditionals mit Self-Check (MR_IS_DEV), Platzhalter
- `upa` (Server-Version ohne Flatpak) in 035-pacman.fish ergaenzt
- 7x `70-desktop.fish` + 1x `70-server.fish` geloescht (→ shared 050-gui.fish)
- 6x `10-display.fish` + 2x `10-host.fish` → in 008-host-flags.fish konsolidiert
- 8x `80-n8-*.fish` → `110-n8-*.fish` umbenannt (neues Nummerierungsschema)
- Loader temporaer erweitert (80-199, wird in Phase 4 durch einschleifig ersetzt)
- `pack-secrets.fish` + `unpack-secrets.fish`: Auf format.fish Library umgestellt

---

## [0.3.1] — 2026-02-28

### Phase 2 Hotfix: Loader-Fix + Header-Audit

- 000-loader.fish: Theme-Referenz 00-theme→005-theme gefixt
- 000-loader.fish: 008-host-flags.fish explizit eingebunden (wird VOR Aliases geladen)
- mr-bytez-info.fish: Loader-Referenz 00-loader→000-loader gefixt
- fish_prompt.fish + fish_right_prompt.fish: Theme-Referenz korrigiert
- 14 Shared Fish-Dateien: Einheitliche 7-Feld Header (Datei/Pfad/Autor/Version/Erstellt/Aktualisiert/Zweck)
- banner.fish: Header standardisiert
- Validierung bestanden: Host-Flags, Alias-Sicherheit, coreutils frei

---

## [0.1.0] — 2026-02-28

### Phase 0: Vorbereitung + Docs

- Paketlisten angelegt: `shared/packages/` (min, desktop, dev)
- 5-5-3 Docs befuellt: README.md, DEPLOYMENT.md, CLAUDE.md, CHANGELOG.md, ROADMAP.md
- Architektur-Docs erstellt: ARCHITEKTUR.md, HOST_MATRIX.md, MIGRATION.md
- Referenz: Handoff v3.0, Chat #FSH01.3

## [Pre-0.1.0] — bis 2026-02-27

### Bestehende Konfiguration

- Loader v2.1.0 (`00-loader.fish`) mit mehrstufigem Lade-System
- Theme v1.1.0 (`00-theme.fish`) mit Gruvbox-Farbschema
- 8 Shared Aliases (10-nav bis 90-misc)
- 8 Host-Konfigurationen mit duplizierten Desktop-Aliases (DRY-Verletzung)
- 4 Audit-Reports erstellt (A2 Verifikation, Host-Inventur, Altes-Repo)
