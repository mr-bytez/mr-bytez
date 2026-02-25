# HANDOFF: A1 Secrets-Repo Restrukturierung — Verschlüsseltes Home-Backup

**Chat-Referenz:** #SEC01.1 (Architektur & Planung), #SEC01.2 (Phase 1 Umsetzung)
**Chat-Links:**
- #SEC01.1: https://claude.ai/chat/1573b769-dc58-4a7c-bac6-7ccdc03d5639
- #SEC01.2: https://claude.ai/chat/57a23402-e625-4bae-b2cf-615791e15f56
**Vorgaenger-Kette:** #DOC01.1 → #DOC01.2 → #DOC01.3 → #SEC01.1 → #SEC01.2
**Datum:** 2026-02-24
**Status:** Phase 1 erledigt — Phase 2+3 offen
**Delegation:** Strategisch in Claude.ai, Mechanisch an Claude Code

---

## Vision

Das Secrets-Repo `mr-bytez-secrets` wird zum **verschluesselten Home-User-Backup** —
ein Single Source of Truth fuer alle persoenlichen Dateien, Secrets, Configs und
System-Einstellungen von `mrohwer`, versioniert und verschluesselt in einer Age-Archivdatei.

**Leitprinzip:** Gleiche Logik wie das Hauptrepo — Root-Ordnerstruktur mit
`shared/` (alle Hosts) + `infrastructure/<hostname>/` (host-spezifisch).
Deployment ueber den bestehenden Anker `/opt/mr-bytez/current/.secrets/`.

**Open Source Philosophie (Zukunft):**
- Oeffentliches Repo (mr-bytez): Generische Templates, Tools, Blueprints (z.B. `mrbz-vps`)
- Privates Repo (mr-bytez-secrets): Verschluesseltes Archiv + produktive Instanzen (z.B. `n8-vps`)

**Vier-Ebenen-Architektur:**

| Ebene | Was | Wo | Wie |
|-------|-----|-----|-----|
| 1 | Verschluesseltes Archiv | Git-Repo (mr-bytez-secrets) | age + tar, committed |
| 2 | Entschluesselte Secrets/Configs | /mr-bytez/.secrets/mrohwer/ | gitignored, lokal |
| 3 | System-Symlinks | ~/.ssh, ~/.gitconfig, /etc/hosts | ueber Anker |
| 4 | Home-Daten (gross) | ~/Dokumente, ~/Bilder, ~/Downloads | rclone crypt → GDrive (Projekt A6) |

Ebene 4 (rclone) ist ein separates Projekt (A6) — wird in der ROADMAP des Secrets-Repos
als Ausblick dokumentiert, aber NICHT in A1 umgesetzt. Die rclone.conf Ablage im Archiv
(`shared/home/mrohwer/.config/rclone/`) wird ebenfalls erst in A6 angelegt — kein Platzhalter
in A1 (Prinzip: start minimal, scale when needed).

---

## Aktueller Stand Secrets-Repo (vor Migration)

**Repo:** mr-bytez-secrets (privat)
**Einbindung:** Submodule unter `shared/home/mrohwer/.secrets/`
**Branch:** main
**Letzter Commit:** `6891373` — 4 Commits insgesamt
**Remotes:** origin = GitHub (`mr-bytez/mr-bytez-secrets`), kein Codeberg (wird in Phase 1 ergaenzt)

### Aktuell versioniert (im Repo):

```
.secrets/
├── api/
│   ├── codeberg.token.age       # Age-verschluesselt
│   ├── codeberg.token.info      # Metadaten
│   ├── github.token.age         # Age-verschluesselt
│   └── github.token.info        # Metadaten
├── ssh/
│   └── mrohwer/
│       ├── id_ed25519_codeberg.age
│       ├── id_ed25519_codeberg.info
│       ├── id_ed25519_codeberg.pub
│       ├── id_ed25519_github.age
│       ├── id_ed25519_github.info
│       └── id_ed25519_github.pub
├── domains.csv                  # 98 Domains, 3 Spalten
└── SECRETS.md                   # Dokumentation (Autor noch "Michael Rohwer")
```

### Unversioniert (nur lokal auf n8-kiste):

```
smb-n8-kiste.creds               # SMB-Credentials (root:root, 43 Bytes) → .gitignore
```

### Lokales ~/.secrets/ auf n8-kiste (NICHT das Submodule!):

