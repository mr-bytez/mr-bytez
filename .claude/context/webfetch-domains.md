# WebFetch Domains — Erlaubte Dokumentations- und API-Seiten

**Version:** 0.1.0
**Erstellt:** 2026-03-05
**Aktualisiert:** 2026-03-05
**Autor:** MR-ByteZ

---

## Zweck

Zentrale Liste aller WebFetch-Domains die Claude Code ohne Rueckfrage abrufen darf.
Source of Truth fuer die `permissions.allow` Eintraege in `.claude/settings.local.json`.

**Pflege:** Bei neuen Domains hier eintragen, dann in `settings.local.json` uebernehmen.
**Format in settings.local.json:** `"WebFetch(domain:example.com)"`
**Wildcard:** Nicht unterstuetzt — jede Subdomain einzeln eintragen (Feature-Request #15260).

---

## Infrastruktur & OS

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Arch Linux | `wiki.archlinux.org` | — | Wiki |
| Fish Shell | `fishshell.com` | — | |
| Docker | `docs.docker.com` | (gleiche Domain) | Engine API unter /reference/api/ |
| Let's Encrypt | `letsencrypt.org` | — | ACME Protokoll |
| nftables | `wiki.nftables.org` | — | Firewall |

## Reverse Proxy & Security

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Traefik | `doc.traefik.io` | (gleiche Domain) | |
| Authentik | `docs.goauthentik.io` | `api.goauthentik.io` | SSO, OpenAPI |
| CrowdSec | `docs.crowdsec.net` | (gleiche Domain) | IDS/IPS |

## Netzwerk & DNS

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| WireGuard | `www.wireguard.com` | — | VPN |
| AdGuard | `adguard-dns.io` | — | DNS Blocking |
| Unbound | `unbound.docs.nlnetlabs.nl` | — | DNS Resolver |

## Monitoring

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Grafana | `grafana.com` | (gleiche Domain) | Dashboards, HTTP API |
| Prometheus | `prometheus.io` | (gleiche Domain) | Metriken |
| Uptime Kuma | (github.com Wiki) | — | Docs auf GitHub |

## Self-Hosted Services

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Nextcloud | `docs.nextcloud.com` | (gleiche Domain) | Cloud |
| Immich | `docs.immich.app` | (gleiche Domain) | Foto/Video |
| Jellyfin | `jellyfin.org` | `api.jellyfin.org` | Media Server |
| Plex | `support.plex.tv` | `docs.plex.tv` | Media Server |
| Paperless-NGX | `docs.paperless-ngx.com` | (gleiche Domain) | DMS |
| Vaultwarden | (github.com Wiki) | — | Passwort-Manager |
| Mailcow | `docs.mailcow.email` | (gleiche Domain) | Mail-Suite |
| Forgejo | `forgejo.org` | (gleiche Domain) | Git-Server |
| Portainer | `docs.portainer.io` | (gleiche Domain) | Container-UI |
| Watchtower | `containrrr.dev` | — | Auto-Update |

## Backup & Sync

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Borg | `borgbackup.readthedocs.io` | — | Deduplizierung |
| rclone | `rclone.org` | — | Cloud-Sync |

## Datenbanken

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| PostgreSQL | `www.postgresql.org` | — | |
| MariaDB | `mariadb.com` | — | |
| Redis | `redis.io` | — | |

## Web & E-Commerce

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Shopware | `developer.shopware.com` | (gleiche Domain) | Store API + Admin API |
| WordPress | `developer.wordpress.org` | (gleiche Domain) | |

## Amazon / Affiliate

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Amazon PA-API | `webservices.amazon.de` | (gleiche Domain) | DEPRECATED 30.04.2026! |
| Amazon PA-API (.com) | `webservices.amazon.com` | (gleiche Domain) | DEPRECATED 30.04.2026! |
| Amazon Associates | `affiliate-program.amazon.com` | (gleiche Domain) | Creators API = Nachfolger |

## AI & Cloud Plattformen

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Anthropic/Claude | `docs.anthropic.com` | `platform.claude.com` | Redirect docs → platform |
| OpenAI/ChatGPT | `platform.openai.com` | (gleiche Domain) | Blockt WebFetch (403) |
| OpenAI Help | `help.openai.com` | — | Blockt WebFetch (403) |
| Google Gemini | `ai.google.dev` | (gleiche Domain) | |
| Google Developers | `developers.google.com` | (gleiche Domain) | |
| Google Cloud | `docs.cloud.google.com` | (gleiche Domain) | Redirect von cloud.google.com |
| DeepSeek | `api-docs.deepseek.com` | (gleiche Domain) | OpenAI-kompatibel |
| xAI/Grok | `docs.x.ai` | (gleiche Domain) | |
| Microsoft 365 | `learn.microsoft.com` | (gleiche Domain) | Graph API, M365 Docs |

## Desktop & Tools

| Service | Docs-Domain | API-Domain | Notizen |
|---------|-------------|------------|---------|
| Brave Browser | `brave.com` | — | |
| Spotify | `developer.spotify.com` | (gleiche Domain) | Web API + SDKs |
| Thunderbird | `support.mozilla.org` | — | Mozilla Support |
| KDE Dolphin | `userbase.kde.org` | — | File Manager |
| tinyMediaManager | `www.tinymediamanager.org` | — | |
| JDownloader | `support.jdownloader.org` | `my.jdownloader.org` | API auf my.jdownloader |
| Micro Editor | `micro-editor.github.io` | — | |
| Fastfetch | (github.com) | — | Repo auf GitHub |
| eza | (github.com) | — | Repo auf GitHub |

## Plattformen (Multi-Service)

| Service | Domain | Notizen |
|---------|--------|---------|
| GitHub | `github.com` | Repos, Wikis, Issues |
| GitHub Docs | `docs.github.com` | Offizielle Docs |

---

## Hinweise

- **OpenAI blockt WebFetch** (403) — Domains trotzdem eintragen fuer den Fall dass sich das aendert
- **Amazon PA-API deprecated 30.04.2026** — Migration auf Creators API (`affiliate-program.amazon.com`)
- **Google Cloud** redirectet `cloud.google.com` → `docs.cloud.google.com` — beide eintragen
- **Anthropic** redirectet `docs.anthropic.com` → `platform.claude.com` — beide eintragen
- **Keine Wildcard-Subdomains** in Claude Code Permissions (Feature-Request #15260)

---

## Statistik

**Gesamt: 56 Domains** (Stand: 2026-03-05)
