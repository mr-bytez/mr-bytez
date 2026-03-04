# CHANGELOG.md

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

---

## [Unreleased]

### Changed
- [Docs][Audit] ROADMAP-Audit: 8 ROADMAPs geprueft, 7 Fixes angewendet
  - Root ROADMAP: Kompakt-Tabelle A1-A5 korrigiert (Status, Abhaengigkeiten, ETAs)
  - Root ROADMAP: Quick Win "Port 22" als erledigt markiert, Format-Library Beschreibung aktualisiert
  - Fish ROADMAP: Toten Handoff-Verweis entfernt (HANDOFF_Fish_Refactor nicht mehr existent)
  - MCP-Server CLAUDE.md: Toten Handoff-Verweis durch Root ROADMAP Referenz ersetzt
  - .claude/ROADMAP.md: Version 1.0.0→0.4.0 (Versionierungs-Policy), Hooks-Status aktualisiert
- [Docs][Config] Projektanweisungen: 7 Bugfixes (Header .md→.txt, Delegation-Duplikate entfernt,
  n8-vps Status aktualisiert, A2-A5 Status mit Root ROADMAP synchronisiert)
- [Docs][Structure] n8-vps Service-Pipeline in Projekt-ROADMAP verschoben
  Root ROADMAP verweist jetzt auf projects/infrastructure/n8-vps/ROADMAP.md
  n8-vps Docs (CLAUDE.md, README, Server-Doku) verweisen auf eigene ROADMAP
  (5-5-3 Konvention: Projekte fuehren eigene Planung, Root nur Verweis)
- [Docs][Config] Task-Format + Selbst-Verifikation als Workflow-Regeln verankert
  - claude-ai-projektanweisungen.txt: task/mintask Keywords (Ziel+Kontext statt Schritt-fuer-Schritt)
  - policies.md: Claude Code Selbst-Verifikation vor jedem Commit (5 Pruefschritte)