Separates Verzeichnis mit ~70 Dateien in 12 Kategorien:
`ai/`, `api/`, `backup/`, `cloud/`, `databases/`, `licenses/`, `personal/`,
`services/`, `ssh/`, `ssl/`, `tools/`, `vpn/` + `generate_pwd.fish`
→ Migration nach Phase 2

---

## Architektur — Drei Ebenen (A1-Scope, ohne rclone)

### Ebene 1: Privates Repo (mr-bytez-secrets, committed + gepusht)

```
mr-bytez-secrets/                    # Submodule unter /mr-bytez/.secrets/
├── mrohwer.tar.age                  # Verschluesseltes Archiv (Single Source of Truth)
├── README.md                        # Ueberblick, Recovery-Anleitung
├── CLAUDE.md                        # KI-Steuerung, Verweise
├── CHANGELOG.md                     # Historie
├── ROADMAP.md                       # Phasenplan (inkl. A6 rclone Ausblick)
├── domains.csv                      # Domain-Inventar (kein Secret)
├── .gitignore                       # Ignoriert mrohwer/ (entschluesselt)
│
└── mrohwer/                         # ← GITIGNORED! Nur lokal entpackt!
    └── (siehe Ebene 2)
```

### Ebene 2: Entschluesselt lokal (gitignored, nur auf dem Host)

```
/mr-bytez/.secrets/mrohwer/
│
├── shared/                              # Auf ALLEN Hosts deployt
│   ├── home/
│   │   └── mrohwer/
│   │       ├── .ssh/
│   │       │   ├── config               # Gemeinsame SSH-Config
│   │       │   ├── id_ed25519_codeberg
│   │       │   ├── id_ed25519_codeberg.pub
│   │       │   ├── id_ed25519_github
│   │       │   ├── id_ed25519_github.pub
│   │       │   ├── id_ed25519_forgejo
│   │       │   ├── id_ed25519_timme_grills
│   │       │   └── id_ed25519_timme_xinro
│   │       ├── .gitconfig               # Gemeinsame Git-Config (B4)
│   │       ├── .config/                 # User-Configs
│   │       ├── .secrets/                # API-Tokens, Credentials
│   │       │   ├── api/
│   │       │   │   ├── codeberg.token
│   │       │   │   └── github.token
│   │       │   ├── ai/
│   │       │   ├── cloud/
│   │       │   ├── databases/
│   │       │   ├── services/
│   │       │   ├── ssl/
│   │       │   ├── vpn/
│   │       │   └── ...
│   │       ├── Dokumente/               # Platzhalter → A6 rclone mount
│   │       └── Bilder/                  # Platzhalter → A6 rclone mount
│   └── etc/
│       └── (shared System-Configs falls noetig)
│
├── infrastructure/
│   ├── n8-kiste/
│   │   ├── home/mrohwer/
│   │   │   └── .secrets/
│   │   │       └── smb-n8-kiste.creds
│   │   └── etc/
│   │       └── hosts                    # /etc/hosts fuer n8-kiste (B2)
│   ├── n8-vps/
│   │   ├── home/mrohwer/...
│   │   └── etc/hosts
│   ├── n8-station/
│   │   ├── home/mrohwer/...
│   │   └── etc/hosts
│   └── ... (weitere Hosts bei Deployment)
```

### Ebene 3: System-Symlinks (ueber den Anker)

```
~/.ssh/config    → /opt/mr-bytez/current/.secrets/mrohwer/shared/home/mrohwer/.ssh/config
~/.gitconfig     → /opt/mr-bytez/current/.secrets/mrohwer/shared/home/mrohwer/.gitconfig
/etc/hosts       → /opt/mr-bytez/current/.secrets/mrohwer/infrastructure/<hostname>/etc/hosts

# Host-spezifische Secrets ueberschreiben/ergaenzen Shared:
# Merge-Logik: DATEI-LEVEL — Host-Datei existiert? → nimm die. Sonst → nimm shared.
# Kein Verzeichnis-Merge, kein Zeilen-Merge. Simple Logik, kein Fehlerrisiko.
```

---

## SSH-Konfiguration (verifiziert 2026-02-24)

### SSH-Ports pro Host

| Host | Port | IP | Netz |
|------|------|----|------|
| n8-kiste | 61022 | 10.10.10.1 | LAN |
| n8-station | 63022 | 10.10.10.3 | LAN |
| n8-vps | 61020 (+22) | 136.243.101.223 | WAN |

**WICHTIG:** Die Projektanweisungen + infrastructure.md sagen pauschal "SSH-Port: 61020" —
das stimmt NUR fuer n8-vps! Jeder Host hat seinen eigenen Port. Muss korrigiert werden!

