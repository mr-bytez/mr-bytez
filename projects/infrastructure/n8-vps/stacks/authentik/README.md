# Authentik SSO Stack — n8-vps

> **Pfad:** `projects/infrastructure/n8-vps/stacks/authentik/`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Authentik Identity Provider fuer zentrales SSO auf n8-vps

---

## Uebersicht

Authentik ist der zentrale Identity Provider fuer alle MR-ByteZ Services.
Er stellt OAuth2/OIDC, SAML und LDAP bereit und schuetzt Services ueber Traefik Forward-Auth.

**Subdomain:** `auth.mr-bytez.de`

---

## Architektur

| Service | Container | Image | IP | Funktion |
|---------|-----------|-------|----|----------|
| PostgreSQL | `mrbz-authentik-postgres` | `postgres:18-alpine` | `172.20.0.100` | Datenbank |
| Valkey | `mrbz-authentik-valkey` | `valkey/valkey:9-alpine` | `172.20.0.101` | Cache (Redis-kompatibel) |
| Server | `mrbz-authentik-server` | `ghcr.io/goauthentik/server:2026.2.1` | `172.20.0.102` | Web-UI + API |
| Worker | `mrbz-authentik-worker` | `ghcr.io/goauthentik/server:2026.2.1` | `172.20.0.103` | Hintergrund-Tasks |

---

## Netzwerke

| Netzwerk | Subnet | Typ | Zweck |
|----------|--------|-----|-------|
| `mrbz-proxy-net` | (extern) | external | Traefik-Anbindung |
| `mrbz-authentik-net` | `172.20.0.0/24` | intern | Stack-Kommunikation |

---

## Volumes

| Volume | Zweck |
|--------|-------|
| `mrbz-authentik-postgres-data` | PostgreSQL Datenbank |
| `mrbz-authentik-valkey-data` | Valkey Persistenz |
| `mrbz-authentik-media` | Authentik Media (Icons, Bilder) |
| `mrbz-authentik-templates` | Custom Templates |
| `mrbz-authentik-certs` | Zertifikate (Worker) |

---

## Secrets

Alle Secrets liegen verschluesselt im Secrets-Submodule unter:
`~/.secrets/services/authentik/`

| Datei | Zweck |
|-------|-------|
| `authentik_postgresql_database_password.secret` | PostgreSQL Passwort |
| `authentik_django_secret_key.secret` | Django Secret Key |
| `authentik_akadmin_password.secret` | Bootstrap Admin-Passwort |
| `authentik_mrohwer_admin_api_token.secret` | Bootstrap API-Token |

---

## Performance-Tuning

Optimiert fuer n8-vps (12 Kerne / 24 Threads, 128 GB RAM):
- **Web Workers:** 4 (statt Standard 2)
- **Web Threads:** 4 pro Worker
- **PostgreSQL:** 256 MB shared_buffers, 512 MB effective_cache_size

---

## Dateien

| Datei | Zweck |
|-------|-------|
| `docker-compose.yml` | Stack-Definition |
| `.env.example` | Vorlage fuer `.env` |
| `README.md` | Diese Datei |
| `DEPLOYMENT.md` | Deployment-Anleitung |

---

## Verweis

→ Deployment-Anleitung: `DEPLOYMENT.md`
→ Docker-Konventionen: `.claude/context/docker.md`
→ Traefik-Stack: `projects/infrastructure/n8-vps/stacks/traefik/`
