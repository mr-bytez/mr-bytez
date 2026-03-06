# mrbz_aud — Modul 03: Header + Versionierung

**Datum:** 2026-03-06
**Status:** FINDINGS

## Zusammenfassung

Pruefung der Header und Versionierung aller 119 Dateien (.md, .fish, .sh, .txt) im Hauptrepo.
17 Dateien ohne jeglichen Header, 10 Markdown-Dateien mit unvollstaendigen Metadaten,
21 Fish-Dateien mit abweichendem Box-Stil, alle Fish-Pfadfelder relativ statt absolut.
Die neueren Dateien (ab Maerz 2026) sind deutlich konsistenter als aeltere.

## Header-Typen im Repo

| Typ | Beschreibung | Anzahl |
|-----|-------------|--------|
| metadata | `**Key:** Value` unter Titel | 34 |
| metadata (Blockquote) | `> **Key:** Value` (neuerer Stil) | 18 |
| box (Agent) | YAML-Frontmatter + ASCII-Box-Banner | 8 |
| 9-box (╔══╗) | Unicode-Doppellinien-Box (Config-Standard) | 18 |
| 7-feld (====) | Deployment-Script-Standard | 1 |
| anderer (┌───┐) | Einfachlinien-Box (aelterer Stil) | 21 |
| anderer (Hook-Box) | Hook-spezifisches Box-Format | 9 |
| **keiner** | **Kein strukturierter Header** | **17** |

## Uebersicht nach Bereich

### Markdown-Dateien (68 Dateien)

| Bereich | Dateien | Vollstaendig | Unvollstaendig | Kein Header |
|---------|---------|-------------|----------------|-------------|
| Root | 5 | 1 | 2 | 2 |
| .claude/ (.md) | 32 | 27 | 5 | 0 |
| .claude/ (.txt) | 2 | 0 | 0 | 2 |
| projects/ | 15 | 13 | 0 | 2 |
| shared/ | 14 | 9 | 3 | 2 |
| **Gesamt** | **68** | **50** | **10** | **8** |

### Fish-Dateien (49 Dateien)

| Bereich | Dateien | 9-box | 7-feld | anderer | keiner |
|---------|---------|-------|--------|---------|--------|
| shared/deployment/ | 4 | 4 | 0 | 0 | 0 |
| shared/etc/fish/aliases/ | 10 | 8 | 0 | 2 | 0 |
| shared/etc/fish/conf.d/ | 4 | 4 | 0 | 0 | 0 |
| shared/etc/fish/functions/ | 11 | 0 | 0 | 11 | 0 |
| shared/etc/fish/themes/ | 1 | 1 | 0 | 0 | 0 |
| shared/etc/fish/variables/ | 1 | 1 | 0 | 0 | 0 |
| shared/lib/ | 2 | 0 | 0 | 2 | 0 |
| shared/home/ | 1 | 0 | 0 | 0 | 1 |
| projects/ (Host-Aliases) | 8 | 0 | 0 | 8 | 0 |
| projects/ (Host-Functions) | 8 | 0 | 0 | 0 | 8 |
| scripts/ | 1 | 0 | 0 | 1 | 0 |
| bot/ | 1 | 0 | 1 | 0 | 0 |
| **Gesamt** | **49** | **18** | **1** | **21** | **9** |

### Shell-Dateien (9 Dateien)

| Bereich | Dateien | 7-feld | anderer |
|---------|---------|--------|---------|
| .claude/hooks/ | 7 | 0 | 7 |
| shared/ | 2 | 0 | 2 |
| **Gesamt** | **9** | **0** | **9** |

## Findings

### [MITTEL] Root CHANGELOG.md ohne Header-Metadaten

- **Datei:** `CHANGELOG.md`
- **Problem:** Kein Version-, Erstellt-, Aktualisiert- oder Autor-Feld. Nur Titel und Beschreibung.
- **Erwartung:** Standard-Metadaten-Block (`**Version:** X.Y.Z`, `**Erstellt:** ...`, etc.)
- **Empfehlung:** Metadaten-Header ergaenzen

### [MITTEL] Root DEPLOYMENT.md unvollstaendiger Header

- **Datei:** `DEPLOYMENT.md`
- **Problem:** Hat nur "Stand:" statt Erstellt/Aktualisiert. Kein Version-Feld, kein Autor.
- **Erwartung:** Standard-Metadaten-Block mit Version, Erstellt, Aktualisiert, Autor
- **Empfehlung:** Header auf Standard-Format bringen