### Aktueller SSH-Zugriff (funktioniert)

- n8-kiste → n8-vps ✅
- n8-kiste → n8-station ✅ (LAN)

**Kein Zugriff (noch):**
- n8-vps → n8-kiste (kein VPN, kein Port-Forwarding)
- n8-vps → n8-station (kein LAN-Zugriff)
- n8-archstick, n8-book → spaeter (ROADMAP)

### Aktuelle SSH-Configs (Ist-Zustand)

**n8-kiste (~/.ssh/config):**
```
# Codeberg (origin)
Host codeberg.org
   HostName codeberg.org
   User git
   IdentityFile ~/.secrets/ssh/id_ed25519_codeberg
   IdentitiesOnly yes

# GitHub (github)
Host github.com
   HostName github.com
   User git
   IdentityFile ~/.secrets/ssh/id_ed25519_github
   IdentitiesOnly yes

# n8-vps
Host n8-vps
   HostName 136.243.101.223
   User mrohwer
   Port 61020
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
   ServerAliveInterval 60
   ServerAliveCountMax 3
   AddKeysToAgent yes

# n8-station
Host n8-station
   HostName 10.10.10.3
   User mrohwer
   Port 63022
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
   ServerAliveInterval 60
   ServerAliveCountMax 3
   AddKeysToAgent yes

# Timme Server - grills-reduziert.de Migration
Host grills-reduziert.de
   HostName k56w83.meinserver.io
   User c448304-dev.xinro.de
   Port 22
   IdentityFile ~/.ssh/id_ed25519_timme_grills
   ServerAliveInterval 60
   ServerAliveCountMax 3

# Timme Server - xinro.de Migration
Host xinro.de
   HostName k56w83.meinserver.io
   User c448304-xinro.de
   Port 22
   IdentityFile ~/.ssh/id_ed25519_timme_xinro
   ServerAliveInterval 60
   ServerAliveCountMax 3
```

**n8-station (~/.ssh/config):**
```
# Forgejo auf n8-kiste
Host forgejo
   HostName 10.10.10.1
   Port 61222
   User forgejo
   IdentityFile ~/.ssh/id_ed25519_forgejo
   IdentitiesOnly yes

# n8-kiste
Host n8-kiste
   HostName 10.10.10.1
   Port 61022
   User mrohwer
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
```

**n8-vps (~/.ssh/config):**
```
# n8-vps (Self-Referenz / lokale Scripts)
Host n8-vps
   HostName 136.243.101.223
   User mrohwer
   Port 61020
   IdentityFile ~/.ssh/id_ed25519
```

### Ziel: Gemeinsame SSH-Config (B1)

Wird unter `.secrets/mrohwer/shared/home/mrohwer/.ssh/config` erstellt.
Konsolidiert alle Eintraege — jeder Host bekommt die gleiche Datei.
IdentityFile-Pfade muessen auf den neuen Secrets-Pfad angepasst werden:
`~/.secrets/ssh/...` → via Symlink oder direkt auf `.ssh/` im selben Verzeichnis.

**Inhalt der gemeinsamen Config:**
```
# ============================================
# SSH Config — mr-bytez Infrastruktur
# Generiert: Phase 1 A1
# Pfad: .secrets/mrohwer/shared/home/mrohwer/.ssh/config
# Deployed via: /opt/mr-bytez/current/.secrets/mrohwer/shared/home/mrohwer/.ssh/config
# ============================================

# ── Git Remotes ─────────────────────────────

Host codeberg.org
   HostName codeberg.org
   User git
   IdentityFile ~/.ssh/id_ed25519_codeberg
   IdentitiesOnly yes

Host github.com
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_ed25519_github
   IdentitiesOnly yes

# ── Forgejo (n8-kiste) ─────────────────────

Host forgejo
   HostName 10.10.10.1
   Port 61222
   User forgejo
   IdentityFile ~/.ssh/id_ed25519_forgejo
   IdentitiesOnly yes

# ── Hosts ───────────────────────────────────

Host n8-kiste
   HostName 10.10.10.1
   User mrohwer
   Port 61022
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
   ServerAliveInterval 60
   ServerAliveCountMax 3
   AddKeysToAgent yes

Host n8-vps
   HostName 136.243.101.223
   User mrohwer
   Port 61020
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
   ServerAliveInterval 60
   ServerAliveCountMax 3
   AddKeysToAgent yes

Host n8-station
   HostName 10.10.10.3
   User mrohwer
   Port 63022
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes
   ServerAliveInterval 60
   ServerAliveCountMax 3
   AddKeysToAgent yes

# ── Timme-Server (Shopware Migration) ──────

Host grills-reduziert.de
   HostName k56w83.meinserver.io
   User c448304-dev.xinro.de
   Port 22
   IdentityFile ~/.ssh/id_ed25519_timme_grills
   ServerAliveInterval 60
   ServerAliveCountMax 3

Host xinro.de
   HostName k56w83.meinserver.io
   User c448304-xinro.de
   Port 22
   IdentityFile ~/.ssh/id_ed25519_timme_xinro
   ServerAliveInterval 60
   ServerAliveCountMax 3
```