- [Fish][Theme][ClaudeCode] Prompt-Farben + Statusline v0.3.0:
  - Theme: n8-kiste BG dunkelgruen (#145a32), n8-station Text weiss, Sudo-User dunkel (#1e1e2e)
  - Statusline: Context-Fortschrittsbalken mit Farbschwellen (gruen/gelb/rot)
  - Statusline: OAuth Usage API — 5h/7d Nutzungslimits mit Reset-Zeit
  - Statusline: Kosten-Block ($X.XX), Git-Cache (5s), Usage-Cache (60s)
  - Statusline: Wiederverwendbare Balken-Funktion, Null-Safety durchgehend

### Added
- [VPS][SEC][Auth][DKR] CrowdSec Middleware + Authentik Forward-Auth fuer Traefik
  - CrowdSec Bouncer Middleware (`crowdsec-bouncer@file`) auf allen oeffentlichen Routern aktiviert:
    Dashboard (`traefik.mr-bytez.de`), Authentik (`auth.mr-bytez.de`)
  - Authentik Forward-Auth Middleware erstellt: `config/dynamic/authentik.yml`
    forwardAuth via Embedded Outpost (`mrbz-authentik-server:9000`)
  - Outpost-Router Labels auf Authentik Server (Priority 200, Auth-Loop-Schutz)
  - Dashboard-Router: BasicAuth durch Authentik Forward-Auth ersetzt
  - CrowdSec Bouncer: `crowdsecMode: stream` + `updateMaxFailure: 5` (Best Practice aus Docs)
  - Forward-Auth: `X-authentik-entitlements` Header ergaenzt (neu seit Authentik 2026.x)
- [VPS][SEC][DKR] CrowdSec Stack + Traefik Plugin + CSP-Header
  - CrowdSec Stack angelegt: projects/infrastructure/n8-vps/stacks/crowdsec/
    Docker Agent (mrbz-crowdsec), LAPI auf 127.0.0.1:8080, Subnet 172.21.0.0/24
    Collections: traefik, http-cve, http-probing, base-http-scenarios
  - Traefik: Access-Log auf JSON-Format (CrowdSec-Kompatibilitaet)
  - Traefik: CrowdSec Bouncer Plugin registriert (v1.5.1)
  - middlewares.yml: crowdsec-bouncer Middleware + CSP-Header ergaenzt
  - Architektur: Docker Agent + Traefik Plugin + Firewall Bouncer (systemd, manuell)
  - docker-compose.yml, .env.example, README.md, DEPLOYMENT.md, config/acquis.yaml
- [VPS][Auth][DKR] Authentik SSO Stack fuer n8-vps erstellt
  - docker-compose.yml: 4 Services (postgres, valkey, server, worker)
  - Subnet 172.20.0.0/24, Container mrbz-authentik-*, Worker-Tuning 4x4
  - Traefik-Labels fuer auth.mr-bytez.de (websecure, letsencrypt-production)
  - .env.example (Secrets-Pfade via file://-Pattern)
  - README.md + DEPLOYMENT.md (3-Phasen-Anleitung)
- [Structure][Docs] n8-vps 5-5-3 Migration — 6 Docs erstellt
  (README, CHANGELOG, ROADMAP, DEPLOYMENT, CLAUDE.md, hardware.md)
- [Structure] hwi.sh Versionierung auf SemVer normalisiert (3.1.1 → 0.3.2),
  Bash-Header + Markdown-Header-Generierung
- [Docs][Infra] ROADMAP zum Master-Arbeitsplan erweitert:
  n8-vps Service-Pipeline (10 Schritte), UFW Deployment (Ist-Zustand 3 Hosts),
  Quick Wins, SMB, Empfohlene Reihenfolge
- [Docs] UFW Ist-Zustand aller 3 Hosts in ROADMAP dokumentiert
  (n8-vps: 6 Regeln, n8-kiste: 20 Regeln, n8-station: nicht installiert)
- [Docs][Infra] Strategische Uebersicht Maerz 2026 erstellt (Pipeline, Quick Wins, Handoff-Status)
- [Traefik][Docker] Traefik v3.6 Reverse Proxy Stack fuer n8-vps erstellt + deployed
  - docker-compose.yml: mrbz-traefik Container, Ports 80/443, mrbz-proxy-net
  - traefik.yml: Statische Config (EntryPoints, Docker+File Provider, ACME DNS-01 Hetzner)
  - middlewares.yml: Security-Headers Middleware (HSTS, X-Frame-Options, CSP)
  - .env.example: Platzhalter fuer Hetzner API-Token + BasicAuth Hash (bcrypt, $$-Escaping)
  - README.md + DEPLOYMENT.md: Stack-Doku + 3-Phasen Deployment-Anleitung
  - Pfad: projects/infrastructure/n8-vps/stacks/traefik/
  - Deployment auf n8-vps: Phase 2+3 erfolgreich (Dashboard 401, LE-Cert, whoami-Test)
  - Fixes: Unbound auf 0.0.0.0 (Docker DNS), UFW Docker-Regeln, Hetzner Robot UDP-Regel
- [Docs][Infra] n8-vps Server-Dokumentation erstellt (Ist-Zustand, geplante Services, Schritt-fuer-Schritt)
  - Server-Steckbrief (Hetzner EX63, Falkenstein, E5-2650v4, 128GB RAM)
  - Kompletter Ist-Zustand (Phase 0-4 + mr-bytez Deployment + DNS)
  - Geplante Services (14 Stacks, 30 Services aus Master-Planung)
  - 10-Schritte Umsetzungsplan (Traefik → Authentik → ... → Produktiv-Services)
  - Pfad: projects/infrastructure/n8-vps/docs/n8-vps-server-dokumentation.md

### Changed
- [Docs] n8-vps Server-Doku verschlankt — Verweise auf Root ROADMAP, Header-Format korrigiert
- [Docs][Infra] n8-vps Server-Doku: Schritt 1+2 ✅, Port 22 entfernt, Handoff-Verweise aktualisiert
- [Docs] ROADMAP: A1 komplett ✅, A3 zurueckgestellt, A4/A5 Abhaengigkeiten korrigiert
- [Docs] Handoff-Policy: Dauerhafte Tasks → ROADMAP, Handoffs nur fuer Uebergaben
- [Docs] infrastructure.md: Port 22 Fallback bei n8-vps entfernt
- [Docs][Infra] Strategische Uebersicht: Quick Wins aktualisiert
- [Deploy][Secrets] deploy.fish v0.5.1 — Reflector Country-Filter + Threads:
  - --country Germany,France,Netherlands,Austria,Switzerland (nur EU-Nachbarn statt weltweit)
  - --threads 5 (parallele Mirror-Tests)
  - Laufzeit von 5+ Minuten auf ~30 Sekunden reduziert
- [Deploy][Config] reflector.conf v0.5.1 — Country-Filter + Threads synchronisiert
- [Deploy][Config] Fallback-Mirrorlist aktualisiert (reflector Top 20 DE/FR/NL/AT/CH, tote Mirrors entfernt)
- [Deploy][Secrets] deploy.fish v0.5.0 — Paketmanager-Updates + Reflector-Integration:
  - Phase 1: pacman -Syu + yay -Syu + flatpak update VOR Paketinstallation
  - reflector: Live-Mirrorlist + Fallback, reflector.conf + reflector.timer
  - Flatpak mit sudo, Zusammenfassungs-Box dynamische Breite
- [Deploy][Secrets] deploy.fish v0.4.0 — Full-Bootstrap mit 7 Fixes aus Live-Test:
  - Fix 1: Flatpak `--system` Flag bei install + info (vermeidet interaktive Abfrage)
  - Fix 2: FISH_LOADER_DEBUG unterdrueckt (kein [loader] Output im Deploy)
  - Fix 3: .bak Backup wird immer ueberschrieben (aktuellstes Backup)
  - Fix 4: Zusammenfassungs-Box zeigt alle Phasen (Pakete, Symlinks, Shell, Secrets)
  - Fix 5: --gui/--dev werden bei --secrets-only ignoriert (Warnung statt Fehler)
  - Fix 6: pacman/flatpak non-interactive (--noconfirm, --system)
  - Fix 7: --verbose Flag (Paket-Details, Secrets-Pfade mit Permissions)
- [Deploy][Secrets] deploy.fish: Phase 0 prueft yay + flatpak (Info, kein Abbruch)
- [Deploy][Secrets] deploy.fish: Usage mit Erstinstallations-Anleitung (6 Schritte)
- [Deploy][Secrets] deploy.fish: ln Output unterdrueckt (nur eigene Meldungen)
- [Deploy][Secrets] deploy.fish: Version 1.0.0 → 0.4.0 (Beta, erster Live-Test)
- [ClaudeCode][Config] Claude Code Statusline eingerichtet (shared/etc/claude-code/statusline.sh)
  - Zeigt Model, Verzeichnis, Git-Branch, Kosten, Lines Added/Removed
  - ANSI-Farben (Gruvbox), jq-basiert, Bash-Script ueber Symlink ~/.claude/statusline.sh
  - settings.json: statusLine type=command konfiguriert
- [Cleanup][Fish] command-Prefix Cleanup: `command cat/grep/du/awk/...` → direkte Aufrufe (15 Dateien)
  - Policies aktualisiert: shell.md, security.md, CLAUDE.md, deploy-agent, scaffold-agent
  - Fish-Configs: 040-fastfetch.fish, 005-theme.fish, host-test.fish, config.fish
  - Scripts: scan-secrets.fish, generate_pwd.fish, pack-secrets.fish, unpack-secrets.fish
  - Hintergrund: Seit A2 Phase 1 sind alle coreutils alias-frei, `command`-Prefix war unnoetig
- [Docs][Cleanup] Box-Header fuer 5 Deployment-Scripts (derive_key, generate_pwd, pack/unpack-secrets, derive_key.README)
- [Infra][Docs] n8-vps Server-Dokumentation aktualisiert: UFW Docker-Regeln, Hetzner Robot Firewall komplett, Unbound Docker-Config
- [Fish] config.fish: Loader-Pfad 000-loader.fish (statt 00-loader.fish), Debug deaktiviert
- [Traefik] traefik.yml: Externe DNS-Resolver entfernt (Docker-interner DNS → Host Unbound)
- [DNS][Infra] DNS-Handoff aktualisiert: Traefik-Tasks ausgelagert, Status angepasst
  - Prioritaet 1 (Traefik) → eigener Handoff, Prioritaet 2+3 bleiben (TTL, PTR, Cleanup)
- [Security][Git] A5 Entscheidung dokumentiert: History-Rewrite mit git filter-repo bei A5
  - Repo bleibt privat bis A5, dann oeffentlich
  - ROADMAP.md + Git-Filter-Handoff aktualisiert
- [Docs] claude-ai-projektanweisungen.txt: Hostname-Salt → Username-Salt, Alias-Dateinamen 0xx, Loader 000, A1-Status
- [Docs] security.md: Verboten-Eintrag aktualisiert (cat-Alias existiert nicht mehr)
- [Docs] shared/etc/fish/CLAUDE.md: Kaputte Handoff-Referenz entfernt
- [Deploy][Config] shared/etc/pacman.d/mirrorlist: Fallback-Mirrorlist (10 DE + 3 EU)
- [Deploy][Config] shared/etc/xdg/reflector/reflector.conf: Reflector-Konfiguration
- [Fish][Packages] Paketlisten korrigiert: min-packages.txt + desktop-packages.txt (Duplikate entfernt, Sektionen bereinigt, reflector hinzugefuegt)
- [Secrets] Submodule aktualisiert (deploy.fish v0.4.0, Box-Header, command-Cleanup)

### Removed
- [Cleanup] Handoff-Konsolidierung — 6 Handoffs aufgeloest:
  A1-Secrets, SMB-Deploy, DNS-Traefik, Git-Filter, Fish-Format, Strategische Uebersicht
  Alle offenen Tasks in ROADMAP.md konsolidiert
  Verbleibend: 1 Handoff (mr-bytez-learn — eigenes Projekt)
- [Cleanup] A1 Handoff geloescht (alle Phasen erledigt, D13 → Phase 4)
- [Cleanup] Traefik-Handoff geloescht (alle 3 Phasen erledigt): HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md
- [Cleanup] INF01 Chat-Uebergabe geloescht (obsolet): HANDOFF_[Infra][Traefik]_chatuebergabe-INF01.md

---

## [0.15.2] - 2026-03-01

### Removed
- [Cleanup] 4 A2-Reports geloescht (Einmal-Artefakte, Ergebnisse umgesetzt):
  REPORT_A2_VERIFIKATION, REPORT_A2_VERIFIKATION_TEIL2,
  REPORT_HOST_CONFIG_INVENTUR, REPORT_ALTES_REPO_INVENTUR
- [Cleanup] UEBERGABE_FSH01.3 geloescht (obsolete Chat-Uebergabe)
- [Cleanup] TASK_HEADER_AUDIT geloescht (Fish-Dateien in A2 Phase 2 standardisiert,
  Deployment-Scripts Kosmetik = niedrige Prio)

### Changed
- [Docs] Fish Theme Handoff aktualisiert: format.fish + pack/unpack-secrets Migration
  als erledigt markiert (A2 Phase 3), Restpunkte dokumentiert (deploy.fish, derive_key.fish)

---

## [0.15.1] - 2026-03-01

### Fixed
- [ClaudeCode][Agents] audit-agent v0.2.0: Bash-Hook Regex-Fix
  - Alter Regex `^\s*(rm|...)` pruefte nur Zeilenanfang — `cd /foo; git push` wurde nicht geblockt
  - Neuer Regex `(^|\s|;|&&|\|)\s*(rm|...)` durchsucht gesamten Command-String
  - Zusaetzliche schreibende Befehle geblockt: git rm, git reset, git checkout, tee, dd, truncate
  - Sub-Agent Warnung ergaenzt (erbt moeglicherweise Permissions des aufrufenden Agents)
  - Lesson Learned: Audit-Agent hat in A2 Phase 6 eigenmaechtig committet+gepusht

---

## [0.15.0] - 2026-03-01

### Added
- [Fish][Refactor][Docs] A2 Phase 5+6 — Tests bestanden, Docs finalisiert, B-Tasks erledigt
  - Phase 5: Tests auf n8-kiste, n8-vps, n8-station bestanden (PASS)
  - Phase 6: shell.md ueberarbeitet (neues Nummerierungsschema, Feature-Flags, Self-Check, einschleifiger Loader)
  - Phase 6: deployment.md aktualisiert (neue Dateinamen, Lesson #28 Rename-Hinweis)
  - Phase 6: skills/ erstellt: NEUER_HOST.md, NEUES_CONDITIONAL.md, DEBUGGING.md
  - B3: Root-README Struktur-Baum aktualisiert (Secrets-Pfad, shared/lib/, shared/packages/)
  - B6: Minimale .bashrc erstellt (shared/etc/bash/.bashrc, Fish-Weiterleitung + Bash-Fallback)
  - B7: mr-bytez-info.fish v0.5.0 — Alias-Listen komplett auf IST-Stand (Phase 1-4)
  - B17: VLC bereits in desktop-packages.txt vorhanden — kein Handlungsbedarf
  - A2 abgeschlossen (Phase 0-6), Restposten: n8-book + n8-archstick (physischer Zugang)
  - Audit: Veraltete Referenzen bereinigt (DEPLOYMENT.md, infrastructure.md, structure.md)
    - DEPLOYMENT.md: 00-loader.fish → 000-loader.fish, Fish Shell v2.0 neutralisiert, Stand-Datum
    - infrastructure.md: Nummerierungsschema 70-89 → 100-200 korrigiert
    - structure.md: Falsche DEPLOYMENT.md-Aussage korrigiert, conf.d/ ergaenzt

---

## [0.14.0] - 2026-02-28

### Changed
- [Fish][Refactor] A2 Phase 4 — Loader-Umbau (einschleifig)
  - 000-loader.fish v0.5.0: 8 Sektionen mit Range-Filtern → 1 Schleife ueber 6 Verzeichnisse
  - Nummerierungsschema: Shared 000-099, Host 100-200, Glob sortiert automatisch
  - `10-paths.fish` → `010-paths.fish` umbenannt (zero-padded, Konsistenz)
  - mr-bytez-info.fish v0.4.0: Feature-Flags (MR_HAS_GUI/MR_IS_DEV/MR_DISPLAY_TYPE) in Diagnose
  - mr-bytez-info.fish: Desktop/Server-Switch durch MR_HAS_GUI-Check ersetzt, N8_HOST_TEST entfernt

---

## [0.13.0] - 2026-02-28

### Added
- [Fish][Refactor] A2 Phase 3 — Conditionals + DRY + format.fish
  - `shared/lib/format.fish` erstellt: Zentrale Formatting-Library (10 Funktionen)
  - `050-gui.fish` erstellt: GUI-Conditionals mit Self-Check (MR_HAS_GUI)
    - Updates mit Flatpak (upa, upall), Flatpak standalone (upfl, upflc, flathub)
    - Cleanup (upclean), Check (upchk), Power-Management (zzz, zzzh, zzzx)
  - `055-dev.fish` erstellt: DEV-Conditionals mit Self-Check (MR_IS_DEV), Platzhalter
  - `upa` (Server-Version ohne Flatpak) in 035-pacman.fish ergaenzt
  - Display-Variablen (GDK_SCALE, QT_SCALE_FACTOR) in 008-host-flags.fish konsolidiert
  - 8x `80-n8-*.fish` → `110-n8-*.fish` umbenannt (git mv)
  - Loader temporaer erweitert (80-89 → 80-199, wird in Phase 4 ersetzt)

### Removed
- 7x `70-desktop.fish` geloescht (aufgegangen in shared 050-gui.fish)
- 1x `70-server.fish` geloescht (Duplikate in shared 020-docker/030-systemd/035-pacman)
- 6x `10-display.fish` + 2x `10-host.fish` geloescht (konsolidiert in 008-host-flags.fish)

### Changed
- `pack-secrets.fish` + `unpack-secrets.fish`: Auf format.fish Library umgestellt
- 008-host-flags.fish v0.2.0: Display-Skalierung pro Host ergaenzt
- 035-pacman.fish v0.4.0: upa ergaenzt, Kommentare auf 050-gui.fish Verweis aktualisiert

---

## [0.12.0] - 2026-02-28

### Fixed
- [Fish][Hotfix] A2 Phase 2 Hotfix — Loader-Fix + Header-Audit
  - 000-loader.fish: Theme-Referenz 00-theme→005-theme + 008-host-flags.fish eingebunden
  - mr-bytez-info.fish: Loader-Referenz 00-loader→000-loader gefixt
  - fish_prompt/fish_right_prompt: Theme-Referenz korrigiert
  - 14 Shared Fish-Dateien: Einheitliche 7-Feld Header standardisiert
  - banner.fish: Header standardisiert
  - Validierung: Host-Flags, Alias-Sicherheit, coreutils frei — alles gruen

---

## [0.11.0] - 2026-02-28

### Added
- [Fish][Refactor] A2 Phase 2 — Nummerierung + Host-Flags
  - `008-host-flags.fish` erstellt: Feature-Flags per switch/case fuer alle 8 Hosts
  - 8 Shared Aliases umbenannt: 10→010, 20→015, 30→020, 40→025, 50→030, 60→035, 65→040, 90→045
  - 2 Conf.d umbenannt: 00-loader→000-loader, 00-theme→005-theme
  - Einheitliche Header + Aktualisiert-Feld + Autor MR-ByteZ in allen 11 Dateien

---

## [0.10.0] - 2026-02-28

### Added
- [Fish][Docs] A2 Phase 0 — Vorbereitung + Docs fuer Fish DRY-Refactoring
  - Paketlisten angelegt: `shared/packages/` (min, desktop, dev) mit pacman/yay/flatpak Sektionen
  - 5-5-3 Docs in `shared/etc/fish/` befuellt: README.md, DEPLOYMENT.md, CLAUDE.md, CHANGELOG.md, ROADMAP.md
  - Architektur-Docs in `.claude/context/` erstellt: ARCHITEKTUR.md, HOST_MATRIX.md, MIGRATION.md
- [Fish][Refactor] A2 Phase 1 — Alias-Umbenennung (Originale freilassen)
  - HOCH-Risiko: cat→bcat, ls→el, grep entfernt, df→duf, du→dust
  - MITTEL-Risiko: rm→rmi, cp→cpi, mv→mvi
  - Originale (cat, ls, grep, df, du, rm, cp, mv) komplett alias-frei

### Changed
- [ClaudeCode][Agents] Header-Standardisierung: YAML-Keys Englisch → Deutsch (4 Agents)
- [ClaudeCode][Hooks] Aktualisiert-Feld + Alignment in allen 7 Hooks
- [ClaudeCode][Agents] scaffold-agent v0.2.0: Aktualisiert-Feld in allen 8 Dateityp-Templates, Typ 8 (.txt) neu, Versionierungsregel (1.0.0 erst nach 6 Monaten)
- [Fish] Versionen korrigiert: 10-nav, 20-eza, 90-misc auf 0.3.1
- Referenz: Handoff v3.0, Chat #FSH01.4

---

## [0.9.0] - 2026-02-27

### Added
- [ClaudeCode][Hooks] 7 Claude Code Hooks in `.claude/hooks/`:
  - `session-start-info.sh` — Zeigt beim Session-Start offene Handoffs und Git-Status
  - `secrets-guard.sh` — Blockiert Read-Zugriff auf entschluesselte Secrets
  - `fish-syntax-guard.sh` — Blockiert Heredocs/EOF und typische Bash-Syntax-Fallen
  - `dual-push-reminder.sh` — Erinnert nach git push origin an Codeberg-Push
  - `pre-commit-docs-check.sh` — Prueft VOR git commit ob CHANGELOG/ROADMAP im Staging sind
  - `handoff-lifecycle-check.sh` — Prueft ob erledigte Handoffs geloescht/archiviert wurden
  - `bash-command-logger.sh` — Loggt alle Bash-Commands als Audit-Trail
- [ClaudeCode][Agents] 4 Claude Code Agents in `.claude/agents/`:
  - `docs-agent.md` — Dokumentation erstellen und pflegen nach 5-5-3 Pattern
  - `audit-agent.md` — Read-only Auditor fuer Bestandsaufnahmen und Reports
  - `deploy-agent.md` — Deployment auf Hosts ueber Anker-System
  - `scaffold-agent.md` — Neue Dateien mit korrektem MR-ByteZ Header erstellen
- [Config] .gitignore erweitert: `.claude/logs/`, `.claude/settings.local.json`

### Changed
- [Structure] **5-3-3 → 5-5-3 Pattern:** 2 neue Ordner (hooks/, agents/), 2 geloeschte (configs/, projects/)
  - hooks/ — Claude Code Event-Hooks (PreToolUse, PostToolUse, SessionStart)
  - agents/ — Spezialisierte Claude Code Agents (docs, audit, deploy, scaffold)
  - configs/ entfernt (nie genutzt, Konfigurationen liegen in context/)
  - projects/ entfernt (nie genutzt, Projekte liegen im Repo-Root)
- [Docs] Alle Referenzen auf "5-3-3" durch "5-5-3" ersetzt (structure.md, documentation.md, claude-ai-projektanweisungen.txt, CLAUDE.md)
- [Git] Cross-Repo Verzeichnis-Regel in `.claude/context/git.md` ergaenzt (pwd-Pflicht nach Secrets-Arbeit)

### Removed
- [Structure] `.claude/configs/` geloescht (ungenutzt, ersetzt durch context/)
- [Structure] `.claude/projects/sensitive-data-cleanup/` geloescht (A5 Placeholder, nie genutzt)
- [Structure] `docs/` (Root) geloescht (war leer)

---

## [0.8.6] - 2026-02-25

### Fixed
- [Security][Fish] cat-Alias Sofort-Fix: `--color=always` → `--color=auto` in 90-misc.fish
  - KRITISCHER BUG: --color=always schrieb ANSI-Farbcodes in Dateien bei Redirect/Pipe
  - Hatte authorized_keys auf n8-station korrumpiert (SSH Key-Auth kaputt)
- [Fish][Deploy] 2 Scripts mit fehlendem command-Prefix gefixt:
  - generate_pwd.fish:165 — `cat` → `command cat`
  - 00-theme.fish:138 — `cat` → `command cat`

### Added
- [Docs] shell.md: Neue Sektion "command-Prefix Pflicht" mit vollstaendiger Alias-Risiko-Tabelle
  - 5 HOCH-Risiko Aliases (cat, grep, ls, df, du), 3 MITTEL (rm, cp, mv)
  - Verweis auf A2 fuer langfristige Alias-Umbenennung

### Changed
- [Infra] Ghost-Submodule bereinigt: /mr-bytez/shared/.secrets/ auf n8-station entfernt
- [Docs] Handoff A1: B15 erledigt (war bereits in SSH-Config vorhanden), Alias-Bug als Lesson Learned #15
- [Docs] ROADMAP: B15 ✅, Alias-Naming unter A2 notiert

---

## [0.8.5] - 2026-02-25

### Added
- [Docs] Neue Context-Datei: `.claude/context/versioning.md` — SemVer-Regeln fuer Scripts
  - 0.x.y Phase (In Entwicklung), 1.0.0 Kriterien, Script-Konventionen
  - Aktuelle Script-Versionen Tabelle (deploy 0.3.0, pack 0.1.0, unpack 0.2.0, derive_key 0.2.0)
- [Infra] n8-station Secrets-Deployment verifiziert — SSH + Dual-Remote funktioniert

### Changed
- [Security][Deploy] deploy.fish v0.3.0 im Secrets-Repo — ohne-sudo Architektur:
  - Script laeuft OHNE sudo, nur /etc/hosts intern mit sudo
  - Ownership-Vorbereitung am Anfang (einmaliger chown bei Root-owned Dateien)
  - Git Remotes Post-Deploy, .gitconfig Backup+Symlink, Ghost-Submodule Warnung
- [Deploy] Script-Standardisierung fuer alle 4 Deployment-Scripte:
  - Versionsvariable ($script_version) statt hardcoded Nummern
  - MR-ByteZ ASCII-Banner eingebaut (pack-secrets.fish, derive_key.fish)
  - Header-Kommentar vereinheitlicht ("Version: siehe $script_version")
  - Korrekte SemVer: deploy 0.3.0, unpack 0.2.0, pack 0.1.0, derive_key 0.2.0
- [Docs] Handoff A1: n8-station deployed, Lessons Learned #13 (sudo-Ownership), #14 (Versionsvariable)
- [Docs] infrastructure.md: n8-station Secrets-Deployment Status ✅
- [Docs] ROADMAP: A1 Phase 3 n8-station ✅, B15 Host-zu-Host SSH-Config

---

## [0.8.4] - 2026-02-26

### Fixed
- [Security][SSH] AddressFamily inet fuer Codeberg in SSH-Config im Archiv
  - n8-vps: IPv6-Problem bei Codeberg SSH (Timeout ohne -4 Flag)
- [Security][Deploy] unpack-secrets.fish v1.1 Bugfix: temp-Verzeichnis statt direktes Loeschen
  - Altes mrohwer/ wird erst nach erfolgreicher Validierung ersetzt
  - Bei falscher Passphrase bleiben bestehende Daten erhalten
  - MR-ByteZ ASCII-Banner eingebaut (wie deploy.fish + pack-secrets.fish)

### Added
- [Infra] n8-vps Secrets-Deployment verifiziert — SSH + Dual-Remote funktioniert
  - Archiv mit --with-username entpackt, deploy.fish erfolgreich, AddressFamily inet aktiv

### Changed
- [Docs] Handoff A1: n8-vps deployed, Lessons Learned #10 (Codeberg IPv6), #11 (unpack loescht vor Verify)
- [Docs] infrastructure.md: n8-vps Secrets-Deployment Status
- [Docs] RECOVERY.md v1.1: HTTPS-Clone Hinweis, AddressFamily inet, git stash

---

## [0.8.3] - 2026-02-26

### Fixed
- [Security][Deploy] deploy.fish Bugfix: `sudo command cp/chmod/chown` → `sudo cp/chmod/chown`
  - sudo kennt Fish-Builtins nicht, `command` vor cp/chmod/chown war unter sudo ueberfluessig/kaputt
- [Security] Passphrase-Fix: `--with-host` → `--with-username` in allen Tipp-Zeilen
  - pack-secrets.fish, unpack-secrets.fish, security.md, Handoff A1, derive_key.README.md

### Added
- [Security] derive_key.fish v1.1: `--with-username` Flag ergaenzt (Salt + Username statt Hostname)
  - Archiv-Passphrase gleich auf allen Hosts (Username-basiert statt Host-basiert)
  - `--with-host` bleibt fuer Legacy-Kompatibilitaet
- [Docs] RECOVERY.md im Secrets-Repo erstellt (Disaster Recovery Anleitung)
- [Docs] ROADMAP A2 um Paket-Inventur ergaenzt (pacman/yay/flatpak pro Host)

### Changed
- [Docs] Handoff A1 aktualisiert: B9 erledigt (Workaround #SEC01.4), Chat-Link #SEC01.5
- [Docs] ROADMAP.md: A1 Phase 3 Bugfixes/Docs erledigt, B9 erledigt

---

## [0.8.2] - 2026-02-25

### Added
- [Security][Deploy] 3 Scripts fuer Secrets-Archiv-Workflow erstellt (A1 Phase 2, Aufgaben 1-3):
  - `shared/deployment/pack-secrets.fish` — mrohwer/ → mrohwer.tar.age (Verschluesselung)
  - `shared/deployment/unpack-secrets.fish` — mrohwer.tar.age → mrohwer/ (Entschluesselung)
  - `.secrets/deploy.fish` — Symlinks ueber Anker setzen (Merge-Logik: Host > Shared)
- [Deploy] deploy.fish Features: Hostname-Erkennung, idempotente Symlinks, sudo-Erkennung,
  Berechtigungen (0600 fuer SSH/.secrets), --dry-run, Schutz vor Ueberschreiben regulaerer Dateien
- [Security] Roundtrip-Test erfolgreich: pack → unpack → diff identisch
- [Security][Structure] Secrets-Migration abgeschlossen (A1 Phase 2, Aufgaben 4+5):
  - 4 .age-Einzeldateien entschluesselt und ins Archiv ueberfuehrt (API-Tokens + SSH-Keys)
  - ~70 Dateien aus lokaler ~/.secrets/ migriert (12 Kategorien → shared/ + infrastructure/n8-vps/)
  - Archiv: 91 Dateien in mrohwer.tar.age (6,7 MB)
  - Alte api/ + ssh/ Verzeichnisse aus Secrets-Repo entfernt (ersetzt durch Archiv)
- [Tools] `shared/deployment/generate_pwd.fish` aus ~/.secrets/ ins Public Repo verschoben
  (Disaster-Recovery-sicher, wie derive_key.fish)
- [Infra] /etc/hosts fuer 3 Hosts erstellt (B2): n8-kiste, n8-vps, n8-station
  - Konsistentes Template, FQDN mit `.mr-bytez.de`, im Archiv unter infrastructure/<hostname>/etc/hosts
  - Archiv aktualisiert: 94 Dateien
- [Security][SSH] SSH-Keys + authorized_keys aller Hosts ins Archiv migriert
  - n8-kiste: id_ed25519, forgejo, tinyssh_unlock + authorized_keys
  - n8-station: id_ed25519, forgejo + authorized_keys
  - n8-vps: authorized_keys
  - authorized_keys bereinigt (alter RSA-Key entfernt, nur Ed25519)
  - Archiv: 107 Dateien, 6,8 MB
- [Git][Docs] Cross-Repo-Regel in git.md + Projektanweisungen ergaenzt
- [Docs][Secrets] A1 Handoff finalisiert: Phase 2 Commit-Hashes, Chat-Link #SEC01.3, Status aktualisiert
- [Security][Deploy] deploy.fish v2.0.0 im Secrets-Repo — Copy+Symlink, Banner, Sektionen, Fixes
  - Copy-Methode fuer SSH/Secrets/hosts, Symlink nur fuer .gitconfig
  - MR-ByteZ ASCII-Banner (shared/lib/banner.fish), Sektions-Header, Box-Zusammenfassung
  - Alias-Schutz (command cp/chmod/chown), .pub 0644 statt 0600
- [Fish][Theme] shared/lib/banner.fish erstellt — MR-ByteZ Logo-Library (voll + --compact)
- [Docs] Neuer Handoff: HANDOFF_[Fish][Theme]_script-formatting-library.md
  - Vision: Zentrale shared/lib/format.fish fuer einheitliches Script-Look&Feel
- [Docs] A1 Handoff aktualisiert: Phase 3 B10 erledigt (n8-kiste deployed)

---

## [0.8.1] - 2026-02-25

### Added
- [Docs] Neue Datei: `.claude/context/claude-ai-user-preferences.txt` — Versionierte User Preferences
- [Config] Befehlsblock-Regel in Projektanweisungen ergaenzt (Befehle zusammenfassen, minimale Copy+Paste)
- [Docs] A1 Handoff — 0.8.1 Commit-Hashes ergaenzt (`7a6aec1`, `64454f4`, `34cbfd7`, `da04cd6`)
- [Git] Neue Regel in git.md: Keine Hash-Endlosschleife — letzter Commit-Hash wird nicht nochmal nachgetragen

---

## [0.8.0] - 2026-02-24

### Changed
- [Structure][Secrets] Submodule verschoben: `shared/home/mrohwer/.secrets/` → `.secrets/` (Repo-Root)
- [Deploy] symlinks.db verschoben: `shared/deployment/` → `.secrets/deployment/` (privates Submodule)
  - ANSI-Farbcodes entfernt (bat-Alias-Falle!), Version 1.1 → 1.2
  - Alle Source-Pfade auf Anker `/opt/mr-bytez/current/` aktualisiert
  - SSH-Config + .gitconfig + hwi-Symlink ergaenzt
- [Docs] 7 Context-Dateien aktualisiert: security.md, deployment.md, structure.md,
  infrastructure.md, claude-ai-projektanweisungen.txt, DEPLOYMENT.md, SMB-Handoff
- [Security] SSH-Policy geaendert: SSH-Config wird jetzt via Secrets-Repo deployt
  (bisher: "nur Template, kein Deployment")
- [Config] SSH-Port Korrektur: nicht pauschal "61020" sondern pro Host
  (n8-kiste: 61022, n8-station: 63022, n8-vps: 61020)
- [Docs] ROADMAP.md: A1 Phase 1 als erledigt, B1+B4+D9 als erledigt, A6 rclone hinzugefuegt

### Added
- [Secrets] 5-3-3 Docs im Secrets-Repo: README.md, CLAUDE.md, CHANGELOG.md, ROADMAP.md
- [Secrets] .gitignore im Secrets-Repo (mrohwer/, *.tar, smb-n8-kiste.creds)
- [Security] SSH-Config erstellt: `.secrets/mrohwer/shared/home/mrohwer/.ssh/config` (B1)
- [Config] .gitconfig erstellt: `.secrets/mrohwer/shared/home/mrohwer/.gitconfig` (B4)
- [Security] Archiv-Modell in security.md dokumentiert (Vier-Ebenen-Architektur)
- [Git] Codeberg-Remote fuer Secrets-Repo (Dual-Remote wie Hauptrepo)

### Removed
- [Cleanup] Erledigten Handoff geloescht: HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md (B1+B4 erledigt)
- [Cleanup] Erledigten Handoff geloescht: HANDOFF_[Deploy][Fish]_etc-fish-symlink-pacman-fix.md (in CLAUDE.md integriert)

---

## [0.7.6] - 2026-02-24

### Changed
- [Docs][Config] Root CLAUDE.md ueberarbeitet — 4 Verbesserungen nach Review
  - Co-Authored-By in Commits explizit unterdrueckt (Git-Workflow)
  - CHANGELOG-Regel unter Zentrale Policies ergaenzt (haeufige Fehlerquelle)
  - pacman -Syu Warning unter Shell-Regeln ergaenzt (Symlink-Pruefung)
  - Redundante "Mandatory Policies" in .claude/CLAUDE.md durch Verweis auf Root ersetzt

### Notes
- [Config] 2 Vorschlaege bewusst abgelehnt (command-cat Erweiterung + Fish Quick-Ref) — bereits ausreichend dokumentiert, wuerde gegen Keine-Redundanz-Policy verstossen

---

## [0.7.5] - 2026-02-17

### Changed
- [Structure] hwi-Script verschoben: `scripts/hwi/` → `shared/usr/local/bin/hwi/`
  - Spiegelt Linux-Verzeichnisstruktur (`/usr/local/bin/`)
  - Konsistent mit `shared/etc/fish/` und `shared/usr/local/share/micro/`
- [Deploy] hwi-Symlink nutzt jetzt den stabilen Anker `/opt/mr-bytez/current/`
  - Alt: `/mr-bytez/scripts/hwi/hwi.sh` (direkt, ohne Anker)
  - Neu: `/opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh`
- [Deploy] hwi in Aktive-System-Symlinks-Tabelle ergaenzt (`.claude/context/deployment.md`)
- [Docs] pacman -Syu Hinweis ergaenzt: Fish-Symlink nach System-Update pruefen
  - `DEPLOYMENT.md` (Root): Troubleshooting-Sektion
  - `.claude/context/deployment.md`: Neuer Abschnitt

### Added
- [Docs] 5-3-3 Docs fuer hwi vervollstaendigt: CLAUDE.md, CHANGELOG.md, ROADMAP.md
- [Docs] README.md (hwi) aktualisiert: Autor, Repo-Pfad-Uebersicht
- [Deploy] Neuer Deployment-Schritt 10: `sudo hwi mrbz` nach Host-Deployment ausfuehren
- [Security] HARDWARE.md in `.gitignore` — sensible Hardware-Infos bleiben lokal
  - Nur von Claude Code (lokal) lesbar, nicht von Claude.ai
- [Docs] Root README.md: hwi-Symlink + Hardware-Audit in Struktur und Status ergaenzt

---

## [0.7.4] - 2026-02-11

### Added
- [Docs][Secrets] Neuer Handoff: HANDOFF_[Secrets][Structure]_a1-secrets-repo-restrukturierung.md

### Changed
- [Docs] Projektanweisungen aktualisiert: C1+C2 als erledigt, A1 als aktuell markiert

---

## [0.7.3] - 2026-02-11

### Changed
- [Docs][Structure] tasks/ Ordner aufgeloest (redundant mit Handoff-System)
  - `structure.md`: tasks/-Verweis entfernt, Typ 3 Community-Projekte ergaenzt,
    Wann-was-wohin Tabelle erweitert (Handoffs, Projektanweisungen)
  - `integration.md`: Claude Code Context-Management (Kontextfenster, /clear, /compact,
    Session-State Pattern, Subagents, CLAUDE.md schlank halten) + MCP Server Kandidaten
    (Sequential Thinking, Context7, GitHub MCP)
  - `policies.md`: Delegation-Abschnitt bei Handoff-Policy ergaenzt
  - `git.md`: CHANGELOG-Regel ergaenzt (VOR dem Commit aktualisieren, ein Commit)
  - `.claude/README.md`: Aktualisiert-Datum
- [Config] Zwei neue Workflow-Regeln in `git.md` verankert:
  - CHANGELOG/ROADMAP immer VOR dem Commit aktualisieren, nie als separater Folge-Commit
  - Erledigte Handoffs VOR dem Commit loeschen/archivieren (selber Commit)
- [Config] Handoff-Lifecycle in `policies.md` praezisiert (Bereinigung im selben Commit)

### Removed
- [Structure] `.claude/tasks/` geloescht (Workflow laeuft ueber Handoff-System)
- [Cleanup] Erledigten Handoff geloescht: HANDOFF_[Docs][Structure]_tasks-konsolidierung-integration-update.md

---

## [0.7.2] - 2026-02-11

### Changed
- [Docs][Structure] Context-Audit: 3 Context-Dateien aktualisiert
  - `structure.md`: 6 Deltas ergaenzt (tags.md, handoffs/, claude-ai-projektanweisungen.txt,
    migration.md im Listing, .claude/projects/ und .claude/tasks/ Verzeichnisse)
  - `integration.md`: Claude Opus 4.6 Features-Abschnitt (Effort Control, Agent Teams,
    Context Compaction, 1M Token Window) + PATH-Detail + Modell-Info
  - `infrastructure.md`: mcp-server Projekt-Location ergaenzt

### Added
- [Docs] Claude Opus 4.6 Features in `integration.md` dokumentiert (verfuegbar seit 05.02.2026)

### Removed
- [Cleanup] Erledigten Handoff geloescht: HANDOFF_[DOC][STR]_context-audit-opus46.md
- [Structure] `migration.md` nach `.claude/archive/` verschoben (alle 11 Schritte erledigt)

---

## [0.7.1] - 2026-02-11

### Added
- [Docs][Structure] Handoff-Policy definiert und in policies.md integriert
- [Structure] Handoff-Ordner umstrukturiert: todo_aus_chats.../ → .claude/context/handoffs/
- [Structure] 5 offene Handoffs verschoben und nach Tag-Konvention umbenannt
- [Config] Zwei neue Tags: `[Community]` (COM) und `[Learn]` (LRN) in tags.md
- [Docs] HANDOFF_[Learn][Stack]_mr-bytez-learn-projektplan.md erstellt

### Fixed
- [Docs] Veraltete Handoff-Verweise in 5 Projekt-Placeholdern korrigiert (5-3-3)

### Changed
- [Docs] Projektanweisungen aktualisiert (neuer Handoff-Ablageort)
- [Docs] ROADMAP.md — alle Handoff-Verweise auf neue Pfade aktualisiert

### Removed
- [Cleanup] 3 erledigte Handoffs geloescht (X01-1, INVENTUR, ARBEITSANWEISUNG_ROADMAP)
- [Structure] Alter Ordner `todo_aus_chats_noch_nicht_in_roadmap_integriert/` entfernt

---

## [0.7.0] - 2026-02-10

### Added
- [Structure] `.claude/` Struktur nach 5-3-3 Pattern implementiert
  - `context/` mit 11 Policy-Dateien (aus PROJECT_NOTES.md + neue)
  - `archive/`, `skills/`, `configs/` Ordner angelegt
  - `CLAUDE.md` als zentrale Steuerung fuer Claude Code & Claude.ai
  - `CHANGELOG.md` und `ROADMAP.md` fuer .claude/-spezifische Historie
- [Structure] 5-3-3 Placeholder fuer 4 A-Projekte erstellt
  - `shared/etc/fish/` (A2: Fish DRY-Refactoring)
  - `shared/stacks/mrbz-dev/` (A3: Claude Dev Container)
  - `projects/infrastructure/mcp-server/` (A4: MCP Server)
  - `.claude/projects/sensitive-data-cleanup/` (A5: Data Cleanup)
- [Docs] `.gitignore` erweitert: Sanitization-Patterns
- [Docs] Inventur aller 40 offenen Aufgaben aus 6 Handoff-Dateien (`INVENTUR.md`)
- [Docs] Arbeitsregeln: Chat-Zeitermittlung via recent_chats Tool, Aenderungskontext, Aufgaben-Delegation
- [Structure] `.claude/tasks/` Task-Queue fuer Claude.ai → Claude Code Uebergabe
  - `README.md` mit Workflow-Dokumentation
- [Config] `.claude/context/tags.md` — Zentrale Tag-Registry (67 Tags, 3-Zeichen-Index)
  - Generische Tags (41) + Dienst-spezifische Tags (26)
  - Jeder Tag mit Index, Bedeutung, Verwendungsbereich, Seit-Datum
- [Docs] `.claude/context/claude-ai-projektanweisungen.txt` — Versionierte Claude.ai Projektanweisungen

### Changed
- [Structure] `PROJECT_NOTES.md` aufgeteilt in `.claude/context/` (11 Dateien)
- [Structure] `.claude/plans/` → `.claude/archive/` umbenannt
- [Structure] `.claude/README.md` aktualisiert (neue Struktur)
- [Docs] Root `ROADMAP.md` komplett umstrukturiert: 5 A-Projekte (A1-A5), B/D-Task-Zuordnung, Timing-Matrix
- [Docs] `.claude/ROADMAP.md` Phase 4+5 mit Verweisen auf Root-ROADMAP
- [Docs] Root `README.md` aktualisiert (PROJECT_NOTES Referenz → .claude/context/)
- [Docs] Root `DEPLOYMENT.md` aktualisiert (PROJECT_NOTES Referenz entfernt)
- [Docs] Autor ueberall: MR-ByteZ (statt Michael Rohwer)
- [Docs] Chat-Benennung v2 komplett in `context/documentation.md` (Format, Datum, Ketten-System, Tag-Verwaltung, Beispiele)
- [Config] TAG_REGISTRY in `context/git.md` finalisiert — Verweis auf `tags.md`
- [Config] Kategorien-Tabelle in `context/git.md` um Index-Spalte erweitert
- [Config] Neue Commit-Regel: Chat-Link bei strategischen Commits

### Removed
- [Structure] `PROJECT_NOTES.md` (aufgeteilt in `.claude/context/`)
- [Structure] Root `CLAUDE.md` (war /init-Artefakt, ersetzt durch `.claude/CLAUDE.md`)
- [Cleanup] `.gitignore.bak` entfernt

### Notes
- [Migration] Phase 2+3 der .claude/ Migration abgeschlossen
- [Pattern] 5-3-3 Pattern: 5 Docs, 3 Ordner, 3 Ebenen — konsistent ueberall
- [Workflow] Alle Policies jetzt in `.claude/context/` statt einer grossen PROJECT_NOTES.md
- [Workflow] 40 Aufgaben in 4 Kategorien (A/B/C/D) inventarisiert und Projekten zugeordnet

---

## [0.6.1] - 2026-02-09

### Changed
- [Micro] Clipboard-Methode von `terminal` (OSC52) auf `external` (xclip) gewechselt
  - `shared/usr/local/share/micro/settings.json` aktualisiert
  - Grund: OSC52 nicht zuverlässig über alle Terminal-Emulatoren hinweg
  - Lösung: `xclip` als System-Dependency, Micro nutzt externes Clipboard

### Added
- [Deploy] `xclip` als Paket-Dependency für Micro Editor dokumentiert
  - Voraussetzung für Ctrl+Shift+C/V in micro (X11)
  - Wayland-Alternative: `wl-clipboard` (bei Bedarf)

### Notes
- [Workflow] Bei Deployment auf neue Hosts: `sudo pacman -S xclip` NICHT vergessen!
- [Compat] Wayland-Hosts brauchen `wl-clipboard` statt `xclip`

---

## [0.6.0] - 2026-02-04

### Changed
- [Docs] **ROADMAP.md** komplett umstrukturiert nach Priorität
  - Phase 3 in 3 Prioritätsstufen gegliedert:
    - 🔴 Priorität 1: Foundation (Claude Dev Container - ZUERST!)
    - 🟠 Priorität 2: Development (MCP Server, Cleanup, Hooks)
    - 🟡 Priorität 3: Enhancement (Chat-Namer, Backup)
  - Abhängigkeiten klar dokumentiert
  - Impact-Level für jedes Feature
  - Kritischer Pfad visualisiert
  - Warum-Begründungen für Reihenfolge
  - Chat-Referenzen zu geplanten Features hinzugefügt:
    - Claude Dev Container
    - MCP Server Implementation
    - Chat-Namer Skill
    - Sensitive Data Cleanup
  - ETA-Zeiträume präzisiert
  - Kompakt-Übersicht nach Priorität sortiert

---

## [0.5.0] - 2026-02-04

### Changed
- [Fish] Fish-Config von `/usr/local/share/fish/` nach `/etc/fish/` verschoben
  - System-Symlink: `/etc/fish -> /opt/mr-bytez/current/shared/etc/fish`
  - Grund: Fish lädt NUR aus `/etc/fish/`, NICHT aus `/usr/local/share/fish/`!
- [Deployment] `symlinks.db` aktualisiert (Fish-Pfad korrigiert)
- [Deployment] DEPLOYMENT.md erste Überarbeitung
- [Docs] PROJECT_NOTES.md Fish-Pfad korrigiert

### Fixed
- [Fish] Powerline Prompt funktioniert jetzt korrekt (richtige Lade-Reihenfolge)
- [Deployment] n8-vps vollständig deployed mit GitHub CLI

### Notes
- [Workflow] Deployment-Workflow etabliert: n8-kiste = commit, n8-vps = read-only (nur pull)
- [Security] GitHub CLI verwendet OAuth (kein SSH-Key auf Server nötig!)

---

## [0.4.0] - 2026-02-03

### Added
- [Docs] **DEPLOYMENT.md** als zentraler Deployment-Guide
  - Stabiler Anker via `/opt/mr-bytez/current`
  - Symlink-Strategie dokumentiert
  - Rollback/Switch-Mechanismus erklärt
  - Troubleshooting-Section
- [Repo] GitHub Mirror zusätzlich zu Codeberg
  - Multi-Remote Push: GitHub + Codeberg
  - Claude.ai GitHub Integration aktiviert
- [Docs] **PROJECT_NOTES.md** erweitert
  - Fish-first Policy dokumentiert
  - Token-Handling (cat/bat Alias-Falle)
  - printf statt heredoc für File-Creation
  - "Wichtige MD-Dateien nur additiv ändern" Policy

### Changed
- [Deployment] Systemweite Symlinks referenzieren `/opt/mr-bytez/current/`
  - Alle System-Symlinks gehen über stabilen Anker
  - Vereinfacht Rollback und Version-Switching
- [Micro] Deployment über stabilen Anker
  - `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`
- [Security] Symlink-Policy verschärft
  - `~/.ssh/config` wird NICHT mehr aus Repo deployed
  - Nur Template: `~/.ssh/config.example`
  - Verhindert kaputte SSH-Config bei Repo-Wechsel

### Fixed
- [Security] SSH-Config Stabilität
  - Keine "kaputte" SSH-Config mehr bei `/mr-bytez` Problemen

### Notes
- [Repo] Split: v1-Repo parallel nutzbar (`/mr-bytez-v1_fish_micro_secrets`)
  - Anker-Switch ermöglicht schnellen Wechsel
- [Secrets] Secrets bleiben in privatem Submodule `shared/home/mrohwer/.secrets` (Age-encrypted)

---

## [0.3.0] - 2026-01-29

### Added
- [Fish] **v2.0 - Hierarchischer Loader mit Theme-System**
  - `00-loader.fish`: Zentraler Loader mit Host-Erkennung
  - `00-theme.fish`: Theme-Variablen initialisieren (Powerline, Icons)
  - `themes/mr-bytez.fish`: User-Typ-Farben (root/sudo/normal)
  - `functions/`: Modulare Funktionen
    - `fish_prompt.fish`: Powerline Prompt
    - `__mr_git_status.fish`: Git Branch + Status
    - `__mr_docker_status.fish`: Docker Container Count
    - `__mr_smart_pwd.fish`: Intelligente PWD-Kürzung
  - `aliases/`: Modulare Alias-Dateien (10-90)
    - `10-basics.fish`: Basis-Aliases (ls, grep, etc.)
    - `20-git.fish`: Git-Workflows
    - `30-docker.fish`: Docker-Shortcuts
    - `40-system.fish`: System-Management
    - `50-tools.fish`: Development-Tools
- [Fish] **Host-spezifische Configs für 8 Hosts**
  - Desktop: n8-kiste, n8-station, n8-book, n8-bookchen
  - Specialized: n8-maxx (Gaming), n8-broker (Trading)
  - Server: n8-vps
  - Portable: n8-archstick
  - Jeder Host: conf.d/, aliases/, variables/, functions/
  - Override-Mechanismus: Shared (00-69) → Host Kategorie (70-79) → Host-spezifisch (80-89) → User-Tweaks (90-99)
- [Micro] **Editor-Konfiguration**
  - `settings.json`: Gruvbox-Theme, Tab-Settings (4 spaces), Search-Optionen
  - `bindings.json`: Comment-Toggle Shortcuts (Ctrl+#, Ctrl+/)
- [Docs] **06-hosts-uebersicht.md** erstellt
  - Alle 8 Hosts dokumentiert
  - VPN-Netzwerk Konzept
  - Host-Naming Konvention erklärt

### Changed
- [Fish] **Deployment-Strategie komplett überarbeitet**
  - EINE System-Symlink statt viele Einzel-Symlinks
  - Zentralisierte Config-Verwaltung
- [Fish] **Config-Hierarchie** neu strukturiert
  - Shared Baseline (00-69)
  - Host Kategorie (70-79): Desktop vs Server
  - Host-spezifisch (80-89): Individuelle Overrides
  - User-Tweaks (90-99): Optionale User-Anpassungen
  - Debug-Modus: `FISH_LOADER_DEBUG=1`
- [Fish] **Prompt-System** komplett neu
  - Powerline-Style mit nahtlosen Übergängen
  - Host-spezifische Farben (rot für Production!)
  - Git-Status Integration (Branch, Dirty-State, Ahead/Behind)
  - Docker-Status (Container-Count)
  - Vi-Mode Indicator
  - Smart PWD (erste + letzte voll, Mitte gekürzt)

---

## [0.2.0] - 2026-01-23

### Added
- [Secrets] **Age-Encryption Management**
  - Secrets als privates Submodule: `shared/home/mrohwer/.secrets`
  - Master-Password Derivation: `shared/deployment/derive_key.fish`
  - Deployment-Metadaten: `shared/deployment/symlinks.db`
- [Secrets] **SSH-Key für Codeberg**
  - `id_ed25519_codeberg`: Codeberg-spezifischer Key
  - `.age` verschlüsselt
- [Secrets] **API-Token für Codeberg**
  - `codeberg_api.token`: Personal Access Token
  - `.age` verschlüsselt
- [Docs] **SECRETS.md** Dokumentation
  - Secrets-Struktur erklärt
  - Derive-Key Workflow dokumentiert
  - Recovery-Prozess beschrieben

### Fixed
- [Secrets] Token-Name korrigiert: `codeberg_api.token` (statt `api_token.txt`)

### Changed
- [Git] `.gitignore` für Age-verschlüsselte Secrets angepasst
  - `*.age` explizit ausgeschlossen
  - `shared/home/mrohwer/.secrets/*` Pattern hinzugefügt
- [Docs] **README.md** Status aktualisiert
  - Phase 1 als abgeschlossen markiert
  - Secrets-Management dokumentiert

---

## [0.1.0] - 2026-01-22

### Added
- [Init] **Repository initialisiert** in `/mr-bytez`
  - Main Branch als Default
  - Basis-Ordnerstruktur angelegt
- [Structure] **Haupt-Ordner erstellt**
  - `shared/`: Shared Resources (alle Hosts)
  - `projects/`: Host-spezifische Projekte
  - `.claude/`: AI/Claude Integration
  - `.config/`: Repo-weite Configs
- [Docs] **Root-Dateien** erstellt
  - README.md: Projekt-Übersicht
  - CHANGELOG.md: Diese Datei (initial)
  - ROADMAP.md: Entwicklungs-Roadmap
  - .gitignore: Standard-Ausschlüsse
- [Remote] **Codeberg Repository** erstellt
  - Repository: `n8lauscher/mr-bytez` (privat)
  - Initial Push durchgeführt

---

## Versionierungs-Schema

**Format:** MAJOR.MINOR.PATCH

- **MAJOR:** Breaking Changes, API-Änderungen (1.0.0 → 2.0.0)
- **MINOR:** Neue Features, backwards compatible (1.0.0 → 1.1.0)
- **PATCH:** Bug-Fixes, backwards compatible (1.0.0 → 1.0.1)

**Beispiele:**
- `0.1.0`: Initial Repository Setup
- `0.2.0`: Secrets Management hinzugefügt
- `0.3.0`: Fish Shell v2.0 mit Loader + Theme
- `0.4.0`: Deployment-System mit Ankern
- `0.5.0`: Fish-Pfad Migration
- `0.6.0`: Dokumentation Konsolidierung
- `1.0.0`: Production-Ready Release (geplant Q2 2026)

---

## Git-Tags

Releases werden via Git-Tags markiert:

```fish
# Tag erstellen
git tag -a v0.6.0 -m "Release 0.6.0 - Dokumentation Konsolidierung"

# Tag pushen
git push origin v0.6.0
git push codeberg v0.6.0
```

**Alle Releases:**
- GitHub: https://github.com/mr-bytez/mr-bytez/releases
- Codeberg: https://codeberg.org/n8lauscher/mr-bytez/tags

---

**Letzte Aktualisierung:** 2026-03-04
