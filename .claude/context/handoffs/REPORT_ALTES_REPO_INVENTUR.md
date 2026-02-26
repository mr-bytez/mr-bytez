# Report: Inventur altes mr-bytez.dev Repo

**Erstellt:** 2026-02-26
**Chat-Referenz:** #FSH01.1 [Fish][Refactor] - A2 Fish DRY-Refactoring Planung
**Pfad:** `/home/mrohwer/mr-bytez.dev/`
**Aktuelles Repo:** `/mr-bytez/`

---

## 1. Zusammenfassung

| Eigenschaft | Wert |
|-------------|------|
| Groesse gesamt | 276 MB |
| Dateien gesamt | 1.517 |
| Git-Repo | **Nein** (kein .git-Verzeichnis) |
| Alter | Erstellt ca. 10. Jan 2026, letzte Aenderung 4. Feb 2026 |
| Version | 0.1.0 (Foundation Phase) |
| Lizenz | GPL v3 |
| Hauptzweck | Vorgaenger-Repo fuer mr-bytez, Planungs- und Dokumentationsphase |

**Groesse pro Verzeichnis:**
- `labs/` — 274 MB (davon: NetAlertX + WatchYourLAN Git-Clones)
- `claude/` — 1,1 MB (Chat-Artefakte, Skills-Entwuerfe)
- `mr-bytez_chat_context/` — 264 KB (Claude.ai Chat-Kontext-Dateien)
- `docs/` — 184 KB (Architektur-Dokumentation)
- `bin/` — 60 KB (Plasma-Scripts)

**Fazit:** Das Repo war nie ein Git-Repo — es war eine lokale Arbeitsumgebung fuer die Planungsphase des aktuellen `/mr-bytez/` Repos. Die 274 MB in `labs/` sind geklonte Drittanbieter-Repos (NetAlertX, WatchYourLAN).

---

## 2. Struktur-Uebersicht

```
mr-bytez.dev/
├── bin/                          # Plasma-Scripts (Fish)
│   └── plasma/
│       ├── desktop/              # 5 Reset-Scripts
│       └── monitor/              # 4 Monitor-Profil-Scripts
├── CHANGELOG.md                  # v0.1.0
├── claude/                       # Chat-Artefakte & Skills-Entwuerfe
│   ├── chat/                     # Archivierte Chat-Outputs
│   │   ├── arbeitsweise_*.md     # Arbeitsweise-Doks
│   │   ├── code_standards.md     # Code-Standards
│   │   ├── command_block_strategie.md
│   │   ├── n8-dev/               # Claude Code Integration Planung
│   │   ├── n8-kiste/             # n8-kiste Doku (Timeline, PostgreSQL, etc.)
│   │   ├── n8-vps/               # n8-vps Install-Review + Master-Planungen
│   │   └── templates_emoji_guide.md
│   ├── config/                   # LEER
│   └── skills/
│       └── n8-dev/               # Skills-Entwuerfe (nur Platzhalter/00Tree.html)
├── .claude/
│   └── context/
│       ├── ARBEITSWEISE.md       # Claude-Arbeitsweise v1.0
│       └── STRUKTUR_REFERENZ.md  # Autoritative Struktur-Referenz v1.0
├── docs/
│   ├── architecture/             # 7 Architektur-Doks (00-06)
│   ├── development/              # Best-Practices, Devlog, Workflows
│   └── templates/                # ADR, Changelog, README Templates
├── labs/
│   └── docker/network/
│       ├── NetAlertX/            # Geklontes Drittanbieter-Repo (~270 MB)
│       └── WatchYourLAN/         # Geklontes Drittanbieter-Repo (~4 MB)
├── mr-bytez_chat_context/        # Claude.ai Chat-Kontext (15 Dateien)
├── README.md                     # Projekt-Uebersicht v0.1.0
├── ROADMAP.md                    # 3-Phasen-Planung
├── TODO.md                       # Sprint-Planung Woche 3
└── LICENSE                       # GPL v3
```

