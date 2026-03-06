# mrbz_aud — Modul 07: Secrets Struktur

**Datum:** 2026-03-06
**Status:** FINDINGS

## Zusammenfassung

Secrets-Repo Strukturanalyse durchgefuehrt (NUR Dateinamen/Verzeichnisse, keine Inhalte gelesen).
Von 8 verwalteten Hosts haben nur 3 eigene Verzeichnisse im Secrets-Repo. Die vorhandene
Struktur ist weitgehend konsistent, es gibt jedoch eine unklare Backup-Verzeichnisstruktur
bei n8-vps und eine .age-Datei ohne entpacktes Gegenstueck.

## Findings

### [INFO] Fehlende Host-Verzeichnisse (5 von 8 Hosts)

- **Datei:** `.secrets/mrohwer/infrastructure/`
- **Problem:** Nur 3 von 8 Hosts haben Verzeichnisse: n8-kiste, n8-station, n8-vps.
  Fehlend: n8-book, n8-bookchen, n8-maxx, n8-broker, n8-archstick
- **Erwartung:** Alle verwalteten Hosts koennten eigene Secrets-Verzeichnisse haben
- **Empfehlung:** Laut `infrastructure.md` Deployment-Status sind nur n8-kiste, n8-vps,
  n8-station vollstaendig deployed. Die fehlenden 5 Hosts sind daher erwartet — erst
  bei Deployment anlegen. Kein Handlungsbedarf, nur zur Dokumentation.

### [INFO] Inkonsistente Host-Struktur (unterschiedliche Tiefe)

- **Datei:** `.secrets/mrohwer/infrastructure/*/`
- **Problem:** Die 3 Hosts haben unterschiedlich tiefe Strukturen:
  - n8-kiste: `etc/hosts`, `home/mrohwer/.ssh/` (7 Dateien)
  - n8-station: `etc/hosts`, `home/mrohwer/.ssh/` (5 Dateien)
  - n8-vps: `etc/hosts`, `home/mrohwer/.ssh/`, `home/mrohwer/.secrets/` (umfangreiche Service-Secrets)
- **Erwartung:** n8-vps ist der Production Server mit Docker-Stacks, daher erwartbar umfangreicher
- **Empfehlung:** Kein Handlungsbedarf — die unterschiedliche Tiefe spiegelt die
  unterschiedlichen Rollen der Hosts wider. n8-kiste und n8-station sind konsistent zueinander.

### [NEEDS_REVIEW] Unklare Backup-Verzeichnisstruktur bei n8-vps

- **Datei:** `.secrets/mrohwer/infrastructure/n8-vps/home/mrohwer/.secrets/backup/`
- **Problem:** Zwei aehnliche Verzeichnisse mit ueberlappender Benennung:
  - `backup/auth/authentik/` — enthaelt: `api_token`, `jellyfin_oidc_credentials.txt`, `proxy_outpost_token.txt`
  - `backup/authentik/` — enthaelt: `db.secret`, `secret_key.secret`
  - Zusaetzlich: `backup/auth/forgejo/` — enthaelt: `client_id`, `client_secret`
- **Erwartung:** Einheitliche Struktur — entweder alles unter `backup/auth/<service>/`
  oder unter `backup/<service>/`
- **Empfehlung:** Menschliche Pruefung ob `backup/authentik/` nach `backup/auth/authentik/`
  migriert werden sollte, oder ob die Trennung beabsichtigt ist (z.B. Auth-Tokens vs. DB-Secrets).

### [INFO] .age-Datei ohne entpacktes Gegenstueck

- **Datei:** `.secrets/mrohwer/shared/home/mrohwer/.secrets/personal/edge_browser_passwords.ods.age`
- **Problem:** Diese .age-Datei hat kein entpacktes Gegenstueck (`edge_browser_passwords.ods`)
  im selben Verzeichnis. Alle anderen Secrets liegen entpackt im `mrohwer/`-Baum vor.
