# ROADMAP.md

**Projekt:** mr-bytez Meta-Repository
**Zweck:** Roadmap & Meilensteine (Projekte + kompakte Uebersicht)
**Erstellt:** 2026-01-22
**Aktualisiert:** 2026-02-26

---

## Leitbild

- Zentrale Verwaltung aller Hosts, Configs & Secrets
- Polyrepo-Ansatz (Submodules fuer Projekte)
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

### ✅ Done

- [x] Fish-Config v2.1 (shared/etc/fish/)
  - [x] Hierarchischer Loader (00-loader.fish)
  - [x] Theme-System (mr-bytez.fish)
  - [x] Modulare Aliases (10-90)
  - [x] Host-spezifische Configs (8 Hosts)
  - [x] Powerline Prompt mit Git/Docker Status
- [x] Micro Editor-Konfiguration (Gruvbox, external Clipboard via xclip)
- [x] Symlink-Strategie vollstaendig dokumentiert (Anker-Modell)
  - [x] Stabiler Anker: `/opt/mr-bytez/current -> /mr-bytez`
  - [x] System-Symlinks laufen ueber den Anker (Fish/Micro)
  - [x] SSH-Policy: `~/.ssh/config` wird nicht deployt (nur Template)

### Offen (jetzt in A-Projekten)

- [ ] Bash-Config → B6 unter Projekt A2
- [ ] mr-bytez-info.fish → B7 unter Projekt A2
- [ ] Docs-Struktur → B8 unter Projekt A3
- [x] Submodule: n8-vps → B9 unter Projekt A1
- [x] Submodule: n8-kiste → B10 unter Projekt A1

**Status:** Done-Anteil abgeschlossen, offene Tasks in Phase 3 integriert

---

## Phase 3: Projekte & Automation (Q1-Q2 2026) 📌

**Strategie:** 5 eigenstaendige Projekte (A1-A5), jeweils mit 5-3-3 Pattern.
Jedes Projekt buendelt verwandte B-Tasks (Root-Aufgaben) und D-Tasks (Sub-Tasks).

**Inventur:** 40 Aufgaben aus 6 Handoff-Dateien + bestehenden Roadmaps kategorisiert.
Details: Inventur wurde in diese ROADMAP integriert (Datei geloescht)

---

### A1: Secrets-Repo Restrukturierung

**Prioritaet:** HOECHSTE — Basis fuer Host-Submodules und SSH-Deployment
**Abhaengigkeiten:** Keine
**5-3-3 Ort:** Im Secrets-Repo selbst (`mr-bytez-secrets`) — hier nur Verweis

**Umfang:**
- Secrets-Submodule (`.secrets/`) auf 5-3-3 Pattern migrieren
- symlinks.db ins private Submodule verschieben
- Eigene CLAUDE.md, ROADMAP.md, README.md, CHANGELOG.md
- Secrets-Inventar vollstaendig und konsistent

**Phase 1 (erledigt):**
- [x] Codeberg-Remote hinzugefuegt (Dual-Remote)
- [x] Submodule verschoben: `shared/home/mrohwer/.secrets/` → `.secrets/`
- [x] 5-3-3 Docs erstellt (README, CLAUDE, CHANGELOG, ROADMAP)
- [x] SECRETS.md aktualisiert (Autor, Pfade)
- [x] .gitignore erstellt
- [x] symlinks.db verschoben + bereinigt (D9)
- [x] SSH-Config erstellt (B1)
- [x] .gitconfig erstellt (B4)
- [x] Context-Dateien im Hauptrepo aktualisiert (7 Dateien)