---

## 3. Inhalts-Analyse pro Kategorie

### 3.1 Fish-Scripts (9 Dateien)

**Pfad:** `bin/plasma/`

| Script | Zweck | Zeilen |
|--------|-------|--------|
| `desktop/reset-activities.fish` | KDE Activities zuruecksetzen | ~15 |
| `desktop/reset-all.fish` | Kompletter Plasma-Reset (Panel, Activities, Cache) | 28 |
| `desktop/reset-panel.fish` | Nur Panel zuruecksetzen | ~15 |
| `desktop/reset-window-rules.fish` | Fensterregeln zuruecksetzen | ~15 |
| `desktop/reset-workspaces.fish` | Workspaces zuruecksetzen | ~10 |
| `monitor/n8kiste-monitor-dual-left+right:3840x2160.fish` | Dual 4K via xrandr | 16 |
| `monitor/n8kiste-monitor-single-left:3840x2160.fish` | Einzelmonitor links | ~15 |
| `monitor/n8kiste-monitor-single-remote:1920x1200.fish` | Remote-Display 1920x1200 | ~12 |
| `monitor/n8kiste-monitor-single-right:3840x2160.fish` | Einzelmonitor rechts | ~15 |

**Bewertung:** Funktionale Fish-Scripts fuer Plasma/KDE Desktop-Management. Monitor-Scripts nutzen `xrandr` direkt. Relevant fuer n8-kiste Desktop-Management.

### 3.2 Shell-Scripts

**Eigene:** Nur `n8-vps_PostInstall_Complete_Phase0-4.sh` (24.975 Bytes) — Bash-Script mit allen Phase 0-4 Installationsbefehlen.

**Drittanbieter:** ~45 Scripts in `labs/docker/network/NetAlertX/` und `labs/docker/network/WatchYourLAN/` — gehoeren zu den geklonten Repos, nicht eigener Code.

### 3.3 Konfigurationsdateien (eigene)

| Datei | Pfad | Zweck |
|-------|------|-------|
| `n8-vps_unbound_custom.conf` | `claude/chat/n8-vps/.../` | Unbound DNS Config (6,9 KB) |
| `.gitignore` | Root | Umfassende Gitignore (100 Zeilen) |

### 3.4 Dokumentation (eigene, ohne labs/)

**Chat-Artefakte (claude/chat/):**

| Datei | Inhalt | Groesse |
|-------|--------|---------|
| `arbeitsweise_bevorzugte_methodik_fuer_claude_chats.md` | Bevorzugte Chat-Methodik | 10 KB |
| `code_standards.md` | Code-Konventionen | 19 KB |
| `command_block_strategie.md` | Strategie fuer Befehlsbloecke | 14 KB |
| `templates_emoji_guide.md` | Emoji-Leitfaden fuer Doks | 22 KB |

**n8-dev (Claude Code Integration):**

| Datei | Inhalt |
|-------|--------|
| `n8-dev-Claude_Code_Integration_Strategie.md` | Integration-Strategie |
| `n8-dev_Claude_Code_Ordner_und_Dateien_Klarheit.md` | Ordner-Klarheit |
| `n8-dev_Claude_Code_Skills_README_Final.md` | Skills-System README |
| `n8-dev_Projekt_Dokumentation_v0.2.2.md` | Projekt-Doku |

**n8-kiste:**

| Datei | Inhalt | Wert |
|-------|--------|------|
| `n8kiste_tinyssh_setup.md` | TinySSH Remote-Unlock Setup (420 Zeilen) | **HOCH** — Vollstaendige Anleitung fuer LUKS Remote-Unlock |
| `n8kiste_postgresql_migration_status.md` | PostgreSQL Migration zu zentralem Setup | MITTEL — Historisch interessant |
| `n8kiste_etc_timeline_COMPLETE_*.md` | /etc Timeline Oct-Nov 2025 | MITTEL — Aenderungshistorie |
| `n8media-sort_Documentation.md` | Media-Sort-System fuer Jellyfin | MITTEL — n8media-sort Dokumentation |
| `n8kiste_code_doku_standard.md` | Code-Doku-Standards | NIEDRIG |

