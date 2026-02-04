# mrbz-dev – Architektur & Implementierungsplan

**Projekt:** mr-bytez Development Stack  
**Scope:** Docker-basierte Entwicklungsumgebung für alle mr-bytez Hosts  
**Erstellt:** 2026-02-04  
**Status:** Architektur finalisiert, Phase 1 Implementation steht an

---

## 1. Vision

Ein Arch-basierter Docker-Container als vollständige, portable Entwicklungsumgebung:

- Vollständige mr-bytez Integration (Fish, Micro, Aliases, Theme, Loader)
- AI CLI Tools (Claude Code, OpenAI, Gemini, Mistral, Grok)
- VS Code Remote Development Support
- MCP Server (separater Container)
- AionUI Web Interface (separater Container)
- Docker Socket Zugriff (spätere Phase)

Der Container läuft auf **jedem Host** (n8-kiste, n8-station, n8-book) mit identischem Verhalten.

---

## 2. Architektur-Entscheidungen (ADRs)

### ADR-001: Docker über Nix

**Entscheidung:** Docker statt Nix DevShell.

**Begründung:**

- Funktionales Arch+pacman+mr-bytez Setup bereits vorhanden
- Nix DevShell bietet **keine** Isolation (nur PATH-Modifikation)
- Docker bietet echte Sandbox (Prozesse, Dateisystem, Netzwerk)
- Nix Multi-Environment-Reproduzierbarkeit nicht nötig für Single-Developer mit konsistenten Arch-Hosts
- Nix hat hohe Lernkurve mit wenig Mehrwert für diesen Use-Case

**Nix-Pakete identifiziert (nicht verwendet):**

- `claude-code` (nixpkgs), `claude-dev` (devenv), `aider-chat`, `codex`, `continue`
- Docker-Socket-Ansätze für Container-Zugriff evaluiert
- Fazit: Löst ein Problem das wir nicht haben

### ADR-002: Git-only Workflow (KEIN Volume Mount)

**Entscheidung:** Container hat eigenen Git-Clone, alle Änderungen über Git.

**Begründung:**

| Aspekt | Volume Mount | Git-only ✅ |
|--------|-------------|-------------|
| Isolation | ❌ Shared State | ✅ Komplett isoliert |
| Host-Risiko | ❌ AI Tools können Host-Dateien brechen | ✅ Host bleibt stabil bis expliziter Pull |
| Portabilität | ❌ Pfad-abhängig | ✅ Identisch auf jedem Host |
| Versionskontrolle | ❌ Implizit | ✅ Erzwingt Disziplin |
| Sandbox | ❌ Prozess-Sandbox, aber Daten-Coupling | ✅ Echte Sandbox |

**Workflow:**

```
Container (mrbz-dev)          Host (n8-kiste)
    │                              │
    ├── Code ändern                │
    ├── git commit                 │
    ├── git push ──────────────►   │
    │                              ├── git pull
    │                              ├── Änderungen prüfen
    │                              └── ✅ Bewusste Übernahme
```

### ADR-003: Container-Identität

**Entscheidung:**

| Eigenschaft | Wert |
|-------------|------|
| Stack-Name | `mrbz-dev` |
| Location im Repo | `shared/stacks/mrbz-dev/` |
| Hostname | `mrbz-dev` |
| Host-Config | `projects/infrastructure/mrbz-dev/` |
| Prompt-Farbe | 🟧 Orange |
| User | `mrohwer` |

**Naming-Konvention (global):**

- Physische Hosts: `n8-*` Prefix
- Container/Stacks: `mrbz-*` Prefix
- Sofortige Unterscheidung physisch vs. virtuell

### ADR-004: MCP als separater Container

**Entscheidung:** MCP Server läuft in eigenem Container innerhalb desselben Stacks.

**Begründung:**

- Unterschiedliche Lifecycles (MCP = persistent service, Workspace = interaktive Shell)
- Unabhängiges Scaling und Restart
- Saubere Trennung der Verantwortlichkeiten
- Service Discovery über Docker-Netzwerk