---

## Deployment-Workflow pro Host

```
1. git pull (Hauptrepo + Submodule update)
   cd /mr-bytez && git pull && git submodule update

2. Archiv entschluesseln + entpacken
   cd /mr-bytez/.secrets/
   fish /mr-bytez/shared/deployment/derive_key.fish secrets --with-host
   age -d -o mrohwer.tar mrohwer.tar.age  # Passphrase eingeben
   tar -xf mrohwer.tar                    # → mrohwer/ entsteht
   rm mrohwer.tar                         # Nur Archiv behalten

3. Deploy-Script setzt Symlinks
   fish /mr-bytez/.secrets/deploy.fish
   # Holt: shared/* + infrastructure/<hostname>/*
   # Setzt Symlinks ueber /opt/mr-bytez/current/.secrets/...
   # Merge-Logik: Datei-Level (Host ueberschreibt Shared)
```

---

## Submodule-Aenderung

```
# Alt:
[submodule "shared/home/mrohwer/.secrets"]
    path = shared/home/mrohwer/.secrets
    url = https://github.com/mr-bytez/mr-bytez-secrets.git

# Neu:
[submodule ".secrets"]
    path = .secrets
    url = https://github.com/mr-bytez/mr-bytez-secrets.git
```

Betroffene Dateien im Hauptrepo:
- `.gitmodules` (Pfad aendern)
- `.gitignore` (`.secrets/mrohwer/` hinzufuegen)
- Altes Submodule entfernen: `git rm shared/home/mrohwer/.secrets`
- Neues Submodule hinzufuegen: `git submodule add <url> .secrets`

---

## Entscheidungen (in #SEC01.1 geklaert)

| Frage | Entscheidung | Begruendung |
|-------|-------------|-------------|
| Secrets-Repo Remotes | Codeberg-Remote hinzufuegen | Konsistenz, Dual-Remote wie Hauptrepo |
| SSH-Keys | Verschluesselt im Archiv = Backup | Entschluesselt nur lokal |
| smb-n8-kiste.creds | .gitignore, spaeter ins Archiv | Host-spezifisch, kommt in infrastructure/n8-kiste/ |
| derive_key.fish | Bleibt im PUBLIC Repo | Kein Secret, noetig fuer Disaster Recovery (Henne-Ei) |
| generate_pwd.fish | Ins PUBLIC Repo verschieben (Phase 2) | Werkzeug wie derive_key.fish, keine Secrets |
| symlinks.db | Bleibt als Checkliste erhalten | Nicht technisch steuernd, Doku/Uebersicht. Im Secrets-Repo weil private Pfade |
| Submodule-Pfad | .secrets/ (Repo-Root) | Sauberer, Root-Struktur passt zum Modell |
| /etc/hosts | Ins Secrets-Repo (infrastructure/) | Enthaelt private IPs + Hostnamen |
| .gitconfig | Ins Secrets-Repo (shared/) | User-spezifisch, auf allen Hosts gleich |
| config.example | Bleibt im Public Repo | Sanitized Vorlage ohne echte IPs, Referenz fuer neue Hosts |
| Container produktiv | Privates Repo (Zukunft) | ROADMAP-Pattern, nicht Teil von A1 |
| Archiv-Groesse | Kein Problem | Secrets/Configs < 1MB, Home-Daten ueber rclone (A6) |
| Merge-Logik | Datei-Level | Host-Datei existiert? → nimm die. Sonst → shared. Kein Zeilen-Merge. |
| rclone Cloud-Sync | Eigenes Projekt A6 | Nur in ROADMAP erwaehnen, keine Platzhalter in A1 |
| SSH-Port Korrektur | Alle Hosts haben eigene Ports | infrastructure.md + Projektanweisungen korrigieren |

