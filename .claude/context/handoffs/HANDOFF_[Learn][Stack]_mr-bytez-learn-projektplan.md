# mr-bytez-learn — Projektplan & Repo-Struktur

**Version:** 0.2.0
**Erstellt:** 2026-02-11
**Aktualisiert:** 2026-02-11
**Autor:** MR-ByteZ
**Status:** Entwurf / Planungsphase
**Lizenz:** GPL v3

---

## Vision

**mr-bytez-learn** ist ein offenes Lernprojekt das strukturiertes Arbeiten mit modernen
Tools vermittelt — von AI (Claude) über Windows, Linux, Git, Python bis hin zu Docker
und Web-Grundlagen.

Die Lernplattform IST das Projekt. Man lernt, indem man daran mitarbeitet.

### Kernprinzipien

- **Open Source** — Alles öffentlich, Spendenbasiert, kein Paywall
- **Docker-first** — Fertige Lernumgebung per `docker compose up`
- **Jupyter-first** — Interaktive Notebooks als Haupteingang, Terminal kommt später
- **Community-driven** — Fork → Lernen → PR → Teamarbeit
- **Teil des mr-bytez Ökosystems** — Nutzt bewährte Patterns und Best Practices
- **Mehrsprachig** — Deutsch first, Community übersetzt (beliebig viele Sprachen)

### Zielgruppe

- Teens (ab ~13 Jahre) die mehr als nur Zocken wollen
- Quereinsteiger und Umschüler
- Hobby-Entwickler die strukturiertes Arbeiten lernen wollen
- Jeder der einen soliden Einstieg in moderne Entwicklungstools braucht

---

## Einbindung ins mr-bytez Ökosystem

### 3 Repos

| Repo | Sichtbarkeit | Zweck |
|------|-------------|-------|
| `mr-bytez` | Public | Main Repo — Infrastruktur, Configs, Hosts |
| `mr-bytez-secrets` | Private | Submodule — Age-verschlüsselte Secrets |
| `mr-bytez-learn` | Public | Community-Projekt — Lernplattform + Docker Stack |

### Einbindung in mr-bytez

**Neuer Projekt-Typ 3:** `projects/community/`

```
/mr-bytez/
├── projects/
│   ├── infrastructure/        # Typ 1: Physical Hosts
│   │   ├── n8-kiste/
│   │   └── n8-vps/
│   │
│   └── community/             # Typ 3: Community-Projekte ⭐ NEU
│       └── mr-bytez-learn/    # Git Submodule → eigenes Repo
```

**Verweis in mr-bytez:**
- `ROADMAP.md` — Neues A-Projekt (A6: mr-bytez-learn)
- `README.md` — Verweis auf Community-Projekt
- `.claude/CLAUDE.md` — Aktive Projekte Tabelle erweitern
- `.claude/context/structure.md` — Neuer Projekt-Typ dokumentieren

### Hosting

- **GitHub** (Main): `mr-bytez/mr-bytez-learn` — Reichweite, Community, PRs, Issues
- **Codeberg** (Mirror): `n8lauscher/mr-bytez-learn` — Konsistenz mit mr-bytez

### Was wir von mr-bytez übernehmen

| Was | Wie |
|-----|-----|
| 5-3-3 Pattern | Vereinfacht (weniger context-Dateien) |
| Fish Aliases | Subset (nav, eza, docker, git) |
| Commit-Format | `[Tag][Tag] Beschreibung` |
| Docs-first Workflow | Ja |
| Additive-Only Regel | Ja |
| Header-Template | Vereinfacht |
| `.claude/` Struktur | Ja, angepasst |

### Was ANDERS ist als mr-bytez

| Aspekt | mr-bytez | mr-bytez-learn |
|--------|----------|----------------|
| Ziel | Infrastruktur-Management | Lernen & Community |
| Zielgruppe | Einzelperson | Öffentlich, Einsteiger |
| Branches | Nur main | main + Feature-Branches |
| PRs | Keine | Kern-Workflow! |
| Container | mrbz-dev (persönliche Umgebung) | mrbz-learn (Lern-Stack) |
| Secrets | Age-Encryption, Submodule | Keine (public Repo!) |
| Sprache | Deutsch | Deutsch first, mehrsprachig |

