# ROADMAP.md

**Projekt:** mr-bytez Meta-Repository
**Zweck:** Roadmap & Meilensteine (Phasen-basiert + kompakte Übersicht)
**Erstellt:** 2026-01-22
**Aktualisiert:** 2026-02-10

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
- [x] GitHub Mirror etabliert (GitHub + Codeberg Multi-Remote)
- [x] Secrets-Management (Age-Encryption)
- [x] derive_key.fish (Master-Password Derivation)
- [x] symlinks.db (Deployment-Datenbank)

**Status:** ✅ Abgeschlossen
**Abgeschlossen:** 2026-01-23

---

## Phase 2: Host-Setup (Q1 2026) 🛠️

**Ziel:** Shared Configs & Submodules

### Milestones

- [x] Fish-Config v2.1 (shared/etc/fish/)
  - [x] Hierarchischer Loader (00-loader.fish)
  - [x] Theme-System (mr-bytez.fish)
  - [x] Modulare Aliases (10-90)
  - [x] Host-spezifische Configs (8 Hosts)
  - [x] Powerline Prompt mit Git/Docker Status
- [x] Micro Editor-Konfiguration (Gruvbox, external Clipboard via xclip)
- [x] Symlink-Strategie vollständig dokumentiert (Anker-Modell)
  - [x] Stabiler Anker: `/opt/mr-bytez/current -> /mr-bytez`
  - [x] System-Symlinks laufen über den Anker (Fish/Micro)
  - [x] SSH-Policy: `~/.ssh/config` wird nicht deployt (nur Template)
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

**Status:** In Progress
**ETA:** Februar 2026

---

## Phase 3: Automation & Integration (Q1 2026) 📌

**Ziel:** Development Foundation, dann Automation & Tooling

**Strategie:** Foundation ZUERST aufbauen, dann darauf entwickeln!

---

### 🏗️ Priorität 1: FOUNDATION (ZUERST - Blocker für alles andere!)

**Impact:** 🔥🔥🔥 **KRITISCH** - Ermöglicht ALLE anderen Entwicklungen!

#### Claude Development Container (Docker Stack)

**Warum ZUERST?**
- ✅ Isolierte Entwicklungsumgebung (kein Host-Chaos!)
- ✅ Reproduzierbar auf ALLEN Hosts (n8-kiste, n8-station, n8-book)
- ✅ Claude Code arbeitet SAUBER im Container
- ✅ Basis für MCP Server Development
- ✅ Basis für alle weiteren Tools
- ✅ Keine Abhängigkeiten - kann SOFORT umgesetzt werden!

**Abhängigkeiten:** ❌ KEINE - Ready to start!

**Milestones:**
- [ ] **Docker Stack Struktur**
  - [ ] `projects/infrastructure/n8-kiste/stacks/claude-dev/`
  - [ ] docker-compose.yml
  - [ ] Dockerfile (optimiert für Claude Code)
  - [ ] .devcontainer/devcontainer.json (VS Code Support)
- [ ] **Container Features**
  - [ ] Node.js + TypeScript (für MCP Development)
  - [ ] Python 3.12+ (für Scripts)
  - [ ] Fish Shell (wie auf Host)
  - [ ] Git + gh CLI
  - [ ] Basis-Tools (micro, eza, fastfetch)
- [ ] **Volume Mounts**
  - [ ] /mr-bytez (Repo Read/Write)
  - [ ] ~/.ssh (SSH-Keys, read-only)
  - [ ] ~/.config (User-Configs)
- [ ] **Integration**
  - [ ] Claude Code CLI funktioniert im Container
  - [ ] VS Code Dev Container Support
  - [ ] Fish Shell wie auf Host konfiguriert
- [ ] **Deployment**
  - [ ] Als Git Submodule verwaltet
  - [ ] FHS-konform in `/opt/mr-bytez/stacks/`
  - [ ] systemd Service (optional, für Auto-Start)
