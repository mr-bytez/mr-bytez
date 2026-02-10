# Handoff-Prompt: Offene Aufgaben aus Session 2026-02-07

**Vorheriger Chat (Part 1):** MR-ByteZ - [deployment][structure] 1 - n8-archstick Erstdeployment + Secrets-Submodule Migration
**Chat-Link:** https://claude.ai/chat/ef3ae845-a798-4d0c-87bb-826d038187e5
**Datum:** 2026-02-07 / 2026-02-08
**Status:** n8-archstick deployed, Secrets-Submodule migriert, alle Hosts + Remotes synchron

**Dieser Chat (Part 2):** MR-ByteZ - [deployment][structure] 2 - SSH-Config Secrets Symlink + README Fix + hosts n8-kiste - ssh-config symlinks-db readme-baum etc-hosts gitconfig --- 2026-02-XX-XX-XX
*(Uhrzeit beim Chat-Start ergänzen!)*

---

## Kontext: Was wurde erledigt

- n8-archstick vollständig deployed (Fish, Micro, Anchor, Hostname, Codeberg SSH)
- Secrets-Submodule verschoben: `shared/.secrets` → `shared/home/mrohwer/.secrets`
- 7 Docs aktualisiert (sed-Ersetzung aller Pfade)
- domains.csv erstellt (98 Domains, 3 Spalten: Anzeigename, IDN-Code, Hoster)
- SECRETS.md aktualisiert (Domains-Section, Pfade korrigiert)
- n8-archstick-test.fish → n8archstick-test.fish (Fish autoload Fix)
- Alter `shared/.secrets` Ordner auf n8-kiste gelöscht
- Alle Repos synchron: n8-kiste, n8-archstick, GitHub, Codeberg = `adcf65e`

---

## Offene Aufgaben (in diesem Chat bitte erledigen)

### Aufgabe 1: SSH-Config ins Secrets-Repo + Symlink-Deployment

**Was:** SSH-Config zentral im privaten Secrets-Repo ablegen, beim Deployment als Symlink nach `~/.ssh/config` setzen.

**Warum:** SSH-Config enthält Hostnamen, IPs, Ports – gehört nicht ins public Repo. Über den Anchor `/opt/mr-bytez/current` konsistent mit restlicher Strategie.

**Aktuelle SSH-Config auf n8-kiste:**
```
Host n8-kiste
   HostName 10.10.10.1
   User mrohwer
   Port 61022
```

**Aktuelle SSH-Config auf n8-archstick:**
```
Host n8-kiste
   HostName 10.10.10.1
   User mrohwer
   Port 61022

Host codeberg.org
   HostName codeberg.org
   User git
   IdentityFile ~/.ssh/id_ed25519_codeberg
   IdentitiesOnly yes
```

**Plan:**
1. `shared/home/mrohwer/.secrets/ssh/mrohwer/config` anlegen (im Secrets-Repo)
2. Inhalt: Gemeinsame SSH-Config für alle Hosts (n8-kiste, n8-vps, Codeberg etc.)
3. Beim Deployment als letzter Schritt: `ln -sf /opt/mr-bytez/current/shared/home/mrohwer/.secrets/ssh/mrohwer/config ~/.ssh/config`
4. DEPLOYMENT.md aktualisieren (neuer Schritt 10: SSH-Config Symlink)
5. SECRETS.md aktualisieren (neue Zeile in SSH-Tabelle)
6. symlinks.db aktualisieren
7. `shared/home/mrohwer/.ssh/config.example` im public Repo bleibt als Referenz (ohne echte IPs)

**Betroffene Hosts nach Deployment:** n8-kiste, n8-archstick (sofort), n8-vps (beim nächsten Pull)

---

### Aufgabe 2: n8-kiste /etc/hosts dokumentieren

**Was:** `/etc/hosts` auf n8-kiste sauber dokumentieren (gleicher Stil wie n8-archstick).