**n8-vps (Installations-Dokumentation):**

| Datei | Inhalt | Wert |
|-------|--------|------|
| `n8-vps_OVERVIEW.md` | Komplette Phase 0-4 Doku (414 Zeilen) | **HOCH** — Server-Referenz |
| `n8-vps_PostInstall_Complete_Phase0-4.sh` | Alle Installationsbefehle als Script | **HOCH** — Reproduzierbar |
| `n8-vps_unbound_custom.conf` | Produktive Unbound-Config | **HOCH** — Direkt nutzbar |
| `n8-vps_Hetzner_Robot_Firewall.txt` | Hetzner Robot FW Regeln | **HOCH** — Firewall-Referenz |
| `n8-vps_Master-Planung_v*.md` | 8 Versionen der Master-Planung | NIEDRIG — Versionsverlauf |
| `n8-vps_Installationsplan_v2_0_konsolidiert.md` | Konsolidierter Installationsplan | MITTEL — Schon teilweise im aktuellen Repo |
| `n8-vps_Security-Domain-Strategie_v*.md` | Security-Domain Strategie (3 Versionen) | MITTEL |
| `n8-vps_Service-Liste_v*.md` | Service-Listen (3 Versionen) | NIEDRIG |
| `n8-vps_Netzwerk_Matrix_v1_0.md` | Netzwerk-Matrix | MITTEL |

**Chat-Kontext (mr-bytez_chat_context/):**

15 Dateien — Claude.ai Chat-Kontext-Dateien. Enthalten die Architektur-Doks (00-06) in Duplikat, plus:
- `ARBEITSANWEISUNG_CHAT_BENENNUNG.md` — Chat-Benennungskonvention
- `CLAUDE_ARBEITSWEISE.md` — Duplikat von `.claude/context/ARBEITSWEISE.md`
- `CLAUDE_STRUKTUR_REFERENZ.md` — Duplikat von `.claude/context/STRUKTUR_REFERENZ.md`
- `mr-bytez_strukturplan_v2.0_final.md` — Finaler Strukturplan (mit kaputtem Encoding)
- `n8-vps_Installationsplan_v2_0_konsolidiert.md` — Duplikat

**Architektur-Doks (docs/architecture/):**

7 Dateien (00-uebersicht.md bis 06-hosts-uebersicht.md) — Vollstaendige Architektur-Dokumentation der fruehen Planungsphase.

**Development-Doks (docs/development/):**
- `best-practices.md`
- `devlog.md`
- `workflows.md`

**Templates (docs/templates/):**
- `adr-template.md` — ADR Template
- `changelog-template.md` — Changelog Template
- `readme-template.md` — README Template

### 3.5 Docker (labs/)

Zwei geklonte Drittanbieter-Repos fuer Netzwerk-Monitoring-Evaluation:
- **NetAlertX** — Netzwerk-Scanner/Alerting (~270 MB, grosses Projekt)
- **WatchYourLAN** — LAN-Scanner (Go + Vue.js, ~4 MB)

Keine eigenen Docker-Konfigurationen.

### 3.6 Secrets/Credentials

| Pfad | Typ |
|------|-----|
| `labs/docker/network/NetAlertX/.env` | NetAlertX-Beispiel-.env (Drittanbieter) |
| `labs/docker/network/NetAlertX/install/freebox_certificate.pem` | Drittanbieter-Zertifikat |

**Keine eigenen Secrets gefunden.** Gut — Secrets waren offenbar nie im Repo.

### 3.7 Web-Projekte/Code (eigener)