---

## Integrierte Tasks

| Task | Beschreibung | Phase | Status |
|------|-------------|-------|--------|
| B1 | SSH-Config ins Secrets-Repo (shared/.ssh/config) | Phase 1 | ✅ Erledigt |
| B2 | /etc/hosts aller Hosts dokumentieren (infrastructure/) | Phase 2 | ✅ Erledigt |
| B4 | .gitconfig Shared (shared/.gitconfig) | Phase 1 | ✅ Erledigt |
| B9 | Submodule n8-vps einrichten | Phase 3 | Offen |
| B10 | Submodule n8-kiste einrichten | Phase 3 | Offen |
| D9 | symlinks.db ins Secrets-Repo (als Checkliste) | Phase 1 | ✅ Erledigt |
| D13 | Credentials n8-archstick | Phase 2 | Offen |

---

## Phasenplan

### Phase 1: Fundament ✅ (erledigt in #SEC01.2)

**Ziel:** Repo-Struktur aufsetzen, 5-3-3 Docs, Submodule verschieben.
**Commit (Secrets-Repo):** `66f0099`
**Commit (Hauptrepo):** `444f34e` (Phase 1), `7a6aec1` (0.8.1 — User Preferences + Policies)

**Aufgaben (alle ✅ erledigt in #SEC01.2):**

1. ✅ **Codeberg-Remote hinzufuegen** — Manuell erstellt + gepusht
2. ✅ **Submodule verschieben** — `shared/home/mrohwer/.secrets/` → `.secrets/`
3. ✅ **5-3-3 Docs im Secrets-Repo** — README, CLAUDE, CHANGELOG, ROADMAP
4. ✅ **SECRETS.md aktualisieren** — Autor MR-ByteZ, Pfade korrigiert
5. ✅ **.gitignore erstellen** — mrohwer/, *.tar, smb-n8-kiste.creds
6. ✅ **symlinks.db verschieben (D9)** — v1.2, ANSI bereinigt, Anker-Pfade
7. ✅ **SSH-Config erstellen (B1)** — `.secrets/mrohwer/shared/home/mrohwer/.ssh/config`
8. ✅ **.gitconfig erstellen (B4)** — mit init, core, push, pull, alias Sektionen
9. ✅ **Bestehende .age-Dateien behalten** — Bleiben bis Phase 2
10. ✅ **Validierung + Commit** — Beide Repos, beide Remotes
11. ✅ **Context-Dateien aktualisieren** — 7 Dateien im Hauptrepo
12. ✅ **ROADMAP.md aktualisieren** — A1 in Arbeit, A6 hinzugefuegt, B1+B4+D9 erledigt
    - A6 als neues Projekt hinzufuegen:
      **A6: Cloud-Sync (rclone crypt)**
      - Home-Ordner (Dokumente, Bilder, Downloads) verschluesselt auf Google Drive (2TB)
      - rclone crypt: Clientseitige Verschluesselung (Dateinamen + Inhalte)
      - rclone.conf im Secrets-Archiv (OAuth-Tokens + crypt-Passphrase)
      - systemd-User-Units fuer Auto-Mount beim Login
      - Abhaengigkeit: A1 Phase 2 (Archiv-Modell muss stehen)

---

### Phase 2: Archiv-Modell umsetzen (#SEC01.3 oder spaeter)

**Ziel:** Verschluesseltes Archiv erstellen, Deploy-Script, Secrets einsortieren.

**Aufgaben:**

1. ✅ **Pack-Script erstellt** (`pack-secrets.fish`) — `shared/deployment/pack-secrets.fish`
   - `mrohwer/` → `mrohwer.tar` → `mrohwer.tar.age`
   - derive_key.fish fuer Passphrase, Validierung vor Verschluesselung
   - --dry-run, --secrets-dir, Ueberschreib-Abfrage

2. ✅ **Unpack-Script erstellt** (`unpack-secrets.fish`) — `shared/deployment/unpack-secrets.fish`
   - `mrohwer.tar.age` → `mrohwer.tar` → `mrohwer/`
   - Cleanup tar, Validierung nach Entpacken, --keep-tar Option

3. ✅ **Deploy-Script erstellt** (`deploy.fish`) — `.secrets/deploy.fish`
   - Liest `shared/` + `infrastructure/<hostname>/`
   - Setzt Symlinks ueber Anker `/opt/mr-bytez/current/.secrets/`
   - Merge-Logik: Datei-Level (Host-spezifisch ueberschreibt Shared)
   - Idempotent, sudo-Erkennung, Berechtigungen, --dry-run

4. ✅ **Bestehende Secrets einsortiert**
   - 4 .age-Dateien entschluesselt: api/codeberg.token, api/github.token, SSH-Keys
   - Eingeordnet in shared/home/mrohwer/.secrets/api/ und shared/home/mrohwer/.ssh/
   - .pub-Dateien direkt kopiert (kein Entschluesseln noetig)
   - Alte api/ + ssh/ Verzeichnisse mit git rm -r entfernt

5. ✅ **Lokale ~/.secrets/ migriert (91 Dateien)**
   - shared/: ai, licenses, personal, cloud (rclone, protonmail, codeberg), vpn (mullvad), tools
   - infrastructure/n8-vps/: services, databases, backup, cloud (hetzner, cloudflare), ssl, vpn
   - generate_pwd.fish → `shared/deployment/generate_pwd.fish` (Public Repo)
   - Geloescht: github_api.token.bak, altes n8kiste-Backup-Archiv

6. ✅ **/etc/hosts fuer 3 Hosts erstellt (B2)**
   - n8-kiste (10.10.10.1 + Dev-Domains), n8-vps (136.243.101.223 + IPv6), n8-station (10.10.10.3)
   - Konsistentes Template: Header, Loopback, FQDN `.mr-bytez.de`, LAN/Public IP
   - Unter infrastructure/<hostname>/etc/hosts im Archiv

7. ✅ **Archiv gepackt + alte Einzeldateien entfernt**
   - mrohwer.tar.age: 94 Dateien, 6,7 MB
   - api/ + ssh/ Verzeichnisse entfernt (git rm -r)

8. **Credentials n8-archstick (D13)**
   - n8-archstick Secrets in infrastructure/n8-archstick/ einordnen

---

### Phase 3: Multi-Host Deployment (spaeter)

**Ziel:** Archiv auf allen Hosts nutzbar machen.

**Aufgaben:**

1. Submodule auf n8-vps einrichten (B9)
2. Submodule auf n8-kiste verifizieren (B10)
3. Deploy-Script auf allen Hosts testen
4. Recovery-Runbook erstellen (Disaster Recovery Anleitung)
5. SSH-Zugriff erweitern: n8-archstick, n8-book (eigene Ports ermitteln)

---

## Betroffene Dateien

### Hauptrepo (mr-bytez)

- `.gitmodules` (Submodule-Pfad aendern)
- `.gitignore` (`.secrets/mrohwer/` hinzufuegen)
- `shared/deployment/symlinks.db` (VERSCHIEBEN nach .secrets/)
- `DEPLOYMENT.md` (Submodule-Pfad, symlinks.db Pfad)
- `CHANGELOG.md` (A1 dokumentieren)
- `ROADMAP.md` (A1 Status + A6 hinzufuegen)
- `.claude/context/security.md` (Archiv-Modell dokumentieren)
- `.claude/context/deployment.md` (symlinks.db Pfad, Submodule-Pfad, SSH-Policy)
- `.claude/context/structure.md` (Submodule-Pfad)
- `.claude/context/infrastructure.md` (SSH-Port pro Host korrigieren)
- `.claude/context/claude-ai-projektanweisungen.txt` (Submodule-Pfad, SSH-Port)
- `.claude/context/handoffs/HANDOFF_[SMB][Deploy]_smb-shares-deployment.md` (Pfade)

### Secrets-Repo (mr-bytez-secrets)

- README.md (NEU)
- CLAUDE.md (NEU)
- CHANGELOG.md (NEU)
- ROADMAP.md (NEU)
- SECRETS.md (UPDATE)
- .gitignore (NEU)
- deployment/symlinks.db (NEU, verschoben aus Hauptrepo)
- mrohwer/shared/home/mrohwer/.ssh/config (NEU, B1)
- mrohwer/shared/home/mrohwer/.gitconfig (NEU, B4)

### Zu loeschende Handoffs (nach Phase 1)

- `HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md`
  (B1+B4 erledigt, B2 in Phase 2, B3 separater Docs-Fix ohne Handoff)

---

## Chat-Benennung fuer Folge-Chats

- #SEC01.2 — Phase 1 Umsetzung (Submodule, Docs, Struktur)
- #SEC01.3 — Phase 2 Archiv-Modell (Pack/Unpack, Migration)
- #SEC01.4 — Phase 3 Multi-Host Deployment