### [MITTEL] Root ROADMAP.md fehlende Version und Autor

- **Datei:** `ROADMAP.md`
- **Problem:** Hat Erstellt + Aktualisiert, aber weder Version noch Autor
- **Erwartung:** Alle 4 Metadaten-Felder vorhanden
- **Empfehlung:** Version + Autor ergaenzen

### [MITTEL] .claude/CHANGELOG.md fehlende Version und Aktualisiert

- **Datei:** `.claude/CHANGELOG.md`
- **Problem:** Kein Version-Feld, kein Aktualisiert-Datum
- **Erwartung:** Vollstaendiger Metadaten-Header
- **Empfehlung:** Version + Aktualisiert ergaenzen

### [MITTEL] .claude/README.md fehlende Version

- **Datei:** `.claude/README.md`
- **Problem:** Kein Version-Feld vorhanden
- **Erwartung:** Version im Metadaten-Header
- **Empfehlung:** Version ergaenzen

### [MITTEL] hwi/ Docs unvollstaendige Header (4 Dateien)

- **Datei:** `shared/usr/local/bin/hwi/CHANGELOG.md` — komplett ohne Header
- **Datei:** `shared/usr/local/bin/hwi/DEPLOYMENT.md` — nur Aktualisiert, sonst nichts
- **Datei:** `shared/usr/local/bin/hwi/README.md` — keine Datums-Felder
- **Datei:** `shared/usr/local/bin/hwi/ROADMAP.md` — nur Aktualisiert, sonst nichts
- **Problem:** 4 von 5 hwi-Docs haben unvollstaendige oder fehlende Header-Metadaten
- **Erwartung:** Einheitlicher Metadaten-Header mit Version, Erstellt, Aktualisiert, Autor
- **Empfehlung:** Alle hwi-Docs auf Standard-Format bringen

### [MITTEL] scan-secrets.fish: Version nicht SemVer-konform

- **Datei:** `scripts/scan-secrets.fish`
- **Problem:** Version `2.0` statt `2.0.0` (SemVer). Autor als Klarname ("Michael Rohwer") statt "MR-ByteZ". Kein strukturierter Header.
- **Erwartung:** SemVer-Format X.Y.Z, Autor "MR-ByteZ", 9-box oder 7-feld Header
- **Empfehlung:** Header auf Standard-Format bringen, Version zu `2.0.0` korrigieren

### [INFO] 8 Host-Test-Functions ohne Header

- **Datei:** `projects/infrastructure/*/root/.../functions/*-test.fish` (8 Dateien)
- **Problem:** Alle 8 Host-spezifischen Test-Functions starten direkt mit `function ...`, kein Header
- **Erwartung:** Mindestens einfacher Header mit Beschreibung, Version, Erstellt
- **Empfehlung:** Bei naechster Bearbeitung Header ergaenzen

### [INFO] config.fish ohne Header

- **Datei:** `shared/home/mrohwer/.config/fish/config.fish`
- **Problem:** Kein Header — nur Kommentar + source-Befehl
- **Erwartung:** Mindestens einfacher Header
- **Empfehlung:** Bei naechster Bearbeitung Header ergaenzen

### [INFO] Root CLAUDE.md ohne Metadaten

- **Datei:** `CLAUDE.md`
- **Problem:** Kein Version-, Erstellt-, Aktualisiert-Feld (ist Steuerungsdatei fuer Claude Code)
- **Erwartung:** Metadaten-Header waere konsistent, aber CLAUDE.md hat Sonderstatus
- **Empfehlung:** Optional: Metadaten ergaenzen. Kein harter Fehler da spezielle Funktion.

### [INFO] 2 .txt Dateien ohne Header

- **Datei:** `.claude/context/claude-ai-projektanweisungen.txt`
- **Datei:** `.claude/context/claude-ai-user-preferences.txt`
- **Problem:** Keinerlei Header-Metadaten (Freitext fuer claude.ai Projekt-Settings)
- **Erwartung:** Format-bedingt kein Standard-Header moeglich (werden in claude.ai eingefuegt)
- **Empfehlung:** Kein Handlungsbedarf — Sonder-Dateien fuer claude.ai Web-UI

### [INFO] 2 HARDWARE.md ohne Header

- **Datei:** `projects/infrastructure/n8-kiste/HARDWARE.md`
- **Datei:** `projects/infrastructure/n8-station/HARDWARE.md`
- **Problem:** Generierte hwi-Outputs mit eigenem ASCII-Banner, kein Standard-Header
- **Erwartung:** Generierte Dateien folgen dem hwi-Tool-Format
- **Empfehlung:** Kein Handlungsbedarf — automatisch generiert