**Phase 2 (erledigt):**
- [x] Pack-Script: pack-secrets.fish (shared/deployment/)
- [x] Unpack-Script: unpack-secrets.fish (shared/deployment/)
- [x] Deploy-Script: deploy.fish v2.0.0 (.secrets/) — Copy+Symlink, Banner, Sektionen
- [x] Bestehende .age-Dateien ins Archiv ueberfuehrt
- [x] Lokale ~/.secrets/ migriert (91 Dateien, 6,7 MB Archiv)
- [x] generate_pwd.fish ins PUBLIC Repo verschoben
- [x] /etc/hosts fuer 3 Hosts erstellt (B2)
- [ ] Credentials n8-archstick (D13)

**Phase 3 (in Arbeit):**
- [x] Submodule n8-vps einrichten (B9) — Workaround: git clone statt Submodule-Init (#SEC01.4)
- [x] Submodule n8-kiste verifizieren (B10) — deploy.fish v2.0 erfolgreich
- [x] Passphrase-Fix: --with-host → --with-username (Archiv gleich auf allen Hosts)
- [x] deploy.fish Bugfix: sudo command → sudo (Fish-Builtin-Kompatibilitaet)
- [x] unpack-secrets.fish v1.1: temp-Verzeichnis (kein Datenverlust bei falscher Passphrase)
- [x] AddressFamily inet fuer Codeberg (IPv6-Problem auf n8-vps)
- [x] RECOVERY.md v1.1 erstellt (Disaster Recovery Anleitung)
- [x] Deploy auf n8-vps verifiziert — SSH + Dual-Remote funktioniert
- [x] Deploy auf n8-station — deploy.fish v0.3.0 (ohne-sudo Architektur)

**Mitlaufende Tasks:**
- D13: Credentials n8-archstick aktualisieren (Phase 2)

**Details:** `.claude/context/handoffs/HANDOFF_[Secrets][Structure]_a1-secrets-repo-restrukturierung.md`

**Status:** Phase 1+2+3 erledigt (alle 3 Hosts deployed + verifiziert)
**ETA:** Februar-Maerz 2026

---

### A2: Fish DRY-Refactoring

**Prioritaet:** Hoch — betrifft alle 8 Hosts, reduziert Duplikation
**Abhaengigkeiten:** Keine
**5-3-3 Ort:** `shared/etc/fish/`

**Umfang:**
- Komplettes DRY-Refactoring der Fish Shell Config
- Neues Nummerierungsschema 000-200 (Shared/Host)
- Feature-Flags (`MR_HAS_GUI`, `MR_IS_DEV`, `MR_DISPLAY_TYPE`)
- Shared Conditionals, Loader-Umbau
- 7-Phasen-Plan
- Paket-Inventur: pacman/yay/flatpak pro Host (Basis fuer Feature-Flags)

**Mitlaufende Tasks:**
- B2: /etc/hosts Dokumentation
- B3: README Struktur-Baum pruefen/fixen
- B4: Git-Config Shared
- B5: SMB-Shares Deployment (nach A2)
- B6: Bash-Config (parallel planen)
- B7: mr-bytez-info.fish (nutzt neue Metadaten-Tags)
- B17: VLC Desktop-Paketliste (Sub-Task von B5)

**Details:** `.claude/context/handoffs/HANDOFF_[Fish][Refactor]_fish-dry-refactoring.md`

**Status:** Geplant
**ETA:** Februar-Maerz 2026

---

### A3: Claude Dev Container

**Prioritaet:** Hoch — isolierte Entwicklungsumgebung fuer A4 und A5
**Abhaengigkeiten:** Keine
**5-3-3 Ort:** `shared/stacks/mrbz-dev/`

**Umfang:**
- Docker Stack (Dockerfile, docker-compose.yml, .devcontainer)
- Arch Linux Container mit Fish, Claude Code, Tools
- mr-bytez Integration (Anker, Symlinks)
- VS Code Dev Container Support

**Mitlaufende Tasks:**
- B8: Docs-Struktur (im Container testen)
- B11: Pre-Commit Hooks (im Container entwickeln)
- B13: Backup & Recovery (restore.fish im Container testen)
- D12: Projekt-Level .claude/ fuer mrbz-dev
- D15: Rollback-Playbook
- D16: Recovery-Runbook

**Details:** `.claude/archive/mrbz-dev-plan.md`
**Chat:** [Claude Dev Container](https://claude.ai/chat/beb70400-561e-4420-8920-86b2fcaf6cbd)

**Status:** Geplant
**ETA:** Maerz 2026

---

### A4: MCP Server

**Prioritaet:** Mittel — braucht Dev Container (A3)
**Abhaengigkeiten:** A3 (Claude Dev Container)
**5-3-3 Ort:** `projects/infrastructure/mcp-server/`

**Umfang:**
- TypeScript MCP Server mit 5 Tools (Filesystem, Docker, Git, Database, RAG)
- Qdrant Vector DB, Traefik Reverse Proxy
- Bearer Token Auth → Authentik OAuth2
- Production Deployment auf n8-vps

**Prerequisite: Traefik Setup (B14)**
- DNS Wildcard Records: ✅ erledigt
- API-Token Age-Verschluesselung (D3)
- Traefik ACME DNS-01 (D14)
- DNS TTL hochsetzen (D1)
- PTR-Records setzen (D2)
- Alte API-Tokens aufraeumen (D4)

**Mitlaufende Tasks:**
- B12: Chat-Namer Skill (kann MCP-Integration nutzen)
- D17: Automatische Context-Synchronisation

**Details:** `.claude/context/handoffs/HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md` (Traefik/DNS)
**Chat:** [MCP Server Implementation](https://claude.ai/chat/fd879abe-a618-40b4-bf2a-540854fa6a54)

**Status:** Geplant nach A3
**ETA:** Maerz-April 2026

---

### A5: Sensitive Data Cleanup

**Prioritaet:** Mittel — braucht Dev Container (A3) zum sicheren Testen
**Abhaengigkeiten:** A3 (Claude Dev Container)
**5-3-3 Ort:** `.claude/projects/sensitive-data-cleanup/`

**Umfang:**
- Pattern-Scanner Script (Fish)
- Clean/Smudge Filter (bidirektional, .gitattributes)
- Hostname/Username/IP Mapping
- Git History Bereinigung (git filter-repo) — Entscheidung noch offen

**Mitlaufende Tasks:**
- D5: Clean/Smudge Filter implementieren
- D6: Pattern-Scanner Script erstellen
- D7: IP-Adressen-Mapping definieren
- B3: README Struktur-Baum nochmal pruefen (nach History-Rewrite)

**Details:** `.claude/context/handoffs/HANDOFF_[Security][Git]_git-filter-cleanup.md`
**Chat:** [Sensitive Data Cleanup](https://claude.ai/chat/29873ea9-d1f6-4d0e-80e3-098e1e3c4104)

**Status:** Geplant nach A3
**ETA:** April 2026

---

## Timing-Matrix

```
C1+C2 Policies (Chat-Benennung v2, TAG_REGISTRY) ✅ erledigt
  ↓
A1 Secrets-Repo Restrukturierung + B1✅, B4✅, B9✅, B10✅, D9✅ — Phase 1+2 erledigt, Phase 3 in Arbeit (D13 offen)
  ↓
A2 Fish DRY-Refactoring + B2, B3, B6, B7 → danach B5+B17
  ↓
A3 Claude Dev Container + B8, B11, B13, D12, D15, D16
  ↓
A4 MCP Server + B14 (Traefik zuerst!), D1-D4, D14, D17 → danach B12
  ↓
A5 Sensitive Data Cleanup + D5-D7 → danach B3 nochmal pruefen
```

**Inkrementell (kein fester Zeitpunkt):**
- D10: Skills entwickeln — pro A-Projekt
- D11: Configs anlegen — pro A-Projekt

---

### A6: Cloud-Sync (rclone crypt)

**Prioritaet:** Niedrig — nach A1 Phase 2
**Abhaengigkeiten:** A1 Phase 2 (Archiv-Modell muss stehen)
**5-3-3 Ort:** Im Secrets-Repo (`.secrets/`)

**Umfang:**
- Home-Ordner (Dokumente, Bilder, Downloads) verschluesselt auf Google Drive (2TB)
- rclone crypt: Clientseitige Verschluesselung (Dateinamen + Inhalte)
- rclone.conf im Secrets-Archiv (OAuth-Tokens + crypt-Passphrase)
- systemd-User-Units fuer Auto-Mount beim Login

**Status:** Geplant
**ETA:** Q2 2026

---

## Phase 4: Expansion (Q2 2026) 📌

**Ziel:** Weitere Hosts & Web-Projekte

### Milestones

- [ ] B18: Submodule n8-station
- [ ] B18: Submodule n8-book
- [ ] B16: blog.mr-bytez.de (oeffentlich)
- [ ] B16: shop.mr-bytez.de (oeffentlich)

**Status:** Geplant
**ETA:** Q2 2026

---

## Kompakt-Uebersicht

### ✅ Done

**Repo & Split:**
- Main-Repo `mr-bytez` als public Repo (GitHub + Codeberg)
- Secrets-Repo `mr-bytez-secrets` als private Repo
- Secrets als Submodule: `shared/home/mrohwer/.secrets`
- Multi-Remote Setup (GitHub + Codeberg)

**Deployment-Foundation:**
- Stabiler Anker: `/opt/mr-bytez/current -> /mr-bytez`
- System-Symlinks ueber Anker (Fish, Micro)
- SSH-Policy: `~/.ssh/config` nicht aus Repo (nur Template)

**Policies & Doku-Baseline:**
- Fish-first Policy (keine Bash-Heredocs, Files via `printf`)
- Token/Key-Policy (cat/bat Alias-Falle)
- "Wichtige MD-Dateien nur additiv aendern" Policy

**.claude/ Migration:**
- `.claude/` Struktur nach 5-3-3 Pattern
- `PROJECT_NOTES.md` aufgeteilt in 11 context/ Dateien
- `CLAUDE.md` als zentrale Steuerung
- Root-Dateien bereinigt (keine verwaisten Referenzen)

**C1+C2 Policies:** ✅
- Chat-Benennung v2 (Format, Ketten-System, Datum-Ermittlung)
- Tag-Registry mit 67 Tags (3-Zeichen-Index, generisch + dienst-spezifisch)
- Handoff-Policy definiert + Ordner umstrukturiert
- Context-Audit: structure.md, integration.md, infrastructure.md aktualisiert
- Opus 4.6 Features in integration.md dokumentiert
- migration.md archiviert (alle Schritte erledigt)

**DNS-Infrastruktur:**
- Wildcard A+AAAA Records fuer `*.mr-bytez.de` → n8-vps
- Hetzner Console API + hcloud CLI eingerichtet
- CAA Records fuer Let's Encrypt (issue + issuewild)

### 📌 Projekte (Phase 3) — Nach Reihenfolge

| Projekt | Beschreibung | Abhaengigkeit | ETA |
|---------|-------------|---------------|-----|
| **A1** Secrets-Repo | 5-3-3 Migration, SSH-Config, Submodules | Keine | Feb 2026 |
| **A2** Fish DRY | Nummerierung 000-200, Feature-Flags, 8 Hosts | Keine | Feb-Maerz 2026 |
| **A3** Dev Container | Docker Stack, Claude Code, VS Code | Keine | Maerz 2026 |
| **A4** MCP Server | TypeScript, Traefik, RAG, n8-vps | A3 | Maerz-Apr 2026 |
| **A5** Data Cleanup | Clean/Smudge Filter, History Rewrite | A3 | Apr 2026 |

### 📅 Expansion (Phase 4)

- Submodule n8-station, n8-book
- Web-Projekte blog/shop

---

## B-Tasks Zuordnung (Referenz)

| # | Aufgabe | Projekt | Quelle |
|---|---------|---------|--------|
| B1 | SSH-Config Secrets-Deployment | A1 | ✅ Phase 1 erledigt |
| B2 | /etc/hosts Dokumentation | A1 | ✅ Phase 2 erledigt (3 Hosts) |
| B3 | README Struktur-Baum | A2 + A5 | `HANDOFF_2026-02-08.md`, Aufgabe 3 |
| B4 | Git-Config Shared | A1 | ✅ Phase 1 erledigt |
| B5 | SMB-Shares Deployment | A2 | `HANDOFF_SMB_DEPLOYMENT.md` |
| B6 | Bash-Config | A2 | Phase 2 (offen) |
| B7 | mr-bytez-info.fish | A2 | Phase 2 (offen) |
| B8 | Docs-Struktur | A3 | Phase 2 (offen) |
| B9 | Submodule n8-vps | A1 | ✅ Phase 3 erledigt (Workaround) |
| B10 | Submodule n8-kiste | A1 | ✅ Phase 3 erledigt |
| B11 | Pre-Commit Hooks | A3 | Phase 3 (alt) |
| B12 | Chat-Namer Skill | A4 | Phase 3 (alt) |
| B13 | Backup & Recovery | A3 | Phase 3 (alt) |
| B14 | Traefik Setup | A4 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| B15 | Host-zu-Host SSH-Config (Ports, Keys, Hostnamen fuer eigene Hosts) | A1 | Phase 3 |
| B16 | Web-Projekte (blog, shop) | Phase 4 | Phase 4 |
| B17 | VLC Desktop-Paketliste | B5/A2 | `HANDOFF_SMB_DEPLOYMENT.md` |

---

## D-Tasks Zuordnung (Referenz)

| # | Sub-Task | Projekt | Quelle |
|---|----------|---------|--------|
| D1 | DNS TTL hochsetzen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D2 | PTR-Records setzen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D3 | API-Token Age-Verschluesselung | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D4 | Alte API-Tokens aufraeumen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D5 | Clean/Smudge Filter | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D6 | Pattern-Scanner Script | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D7 | IP-Adressen-Mapping | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D9 | symlinks.db verschieben | A1 | ✅ Phase 1 erledigt |
| D10 | Skills entwickeln | Inkrementell | Pro A-Projekt |
| D11 | Configs anlegen | Inkrementell | Pro A-Projekt |
| D12 | Projekt-Level .claude/ | A3 | Fuer mrbz-dev |
| D13 | Credentials n8-archstick | A1 | `HANDOFF_SMB_DEPLOYMENT.md` |
| D14 | Traefik ACME DNS-01 | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D15 | Rollback-Playbook | A3/B13 | Phase 4 (alt) |
| D16 | Recovery-Runbook | A3/B13 | Phase 4 (alt) |
| D17 | Automatische Context-Sync | A4 | `.claude/ROADMAP.md` Phase 5 |

Alle aktiven Handoffs liegen unter `.claude/context/handoffs/`.

---

## Notizen

- Dieses Dokument ist bewusst high-level
- Operative Schritte gehoeren in `DEPLOYMENT.md`
- Policies in `.claude/context/`
- Details zu A-Projekten in den jeweiligen Handoff-Dateien (siehe Verweise)
- Aktive Handoffs: `.claude/context/handoffs/`

---

## Chat-Referenzen

1. **Claude Dev Container (A3):**
   https://claude.ai/chat/beb70400-561e-4420-8920-86b2fcaf6cbd

2. **Chat-Namer Skill (B12):**
   https://claude.ai/chat/54ddc814-8f3c-4efd-884f-23714d332ab1

3. **Sensitive Data Cleanup (A5):**
   https://claude.ai/chat/29873ea9-d1f6-4d0e-80e3-098e1e3c4104

4. **MCP Server Implementation (A4):**
   https://claude.ai/chat/fd879abe-a618-40b4-bf2a-540854fa6a54

---

**Letzte Aktualisierung:** 2026-02-25
