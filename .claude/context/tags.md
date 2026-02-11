# Tag-Registry — Commits & Chat-Benennung

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Zweck

Zentrale Registry fuer ALLE Tags — verwendet in Git-Commits UND Chat-Benennung.

- Jeder Tag hat einen eindeutigen 3-Zeichen-Index (Grossbuchstaben, bestmoeglich abgekuerzt)
- Der Index dient gleichzeitig als Ketten-Prefix fuer Chat-IDs (z.B. `#STR01.3`)
- Neue Tags: Beim Chat-Benennen `tags.md` pruefen. Fehlt ein passender Tag → neuen vorschlagen und via Claude Code eintragen lassen.

---

## Generische Tags (Workflow, Struktur, Entwicklung)

| Tag          | Index | Bedeutung                             | Verwendet in    | Seit    |
|-------------|-------|---------------------------------------|-----------------|---------|
| [Backup]    | BAK   | Backup, Recovery, Restore, Borg       | Commits + Chats | 2026-02 |
| [Bash]      | BSH   | Bash Shell, Scripts                   | Commits + Chats | 2026-02 |
| [Cleanup]   | CLN   | Aufraeumarbeiten, Linting             | Commits         | 2026-01 |
| [ClaudeCode]| CLC   | Claude Code CLI Aufgaben              | Chats           | 2026-02 |
| [Cloud]     | CLD   | Cloud-Services allgemein (Nextcloud, Immich, rclone) | Commits + Chats | 2026-02 |
| [Community] | COM   | Community-Projekte, Outreach, Social  | Commits + Chats | 2026-02 |
| [Config]    | CFG   | Konfigurationsdateien, Environment    | Commits + Chats | 2026-01 |
| [Database]  | DBA   | Datenbanken allgemein (PostgreSQL, MariaDB, Redis) | Commits + Chats | 2026-02 |
| [Deploy]    | DEP   | Deployment, symlinks.db               | Commits + Chats | 2026-01 |
| [DNS]       | DNS   | DNS-Records, Resolver, Blocking       | Commits + Chats | 2026-02 |
| [Docker]    | DKR   | Container, Compose, Stacks            | Commits + Chats | 2026-01 |
| [Docs]      | DOC   | README, CHANGELOG, ROADMAP, ADRs      | Commits + Chats | 2026-01 |
| [Feature]   | FEA   | Neue Funktionalitaet                  | Commits         | 2026-01 |
| [Firewall]  | FWL   | nftables, Portregeln, Network Security | Commits + Chats | 2026-02 |
| [Fish]      | FSH   | Fish Shell, Functions, Aliases        | Commits + Chats | 2026-01 |
| [Fix]       | FIX   | Bug-Fixes, Korrekturen                | Commits         | 2026-01 |
| [Git]       | GIT   | Git-Workflow, Filter, History         | Commits + Chats | 2026-02 |
| [Hardware]  | HRD   | Hardware-Info, System-Specs           | Commits + Chats | 2026-02 |
| [Hotfix]    | HOT   | Notfall-Fix in Production             | Commits         | 2026-01 |
| [Learn]     | LRN   | Lernplattform, Curriculum, Education  | Commits + Chats | 2026-02 |
| [Mail]      | MAL   | Mail-Server allgemein, SMTP, IMAP     | Commits + Chats | 2026-02 |
| [MCP]       | MCP   | MCP Server, Tools, RAG                | Commits + Chats | 2026-02 |
| [Media]     | MDA   | Media-Server allgemein, Streaming     | Commits + Chats | 2026-02 |
| [Micro]     | MIC   | Micro Editor, Settings, Themes        | Commits + Chats | 2026-02 |
| [Migration] | MIG   | Migrationen, 5-3-3, Umzuege           | Commits + Chats | 2026-02 |
| [Monitor]   | MON   | Monitoring allgemein, Alerts, Metriken | Commits + Chats | 2026-02 |
| [Network]   | NET   | Netzwerk allgemein, Interfaces, Routing | Commits + Chats | 2026-02 |
| [Prompt]    | PRM   | Prompt-System, Powerline              | Commits + Chats | 2026-02 |
| [Refactor]  | REF   | Code-Umstrukturierung                 | Commits + Chats | 2026-01 |
| [Release]   | REL   | Version-Bumps, Git-Tags               | Commits         | 2026-01 |
| [Roadmap]   | RDM   | Planung, Priorisierung                | Chats           | 2026-02 |
| [Security]  | SEC   | Secrets, Permissions, Encryption      | Commits + Chats | 2026-01 |
| [Shop]      | SHP   | E-Commerce allgemein (Shopware, WooCommerce) | Commits + Chats | 2026-02 |
| [SMB]       | SMB   | CIFS-Mounts, Samba-Shares             | Commits + Chats | 2026-02 |
| [SSH]       | SSH   | SSH-Config, Keys, Tunnels             | Commits + Chats | 2026-02 |
| [Structure] | STR   | Ordner-/Dateistruktur, 5-3-3         | Commits + Chats | 2026-02 |
| [Submodule] | SUB   | Submodule-Updates                     | Commits         | 2026-01 |
| [Symlink]   | SYM   | Symlink-Strategie, symlinks.db        | Commits + Chats | 2026-02 |
| [Test]      | TST   | Tests                                 | Commits         | 2026-01 |
| [VPN]       | VPN   | VPN allgemein, Tunnel, Netzwerk       | Commits + Chats | 2026-02 |
| [VSCode]    | VSC   | VS Code, DevContainer, Extensions     | Commits + Chats | 2026-02 |
| [Web]       | WEB   | Web-Services allgemein, CMS, Blogs    | Commits + Chats | 2026-02 |
| [WIP]       | WIP   | Work in Progress                      | Commits         | 2026-01 |

