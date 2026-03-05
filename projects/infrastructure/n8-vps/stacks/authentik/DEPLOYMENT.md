# Authentik SSO Stack — Deployment-Anleitung

> **Pfad:** `projects/infrastructure/n8-vps/stacks/authentik/DEPLOYMENT.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Schritt-fuer-Schritt Deployment auf n8-vps

---

## Voraussetzungen

- [ ] Traefik Reverse Proxy laeuft (`mrbz-traefik` Container healthy)
- [ ] `mrbz-proxy-net` Netzwerk existiert
- [ ] Wildcard-Zertifikat fuer `*.mr-bytez.de` aktiv
- [ ] DNS: `auth.mr-bytez.de` zeigt auf n8-vps (Wildcard A-Record)
- [ ] Secrets deployed unter `~/.secrets/services/authentik/`

---

## Phase 1: Vorbereitung

### 1.1 Secrets pruefen

```fish
# Pruefen ob alle Secrets vorhanden sind
ls ~/.secrets/services/authentik/
# Erwartet: authentik_postgresql_database_password.secret
#           authentik_django_secret_key.secret
#           authentik_akadmin_password.secret
#           authentik_mrohwer_admin_api_token.secret
```

### 1.2 Environment einrichten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/authentik
cp .env.example .env
# Pfade in .env pruefen und ggf. anpassen
```

### 1.3 Bootstrap aktivieren (nur beim ersten Start)

In `.env` die Bootstrap-Zeilen einkommentieren:
```
AUTHENTIK_BOOTSTRAP_PASSWORD_FILE=/home/mrohwer/.secrets/services/authentik/authentik_akadmin_password.secret
AUTHENTIK_BOOTSTRAP_TOKEN_FILE=/home/mrohwer/.secrets/services/authentik/authentik_mrohwer_admin_api_token.secret
```

In `docker-compose.yml` die Bootstrap-Variablen im `x-authentik-env` Anchor einkommentieren:
```yaml
AUTHENTIK_BOOTSTRAP_PASSWORD: file://${AUTHENTIK_BOOTSTRAP_PASSWORD_FILE}
AUTHENTIK_BOOTSTRAP_TOKEN: file://${AUTHENTIK_BOOTSTRAP_TOKEN_FILE}
AUTHENTIK_BOOTSTRAP_EMAIL: admin@mr-bytez.de
```

---

## Phase 2: Stack starten

### 2.1 Internes Netzwerk erstellen

```fish
# Netzwerk wird automatisch von docker compose erstellt,
# alternativ manuell:
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/24 \
  --gateway 172.20.0.1 \
  mrbz-authentik-net
```

### 2.2 Stack starten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/authentik
docker compose up -d
```

### 2.3 Container-Status pruefen

```fish
docker compose ps
# Alle 4 Container sollten "healthy" sein (kann 1-2 Min dauern)

docker compose logs -f server
# Warten bis "Starting authentik server" erscheint
```

---

## Phase 3: Verifizierung

### 3.1 Health Checks

```fish
# Alle Container healthy?
docker ps --filter "name=mrbz-authentik" --format "table {{.Names}}\t{{.Status}}"

# PostgreSQL erreichbar?
docker exec mrbz-authentik-postgres pg_isready -d authentik -U authentik
```

### 3.2 Web-UI testen

- Browser: `https://auth.mr-bytez.de`
- Login mit `akadmin` und dem Bootstrap-Passwort
- Admin-Interface: `https://auth.mr-bytez.de/if/admin/`

### 3.3 Bootstrap deaktivieren

Nach erfolgreichem Login:
1. Bootstrap-Zeilen in `.env` wieder auskommentieren
2. Bootstrap-Zeilen in `docker-compose.yml` wieder auskommentieren
3. Stack neu starten: `docker compose up -d`

---

## Troubleshooting

### Container startet nicht

```fish
# Logs pruefen
docker compose logs postgres
docker compose logs server

# Haeufige Ursachen:
# - Secrets-Datei nicht gefunden → Pfade in .env pruefen
# - Port-Konflikt → docker ps pruefen (kein Host-Port exponiert)
# - Netzwerk-Konflikt → docker network ls pruefen
```

### auth.mr-bytez.de nicht erreichbar

```fish
# Traefik-Router pruefen
docker logs mrbz-traefik 2>&1 | grep authentik

# Netzwerk-Verbindung pruefen
docker network inspect mrbz-proxy-net | grep mrbz-authentik-server

# Authentik Server Health
docker exec mrbz-authentik-server ak healthcheck
```

### Datenbank-Verbindung fehlgeschlagen

```fish
# PostgreSQL-Logs pruefen
docker compose logs postgres

# Passwort-Datei lesbar?
docker exec mrbz-authentik-server cat /run/secrets/authentik_db_password 2>/dev/null
# Falls nicht: Pfad in .env und Volume-Mounts pruefen
```

### Performance-Probleme

```fish
# Resource-Nutzung pruefen
docker stats --filter "name=mrbz-authentik" --no-stream

# Worker-Anzahl anpassen in docker-compose.yml:
# AUTHENTIK_WEB__WORKERS: 4  → erhoehen falls CPU frei
# AUTHENTIK_WEB__THREADS: 4  → erhoehen falls I/O-lastig
```

---

## Naechste Schritte

Nach erfolgreichem Deployment:
1. **Forward-Auth Middleware** in Traefik konfigurieren (`config/dynamic/authentik.yml`)
2. **Traefik Dashboard** von BasicAuth auf Authentik Forward-Auth umstellen
3. **OAuth2/OIDC Provider** fuer weitere Services einrichten (Jellyfin, Portainer, etc.)