Nur ein Python-Script: `bin/plasma/utils/panel-duplicate.py` (KDE Panel-Duplikation).

Der Rest unter `labs/` ist Drittanbieter-Code (PHP, Python, JS, Go, HTML, CSS).

---

## 4. Vergleich mit aktuellem Repo

### 4.1 Ueberschneidende Dateinamen

| Dateiname | Altes Repo | Neues Repo | Status |
|-----------|-----------|------------|--------|
| `README.md` | Root-Uebersicht v0.1.0 | Aktuelle Uebersicht | DUPLIKAT (neues ist aktueller) |
| `CHANGELOG.md` | v0.1.0 | Aktuelle Version | DUPLIKAT (neues ist aktueller) |
| `ROADMAP.md` | 3-Phasen-Plan | Aktuelle Planung | DUPLIKAT (neues ist aktueller) |
| `.gitignore` | Umfassend (100 Zeilen) | Aktuelle Version | VERGLEICHEN |
| `LICENSE` | GPL v3 | GPL v3 | DUPLIKAT |
| `best-practices.md` | Development Best Practices | Aktuell | VERGLEICHEN |

### 4.2 Einzigartige Inhalte (NUR im alten Repo)

**Hoher Wert:**
1. `bin/plasma/` — 9 KDE Plasma Fish-Scripts (Desktop-Reset, Monitor-Profile)
2. `claude/chat/n8-kiste/n8kiste_tinyssh_setup.md` — Vollstaendige TinySSH Remote-Unlock Anleitung
3. `claude/chat/n8-vps/.../n8-vps_OVERVIEW.md` — Komplette Server-Referenz Phase 0-4
4. `claude/chat/n8-vps/.../n8-vps_PostInstall_Complete_Phase0-4.sh` — Reproduzierbares Install-Script
5. `claude/chat/n8-vps/.../n8-vps_unbound_custom.conf` — Produktive Unbound-Config
6. `claude/chat/n8-vps/.../n8-vps_Hetzner_Robot_Firewall.txt` — Firewall-Regeln

**Mittlerer Wert:**
7. `claude/chat/n8-kiste/n8kiste_postgresql_migration_status.md` — PostgreSQL Migration
8. `claude/chat/n8-kiste/n8media-sort_Documentation.md` — Media-Sort System
9. `claude/chat/n8-kiste/n8kiste_etc_timeline_COMPLETE_*.md` — /etc Aenderungshistorie
10. `claude/chat/n8-vps/n8-vps_Netzwerk_Matrix_v1_0.md` — Netzwerk-Matrix
11. `claude/chat/n8-vps/n8-vps_Security-Domain-Strategie_v1_2.md` — Security-Strategie
12. `docs/architecture/00-06` — Architektur-Doks (fruehe Version)
13. `docs/templates/` — ADR, Changelog, README Templates
14. `claude/chat/code_standards.md` — Code-Standards (19 KB)
15. `bin/plasma/utils/panel-duplicate.py` — KDE Panel-Duplikation

**Niedriger Wert:**
16. `claude/chat/n8-vps/n8-vps_Master-Planung_v*.md` — 8 Versionen (nur Versionsverlauf)
17. `claude/chat/templates_emoji_guide.md` — Emoji-Guide (nicht mehr Policy)
18. `claude/chat/command_block_strategie.md` — Veraltete Strategie
19. `.claude/context/ARBEITSWEISE.md` — Claude-Arbeitsweise v1.0 (veraltet)
20. `.claude/context/STRUKTUR_REFERENZ.md` — Struktur-Referenz v1.0 (veraltet)

---

## 5. Bewertungs-Matrix

