# Roadmap

**Projekt:** mr-bytez Meta-Repository
**Erstellt:** 2026-01-22
**Aktualisiert:** 2026-01-23

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

**Ziel:** n8-vps & n8-kiste als Submodules

### Milestones
- [ ] Fish-Config Basis (shared/usr/local/share/fish/)
- [ ] Docs-Struktur (shared/home/mrohwer/Documents/)
- [ ] Submodule: n8-vps (Codeberg privat)
- [ ] Submodule: n8-kiste (Codeberg privat)
- [ ] Shared Configs deployed
- [ ] Symlink-Strategie implementiert

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

**Letzte Aktualisierung:** 2026-01-23