**Aktuelle Einträge auf n8-kiste:**
```
127.0.0.1   localhost
::1         localhost
127.0.1.1   n8-kiste.local n8-kiste
10.10.10.1  n8-kiste.local n8-kiste
127.0.0.1 grills-reduziert.local
127.0.0.1 xinro.local
```

**Kontext zu den .local Domains:**
- `grills-reduziert.local` = Lokaler Hostname für Shopware5 Docker-Migration-Stack auf n8-kiste
- `xinro.local` = Lokaler Hostname für xinro.de Shopware5 Docker-Migration-Stack auf n8-kiste
- Beide sind Docker-basierte Shop-Migrationen von Timmehosting nach n8-vps

**Vorlage:** n8-archstick `/etc/hosts` (erstellt in dieser Session) mit mr-bytez Header, Kommentaren pro Section.

---

### Aufgabe 3: README.md Struktur-Baum korrigieren

**Was:** Der ASCII-Art Struktur-Baum in `/mr-bytez/README.md` (Zeilen 47-64) ist veraltet und teilweise falsch eingerückt.

**Aktueller (fehlerhafter) Baum:**
```text
/mr-bytez/
├── shared/                      # Shared Resources (alle Hosts)
│   ├── usr/local/share/         # System-weite Configs
├── etc/                         # System Configs
│   └── fish/                    # Fish Shell v2.x (Loader, Theme, Aliases, Functions)
│   │   └── micro/               # Micro Editor Settings
│   ├── home/                    # User-Templates (keine Live-Homes)
│   ├── .secrets/                # Private Secrets (Age-Encrypted) -> Submodule
│   └── deployment/              # Deployment-Metadaten (symlinks.db, derive_key.fish, …)
├── projects/                    # Projekte/Hosts (Submodules)
├── .claude/                     # AI/Claude Integration (optional)
├── .config/                     # Repo-weite Configs
├── README.md
├── DEPLOYMENT.md                # Deployment-Guide
├── PROJECT_NOTES.md
├── ROADMAP.md
└── CHANGELOG.md
```

**Probleme:**
- `etc/` und `home/` hängen unter `shared/` aber die Einrückung ist falsch
- `.secrets/` muss unter `home/mrohwer/` stehen (neuer Pfad nach Migration)
- `micro/` Einrückung falsch
- Fehlende Unterordner wie `projects/infrastructure/`, `projects/web/`

**Hinweis:** Prüfe die tatsächliche Repo-Struktur mit `find` oder `tree` bevor du den Baum korrigierst. Doku-Policy: README ist Überblick, nicht jede Datei muss rein.

---

### Aufgabe 4: Git-Config als Shared-Config

**Was:** `user.name` + `user.email` muss aktuell auf jedem Host manuell gesetzt werden. Überlegen ob und wie das automatisiert/zentralisiert werden kann.

**Aktuelle Werte (identisch auf allen Hosts):**
```
user.name = Michael Rohwer
user.email = mrohwer@mr-bytez.de
```

**Mögliche Ansätze:**
- `.gitconfig` Template im Repo (wie `config.example` für SSH)
- Automatisches Setzen im Deployment-Script
- Include-Direktive in globaler `.gitconfig` die auf Repo-Config zeigt

**Priorität:** Niedrig, aber nice-to-have für neue Host-Deployments.

---

## Wichtige Referenzen

- **Commit-Policy:** Alle Commits auf n8-kiste (n8-vps + n8-archstick = read-only, nur pull). AUSNAHME: n8-archstick hat in dieser Session committed (Submodule-Migration).
- **Fish-Regeln:** Keine heredocs/EOF, printf für Datei-Erstellung, `command cat` statt `cat` für Secrets
- **Secrets-Pfad (NEU):** `shared/home/mrohwer/.secrets/` (Submodule)
- **Anchor:** `/opt/mr-bytez/current` → `/mr-bytez`
- **Symlinks:** `/etc/fish`, `/usr/local/share/micro`, `~/.config/fish/config.fish`, `~/.config/micro/`
