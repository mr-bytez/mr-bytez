# mr-bytez

**Version:** 0.7.0\
**Status:** Active / Fish-first / Micro\
**Erstellt:** 2026-01-22\
**Aktualisiert:** 2026-02-17\
**Autor:** MR-ByteZ

---

## Übersicht

Meta-Repository zur Verwaltung einer persönlichen, reproduzierbaren Linux-Infrastruktur.

**Kernkonzept:**

- Zentrale Verwaltung aller Hosts, Configs & Secrets
- Polyrepo-Ansatz (Submodules für Projekte)
- Single Source of Truth im Live-System unter `/mr-bytez`
- Deterministisches Deployment (kontrollierte Symlinks, keine Magie)
- Disaster Recovery über Master-Password + Git

---

## Repos

### Main Repo: `mr-bytez` (public)

Enthält:

- Struktur, Shared-Configs (Fish/Micro), Deployment-Metadaten, Projects-Ordner
- **keine Klartext-Secrets**
- **Secrets als Submodule**

### Secrets Repo: `mr-bytez-secrets` (private)

Enthält:

- ausschließlich **Age-verschlüsselte** Secrets (`*.age`) + Metadaten (`*.info`) + Doku (`SECRETS.md`)

> Im Main-Repo ist das Secrets-Repo als Submodule eingebunden (z. B. `shared/home/mrohwer/.secrets`).

---

## Struktur

```text
/mr-bytez/
├── shared/                      # Shared Resources (alle Hosts)
│   ├── usr/local/bin/           # System-weite Scripts (hwi)
│   ├── usr/local/share/         # System-weite Configs
├── etc/                         # System Configs
│   └── fish/                    # Fish Shell v2.x (Loader, Theme, Aliases, Functions)
│   │   └── micro/               # Micro Editor Settings
│   ├── home/                    # User-Templates (keine Live-Homes)
│   ├── .secrets/                # Private Secrets (Age-Encrypted) -> Submodule
│   └── deployment/              # Deployment-Metadaten (symlinks.db, derive_key.fish, …)
├── projects/                    # Projekte/Hosts (Submodules)
├── .claude/                     # AI-Context, Policies & Konventionen
│   ├── CLAUDE.md                # Zentrale Steuerung für Claude Code
│   └── context/                 # Policies (11 Dateien)
├── .config/                     # Repo-weite Configs
├── README.md
├── DEPLOYMENT.md                # Deployment-Guide
├── ROADMAP.md
└── CHANGELOG.md
```

---

## Status

### Phase 1: Foundation ✅

- [x] Repository erstellt + Basis-Struktur angelegt
- [x] GitHub Repo (`mr-bytez/mr-bytez`) privat angelegt
- [x] Codeberg Repo (`n8lauscher/mr-bytez`) privat angelegt
- [x] Multi-Remote Setup (GitHub + Codeberg) etabliert
- [x] Secrets als **privates Submodule** `shared/home/mrohwer/.secrets` (Age-encrypted)
- [x] Secrets-Doku: `shared/home/mrohwer/.secrets/SECRETS.md`
- [x] Master-Password Derivation: `shared/deployment/derive_key.fish`
- [x] Deployment-Metadaten: `shared/deployment/symlinks.db`
- [x] Projekt-Hinweise (Fish/Tokens): `.claude/context/`

### Phase 2: Host-Setup (in progress) 🛠️

- [x] Fish Shell v2.x (Loader/Theme/Aliases/Functions) unter `shared/usr/local/share/fish/`
- [x] Host-spezifische Fish-Overrides (u. a. n8-kiste, n8-station, n8-book, n8-bookchen, n8-maxx, n8-broker, n8-vps, n8-archstick)
- [x] Micro Editor Konfiguration unter `shared/usr/local/share/micro/` (Gruvbox, external Clipboard via xclip)
- [x] Stabiler Deployment-Anker: `/opt/mr-bytez/current -> /mr-bytez`
- [x] System-Symlinks laufen über den Anker (kein Symlink-Wildwuchs)
  - `/etc/fish -> /opt/mr-bytez/current/shared/etc/fish`
  - `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`
  - `/usr/local/bin/hwi -> /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh`
- [x] Hardware-Audit Script (hwi) — erfasst Hardware-Infos pro Host
  - Nach jedem Deployment: `sudo hwi mrbz` → erzeugt lokale `HARDWARE.md`
  - HARDWARE.md ist gitignored (sensible Daten, nur lokal fuer Claude Code)
  - Details: `shared/usr/local/bin/hwi/`
- [x] SSH-Config wird **nicht** mehr aus dem Repo deployt (nur Template)
  - Repo enthält nur: `shared/home/mrohwer/.ssh/config.example`
- [ ] Docs-Struktur weiter ausbauen (klarer “Start here”-Pfad)
- [ ] Projects/Submodules ergänzen (Hosts/Services als eigene Repos)

### Phase 3: Automation (geplant)

- [ ] Restore/Recovery Script (Fish)
- [ ] Pre-Commit Hooks / Linting / Safety-Checks
- [ ] Automatisches Sync/Update (Multi-Remote, Submodules)
- [ ] MCP / AI-Integration (Claude/Codex Workflows)

---

## Deployment

Die README ist bewusst nur der Überblick.

- Deployment-Mechanik (Anker, Symlinks, Rollback, Troubleshooting) steht in `DEPLOYMENT.md`.
- Verbindliche Regeln/Policies stehen in `.claude/context/`.

---

## Security / Secrets

- Keine Klartext-Secrets im public Repo.
- Secrets liegen ausschließlich im privaten Submodule `shared/home/mrohwer/.secrets`.
- Token/Key-Handling (inkl. `cat`-Alias-Falle) steht in `.claude/context/security.md` und `shared/home/mrohwer/.secrets/SECRETS.md`.

---

## Hinweise zur Repo-Historie

- Das alte „v1“-Repo bleibt erhalten (z. B. lokal unter `/mr-bytez-v1_fish_micro_secrets`) und kann parallel weitergeführt werden.
- Live-System zeigt auf `/mr-bytez`; System-Links zeigen auf `/opt/mr-bytez/current`.

---

## Dokumentation & Policies

Alle Arbeitskonventionen und Policies sind in `.claude/context/` dokumentiert:

| Datei | Inhalt |
|-------|--------|
| `policies.md` | Grundprinzipien, Repo-Regeln |
| `shell.md` | Fish-first Shell-Konventionen |
| `security.md` | Secrets, Tokens, Sanitization |
| `git.md` | Commit-Format, Branches |
| `deployment.md` | Symlinks, Anker-System |
| `documentation.md` | Doku-Workflow, Templates |

Einstieg für Claude Code / Claude.ai: `.claude/CLAUDE.md`

**Weitere Dateien:**

- **Deployment:** `DEPLOYMENT.md`
- **Secrets:** `shared/home/mrohwer/.secrets/SECRETS.md`
- **Planung:** `ROADMAP.md`
- **Historie:** `CHANGELOG.md`

---

## Kontakt

**Autor:** MR-ByteZ\
**Email:** [mail@mr-bytez.de](mailto\:mail@mr-bytez.de)

---

## Lizenz

GPL v3

