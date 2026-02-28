# CHANGELOG.md

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

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

**Letzte Aktualisierung:** 2026-02-27