---

## Mehrsprachigkeit

### Strategie: Deutsch first, Community übersetzt

**Curriculum:**
```
curriculum/
├── modul-00-claude/               # Deutsch (Original)
│   ├── 00-was-ist-ki.ipynb
│   └── ...
└── translations/                  # Übersetzungen
    ├── README.md                      # Anleitung zum Übersetzen
    ├── en/                            # Englisch
    │   └── modul-00-claude/
    │       ├── 00-what-is-ai.ipynb
    │       └── ...
    ├── es/                            # Spanisch (Beispiel)
    ├── tr/                            # Türkisch (Beispiel)
    └── ...                            # Beliebig erweiterbar
```

**Repo-Doku (README, CONTRIBUTING etc.):**
- Ein Dokument mit beiden Sprachen (DE + EN)
- Deutsch oben, Englisch unten (oder Sections)

**Warum dieser Ansatz:**
- Du schreibst nur Deutsch — kein doppelter Aufwand
- Übersetzungen sind ein perfekter Community-Beitrag (PR!)
- Skaliert auf beliebig viele Sprachen
- Neue Sprachen hinzufügen = neuer Ordner unter `translations/`

---

## Repo-Struktur

```
mr-bytez-learn/
│
├── README.md                          # Projekt-Übersicht (DE + EN)
├── CHANGELOG.md                       # Versions-Historie
├── ROADMAP.md                         # Projekt-Planung
├── DEPLOYMENT.md                      # "So startest du" (Onboarding)
├── CONTRIBUTING.md                    # Contribution Guidelines (DE + EN)
├── CLAUDE-CONTEXT.md                  # ⭐ Kontext-Doc für Free-User
├── LICENSE                            # GPL v3
├── .gitignore
│
│── ═══════════════════════════════════════════
│   🤖 KI-CONTEXT
│── ═══════════════════════════════════════════
│
├── .claude/
│   ├── CLAUDE.md                      # Zentrale Steuerung für Claude
│   ├── README.md                      # GitHub-Darstellung
│   ├── CHANGELOG.md                   # .claude/ Historie
│   ├── ROADMAP.md                     # .claude/ Planung
│   │
│   ├── context/                       # Projekt-Policies
│   │   ├── policies.md                    # Grundregeln (vereinfacht)
│   │   ├── structure.md                   # Repo-Aufbau
│   │   ├── curriculum.md                  # Lehrplan-Übersicht
│   │   ├── contribution.md                # PR-Workflow, Code-Standards
│   │   └── stack.md                       # Docker Stack Architektur
│   │
│   ├── skills/                        # AI-Skills
│   │   └── .gitkeep
│   ├── configs/                       # Konfigurationen
│   │   └── .gitkeep
│   └── archive/                       # Abgeschlossene Arbeit
│       └── .gitkeep
│
│── ═══════════════════════════════════════════
│   🐳 DOCKER STACK
│── ═══════════════════════════════════════════
│
├── stack/
│   ├── docker-compose.yml             # Stack-Definition (alle Services)
│   ├── Dockerfile.workspace           # Arch Linux Workspace Image
│   ├── Dockerfile.jupyter             # Jupyter Image (Arch-basiert)
│   ├── entrypoint.fish                # Workspace Startup-Script
│   │
│   ├── fish/                          # Fish Shell Config (mr-bytez Light)
│   │   ├── conf.d/
│   │   │   └── 00-learn-theme.fish        # Prompt + Theme
│   │   ├── aliases/
│   │   │   ├── 10-nav.fish                # Navigation
│   │   │   ├── 20-eza.fish                # Listing
│   │   │   ├── 30-docker.fish             # Docker
│   │   │   └── 40-git.fish                # Git
│   │   └── functions/
│   │       └── learn-info.fish            # Diagnose (wie mr-bytez-info)
│   │
│   └── jupyter/
│       └── jupyter_config.py          # Jupyter Konfiguration
│
├── .devcontainer/                     # VS Code DevContainer
│   └── devcontainer.json              # Nutzt docker-compose.yml mit
│
│── ═══════════════════════════════════════════
│   📚 CURRICULUM
│── ═══════════════════════════════════════════
│
├── curriculum/
│   │
│   │── ── Phase 0: Onboarding (VOR Container) ──
│   │
│   ├── onboarding/
│   │   ├── 00-willkommen.md               # Was ist mr-bytez-learn?
│   │   │
│   │   ├── 01-computer-basics/            # ⭐ Windows Grundwissen
│   │   │   ├── 01-dateisystem.md              # Ordner, Dateien, Erweiterungen
│   │   │   ├── 02-taskmanager-basics.md       # Was sind Prozesse? (grob)
│   │   │   ├── 03-terminal-cmd.md             # CMD öffnen, dir, cd, mkdir
│   │   │   ├── 04-netzwerk-basics.md          # IP, was ist Internet (grob)
│   │   │   └── 05-sicherheit-basics.md        # Passwörter, 2FA, Phishing
│   │   │
│   │   ├── 02-voraussetzungen.md          # Hardware, Accounts (Claude, GitHub)
│   │   ├── 03-installation-windows.md     # Docker Desktop + WSL2
│   │   ├── 04-installation-linux.md       # Docker auf nativem Linux
│   │   ├── 05-erster-start.md             # git clone + docker compose up
│   │   └── 06-test-onboarding.md          # ⭐ Erster Offline-Test!
│   │
│   │── ── Phase A: Jupyter-first (interaktiv) ──
│   │
│   ├── modul-00-claude/               # 🤖 AI & Claude verstehen
│   │   ├── 00-was-ist-ki.ipynb
│   │   ├── 01-claude-chat.ipynb
│   │   ├── 02-kontext-und-memory.ipynb
│   │   ├── 03-projekte-und-anweisungen.ipynb
│   │   ├── 04-claude-cli.ipynb
│   │   ├── 05-prompt-engineering.ipynb
│   │   └── test/
│   │       └── test-modul-00.md
│   │
│   ├── modul-01-computer-vertiefung/  # 🖥️ Computer-Vertiefung
│   │   ├── 00-taskmanager-detail.ipynb
│   │   ├── 01-netzwerk-detail.ipynb
│   │   ├── 02-powershell-vs-bash.ipynb
│   │   ├── 03-software-paketmanager.ipynb
│   │   ├── 04-windows-vs-linux.ipynb
│   │   └── test/
│   │       └── test-modul-01.md
│   │
│   ├── modul-02-linux/                # 🐧 Linux & WSL
│   │   ├── 00-was-ist-linux.ipynb
│   │   ├── 01-terminal-grundlagen.ipynb
│   │   ├── 02-dateisystem-linux.ipynb
│   │   ├── 03-pacman.ipynb
│   │   ├── 04-shell-basics.ipynb
│   │   ├── 05-text-editieren.ipynb
│   │   └── test/
│   │       └── test-modul-02.md
│   │
│   ├── modul-03-git/                  # 🔀 Git & Teamarbeit
│   │   ├── 00-was-ist-git.ipynb
│   │   ├── 01-git-basics-lokal.ipynb
│   │   ├── 02-github-web.ipynb
│   │   ├── 03-clone-push-pull.ipynb
│   │   ├── 04-fork-und-pr.ipynb
│   │   └── test/
│   │       └── test-modul-03.md
│   │
│   ├── modul-04-docker/               # 🐳 Docker Grundlagen
│   │   ├── 00-was-ist-docker.ipynb
│   │   ├── 01-images-container.ipynb
│   │   ├── 02-docker-compose.ipynb
│   │   ├── 03-unser-stack.ipynb
│   │   └── test/
│   │       └── test-modul-04.md
│   │
│   │── ── Phase B: Terminal-Übergang ──
│   │
│   ├── modul-05-python/               # 🐍 Python — Quiz-Plattform
│   │   ├── 00-hello-world.ipynb
│   │   ├── 01-variablen-datentypen.ipynb
│   │   ├── 02-if-else.ipynb
│   │   ├── 03-schleifen.ipynb
│   │   ├── 04-listen-dicts.ipynb
│   │   ├── 05-funktionen.ipynb
│   │   ├── 06-dateien-json.ipynb
│   │   ├── 07-klassen-oop.ipynb
│   │   ├── 08-quiz-tool-v1.ipynb          # ⭐ Meilenstein!
│   │   ├── 09-error-handling.ipynb
│   │   ├── 10-cli-verschoenern.ipynb
│   │   ├── 11-quiz-erweitern.ipynb
│   │   ├── 12-quiz-tool-v2.ipynb          # 🏆 Meilenstein!
│   │   └── test/
│   │       └── test-modul-05.md
│   │
│   ├── modul-06-web/                  # 🌐 Web-Grundlagen
│   │   ├── 00-wie-funktioniert-web.ipynb
│   │   ├── 01-html-struktur.ipynb
│   │   ├── 02-css-styling.ipynb
│   │   ├── 03-javascript-ueberblick.ipynb
│   │   ├── 04-php-ueberblick.ipynb
│   │   ├── 05-projektseite.ipynb          # ⭐ Meilenstein!
│   │   └── test/
│   │       └── test-modul-06.md
│   │
│   │── ── Phase C: Community (parallel ab Modul 3) ──
│   │
│   ├── modul-07-community/            # 🌍 Community & Social
│   │   ├── 00-readme-schreiben.ipynb
│   │   ├── 01-fortschritt-blog.ipynb
│   │   ├── 02-discord-setup.ipynb
│   │   └── 03-andere-einladen.ipynb
│   │
│   │── ── Übersetzungen ──
│   │
│   └── translations/
│       ├── README.md                      # Anleitung zum Übersetzen
│       ├── en/
│       │   ├── onboarding/
│       │   ├── modul-00-claude/
│       │   └── ...
│       └── ...
│
│── ═══════════════════════════════════════════
│   🐍 QUIZ-PLATTFORM
│── ═══════════════════════════════════════════
│
├── quiz/
│   ├── README.md
│   ├── main.py
│   ├── quiz_engine.py
│   ├── questions/
│   │   ├── modul-00-claude.json
│   │   ├── modul-01-computer.json
│   │   ├── modul-02-linux.json
│   │   ├── modul-03-git.json
│   │   ├── modul-04-docker.json
│   │   ├── modul-05-python.json
│   │   └── modul-06-web.json
│   └── scores/                        # gitignored!
│       └── .gitkeep
│
│── ═══════════════════════════════════════════
│   👤 PERSÖNLICHER BEREICH (in Forks)
│── ═══════════════════════════════════════════
│
├── workspace/
│   ├── README.md
│   ├── notizen/
│   │   └── .gitkeep
│   ├── projekte/
│   │   └── .gitkeep
│   └── fortschritt/
│       └── .gitkeep
│
│── ═══════════════════════════════════════════
│   📋 TESTS (Offline)
│── ═══════════════════════════════════════════
│
└── tests/
    ├── README.md                      # Anleitung für Mentoren
    ├── modul-00-claude.md
    ├── modul-01-computer.md
    ├── modul-02-linux.md
    ├── modul-03-git.md
    ├── modul-04-docker.md
    ├── modul-05-python.md
    ├── modul-06-web.md
    └── loesungen/
        ├── .gitkeep
        └── README.md                  # "NUR für Mentoren!"
```