| # | Datei/Verzeichnis | Kategorie | Begruendung |
|---|-------------------|-----------|-------------|
| 1 | `bin/plasma/desktop/*.fish` (5 Scripts) | **UEBERNEHMEN** | Funktionale KDE-Reset-Scripts, existieren nicht im aktuellen Repo |
| 2 | `bin/plasma/monitor/*.fish` (4 Scripts) | **UEBERNEHMEN** | Monitor-Profile fuer n8-kiste, existieren nicht im aktuellen Repo |
| 3 | `bin/plasma/utils/panel-duplicate.py` | **UEBERNEHMEN** | KDE-Utility, existiert nicht im aktuellen Repo |
| 4 | `n8-vps_OVERVIEW.md` | **REFERENZ** | Server-Referenz Phase 0-4, als Archiv-Doku wertvoll |
| 5 | `n8-vps_PostInstall_Complete_Phase0-4.sh` | **REFERENZ** | Install-Script, nicht 1:1 nutzbar aber gute Referenz |
| 6 | `n8-vps_unbound_custom.conf` | **REFERENZ** | Pruefen ob aktuelle Config abweicht |
| 7 | `n8-vps_Hetzner_Robot_Firewall.txt` | **REFERENZ** | Firewall-Regeln-Dokumentation |
| 8 | `n8kiste_tinyssh_setup.md` | **REFERENZ** | TinySSH-Anleitung, vollstaendig aber noch nicht umgesetzt |
| 9 | `n8kiste_postgresql_migration_status.md` | **REFERENZ** | PostgreSQL-Migration Doku |
| 10 | `n8media-sort_Documentation.md` | **REFERENZ** | Media-Sort-System |
| 11 | `n8kiste_etc_timeline_COMPLETE_*.md` | **ARCHIVIEREN** | /etc Aenderungs-Historie, historisch interessant |
| 12 | `n8-vps_Netzwerk_Matrix_v1_0.md` | **REFERENZ** | Netzwerk-Uebersicht |
| 13 | `n8-vps_Security-Domain-Strategie_v1_2.md` | **REFERENZ** | Security-Domain Design |
| 14 | `docs/templates/*.md` | **REFERENZ** | ADR/Changelog/README Templates — pruefen ob noch nuetzlich |
| 15 | `docs/architecture/00-06` | **VERALTET** | Fruehe Architektur-Doks, aktuelles Repo hat eigene |
| 16 | `code_standards.md` | **REFERENZ** | Code-Standards — pruefen auf verwertbare Inhalte |
| 17 | `README.md`, `CHANGELOG.md`, `ROADMAP.md` | **DUPLIKAT** | Aktuelles Repo hat neuere Versionen |
| 18 | `.claude/context/ARBEITSWEISE.md` | **VERALTET** | Durch aktuelles Policy-System ersetzt |
| 19 | `.claude/context/STRUKTUR_REFERENZ.md` | **VERALTET** | Durch aktuelles structure.md ersetzt |
| 20 | `mr-bytez_chat_context/` (15 Dateien) | **VERALTET** | Duplikate + veraltete Chat-Kontexte |
| 21 | `n8-vps_Master-Planung_v*.md` (8 Versionen) | **VERALTET** | Nur Versionsverlauf, kein aktueller Nutzen |
| 22 | `templates_emoji_guide.md` | **VERALTET** | Emoji-Policy existiert nicht mehr |
| 23 | `command_block_strategie.md` | **VERALTET** | Claude.ai-spezifisch, nicht fuer Claude Code |
| 24 | `arbeitsweise_bevorzugte_methodik_*.md` | **VERALTET** | Durch CLAUDE.md ersetzt |
| 25 | `claude/skills/n8-dev/` | **VERALTET** | Nur Platzhalter (00Tree.html), keine echten Skills |
| 26 | `labs/docker/network/NetAlertX/` | **VERALTET** | Geklontes Drittanbieter-Repo, 270 MB |
| 27 | `labs/docker/network/WatchYourLAN/` | **VERALTET** | Geklontes Drittanbieter-Repo, 4 MB |
| 28 | `.gitignore` | **REFERENZ** | Umfassender als aktuell — Eintraege vergleichen |
| 29 | `TODO.md` | **VERALTET** | Sprint Woche 3, laengst ueberholt |
| 30 | `LICENSE` | **DUPLIKAT** | Identisch |

