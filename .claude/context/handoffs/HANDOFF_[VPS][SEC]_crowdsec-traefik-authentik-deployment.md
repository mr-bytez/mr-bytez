# Handoff: CrowdSec + Authentik Deployment auf n8-vps

> **Pfad:** `.claude/context/handoffs/HANDOFF_[VPS][SEC]_crowdsec-traefik-authentik-deployment.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-05
> **Aktualisiert:** 2026-03-05
> **Autor:** MR-ByteZ
> **Chat:** https://claude.ai/chat/f64d25fb-098d-4d26-87df-c58ccbfce3c3

---

## Kontext

VPS-Pipeline Schritte 3 (Authentik) und 6 (CrowdSec) — Stack-Erstellung, Deployment,
Konfiguration und Host-Level Tuning.

---

## Erledigte Punkte

- ✅ CrowdSec Stack erstellt + deployed (Docker Agent, LAPI, Subnet 172.21.0.0/24)
- ✅ CrowdSec Bouncer Middleware auf allen oeffentlichen Routern aktiviert
- ✅ CrowdSec Enrollment bestaetigt (Console-Dashboard)
- ✅ Authentik Stack erstellt + deployed (3 Services: postgres, server, worker)
- ✅ Authentik konfiguriert: akadmin deaktiviert, mrohwer als Admin mit MFA
- ✅ Authentik Passwort-Policy: min 15 Zeichen
- ✅ Valkey komplett entfernt (seit Authentik 2025.10 obsolet, PostgreSQL als Cache)
- ✅ Forward-Auth Middleware erstellt (config/dynamic/authentik.yml)
- ✅ Dashboard BasicAuth durch Authentik Forward-Auth ersetzt (in Config)
- ✅ Outpost-Router Labels auf Authentik Server (Priority 200, Auth-Loop-Schutz)
- ✅ CrowdSec Bouncer: crowdsecMode stream + updateMaxFailure 5
- ✅ Hardware-Doku korrigiert (echte Specs: Core Ultra 7 265, 64 GB DDR5)
- ✅ Stack-Tuning: PostgreSQL, Traefik Timeouts, CrowdSec updateInterval
- ✅ Traefik Config-Fix: keepAlive-Felder auf transport-Ebene verschoben
- ✅ Host-Level Tuning: sysctl, ulimits, Docker daemon.json, systemd Limits
- ✅ Config-Dateien unter shared/etc/ ins Repo aufgenommen (5 Dateien + Fish ulimit)
- ✅ DEPLOYMENT.md mit manuellen Deploy-Schritten ergaenzt
- ✅ Codeberg-Pushes nachgeholt
- ✅ Host-Level Tuning auf n8-vps deployed (sysctl, ulimits, Docker, systemd, Fish)
- ✅ PostgreSQL Volume-Mount Fix: `/var/lib/postgresql/data` → `/var/lib/postgresql`
  (postgres:18-alpine schreibt unter `18/docker/`, Volume war leer). `external: true` gesetzt.
- ✅ Stack-Haertung: `no-new-privileges`, Traefik Healthcheck/Hostname/Logging, CSRF, PGDATA
- ✅ Secret-Key Newline-Bug gefixt (openssl base64 Zeilenumbruch → Outpost-Fehler)
- ✅ Forward-Auth Provider + Application via API erstellt, Embedded Outpost zugewiesen
- ✅ Forward-Auth live getestet (traefik.mr-bytez.de → 302 → auth.mr-bytez.de)
- ✅ Alle 3 Stacks redeployed + verifiziert (5 Container healthy)

---

## Offene Punkte

- [x] ~~**Firewall Bouncer**~~ — erledigt (CrowdSec komplett auf nativ migriert, Bouncer in iptables-Mode)
- [ ] **Community-Blocklisten** — In CrowdSec Console zusaetzliche Listen abonnieren:
  FireHOL BotScout, greensnow.co, Georgs Honeypot, Tor Exit Nodes
- [ ] **CrowdSec Console Enrollment** — Neue native Instanz in Console enrollen
  (alter Docker-Enrollment ist ungueltig, neuer Enroll-Key noetig)
- [x] ~~**Authentik Forward-Auth Provider**~~ — erledigt (via API: Provider + Application + Outpost)
- [x] ~~**Traefik Dashboard Forward-Auth testen**~~ — erledigt (302 → auth.mr-bytez.de, Login funktioniert)
- [x] ~~**Host-Level Tuning auf n8-vps deployen**~~ — erledigt (deployed + verifiziert)

---

## Relevante Dateien

| Datei | Beschreibung |
|-------|--------------|
| `projects/infrastructure/n8-vps/stacks/crowdsec/` | CrowdSec Stack |
| `projects/infrastructure/n8-vps/stacks/authentik/` | Authentik Stack |
| `projects/infrastructure/n8-vps/stacks/traefik/` | Traefik Stack |
| `shared/etc/sysctl.d/90-mr-bytez.conf` | Kernel-Parameter |
| `shared/etc/security/limits.d/90-mr-bytez.conf` | PAM Limits |
| `shared/etc/docker/daemon.json` | Docker Default-Ulimits |
| `shared/etc/systemd/system.conf.d/90-mr-bytez.conf` | systemd System-Limits |
| `shared/etc/systemd/user.conf.d/90-mr-bytez.conf` | systemd User-Limits |
| `shared/etc/fish/conf.d/010-ulimits.fish` | Fish Soft-Limit Workaround |
| `DEPLOYMENT.md` | Host-Level Tuning Deploy-Anleitung |