---

## Docker Stack — Architektur

### Netzwerk

```
mrbz-learn-net (172.31.0.0/24)

┌──────────────────────────────────────────────────────────┐
│                                                           │
│  ┌─────────────────┐    ┌─────────────────┐              │
│  │ mrbz-learn-     │    │ mrbz-learn-     │              │
│  │ workspace        │    │ terminal        │  Port 7681   │
│  │                  │    │ (ttyd)          │  ← Browser   │
│  │ Arch Linux       │◄──┤ Web-Terminal     │              │
│  │ Fish, Python,    │    └─────────────────┘              │
│  │ Node, Git, Micro │                                     │
│  │ eza, bat, htop   │    ┌─────────────────┐              │
│  │ fastfetch, etc.  │    │ mrbz-learn-     │              │
│  └─────────────────┘    │ jupyter          │  Port 8888   │
│                          │ (Notebooks)     │  ← Browser   │
│                          └─────────────────┘              │
│                                                           │
│                          ┌─────────────────┐              │
│                          │ mrbz-learn-     │  Port 9443   │
│                          │ portainer       │  ← Browser   │
│                          │ (Phase 3)       │              │
│                          └─────────────────┘              │
└──────────────────────────────────────────────────────────┘
```

### Container-Details

#### mrbz-learn-workspace (Phase 1)

