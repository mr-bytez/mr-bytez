# CrowdSec — Deployment-Anleitung

**Version:** 0.1.0
**Erstellt:** 2026-03-04
**Aktualisiert:** 2026-03-04
**Autor:** MR-ByteZ

---

## Voraussetzungen

- [ ] Traefik Stack laeuft auf n8-vps
- [ ] Traefik Access-Log im JSON-Format (`traefik.yml`: `accessLog.format: json`)
- [ ] Docker-Netzwerk `mrbz-proxy-net` existiert
- [ ] CrowdSec Central API Account erstellt (https://app.crowdsec.net/)
- [ ] Enroll-Key von Central API kopiert

---

## Phase 1: Vorbereitung

### 1.1 Repo aktuell halten

```fish
cd /mr-bytez
git pull
```

### 1.2 Environment vorbereiten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/crowdsec
cp .env.example .env
```

### 1.3 Enroll-Key eintragen

Von https://app.crowdsec.net/ → Security Engines → Add Security Engine:

```fish
# .env editieren — CROWDSEC_ENROLL_KEY eintragen
micro .env
```

### 1.4 Traefik Access-Log pruefen

```fish
# Existiert die Log-Datei?
ls -la /var/log/traefik/access.log

# Ist das Format JSON?
tail -1 /var/log/traefik/access.log | python3 -m json.tool
```

Falls kein JSON: Traefik-Stack neu starten nach `traefik.yml` Aenderung.

---

## Phase 2: Stack starten + enrollen

### 2.1 Stack starten

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/crowdsec
docker compose up -d
```

### 2.2 Logs pruefen

```fish
docker logs mrbz-crowdsec --tail 50
```

Erwartete Ausgabe: Collections werden installiert, LAPI startet, Enrollment erfolgt.

### 2.3 Enrollment verifizieren

```fish
# Lokale Pruefung
docker exec mrbz-crowdsec cscli capi status

# Central API Dashboard pruefen
# https://app.crowdsec.net/ → Security Engines → n8-vps sollte erscheinen
```

### 2.4 Enrollment in Central API akzeptieren

In der CrowdSec Console (https://app.crowdsec.net/):
1. Security Engines oeffnen
2. Pending Engine "n8-vps" akzeptieren
3. Blocklists zuweisen (empfohlen: alle Community-Listen)

### 2.5 Health-Check

```fish
# CrowdSec Version
docker exec mrbz-crowdsec cscli version

# Installierte Collections
docker exec mrbz-crowdsec cscli collections list

# LAPI erreichbar
curl -s http://127.0.0.1:8080/health
```

---

## Phase 3: Bouncer-Keys generieren

### 3.1 Traefik Bouncer-Key

```fish
docker exec mrbz-crowdsec cscli bouncers add traefik-bouncer
```

Den ausgegebenen API-Key sicher speichern:
1. In Secrets-Repo: `.secrets/mrohwer/infrastructure/n8-vps/home/mrohwer/.secrets/services/crowdsec/crowdsec_traefik_bouncer_api_key.secret`
2. In Traefik `.env`: `CROWDSEC_BOUNCER_API_KEY=<key>`

### 3.2 Firewall Bouncer-Key (fuer spaeter)

```fish
docker exec mrbz-crowdsec cscli bouncers add firewall-bouncer
```

Den ausgegebenen API-Key sicher speichern:
1. In Secrets-Repo: `.secrets/mrohwer/infrastructure/n8-vps/home/mrohwer/.secrets/services/crowdsec/crowdsec_firewall_bouncer_api_key.secret`
2. In `/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml` auf dem Host

### 3.3 Traefik-Stack neu starten

Nach Eintragen des Bouncer-Keys in Traefik `.env`:

```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose up -d
```

### 3.4 Bouncer verifizieren

```fish
# Registrierte Bouncers anzeigen
docker exec mrbz-crowdsec cscli bouncers list

# Aktive Entscheidungen (sollte initial leer sein)
docker exec mrbz-crowdsec cscli decisions list
```

---

## Troubleshooting

### CrowdSec startet nicht

```fish
# Container-Status pruefen
docker ps -a --filter name=mrbz-crowdsec

# Detaillierte Logs
docker logs mrbz-crowdsec 2>&1 | tail -100
```

### Enrollment schlaegt fehl

- Enroll-Key in `.env` korrekt eingetragen?
- Internet-Zugang (HTTPS) vom Container aus vorhanden?
- Key bereits verwendet? → Neuen Key in Central API generieren

### LAPI nicht erreichbar

```fish
# Port-Binding pruefen
ss -tlnp | grep 8080

# Container-Netzwerk pruefen
docker network inspect mrbz-crowdsec-net
docker network inspect mrbz-proxy-net
```

### Traefik Plugin verbindet sich nicht

- Traefik Container und CrowdSec Container im selben Netzwerk (`mrbz-proxy-net`)?
- Bouncer-Key korrekt in Traefik `.env`?
- CrowdSec LAPI laeuft (`curl http://127.0.0.1:8080/health`)?

---

## Wartung

### Entscheidungen anzeigen

```fish
docker exec mrbz-crowdsec cscli decisions list
```

### Manuell IP bannen/entbannen

```fish
# IP bannen (4 Stunden)
docker exec mrbz-crowdsec cscli decisions add --ip 1.2.3.4 --duration 4h --reason "Manueller Ban"

# IP entbannen
docker exec mrbz-crowdsec cscli decisions delete --ip 1.2.3.4
```

### Metriken anzeigen

```fish
docker exec mrbz-crowdsec cscli metrics
```

### Hub aktualisieren

```fish
docker exec mrbz-crowdsec cscli hub update
docker exec mrbz-crowdsec cscli hub upgrade
```

---

## Referenzen

- **CrowdSec Docs:** https://docs.crowdsec.net/
- **Traefik Plugin:** https://github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin
- **Central API Console:** https://app.crowdsec.net/
- **Docker-Konventionen:** `.claude/context/docker.md`
