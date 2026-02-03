# ROADMAP.md

**Projekt:** mr-bytez Meta-Repository  \
**Zweck:** Roadmap & Meilensteine (Phasen-basiert + kompakte Übersicht)  \
**Erstellt:** 2026-01-22  \
**Aktualisiert:** 2026-02-03  \

---

## Leitbild

- Zentrale Verwaltung aller Hosts, Configs & Secrets
- Polyrepo-Ansatz (Submodules für Projekte)
- Single Source of Truth im Live-System unter `/mr-bytez`

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

**Status:** ✅ Abgeschlossen  \
**Abgeschlossen:** 2026-01-23

---

## Phase 2: Host-Setup (Q1 2026) 🛠️

**Ziel:** Shared Configs & Submodules

### Milestones

- [x] Fish-Config v2.0 (shared/etc/fish/)
  - [x] Hierarchischer Loader (00-loader.fish)
  - [x] Theme-System (mr-bytez.fish)
  - [x] Modulare Aliases (10-90)
  - [x] Host-spezifische Configs (8 Hosts)
- [x] Micro Editor-Konfiguration
- [ ] Bash-Config (Äquivalent zur Fish-Config)
  - [ ] Aliases, Variablen, Funktionen
  - [ ] Hierarchische Struktur (shared → host-spezifisch)
- [ ] mr-bytez-info.fish (Selbstdokumentierendes Hilfe-System)
  - [ ] Metadaten-Tags: @alias, @var, @func, @file, @category, @scope
  - [ ] Dynamisches Parsing aller Config-Dateien
  - [ ] Ausgabe pro Host: aktive Aliase, Variablen, Funktionen
- [ ] Docs-Struktur (shared/home/mrohwer/Documents/)
- [ ] Submodule: n8-vps (Codeberg privat)
- [ ] Submodule: n8-kiste (Codeberg privat)
- [x] Symlink-Strategie vollständig dokumentiert (Anker-Modell)
  - [x] Stabiler Anker: `/opt/mr-bytez/current -> /mr-bytez`
  - [x] System-Symlinks laufen über den Anker (Fish/Micro)
  - [x] SSH-Policy: `~/.ssh/config` wird nicht deployt (nur Template)

**Status:** In Progress  \
**ETA:** Februar 2026

---

## Phase 3: Automation & Integration (Q1 2026) 📌

**Ziel:** Deployment, Backup & Multi-Remote

### Milestones

- [x] GitHub als zusätzliches Remote
  - [x] Multi-Remote Push (Codeberg + GitHub)
- [ ] MCP GitHub Server für Claude
  - [ ] Personal Access Token + Age-Verschlüsselung
  - [ ] Claude Lese- + Schreibzugriff auf Repo
- [ ] restore.fish Script (Disaster Recovery)
- [ ] Auto-Backup zu Codeberg (Cronjob)
- [ ] Webhosting Backup (Hetzner)
- [ ] Git-Hooks (pre-commit für Secrets)
- [ ] Pre-Commit Hooks / Linting / Safety-Checks (Repo-Qualität)

**Status:** Geplant  \
**ETA:** März 2026

---

## Phase 4: Expansion (Q2 2026) 📌

**Ziel:** Weitere Hosts & Web-Projekte

### Milestones

- [ ] Submodule: n8-station
- [ ] Submodule: n8-book
- [ ] Submodule: blog.mr-bytez.de (öffentlich)
- [ ] Submodule: shop.mr-bytez.de (öffentlich)
- [ ] Dokumentation vervollständigen

**Status:** Geplant  \
**ETA:** Q2 2026

---

## Kompakt-Übersicht (aus der Kurz-Roadmap)

> Dieser Abschnitt bleibt als schnelle „Scan“-Ansicht bestehen und spiegelt die Phase-Roadmap in Kurzform.

## Done ✅

### Repo & Split

- [x] Main-Repo `mr-bytez` als **public** Repo etabliert (GitHub + Codeberg)
- [x] Secrets-Repo `mr-bytez-secrets` als **private** Repo etabliert
- [x] Secrets als Submodule im Main-Repo: `shared/.secrets`
- [x] Multi-Remote Setup im Main-Repo (GitHub + Codeberg)

### Deployment-Foundation

- [x] Stabiler Anker eingeführt: `/opt/mr-bytez/current -> /mr-bytez`
- [x] System-Symlinks laufen über den Anker
  - [x] Fish: `/usr/local/share/fish -> /opt/mr-bytez/current/shared/usr/local/share/fish`
  - [x] Micro: `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`
- [x] SSH-Policy umgesetzt: `~/.ssh/config` wird **nicht** aus dem Repo deployt (nur Template)
  - [x] Template vorhanden: `shared/home/mrohwer/.ssh/config.example`

### Policies & Doku-Baseline

- [x] Fish-first Policy (keine Bash-Heredocs, Files via `printf`)
- [x] Token/Key-Policy (cat/bat Alias-Falle) dokumentiert
- [x] „Wichtige MD-Dateien nur additiv ändern“ Policy festgelegt

---

## In progress 🛠️

### Doku-Konsolidierung (Finalisierung)

- [ ] `README.md` / `DEPLOYMENT.md` / `PROJECT_NOTES.md` final im Repo übernehmen (Single Source of Truth je Datei)
- [ ] `CHANGELOG.md` aktualisieren (Repo-Split, Anker-Deployment, SSH-Template, Submodule)
- [ ] `ROADMAP.md` (dieses Dokument) im Repo verankern und regelmäßig pflegen

### Projects/Submodules

- [ ] `projects/` Struktur definieren (Naming, Ownership, README pro Projekt)
- [ ] Erste Host-/Service-Repos als Submodule hinzufügen

---

## Planned 📌

### Automation & Qualität

- [ ] Pre-Commit Hooks (Format/Lint/Safety Checks)
- [ ] CI-Checks für Markdown (Links, Format) und grundlegende Repo-Policies
- [ ] Script: „Repo bootstrap / restore“ (Fish)

### Deployment-Erweiterung

- [ ] Standardisierte Deploy-Checks (Symlink-Validation, Permissions, Submodule-State)
- [ ] Rollback-Playbook (Dokumentation + Routine)

### Secrets / Recovery

- [ ] Recovery-Runbook (kompakt): „neuer Host → Zugriff → Secrets → Deployment“
- [ ] Secrets-Inventar (`*.info`) vollständig und konsistent halten

---

## Notizen

- Dieses Dokument ist bewusst high-level.
- Operative Schritte gehören in `DEPLOYMENT.md`, Policies in `PROJECT_NOTES.md`.

---

**Letzte Aktualisierung:** 2026-02-03