**Base:** `archlinux:base-devel`
**Zweck:** Hauptarbeitsumgebung

**Pakete (alle via pacman):**
```
# Basis
base-devel fish python python-pip nodejs npm git github-cli micro openssh

# Moderne CLI Tools
eza bat htop fastfetch duf dust tree jq ripgrep fd

# Extras
xclip
```

**Fish Config:** mr-bytez Light — Vereinfachter Prompt, Basis-Aliases,
learn-info Funktion, Farbschema Grün.

#### mrbz-learn-terminal (Phase 1)

**Image:** `tsl0922/ttyd` oder custom
**Port:** 7681
**Nutzung:** Ab Modul 2 aktiv (vorher primär Jupyter)

#### mrbz-learn-jupyter (Phase 1 — Haupteingang!)

**Base:** `archlinux:base-devel` + Jupyter
**Port:** 8888
**Pakete:** `python python-pip` + `pip: jupyterlab notebook ipykernel`
**Rolle:** Primärer Einstiegspunkt für alle Teilnehmer!

#### mrbz-learn-portainer (Phase 3)

**Image:** `portainer/portainer-ce`
**Port:** 9443

### Docker Compose

```yaml
# stack/docker-compose.yml
version: "3.8"

services:
  workspace:
    build:
      context: .
      dockerfile: Dockerfile.workspace
    container_name: mrbz-learn-workspace
    hostname: mrbz-learn
    stdin_open: true
    tty: true
    restart: unless-stopped
    volumes:
      - mrbz-learn-home:/home/learner
      - mrbz-learn-projects:/projects
      - ../curriculum:/notebooks:ro
    networks:
      mrbz-learn-net:
        ipv4_address: 172.31.0.10

  terminal:
    image: tsl0922/ttyd:latest
    container_name: mrbz-learn-terminal
    restart: unless-stopped
    ports:
      - "7681:7681"
    command: >
      ttyd --writable
      docker exec -it mrbz-learn-workspace fish
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - workspace
    networks:
      mrbz-learn-net:
        ipv4_address: 172.31.0.11

  jupyter:
    build:
      context: .
      dockerfile: Dockerfile.jupyter
    container_name: mrbz-learn-jupyter
    restart: unless-stopped
    ports:
      - "8888:8888"
    volumes:
      - ../curriculum:/notebooks
      - mrbz-learn-home:/home/learner
    networks:
      mrbz-learn-net:
        ipv4_address: 172.31.0.12

  # Phase 3
  # portainer:
  #   image: portainer/portainer-ce:latest
  #   container_name: mrbz-learn-portainer
  #   restart: unless-stopped
  #   ports:
  #     - "9443:9443"
  #   volumes:
  #     - /var/run/docker.sock:/var/run/docker.sock
  #     - mrbz-learn-portainer:/data
  #   networks:
  #     mrbz-learn-net:
  #       ipv4_address: 172.31.0.20

volumes:
  mrbz-learn-home:
  mrbz-learn-projects:

networks:
  mrbz-learn-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.31.0.0/24
```

