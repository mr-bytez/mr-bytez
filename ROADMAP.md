# Roadmap

**Projekt:** mr-bytez Meta-Repository
**Erstellt:** 2026-01-22
**Aktualisiert:** 2026-01-29

---

## Phase 1: Foundation (Q1 2026) ✅

**Ziel:** Basis-Repository & Secrets-Management

### Milestones
- [x] Repository in `/mr-bytez` erstellt
- [x] Basis-Ordnerstruktur angelegt
- [x] Root-Dateien (README, CHANGELOG, ROADMAP, .gitignore)
- [x] SSH-Key generiert & deployed (id_ed25519_codeberg)
- [x] Codeberg Repository verbunden (n8lauscher/mr-bytez)
- [x] Secrets-Management (Age-Encryption)
- [x] derive_key.fish (Master-Password Derivation)
- [x] symlinks.db (Deployment-Datenbank)

**Status:** ✅ Abgeschlossen
**Abgeschlossen:** 2026-01-23

---

## Phase 2: Host-Setup (Q1 2026)

**Ziel:** Shared Configs & Submodules

### Milestones
- [x] Fish-Config v2.0 (shared/usr/local/share/fish/)
  - [x] Hierarchischer Loader (00-loader.fish)
  - [x] Theme-System (mr-bytez.fish)
  - [x] Modulare Aliases (10-90)
  - [x] Host-spezifische Configs (8 Hosts)
- [x] Micro Editor-Konfiguration
- [ ] Docs-Struktur (shared/home/mrohwer/Documents/)
- [ ] Submodule: n8-vps (Codeberg privat)
- [ ] Submodule: n8-kiste (Codeberg privat)
- [ ] Symlink-Strategie vollständig dokumentiert

**Status:** In Progress
**ETA:** Februar 2026

---

## Phase 3: Automation (Q1 2026)

**Ziel:** Deployment & Backup-Automatisierung

### Milestones
- [ ] restore.fish Script (Disaster Recovery)
- [ ] Auto-Backup zu Codeberg (Cronjob)
- [ ] Webhosting Backup (Hetzner)
- [ ] Git-Hooks (pre-commit für Secrets)

**Status:** Geplant
**ETA:** März 2026

---

## Phase 4: Expansion (Q2 2026)

**Ziel:** Weitere Hosts & Web-Projekte

### Milestones
- [ ] Submodule: n8-station
- [ ] Submodule: n8-book
- [ ] Submodule: blog.mr-bytez.de (öffentlich)
- [ ] Submodule: shop.mr-bytez.de (öffentlich)
- [ ] Dokumentation vervollständigen

**Status:** Geplant
**ETA:** Q2 2026

---

**Letzte Aktualisierung:** 2026-01-29