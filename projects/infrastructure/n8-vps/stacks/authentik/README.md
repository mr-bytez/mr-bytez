# Authentik SSO Stack — n8-vps

> **Pfad:** `projects/infrastructure/n8-vps/stacks/authentik/`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-05
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
| PostgreSQL | `mrbz-authentik-postgres` | `postgres:18-alpine` | `172.20.0.100` | Datenbank + Cache (django_postgres_cache) |
| Server | `mrbz-authentik-server` | `ghcr.io/goauthentik/server:2026.2.1` | `172.20.0.102` | Web-UI + API |
| Worker | `mrbz-authentik-worker` | `ghcr.io/goauthentik/server:2026.2.1` | `172.20.0.103` | Hintergrund-Tasks |

**Hinweis:** Seit Authentik 2025.10 wurde Redis/Valkey entfernt. PostgreSQL uebernimmt
Cache, Sessions, WebSocket und Tasks via `django_postgres_cache`.

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
| `mrbz-authentik-postgres-data` | PostgreSQL Datenbank + Cache |
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

Optimiert fuer n8-vps (20 Kerne, 64 GB DDR5):
- **Web Workers:** 4 (statt Standard 2)
- **Web Threads:** 4 pro Worker
- **PostgreSQL:** 2 GB shared_buffers, 8 GB effective_cache_size, 200 max_connections
- **PostgreSQL:** max_locks_per_transaction=256 (Authentik Redis-Migration, GitHub #18151)
- **PostgreSQL:** wal_buffers=64 MB (erhoehter Write-Throughput fuer Cache-Writes)
- **Kein Redis/Valkey:** Seit Authentik 2025.10 entfernt, PostgreSQL ist alleiniger Cache

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