### VS Code DevContainer

```json
{
  "name": "mr-bytez-learn",
  "dockerComposeFile": "../stack/docker-compose.yml",
  "service": "workspace",
  "workspaceFolder": "/projects",
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "fish"
      },
      "extensions": [
        "ms-python.python",
        "bmalehorn.vscode-fish",
        "ms-azuretools.vscode-docker",
        "eamodio.gitlens",
        "ms-toolsai.jupyter",
        "ms-vsliveshare.vsliveshare",
        "yzhang.markdown-all-in-one"
      ]
    }
  },
  "forwardPorts": [7681, 8888],
  "postCreateCommand": "echo '🎉 mr-bytez-learn bereit! http://localhost:8888'"
}
```

---

## Curriculum — Lernpfad

### Überblick: Windows-Basics → Jupyter → Terminal

```
Phase 0: Onboarding (VOR dem Container, Markdown)
├── Windows-Basics (Dateisystem, CMD, Netzwerk grob, Sicherheit)
├── Docker/WSL Installation
└── Erster Start: git clone + docker compose up

Phase A: Jupyter-first (geführt, visuell, interaktiv)
├── Modul 0: Claude verstehen
├── Modul 1: Computer-Vertiefung (Taskmanager, Netzwerk, Shells)
├── Modul 2: Linux Basics (Terminal-Zellen in Jupyter)
├── Modul 3: Git (Konzepte in Jupyter → Terminal)
└── Modul 4: Docker Grundlagen (eigenen Stack verstehen!)

Phase B: Terminal-Übergang (selbstständiger)
├── Modul 5: Python — Quiz-Plattform bauen (Jupyter → Editor+Terminal)
└── Modul 6: Web-Grundlagen (HTML/CSS → Browser+Editor)

Phase C: Community (parallel ab Modul 3)
└── Modul 7: README, Blog, Discord, Social, Übersetzen
```