### ADR-005: VS Code Integration

**Entscheidung:** Dev Containers Extension (Microsoft) statt Remote SSH/Tunnel.

**Begründung:**

- Bessere Integration (Extensions laufen im Container-Kontext)
- Schnelleres Setup
- `devcontainer.json` im Repo versionierbar
- Standard-Workflow für containerisierte Entwicklung

### ADR-006: Docker Socket

**Entscheidung:** NICHT in Phase 1. Docker-outside-of-Docker wenn implementiert.

**Begründung:**

- Basis-Container muss zuerst funktionieren
- Docker-in-Docker (DinD) zu komplex und fragil
- Host-Socket-Mount ist pragmatischer Ansatz
- Sicherheitsimplikationen müssen separat evaluiert werden

---

## 3. Netzwerk-Architektur

### Custom Bridge Network

| Eigenschaft | Wert |
|-------------|------|
| Netzwerk-Name | `mrbz-dev-net` |
| Subnet | `172.30.0.0/24` |
| Gateway | `172.30.0.1` |

### Container & IP-Zuordnung

| Container | Hostname | IP | Rolle |
|-----------|----------|-----|-------|
| `mrbz-dev-workspace` | `mrbz-dev` | `172.30.0.10` | Haupt-Entwicklungscontainer |
| `mrbz-dev-mcp` | `mrbz-mcp` | `172.30.0.20` | MCP Server |
| `mrbz-dev-qdrant` | `mrbz-qdrant` | `172.30.0.30` | Vector DB (RAG) |
| `mrbz-dev-aionui` | `mrbz-aionui` | `172.30.0.40` | AionUI Web Interface |

### DNS-Strategie

- **Hostname only** (kurz, für Fish Loader Matching)
- DNS-Aliases im Docker-Netzwerk für Service Discovery verfügbar
- Keine verschachtelten DNS-Zonen, keine Symlinks

---

## 4. Infrastruktur-Verzeichnisstruktur

**Entscheidung:** Flach, keine Zonen, keine Symlinks.

```
projects/infrastructure/
├── n8-kiste/              # 🖥️  Desktop/Dev (physisch)
├── n8-vps/                # 🖥️  Hetzner Server (physisch)
├── n8-station/            # 🖥️  Workstation (physisch)
├── n8-book/               # 💻 Laptop (physisch)
├── n8-bookchen/           # 💻 Small Laptop (physisch)
├── n8-maxx/               # 🎮 Gaming PC (physisch)
├── n8-broker/             # 📈 Trading (physisch)
├── n8-archstick/          # 🔌 USB Stick (physisch)
├── mrbz-dev/              # 🐳 Workspace Container
├── mrbz-mcp/              # 🐳 MCP Container
├── mrbz-qdrant/           # 🐳 Qdrant Container
└── mrbz-aionui/           # 🐳 AionUI Container
```

Fish Loader bleibt unverändert — `hostname` matched direkt.

---

## 5. Secrets Management

### Strategie

- Alle Secrets in `shared/.secrets/` Submodule (Age-verschlüsselt)
- Container clont Submodule, entschlüsselt mit `derive_key.fish` + Master-Password
- **Kein Klartext** im Container-Image oder in Environment-Variablen

### Bootstrap-Prozess

```
1. Container startet
2. gh auth login (Browser-Flow auf GUI-Host)
   ODER Token aus Secrets-Submodule (Headless)
3. gh repo clone mr-bytez/mr-bytez-secrets → shared/.secrets/
4. derive_key.fish secrets --with-host → Age-Passphrase
5. Secrets entschlüsseln
```

### GitHub CLI Auth

- GUI-Hosts: `gh auth login` → Browser-Flow
- Headless/Container: Token aus Secrets-Submodule
- OAuth-basiert, kein SSH-Key nötig

---

## 6. Fish Shell Integration

### Loader-Kompatibilität

Der bestehende Fish Loader (`00-loader.fish`) funktioniert ohne Änderung:

```fish
set -l host_base /mr-bytez/projects/infrastructure/(hostname)/root/home/(whoami)/.config/fish
```

- `hostname` im Container = `mrbz-dev` → matched `projects/infrastructure/mrbz-dev/`
- Shared Configs (00-69) laden zuerst
- Container-spezifische Overrides (70-89) danach

### Container Fish Config

```
projects/infrastructure/mrbz-dev/
└── root/home/mrohwer/.config/fish/
    ├── aliases/
    │   ├── 70-dev.fish          # Dev-Kategorie (statt Desktop/Server)
    │   └── 80-mrbz-dev.fish    # Container-spezifisch
    ├── variables/
    │   └── 10-host.fish         # N8_HOST_TEST, keine Display-Vars
    └── functions/
        └── mrbz-dev-test.fish   # Host-Test Funktion
```

### Prompt-Farbe

- `__mr_host_color.fish` erweitern: `mrbz-dev` → Orange (`e67e22`)
- Sofortige visuelle Unterscheidung: "Ich bin im Container"

### Fish History

- Host-unabhängig, persistiert im Container
- Docker Named Volume oder im Repo unter mrbz-dev Config

---

## 7. Implementierung

### Phase 1: Foundation 🔴 NÄCHSTER SCHRITT

**Ziel:** Funktionierender Basis-Container mit mr-bytez Integration.

#### 1.1 Docker Stack

```
shared/stacks/mrbz-dev/
├── docker-compose.yml
├── Dockerfile
├── .devcontainer/
│   └── devcontainer.json
└── README.md
```

#### 1.2 Base Image & Setup

| Schritt | Detail |
|---------|--------|
| Base Image | `archlinux:base-devel` |
| User Setup | `mrohwer` (non-root, sudo) |
| Locale | `de_DE.UTF-8` + `en_US.UTF-8` |
| Timezone | `Europe/Berlin` |
| Shell | Fish als Default (`chsh -s /usr/bin/fish`) |

#### 1.3 mr-bytez Integration

| Schritt | Detail |
|---------|--------|
| Git Clone | `gh repo clone mr-bytez/mr-bytez` → `/mr-bytez` |
| Anker | `/opt/mr-bytez/current` → `/mr-bytez` |
| Fish Symlink | `/etc/fish` → `/opt/mr-bytez/current/shared/etc/fish` |
| Micro Symlink | `/usr/local/share/micro` → `/opt/mr-bytez/current/shared/usr/local/share/micro` |
| User Config | `~/.config/fish/config.fish` → Repo |

#### 1.4 Tools (via pacman)

**Basis:**

- `fish`, `micro`, `git`, `github-cli`
- `eza`, `bat`, `fastfetch`, `duf`, `dust`, `htop`
- `tree`, `jq`, `ripgrep`, `fd`

**AI CLI (Phase 1 nur Claude Code):**

- `claude-code` (npm install)
- Node.js 20+ als Dependency

#### 1.5 VS Code DevContainer

```json
{
  "name": "mrbz-dev",
  "dockerComposeFile": "docker-compose.yml",
  "service": "workspace",
  "workspaceFolder": "/mr-bytez",
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "fish"
      }
    }
  }
}
```

#### 1.6 Erwartetes Ergebnis Phase 1

- ✅ `docker compose up -d` startet Container
- ✅ `docker exec -it mrbz-dev-workspace fish` → Powerline Prompt (Orange)
- ✅ Alle mr-bytez Aliases funktionieren (`ll`, `gs`, `dps`)
- ✅ Fish Loader erkennt `mrbz-dev` Host
- ✅ Fastfetch + Greeting mit mr-bytez ASCII Art
- ✅ Micro mit Gruvbox Theme
- ✅ `claude` CLI funktioniert
- ✅ VS Code Dev Container attacht korrekt
- ✅ Git Workflow: commit/push aus Container, pull auf Host

---

### Phase 2: AI Tools & MCP

