# CHANGELOG.md

Alle nennenswerten Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Semantic Versioning](https://semver.org/lang/de/).

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
- [Secrets] Secrets bleiben in privatem Submodule `shared/.secrets` (Age-encrypted)

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
  - Secrets als privates Submodule: `shared/.secrets`
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
  - `shared/.secrets/*` Pattern hinzugefügt
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

**Letzte Aktualisierung:** 2026-02-04