### Windows-Basics: Mix-Ansatz

**VOR dem Container (Onboarding, Markdown):**
- Dateisystem (C:\, Downloads, Dateierweiterungen)
- CMD/PowerShell öffnen, erste Befehle
- IP-Adresse (ganz grob)
- Sicherheit (Passwörter, 2FA, Phishing)
- → Genug um Docker/WSL installieren zu können!

**NACH dem Container (Modul 1, Jupyter-Vertiefung):**
- Taskmanager (Prozesse, RAM vs. Festplatte)
- Netzwerk tiefer (DNS, HTTP)
- PowerShell vs. Fish/Bash Vergleich
- winget vs. pacman
- Windows vs. Linux Gegenüberstellung

### Zeitplan (3x pro Woche, ~1h pro Session)

| Phase | Modul | Wochen | Sessions | Modus |
|-------|-------|--------|----------|-------|
| 0 | Onboarding + Windows-Basics | 0 | 2-3 | Markdown, mit Papa |
| A | Modul 0: Claude | 1-2 | ~6 | Jupyter |
| A | Modul 1: Computer-Vertiefung | 3-4 | ~5 | Jupyter |
| A | Modul 2: Linux | 5-6 | ~7 | Jupyter → Terminal |
| A | Modul 3: Git | 7-8 | ~5 | Jupyter → Terminal |
| A | Modul 4: Docker | 9-10 | ~4 | Jupyter → Terminal |
| B | Modul 5: Python | 11-20 | ~30 | Jupyter → Terminal |
| B | Modul 6: Web | 21-24 | ~12 | Jupyter → Browser |
| C | Modul 7: Community | parallel | laufend | Mix |
| | **Gesamt** | **~24** | **~72** | **~6 Monate** |

### Prüfungskonzept

- Offline-Tests nach jedem Modul (Papier oder mündlich)
- OHNE Claude oder Computer
- Papa/Mentor prüft
- Tests in `tests/`, Lösungen in `tests/loesungen/`
- Quiz-Tool (ab Modul 5) zusätzlich zur Selbstkontrolle

---

## Claude-Zugang — Zwei-Wege-Strategie

### Weg 1: Für alle (Doku im Repo)

- Jupyter Notebooks sind selbsterklärend
- Projekt funktioniert zu 100% ohne Claude-Account
- Claude ist ein optionaler Buddy zum Fragen stellen

### Weg 2: Für ambitionierte (CLAUDE-CONTEXT.md)

- Kontext-Doc im Repo-Root
- User kopiert/lädt es in einen neuen Claude-Chat hoch
- Claude versteht sofort den Projektkontext
- Aktualisierung bei größeren Änderungen

