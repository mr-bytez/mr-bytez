# WebFetch Domains — Erlaubte Dokumentations- und API-Seiten

**Version:** 0.2.0
**Erstellt:** 2026-03-05
**Aktualisiert:** 2026-03-05
**Autor:** MR-ByteZ

---

## Zweck

Zentrale Liste aller WebFetch-Domains die Claude Code ohne Rueckfrage abrufen darf.
Source of Truth fuer die `permissions.allow` Eintraege in `.claude/settings.json`.

**Sync-Pflicht:** Bei Aenderungen IMMER beide Dateien aktualisieren:
1. Diese Datei (Source of Truth, Dokumentation)
2. `.claude/settings.json` (Runtime-Config, Team-weit in Git)

**Format in settings.json:** `"WebFetch(domain:example.com)"`
**Wildcard:** Nicht unterstuetzt — jede Subdomain einzeln eintragen (Feature-Request #15260).

---

## Status-Legende

| Wert | Bedeutung |
|------|-----------|
| Aktiv | Domain ist in `settings.json` eingetragen und erreichbar |
| Redirect | Domain leitet weiter (Ziel-Domain ebenfalls eingetragen) |
| Auth-Wall | Domain erfordert Authentifizierung (302 → Login) |
| Blockiert | WebFetch wird vom Server abgelehnt (401/403/ECONNREFUSED) |
| Geplant | Domain noch nicht in JSON, fuer spaeter vorgesehen |

---

## Infrastruktur & OS

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Arch Linux | `wiki.archlinux.org` | — | Aktiv | Wiki |
| Arch Man-Pages | `man.archlinux.org` | — | Aktiv | Manual Pages |
| AUR | `aur.archlinux.org` | — | Aktiv | Paket-Registry |
| Fish Shell | `fishshell.com` | — | Aktiv | |
| Docker | `docs.docker.com` | (gleiche Domain) | Aktiv | Engine API unter /reference/api/ |
| Let's Encrypt | `letsencrypt.org` | — | Aktiv | ACME Protokoll |
| nftables | `wiki.nftables.org` | — | Aktiv | Firewall |
| Hetzner Docs | `docs.hetzner.com` | — | Aktiv | Hosting-Dokumentation |
| Hetzner Cloud | `docs.hetzner.cloud` | — | Aktiv | Cloud-API-Docs |
| Hetzner Robot | `robot.hetzner.com` | — | Auth-Wall | 302 → OAuth Login |
| age encryption | `age-encryption.org` | — | Redirect | 302 → github.com/FiloSottile/age |

## Reverse Proxy & Security

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Traefik | `doc.traefik.io` | (gleiche Domain) | Aktiv | |
| Authentik | `docs.goauthentik.io` | `api.goauthentik.io` | Aktiv | SSO, OpenAPI |
| CrowdSec | `docs.crowdsec.net` | (gleiche Domain) | Aktiv | IDS/IPS |

## Netzwerk & DNS

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| WireGuard | `www.wireguard.com` | — | Aktiv | VPN |
| AdGuard | `adguard-dns.io` | — | Aktiv | DNS Blocking |
| Unbound | `unbound.docs.nlnetlabs.nl` | — | Aktiv | DNS Resolver |

## Monitoring

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Grafana | `grafana.com` | (gleiche Domain) | Aktiv | Dashboards, HTTP API |
| Prometheus | `prometheus.io` | (gleiche Domain) | Aktiv | Metriken |
| Uptime Kuma | (github.com Wiki) | — | — | Docs auf GitHub |

## Self-Hosted Services

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Nextcloud | `docs.nextcloud.com` | (gleiche Domain) | Aktiv | Cloud |
| Immich | `docs.immich.app` | (gleiche Domain) | Aktiv | Foto/Video |
| Jellyfin | `jellyfin.org` | `api.jellyfin.org` | Aktiv | Media Server |
| Plex | `support.plex.tv` | `docs.plex.tv` | Aktiv | Media Server |
| Paperless-NGX | `docs.paperless-ngx.com` | (gleiche Domain) | Aktiv | DMS |
| Vaultwarden | (github.com Wiki) | — | — | Passwort-Manager |
| Mailcow | `docs.mailcow.email` | (gleiche Domain) | Aktiv | Mail-Suite |
| Forgejo | `forgejo.org` | (gleiche Domain) | Aktiv | Git-Server |
| Portainer | `docs.portainer.io` | (gleiche Domain) | Aktiv | Container-UI |
| Watchtower | `containrrr.dev` | — | Aktiv | Auto-Update |

## Backup & Sync

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Borg | `borgbackup.readthedocs.io` | — | Aktiv | Deduplizierung |
| rclone | `rclone.org` | — | Aktiv | Cloud-Sync |

## Datenbanken

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| PostgreSQL | `www.postgresql.org` | — | Aktiv | |
| MariaDB | `mariadb.com` | — | Aktiv | |
| Redis | `redis.io` | — | Aktiv | |

## Web & E-Commerce

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Shopware | `developer.shopware.com` | (gleiche Domain) | Aktiv | Store API + Admin API |
| WordPress | `developer.wordpress.org` | (gleiche Domain) | Aktiv | |

## Amazon / Affiliate

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Amazon PA-API (.de) | `webservices.amazon.de` | (gleiche Domain) | Aktiv | DEPRECATED 30.04.2026! |
| Amazon PA-API (.com) | `webservices.amazon.com` | (gleiche Domain) | Aktiv | DEPRECATED 30.04.2026! |
| Amazon Associates (.com) | `affiliate-program.amazon.com` | (gleiche Domain) | Aktiv | Creators API = Nachfolger |
| Amazon PartnerNet (.de) | `partnernet.amazon.de` | — | Aktiv | Amazon.de Associates Central |

## AI & Cloud Plattformen

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Anthropic | `docs.anthropic.com` | `platform.claude.com` | Aktiv | Redirect docs → platform |
| Anthropic Console | `console.anthropic.com` | — | Redirect | 302 → platform.claude.com |
| Claude Docs | `docs.claude.com` | — | Blockiert | 401 Unauthorized |
| OpenAI/ChatGPT | `platform.openai.com` | (gleiche Domain) | Blockiert | 403 — NICHT in settings.json |
| OpenAI Help | `help.openai.com` | — | Blockiert | 403 — NICHT in settings.json |
| Google Gemini | `ai.google.dev` | (gleiche Domain) | Aktiv | |
| Google Developers | `developers.google.com` | (gleiche Domain) | Aktiv | |
| Google Cloud | `docs.cloud.google.com` | (gleiche Domain) | Aktiv | Redirect von cloud.google.com |
| DeepSeek | `api-docs.deepseek.com` | (gleiche Domain) | Aktiv | OpenAI-kompatibel |
| xAI/Grok | `docs.x.ai` | (gleiche Domain) | Aktiv | |
| Microsoft 365 | `learn.microsoft.com` | (gleiche Domain) | Aktiv | Graph API, M365 Docs |

## Desktop & Tools

| Service | Docs-Domain | API-Domain | Status | Notizen |
|---------|-------------|------------|--------|---------|
| Brave Browser | `brave.com` | — | Aktiv | |
| Spotify | `developer.spotify.com` | (gleiche Domain) | Aktiv | Web API + SDKs |
| Thunderbird | `support.mozilla.org` | — | Aktiv | Mozilla Support |
| KDE Dolphin | `userbase.kde.org` | — | Aktiv | File Manager |
| tinyMediaManager | `www.tinymediamanager.org` | — | Aktiv | |
| JDownloader | `support.jdownloader.org` | `my.jdownloader.org` | Aktiv | API auf my.jdownloader |
| Micro Editor | `micro-editor.github.io` | — | Aktiv | |
| Fastfetch | (github.com) | — | — | Repo auf GitHub |
| eza | (github.com) | — | — | Repo auf GitHub |

## Plattformen (Multi-Service)

| Service | Domain | Status | Notizen |
|---------|--------|--------|---------|
| GitHub | `github.com` | Aktiv | Repos, Wikis, Issues |
| GitHub Docs | `docs.github.com` | Aktiv | Offizielle Docs |
| Codeberg | `codeberg.org` | Aktiv | Forgejo-basiert |

---

## Hinweise

- **OpenAI blockt WebFetch** (403) — Domains in Doku behalten, NICHT in settings.json
- **Amazon PA-API deprecated 30.04.2026** — Migration auf Creators API (`affiliate-program.amazon.com`)
- **Google Cloud** redirectet `cloud.google.com` → `docs.cloud.google.com` — beide in settings.json
- **Anthropic** redirectet `docs.anthropic.com` → `platform.claude.com` — beide in settings.json
- **console.anthropic.com** redirectet → `platform.claude.com` — in settings.json fuer Convenience
- **age-encryption.org** redirectet → GitHub — in settings.json fuer Convenience
- **Keine Wildcard-Subdomains** in Claude Code Permissions (Feature-Request #15260)

---

## Statistik

**Gesamt: 64 Domains in settings.json** (Stand: 2026-03-05)
- 54 aus vorheriger Version (56 minus 2 OpenAI)
- 10 neue: Codeberg, Hetzner (3x), age, Arch (2x), Amazon PartnerNet DE, Anthropic Console, Claude Docs
- 2 OpenAI-Domains nur in Doku (blocken WebFetch)
- affiliate-program.amazon.de entfernt (Domain existiert nicht, ECONNREFUSED)