---

## Dienst-spezifische Tags (konkrete Services/Tools)

| Tag          | Index | Bedeutung                             | Verwendet in    | Seit    |
|-------------|-------|---------------------------------------|-----------------|---------|
| [AdGuard]   | ADG   | AdGuard Home, DNS-Blocking, Filtering | Commits + Chats | 2026-02 |
| [Authentik] | AUT   | Authentik SSO, OAuth2, OIDC, SAML     | Commits + Chats | 2026-02 |
| [Borg]      | BRG   | Borg/borgmatic, Deduplizierung        | Commits + Chats | 2026-02 |
| [CrowdSec]  | CRS   | CrowdSec IDS/IPS, Threat Intelligence | Commits + Chats | 2026-02 |
| [Forgejo]   | FRG   | Forgejo Git-Server, Self-Hosted       | Commits + Chats | 2026-02 |
| [Grafana]   | GRF   | Grafana Dashboards, Metriken          | Commits + Chats | 2026-02 |
| [Immich]    | IMC   | Immich Foto/Video Management          | Commits + Chats | 2026-02 |
| [Jellyfin]  | JLF   | Jellyfin Media Server                 | Commits + Chats | 2026-02 |
| [Mailcow]   | MCW   | Mailcow Mail-Suite, SOGo              | Commits + Chats | 2026-02 |
| [MariaDB]   | MDB   | MariaDB Datenbank                     | Commits + Chats | 2026-02 |
| [Nextcloud] | NXC   | Nextcloud, CalDAV, WebDAV, Files      | Commits + Chats | 2026-02 |
| [Paperless] | PPL   | Paperless-NGX Dokumenten-Management   | Commits + Chats | 2026-02 |
| [Plex]      | PLX   | Plex Media Server, Streaming          | Commits + Chats | 2026-02 |
| [Portainer] | PRT   | Portainer Docker Management UI        | Commits + Chats | 2026-02 |
| [PostgreSQL]| PGS   | PostgreSQL Datenbank                  | Commits + Chats | 2026-02 |
| [Prometheus]| PRO   | Prometheus Metriken-Collection        | Commits + Chats | 2026-02 |
| [rclone]    | RCL   | rclone VFS Cache, Cloud-Sync          | Commits + Chats | 2026-02 |
| [Redis]     | RDS   | Redis Cache, Session Store            | Commits + Chats | 2026-02 |
| [Shopware]  | SHW   | Shopware E-Commerce                   | Commits + Chats | 2026-02 |
| [Traefik]   | TRF   | Traefik Reverse Proxy, SSL, ACME      | Commits + Chats | 2026-02 |
| [Unbound]   | UNB   | Unbound DNS Resolver                  | Commits + Chats | 2026-02 |
| [UptimeKuma]| UPK   | Uptime Kuma Monitoring                | Commits + Chats | 2026-02 |
| [Vaultwarden]| VLT  | Vaultwarden Password Manager          | Commits + Chats | 2026-02 |
| [Watchtower]| WTW   | Watchtower Container Auto-Update      | Commits + Chats | 2026-02 |
| [WireGuard] | WRG   | WireGuard VPN Tunnel                  | Commits + Chats | 2026-02 |
| [WordPress] | WPR   | WordPress Blog, CMS                   | Commits + Chats | 2026-02 |

---

## Regeln

- **Index:** Immer 3 Zeichen, Grossbuchstaben, bestmoeglich abgekuerzt
- **Neue Tags:** Vorschlagen wenn kein passender existiert, dann hier eintragen via Claude Code
- **Keine Phasen-Tags:** Kein `[Diskussion]`, `[Planung]`, `[Debug]` — die Phase ergibt sich aus der Ketten-Nummer
- **Tags beschreiben WAS und WO**, nicht die Phase des Projekts
- **Alphabetisch sortiert** innerhalb jeder Tabelle (Generisch / Dienst-spezifisch)
- **Spalte "Verwendet in":** `Commits` = nur Git-Commits, `Chats` = nur Chat-Benennung, `Commits + Chats` = beides
- **Zwei Ebenen:** Generische Tags fuer breite Kategorien (z.B. `[Database]`, `[Media]`, `[Cloud]`), Dienst-spezifische Tags fuer konkrete Services (z.B. `[PostgreSQL]`, `[Plex]`, `[Nextcloud]`). Beides kann kombiniert werden:
  - `[Cloud][Nextcloud]` — Nextcloud-spezifische Cloud-Arbeit
  - `[Database][PostgreSQL]` — PostgreSQL-spezifische DB-Arbeit
  - `[Media]` allein — wenn es um Media generell geht
- **Quelle fuer n8-vps Dienste:** `n8-vps_Master-Planung_v4_1.md` (14 Stacks, 30 Services)