- [ ] **Dokumentation**
  - [ ] README.md im Stack
  - [ ] Deployment-Guide
  - [ ] Troubleshooting

**Referenz:** [Chat: Claude Dev Container](https://claude.ai/chat/beb70400-561e-4420-8920-86b2fcaf6cbd)

**Status:** 🔴 HÖCHSTE PRIORITÄT - Nächster Schritt!
**ETA:** Februar 2026 (Woche 1-2)

---

### 🔧 Priorität 2: DEVELOPMENT (Nach Foundation)

**Impact:** 🔥🔥 HOCH - Wichtige Features, aber brauchen Foundation!

**Abhängigkeiten:** ✅ Claude Dev Container MUSS existieren!

#### MCP Server für n8-vps (Production RAG + Docker Management)

**Warum NACH Dev Container?**
- ⚠️ Braucht TypeScript Development-Umgebung
- ⚠️ Braucht sichere Test-Umgebung
- ⚠️ Komplexes Projekt - Container vereinfacht Development

**Milestones:**
- [ ] **Phase 1: Development im Container (n8-kiste)**
  - [ ] TypeScript MCP Server implementieren
  - [ ] Filesystem Tool (Dateizugriff)
  - [ ] Docker Tool (status/logs/start/stop/compose)
  - [ ] Git Tool (Repository-Verwaltung)
  - [ ] Database Tool (PostgreSQL/Redis Zugriff)
  - [ ] RAG Tool (Qdrant Vector Search)
  - [ ] Lokale Tests & Debugging IM CONTAINER
- [ ] **Phase 2: Production Deployment (n8-vps)**
  - [ ] Native Installation (systemd Service)
  - [ ] Qdrant als Docker Container
  - [ ] Traefik Reverse Proxy (mcp.mr-bytez.de)
  - [ ] Bearer Token Authentication
  - [ ] Später: Authentik OAuth2 Integration

**Architektur:**
```
Internet → Traefik (mcp.mr-bytez.de) → Bearer Token Auth → MCP Server (Native)
                                                              ├─ Filesystem Tool
                                                              ├─ Docker Tool
                                                              ├─ Git Tool
                                                              ├─ Database Tool
                                                              └─ RAG Tool (Qdrant)
```

**Tech-Stack:**
- MCP Server: TypeScript, Native Installation, systemd
- Vector DB: Qdrant (Docker Container, Hybrid Search)
- Auth: Bearer Token → später Authentik OAuth2

**Referenz:** [Chat: MCP Server Implementation](https://claude.ai/chat/fd879abe-a618-40b4-bf2a-540854fa6a54)

**Status:** Geplant nach Dev Container
**ETA:** März 2026

---

#### Sensitive Data Cleanup (Git History Bereinigung)

**Warum NACH Dev Container?**
- ⚠️ Braucht sichere Test-Umgebung (git filter-repo!)
- ⚠️ Gefährliche Operation - besser im Container testen
- ⚠️ Script-Development braucht Fish-Umgebung

**Milestones:**
- [ ] **Pattern-Analyse im Container**
  - [ ] `mr-bytez-scan-sensitive.fish` Script erstellen
  - [ ] Bestandsaufnahme durchführen
  - [ ] Pattern definieren (Username, Hostnamen, IPs)
- [ ] **Ersetzungs-Strategie**
  - [ ] Username: `mrohwer` → `mr-bytez-admin`
  - [ ] Hostnamen:
    - `n8-kiste` → `mr-bytez-server-file`
    - `n8-vps` → `mr-bytez-server-vps`
    - `n8-station` → `vpn-client-workstation`
    - `n8-book` → `vpn-client-notebook`
  - [ ] IP-Adressen identifizieren & maskieren
- [ ] **Git History Bereinigung**
  - [ ] IM CONTAINER testen mit git filter-repo
  - [ ] Backup erstellen
  - [ ] Entscheidung: History-Bereinigung vs. nur ab jetzt
  - [ ] Force-Push koordinieren

**Referenz:** [Chat: Sensitive Data Cleanup](https://claude.ai/chat/29873ea9-d1f6-4d0e-80e3-098e1e3c4104)

**Status:** Geplant nach Dev Container
**ETA:** März 2026

---

#### Pre-Commit Hooks & Code Quality

**Warum NACH Dev Container?**
- ⚠️ Hook-Development braucht Test-Umgebung
- ⚠️ Linting/Formatting im Container testen

**Milestones:**
- [ ] **Pre-Commit Hooks entwickeln IM CONTAINER**
  - [ ] Format-Checks (Fish, Markdown, YAML)
  - [ ] Lint-Checks (shellcheck, markdownlint)
  - [ ] Secrets-Detection (nie Klartext committen!)
  - [ ] Symlink-Validation
- [ ] **CI-Checks**
  - [ ] Markdown Links & Format
  - [ ] Grundlegende Repo-Policies
- [ ] **Deploy-Checks**
  - [ ] Symlink-Validation
  - [ ] Permissions-Check
  - [ ] Submodule-State-Validation

**Status:** Geplant nach Dev Container
**ETA:** März 2026

---

### 🎨 Priorität 3: ENHANCEMENT (Nice-to-have)

**Impact:** 🔥 MEDIUM - Nützlich, aber nicht kritisch

**Abhängigkeiten:** ✅ Dev Container hilfreich, aber nicht zwingend

#### Chat-Namer Skill (Claude.ai Web/Desktop)

**Warum niedrige Priorität?**
- ℹ️ Nur Convenience-Feature
- ℹ️ Manuelle Benennung funktioniert auch
- ℹ️ Keine Blocker für andere Features

**Milestones:**
- [ ] Skill-Struktur: `.claude/skills/chat-namer/`
- [ ] Template für Namens-Generierung
- [ ] Format: `MR-ByteZ - [kategorie] - Beschreibung - Keywords --- YYYY-MM-DD-HH-MM`
- [ ] Beispiel-Namen & Kategorien
- [ ] **Plattformen:**
  - ✅ Claude.ai Web Interface
  - ✅ Claude Desktop App
  - ❌ Claude Code CLI (keine manuellen Chat-Namen)

**Referenz:** [Chat: Chat-Namer Skill](https://claude.ai/chat/54ddc814-8f3c-4efd-884f-23714d332ab1)

**Status:** Low Priority
**ETA:** Q2 2026 oder später

---

#### Backup & Recovery Automation

**Milestones:**
- [x] GitHub als zusätzliches Remote (Multi-Remote Push)
- [ ] MCP GitHub Server (siehe MCP Server oben)
- [ ] restore.fish Script (Disaster Recovery)
- [ ] Auto-Backup zu Codeberg (Cronjob)
- [ ] Webhosting Backup (Hetzner)

**Status:** Teilweise done, Rest geplant
**ETA:** März-April 2026

---

## Phase 3 - Zusammenfassung

**Kritischer Pfad:**
```
1. Claude Dev Container (ZUERST!) ← 🔴 Nächster Schritt!
    ↓
2. MCP Server Development (im Container)
    ↓
3. Sensitive Data Cleanup (im Container testen)
    ↓
4. Pre-Commit Hooks (im Container entwickeln)
    ↓
5. Chat-Namer Skill (optional)
```

**Status:** Foundation Ready to Start!
**ETA Phase 3:** Februar-März 2026

---

## Phase 4: Expansion (Q2 2026) 📌

**Ziel:** Weitere Hosts & Web-Projekte

### Milestones

- [ ] Submodule: n8-station
- [ ] Submodule: n8-book
- [ ] Submodule: blog.mr-bytez.de (öffentlich)
- [ ] Submodule: shop.mr-bytez.de (öffentlich)
- [ ] Dokumentation vervollständigen
- [ ] Rollback-Playbook (Dokumentation + Routine)
- [ ] Recovery-Runbook (kompakt): „neuer Host → Zugriff → Secrets → Deployment"
- [ ] Secrets-Inventar (`*.info`) vollständig und konsistent halten

**Status:** Geplant
**ETA:** Q2 2026

---

## Kompakt-Übersicht

### ✅ Done

**Repo & Split:**
- Main-Repo `mr-bytez` als public Repo (GitHub + Codeberg)
- Secrets-Repo `mr-bytez-secrets` als private Repo
- Secrets als Submodule: `shared/home/mrohwer/.secrets`
- Multi-Remote Setup (GitHub + Codeberg)

**Deployment-Foundation:**
- Stabiler Anker: `/opt/mr-bytez/current -> /mr-bytez`
- System-Symlinks über Anker (Fish, Micro)
- SSH-Policy: `~/.ssh/config` nicht aus Repo (nur Template)

**Policies & Doku-Baseline:**
- Fish-first Policy (keine Bash-Heredocs, Files via `printf`)
- Token/Key-Policy (cat/bat Alias-Falle)
- "Wichtige MD-Dateien nur additiv ändern" Policy

**.claude/ Migration:**
- `.claude/` Struktur nach 5-3-3 Pattern
- `PROJECT_NOTES.md` aufgeteilt in 11 context/ Dateien
- `CLAUDE.md` als zentrale Steuerung
- Root-Dateien bereinigt (keine verwaisten Referenzen)

### ✅ Done (Doku-Konsolidierung)

- [x] PROJECT_NOTES.md aufgeteilt in `.claude/context/` (11 Dateien)
- [x] .claude/ Struktur nach 5-3-3 Pattern implementiert
- [x] CLAUDE.md, CHANGELOG.md, ROADMAP.md für .claude/ erstellt
- [x] Root-Dateien aktualisiert (README, CHANGELOG, ROADMAP, DEPLOYMENT)
- [x] .gitignore erweitert (Sanitization-Patterns)
- [x] Root CLAUDE.md entfernt (war /init-Artefakt)

### 🛠️ In Progress

**Projects/Submodules:**
- `projects/` Struktur definieren
- Erste Host-/Service-Repos als Submodule

### 📌 Planned - Nach Priorität geordnet

**🔴 HÖCHSTE PRIORITÄT (Foundation - ZUERST!):**
- Claude Development Container (Docker Stack)
  - Blocker für alles andere!
  - Keine Abhängigkeiten
  - Ready to start!

**🟠 HOHE PRIORITÄT (Nach Foundation):**
- MCP Server für n8-vps (RAG + Docker Management)
  - Braucht Dev Container
- Sensitive Data Cleanup (Git History)
  - Braucht sichere Test-Umgebung
- Pre-Commit Hooks & CI
  - Braucht Dev Container

**🟡 MITTLERE PRIORITÄT (Enhancement):**
- Chat-Namer Skill (Claude.ai)
  - Nice-to-have, nicht kritisch
- Backup & Recovery Automation
  - Teilweise done, Rest geplant

**📅 SPÄTER (Phase 4):**
- Weitere Hosts & Web-Projekte

---

## Notizen

- Dieses Dokument ist bewusst high-level
- Operative Schritte gehören in `DEPLOYMENT.md`
- Policies in `.claude/context/`
- Details zu geplanten Features siehe Chat-Referenzen

---

## Chat-Referenzen

Detaillierte Informationen zu geplanten Features finden sich in folgenden Chats:

1. **Claude Dev Container:**
   https://claude.ai/chat/beb70400-561e-4420-8920-86b2fcaf6cbd

2. **Chat-Namer Skill:**
   https://claude.ai/chat/54ddc814-8f3c-4efd-884f-23714d332ab1

3. **Sensitive Data Cleanup:**
   https://claude.ai/chat/29873ea9-d1f6-4d0e-80e3-098e1e3c4104

4. **MCP Server Implementation:**
   https://claude.ai/chat/fd879abe-a618-40b4-bf2a-540854fa6a54

---

**Letzte Aktualisierung:** 2026-02-10
