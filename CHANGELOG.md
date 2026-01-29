# Changelog

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

---

## [Unreleased]

### Planned
- Docs-Struktur (shared/home/mrohwer/Documents/)
- Submodules: n8-vps, n8-kiste
- Strukturplan-Docs aktualisieren (neue Symlink-Strategie)

---

## [0.3.0] - 2026-01-29

### Added
- [Fish] v2.0 - Hierarchischer Loader mit Theme-System
  - 00-loader.fish: Zentraler Loader mit Host-Erkennung
  - 00-theme.fish: Theme-Variablen initialisieren
  - themes/mr-bytez.fish: User-Typ-Farben (root/sudo/normal)
  - functions/: Prompt, Git-Status, Docker-Status, Helper
  - aliases/: Modulare Alias-Dateien (10-90)
- [Fish] Host-spezifische Configs für 8 Hosts
  - Desktop: n8-kiste, n8-station, n8-book, n8-bookchen, n8-maxx, n8-broker
  - Server: n8-vps
  - Spezial: n8-archstick
- [Micro] Editor-Konfiguration
  - settings.json: Gruvbox-Theme, Tab-Settings, Search-Optionen
  - bindings.json: Comment-Toggle Shortcuts

### Changed
- [Fish] Deployment-Strategie: EIN System-Symlink statt viele Einzel-Symlinks
- [Fish] Config-Hierarchie: Shared → Host-Override

---

## [0.2.0] - 2026-01-23

### Added
- [Secrets] Management mit Age-Encryption
- [Secrets] SSH-Key für Codeberg (id_ed25519_codeberg)
- [Secrets] API-Token für Codeberg (codeberg_api.token)
- [Secrets] derive_key.fish für Master-Password Derivation
- [Secrets] symlinks.db für automatisches Deployment
- [Secrets] SECRETS.md Dokumentation

### Fixed
- [Secrets][Fix] Token-Name korrigiert (codeberg_api.token)

### Changed
- .gitignore angepasst für Age-verschlüsselte Secrets
- README.md mit aktuellem Status

---

## [0.1.0] - 2026-01-22

### Added
- [Init] Repository initialisiert in `/mr-bytez`
- [Init] Basis-Ordnerstruktur (shared/, projects/, .claude/, .config/)
- [Init] Root-Dateien (README, CHANGELOG, ROADMAP, .gitignore)
- [Init] Git-Konfiguration (main branch)
- [Init] Codeberg Repository erstellt (n8lauscher/mr-bytez)

---

**Letzte Aktualisierung:** 2026-01-29