- **Erwartung:** Entweder gehoert diese Datei zum Archiv-Modell (dann waere sie in
  `mrohwer.tar.age` enthalten) oder sie ist ein Sonderfall
- **Empfehlung:** Kein Sicherheitsrisiko. Die Datei ist einzeln age-verschluesselt und
  muss nicht permanent entpackt sein. Vermutlich bewusst nur bei Bedarf entschluesselt.

### [INFO] Root-Level Dateien (Docs + Scripts)

- **Datei:** `.secrets/` (Root)
- **Problem:** Folgende Dateien liegen im Secrets-Repo Root:
  - Docs: `CHANGELOG.md`, `CLAUDE.md`, `README.md`, `RECOVERY.md`, `ROADMAP.md`, `SECRETS.md`
  - Scripts: `deploy.fish`
  - Daten: `domains.csv`, `deployment/symlinks.db`
  - Archiv: `mrohwer.tar.age`
- **Erwartung:** Root-Dateien sind Docs/Scripts/Config, keine Secrets — korrekt
- **Empfehlung:** Kein Handlungsbedarf. Struktur entspricht dem Archiv-Modell
  aus `security.md`. 6 Docs im Root (statt 5-5-3 uebliche 5) — `SECRETS.md` und
  `RECOVERY.md` sind fachlich begruendet.

### [INFO] n8-station ohne Forgejo-SSH-Key

- **Datei:** `.secrets/mrohwer/infrastructure/n8-station/home/mrohwer/.ssh/`
- **Problem:** n8-kiste hat `id_ed25519_forgejo` + `.pub`, n8-station nicht.
  n8-kiste hat zusaetzlich `id_ed25519_tinyssh_unlock` + `.pub` (Remote-Unlock).
- **Erwartung:** Nicht alle Hosts brauchen Forgejo-Zugang
- **Empfehlung:** Falls n8-station Forgejo-Zugang braucht, Schluessel erstellen.
  Sonst kein Handlungsbedarf.

## Struktur-Uebersicht

### Verzeichnisbaum (Top-Level)

```
.secrets/
├── CHANGELOG.md, CLAUDE.md, README.md, RECOVERY.md, ROADMAP.md, SECRETS.md
├── deploy.fish, domains.csv
├── deployment/symlinks.db
├── mrohwer.tar.age                    # Verschluesseltes Archiv (SoT)
└── mrohwer/                           # Entpackt (gitignored)
    ├── infrastructure/
    │   ├── n8-kiste/    (etc, .ssh)
    │   ├── n8-station/  (etc, .ssh)
    │   └── n8-vps/      (etc, .ssh, .secrets mit Services)
    └── shared/
        └── home/mrohwer/ (.gitconfig, .ssh, .secrets)
```

### Host-Vergleich

| Host | etc/hosts | .ssh Keys | .secrets | Status |
|------|-----------|-----------|----------|--------|
| n8-kiste | ja | 7 Dateien | — | Vollstaendig |
| n8-station | ja | 5 Dateien | — | Vollstaendig |
| n8-vps | ja | 1 Datei (authorized_keys) | Umfangreich (Services, Cloud, SSL, VPN, DB) | Vollstaendig |
| n8-book | — | — | — | Nicht angelegt |
| n8-bookchen | — | — | — | Nicht angelegt |
| n8-maxx | — | — | — | Nicht angelegt |
| n8-broker | — | — | — | Nicht angelegt |
| n8-archstick | — | — | — | Nicht angelegt |

### Datei-Zaehlung

| Bereich | Anzahl Dateien |
|---------|---------------|
| Root-Docs + Scripts | 9 |
| n8-kiste | 8 |
| n8-station | 6 |
| n8-vps | 72 |
| shared | 14 |
| **Gesamt** | **109** |

## Statistik

- Gepruefte Verzeichnisse: 63
- Gepruefte Dateien: 109
- Findings: 6 (0 KRITISCH, 0 MITTEL, 5 INFO, 1 NEEDS_REVIEW)