**Abhängigkeit:** Phase 1 abgeschlossen

| Feature | Detail |
|---------|--------|
| Weitere AI CLIs | OpenAI, Gemini, Mistral, Grok |
| MCP Server | TypeScript, eigener Container (`mrbz-mcp`) |
| Qdrant | Vector DB Container (`mrbz-qdrant`) |
| MCP Tools | Filesystem, Docker, Git, Database, RAG |

### Phase 3: Integration & Polish

| Feature | Detail |
|---------|--------|
| AionUI | Web Interface Container (`mrbz-aionui`) |
| Docker Socket | Host-Socket Mount für Container-Management |
| claude-mem | Memory-Integration |
| git filter-repo | Sensitive Data Cleanup (sichere Testumgebung) |
| Pre-Commit Hooks | Entwicklung & Test im Container |

---

## 8. Docker Compose (Entwurf Phase 1)

```yaml
# shared/stacks/mrbz-dev/docker-compose.yml

services:
  workspace:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: mrbz-dev-workspace
    hostname: mrbz-dev
    networks:
      mrbz-dev-net:
        ipv4_address: 172.30.0.10
    volumes:
      - fish-history:/home/mrohwer/.local/share/fish
    stdin_open: true
    tty: true
    restart: unless-stopped

networks:
  mrbz-dev-net:
    name: mrbz-dev-net
    driver: bridge
    ipam:
      config:
        - subnet: 172.30.0.0/24
          gateway: 172.30.0.1
```

---

## 9. Dockerfile (Entwurf Phase 1)

```dockerfile
# shared/stacks/mrbz-dev/Dockerfile

FROM archlinux:base-devel

# ── Locale & Timezone ────────────────────────────
RUN sed -i 's/#de_DE.UTF-8/de_DE.UTF-8/' /etc/locale.gen && \
    sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && \
    locale-gen && \
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

ENV LANG=de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8

# ── System Update & Tools ────────────────────────
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    fish micro git github-cli \
    eza bat fastfetch duf dust htop \
    tree jq ripgrep fd \
    openssh curl wget unzip \
    nodejs npm && \
    pacman -Scc --noconfirm

# ── User Setup ───────────────────────────────────
RUN useradd -m -s /usr/bin/fish -G wheel mrohwer && \
    echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# ── Claude Code CLI ──────────────────────────────
RUN npm install -g @anthropic-ai/claude-code

# ── mr-bytez Bootstrap (Git Clone bei Runtime) ───
# Clone passiert beim ersten Start via Entrypoint
COPY entrypoint.fish /usr/local/bin/entrypoint.fish
RUN chmod +x /usr/local/bin/entrypoint.fish

USER mrohwer
WORKDIR /home/mrohwer

ENTRYPOINT ["fish", "/usr/local/bin/entrypoint.fish"]
CMD ["fish"]
```

---

## 10. Offene Punkte

| Thema | Status | Notiz |
|-------|--------|-------|
| Entrypoint-Script | 📌 Noch erstellen | mr-bytez Clone + Symlink Setup |
| Host-Color für mrbz-dev | 📌 Erweitern | `__mr_host_color.fish` + Orange |
| mrbz-dev Fish Config | 📌 Erstellen | `projects/infrastructure/mrbz-dev/` |
| yay im Container | ❓ Evaluieren | AUR-Support nötig? |
| Fish History Persistenz | 📌 Named Volume | Konfigurieren in Compose |
| GPU Passthrough | ❓ Später | Für AI Inference (optional) |

---

## 11. Verwandte Dokumente

- `ROADMAP.md` — Gesamtprojekt-Roadmap (Phase 3 verweist hierher)
- `DEPLOYMENT.md` — Host-Deployment-Guide
- `PROJECT_NOTES.md` — Repo-Policies & Arbeitsweise
- `shared/deployment/derive_key.fish` — Secrets Key-Derivation

---

**Nächster Schritt:** Phase 1 Implementation starten — Dockerfile + docker-compose.yml + Entrypoint erstellen.
