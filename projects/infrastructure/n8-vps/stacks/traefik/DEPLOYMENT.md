# Traefik Deployment — n8-vps

**Version:** 0.1.0
**Erstellt:** 2026-03-01
**Aktualisiert:** 2026-03-01
**Autor:** MR-ByteZ

---

## Voraussetzungen

- [x] DNS Wildcard A+AAAA Records `*.mr-bytez.de` → n8-vps
- [x] CAA Records fuer Let's Encrypt (`issue` + `issuewild`)
- [x] Firewall: Port 80 + 443 offen
- [x] Docker installiert und laeuft auf n8-vps
- [x] mr-bytez Repo deployed auf n8-vps (read-only)

---

## Phase 2: Deployment auf n8-vps

### Schritt 1: Repo aktualisieren

```fish
cd /mr-bytez
git pull origin main
```

### Schritt 2: Docker-Netzwerk erstellen

```fish
docker network create mrbz-proxy-net
```

### Schritt 3: Log-Verzeichnis erstellen

```fish
sudo mkdir -p /var/log/traefik
sudo chown mrohwer:mrohwer /var/log/traefik
```

### Schritt 4: .env erstellen

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
cp .env.example .env
```

Werte eintragen:

```fish
# API-Token aus Secrets eintragen
# BasicAuth Hash generieren:
htpasswd -nB admin
# Ausgabe (user:hash) in .env bei TRAEFIK_DASHBOARD_AUTH eintragen
```

**Hinweis:** `apache-tools` muss installiert sein (`sudo pacman -S apache`).

### Schritt 5: Stack starten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose up -d
```

### Schritt 6: Verifizierung

```fish
# Container laeuft?
docker ps | command grep mrbz-traefik

# Dashboard erreichbar? (BasicAuth Prompt)
curl -v https://traefik.mr-bytez.de

# HTTP→HTTPS Redirect?
curl -I http://traefik.mr-bytez.de

# Logs pruefen
command cat /var/log/traefik/access.log
command cat /var/log/traefik/error.log
```

---

## Phase 3: Test-Service (Validierung)

### whoami Test-Container deployen

```fish
docker run -d \
  --name mrbz-whoami \
  --network mrbz-proxy-net \
  --label "traefik.enable=true" \
  --label "traefik.http.routers.whoami.rule=Host(\`whoami.mr-bytez.de\`)" \
  --label "traefik.http.routers.whoami.entrypoints=websecure" \
  --label "traefik.http.routers.whoami.tls.certresolver=letsencrypt-production" \
  traefik/whoami
```

### Verifizierung

```fish
# Container-Info anzeigen
curl https://whoami.mr-bytez.de

# SSL-Zertifikat pruefen (Wildcard *.mr-bytez.de)
curl -v https://whoami.mr-bytez.de 2>&1 | command grep "subject:"

# HTTP→HTTPS Redirect
curl -I http://whoami.mr-bytez.de
```

### Test-Container entfernen

```fish
docker rm -f mrbz-whoami
```

---

## Troubleshooting

### ACME/Zertifikat-Probleme

```fish
# Traefik Logs pruefen
docker logs mrbz-traefik 2>&1 | command grep -i acme

# acme.json Berechtigungen pruefen (muss 0600 sein)
docker exec mrbz-traefik ls -la /letsencrypt/acme.json
```

### Dashboard nicht erreichbar

```fish
# DNS pruefen
dig traefik.mr-bytez.de

# Container-Status
docker inspect mrbz-traefik | command grep -A5 State

# Netzwerk pruefen
docker network inspect mrbz-proxy-net
```

### Container startet nicht

```fish
# Logs anzeigen
docker compose logs traefik

# Config validieren
docker run --rm -v (pwd)/config/traefik.yml:/etc/traefik/traefik.yml:ro traefik:v3.6 traefik --configfile /etc/traefik/traefik.yml --check
```

---

## Wartung

### Stack neu starten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose restart
```

### Config-Aenderung anwenden

Statische Config (`traefik.yml`) erfordert Neustart:
```fish
docker compose restart
```

Dynamische Config (`dynamic/*.yml`) wird automatisch erkannt (watch: true).

### Update

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose pull
docker compose up -d
```
