# CHANGELOG.md

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

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

**Letzte Aktualisierung:** 2026-02-11