### Varianten dokumentiert

| Variante | Kosten | Für wen |
|----------|--------|---------|
| Ohne Claude | Kostenlos | Funktioniert! |
| Claude.ai Free | Kostenlos | Alle |
| Claude.ai Pro | ~20$/Monat | Power-User |
| Claude Code CLI | Pro/Max | Fortgeschrittene |

### Für Maintainer (du)

- Claude.ai Pro mit GitHub Sync + Projekt
- `.claude/` Struktur im Repo
- Claude Code auf n8-kiste

---

## Commit-Workflow

### Maintainer

| Aspekt | Workflow |
|--------|----------|
| Commits | Auf n8-kiste |
| Remotes | GitHub (origin) + Codeberg (codeberg) |
| Push | Immer zu beiden |
| Format | `[Tag1][Tag2] Beschreibung` |
| Tags | Eigene Tag-Registry |
| Sprache | Deutsch |

### Community (PRs)

| Aspekt | Workflow |
|--------|----------|
| Fork | Auf GitHub |
| Branch | Feature-Branch |
| PR | Gegen `main` |
| Review | Maintainer |
| Merge | Squash & Merge |

### Tag-Registry (Vorschlag)

| Tag | Index | Bedeutung |
|-----|-------|-----------|
| Curriculum | CUR | Lektionen, Module, Notebooks |
| Quiz | QIZ | Quiz-Plattform |
| Stack | STK | Docker Stack |
| Docs | DOC | Dokumentation |
| Community | COM | Community, Social |
| Translation | TRL | Übersetzungen |
| Structure | STR | Repo-Struktur |
| Fix | FIX | Bugfixes |
| Test | TST | Tests, Prüfungen |
| Onboarding | ONB | Onboarding-Material |

---

## Monetarisierung & Nachhaltigkeit

**Grundprinzip:** Open Source, Spendenbasiert, kein Paywall.

- GitHub Sponsors / Ko-fi Link im README
- Aufmerksamkeit zuerst, Geld kommt wenn's Wert liefert
- Kein Premium-Content

**Selbsttragendes Wachstum:**
- Modulares System (neue Module unabhängig)
- Übersetzungen als Community-Beitrag
- Community-Maintainer (nicht alles an einer Person)
- CI/CD für Notebook-Validierung

---

## Nächste Schritte

### Phase 0: Vorbereitung (du + Claude)

1. [ ] Dieses Dokument finalisieren
2. [ ] Repo auf GitHub erstellen (`mr-bytez/mr-bytez-learn`)
3. [ ] Codeberg Mirror einrichten
4. [ ] Repo-Grundstruktur anlegen
5. [ ] Docker Stack implementieren (Dockerfiles, compose)
6. [ ] Fish Config Light erstellen
7. [ ] DevContainer konfigurieren
8. [ ] CLAUDE-CONTEXT.md erstellen
9. [ ] Onboarding-Guide schreiben (inkl. Windows-Basics)
10. [ ] Erste Jupyter Notebooks (Modul 0)
11. [ ] Erste Offline-Tests

### Phase 1: Pilot (dein Sohn)

12. [ ] Onboarding durchführen
13. [ ] Modul 0 durcharbeiten
14. [ ] Feedback, Notebooks anpassen
15. [ ] Weitere Module erstellen

### Phase 2: Community

16. [ ] README + CONTRIBUTING finalisieren (DE + EN)
17. [ ] Discord/Social Setup
18. [ ] Erste externe Teilnehmer
19. [ ] translations/ vorbereiten

### mr-bytez Repo-Änderungen

20. [ ] `projects/community/` Ordner erstellen
21. [ ] `mr-bytez-learn` als Submodule einbinden
22. [ ] `.claude/context/structure.md` — Typ 3 dokumentieren
23. [ ] `.claude/CLAUDE.md` — Aktive Projekte erweitern
24. [ ] `ROADMAP.md` — A6: mr-bytez-learn
25. [ ] `CHANGELOG.md` — Community-Projekt dokumentieren
26. [ ] `.claude/context/tags.md` — Neue Tags