### [INFO] .claude/archive/ Dateien mit unvollstaendigen Headern

- **Datei:** `.claude/archive/migration.md` — Aktualisiert-Datum fehlt
- **Datei:** `.claude/archive/mrbz-dev-plan.md` — Version + Autor fehlt
- **Problem:** Archivierte Dateien haben unvollstaendige Metadaten
- **Erwartung:** Einheitlicher Header
- **Empfehlung:** Niedrige Prioritaet — Archiv-Dateien, keine aktive Nutzung

### [INFO] hwi/CLAUDE.md fehlende Aktualisiert-Datum

- **Datei:** `shared/usr/local/bin/hwi/CLAUDE.md`
- **Problem:** Aktualisiert-Datum fehlt
- **Erwartung:** Vollstaendiger Metadaten-Header
- **Empfehlung:** Bei naechster Aenderung ergaenzen

### [INFO] Alle .sh Hook-Dateien nutzen eigenes Box-Format statt 7-Feld-Standard

- **Datei:** `.claude/hooks/*.sh` (7 Dateien) + `shared/etc/claude-code/statusline.sh` + `shared/usr/local/bin/hwi/hwi.sh`
- **Problem:** 0/9 .sh-Dateien nutzen den dokumentierten 7-Feld-Standard (`# ====`). Alle verwenden ein eigenes Box-Format mit Unicode-Rahmen. Felder sind inhaltlich vollstaendig.
- **Erwartung:** 7-Feld-Standard laut docs-agent.md
- **Empfehlung:** Entweder Standard anpassen (Hook-Box als gueltig definieren) oder Hooks migrieren

### [INFO] 2 .sh Dateien mit relativen Pfaden

- **Datei:** `shared/etc/claude-code/statusline.sh` — Pfad relativ statt absolut
- **Datei:** `shared/usr/local/bin/hwi/hwi.sh` — Pfad relativ statt absolut
- **Problem:** Pfad-Feld im Header ist relativ, Hook-Dateien haben korrekte absolute Pfade
- **Erwartung:** Absolute Pfade (z.B. `/mr-bytez/shared/...`)
- **Empfehlung:** Pfade auf absolut korrigieren

### [NEEDS_REVIEW] Fish-Config-Header: 3 verschiedene Box-Stile im Einsatz

- **Datei:** Alle 49 .fish-Dateien betroffen
- **Problem:** 3 verschiedene Header-Box-Stile: (1) Standard ╔══╗ 9-box (18x), (2) Aelterer ┌───┐ Box-Stil (21x), (3) Kein Header (9x). Der ┌───┐-Stil existiert in 2 Varianten: Felder innerhalb vs. ausserhalb der Box. Zusaetzlich nutzen 050-gui.fish und 055-dev.fish den ┌───┐-Stil obwohl alle anderen aliases/ den ╔══╗-Stil haben.
- **Erwartung:** Ein einheitlicher Standard
- **Empfehlung:** Entscheidung noetig: Sollen alle Fish-Dateien auf ╔══╗ 9-box migriert werden? Oder wird ┌───┐ als gleichwertiger Standard akzeptiert? Stilbruch in aliases/ (050/055 vs. 010-045) sollte in jedem Fall behoben werden.

### [NEEDS_REVIEW] Fish Pfad-Felder: Durchgehend relativ statt absolut

- **Datei:** Alle 40 .fish-Dateien mit Header (49 total - 9 ohne Header)
- **Problem:** Keine einzige Fish-Datei hat einen absoluten Pfad im Pfad-Feld. Alle nutzen relative Pfade (z.B. `shared/deployment/derive_key.fish`). Host-Alias-Dateien haben sogar nur Fragment-Pfade (z.B. `aliases/110-n8-book.fish`).
- **Erwartung:** docs-agent.md definiert: `# Pfad: /vollstaendiger/pfad` (absolut)
- **Empfehlung:** Entscheidung noetig: Relative Pfade als Standard akzeptieren (einfacher wartbar) oder auf absolute Pfade mit `/mr-bytez/`-Prefix migrieren?

## Statistik

- Gepruefte Dateien: 119 (68 .md/.txt + 49 .fish + 9 .sh) — ohne .secrets/, projects/web/, mrbz_aud/reports/
- Findings: 17 (0 KRITISCH, 7 MITTEL, 8 INFO, 2 NEEDS_REVIEW)