---

## 6. Empfehlungen — Top-10 Dinge zur Uebernahme

### Prioritaet 1: Direkt uebernehmen

| # | Was | Wohin | Aufwand |
|---|-----|-------|---------|
| 1 | `bin/plasma/desktop/*.fish` (5 Scripts) | `shared/bin/plasma/desktop/` oder `projects/infrastructure/n8-kiste/bin/plasma/desktop/` | Gering — Copy + ggf. Pfad-Anpassung |
| 2 | `bin/plasma/monitor/*.fish` (4 Scripts) | `projects/infrastructure/n8-kiste/bin/plasma/monitor/` | Gering — Copy |
| 3 | `bin/plasma/utils/panel-duplicate.py` | `projects/infrastructure/n8-kiste/bin/plasma/utils/` | Gering — Copy |

### Prioritaet 2: Als Referenz-Archiv uebernehmen

| # | Was | Wohin | Aufwand |
|---|-----|-------|---------|
| 4 | `n8-vps_OVERVIEW.md` | `projects/infrastructure/n8-vps/docs/` oder `.claude/archive/` | Gering |
| 5 | `n8-vps_PostInstall_Complete_Phase0-4.sh` | `projects/infrastructure/n8-vps/docs/` | Gering |
| 6 | `n8-vps_unbound_custom.conf` | `projects/infrastructure/n8-vps/docs/` | Gering |
| 7 | `n8-vps_Hetzner_Robot_Firewall.txt` | `projects/infrastructure/n8-vps/docs/` | Gering |
| 8 | `n8kiste_tinyssh_setup.md` | `projects/infrastructure/n8-kiste/docs/` | Gering |

### Prioritaet 3: Inhalte extrahieren

| # | Was | Aktion |
|---|-----|--------|
| 9 | `.gitignore` (altes Repo) | Mit aktueller `.gitignore` vergleichen, fehlende sinnvolle Eintraege uebernehmen |
| 10 | `n8kiste_postgresql_migration_status.md` + `n8media-sort_Documentation.md` | Entscheiden ob als Referenz unter `projects/infrastructure/n8-kiste/docs/` archivieren |

---

## 7. Aufwands-Schaetzung

| Aufgabe | Aufwand | Beschreibung |
|---------|---------|-------------|
| Plasma-Scripts uebernehmen (Prio 1) | **5 min** | 10 Dateien kopieren, Pfade pruefen |
| Referenz-Archiv erstellen (Prio 2) | **10 min** | 5 Dateien in Archiv-Ordner kopieren |
| .gitignore Vergleich (Prio 3) | **5 min** | Diff pruefen, Eintraege ergaenzen |
| Restliche Referenz-Doks (Prio 3) | **5 min** | 2 Dateien optional archivieren |
| **Gesamt** | **~25 min** | Inklusive Commit + CHANGELOG |

### Was NICHT zu tun ist

- `labs/` kann komplett ignoriert werden (274 MB Drittanbieter-Code)
- `mr-bytez_chat_context/` kann ignoriert werden (Duplikate)
- `claude/skills/n8-dev/` kann ignoriert werden (leere Platzhalter)
- Die 8 Master-Planungs-Versionen sind nur Versionsverlauf, nicht uebernehmen
- Veraltete Claude.ai-spezifische Doks (Arbeitsweise, Struktur-Referenz) nicht uebernehmen

### Empfehlung zum alten Repo

Das alte Repo kann nach erfolgreicher Uebernahme der relevanten Dateien **archiviert oder geloescht** werden. Es enthaelt keinen Code oder Konfiguration die nicht besser im aktuellen Repo aufgehoben waere. Die 274 MB in `labs/` sind geklonte Drittanbieter-Repos die jederzeit neu geklont werden koennen.

---

**Report-Ende**
