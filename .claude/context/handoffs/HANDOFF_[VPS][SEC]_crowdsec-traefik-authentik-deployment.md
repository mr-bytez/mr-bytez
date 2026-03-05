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

---

## Offene Punkte

- [ ] **Firewall Bouncer** — CrowdSec Firewall Bouncer (cs-firewall-bouncer-iptables)
  aus AUR bauen und auf n8-vps installieren. Manuell per SSH (systemd-Service).
  Konfiguration: LAPI URL http://127.0.0.1:8080, API-Key aus `cscli bouncers add`.
- [ ] **Authentik Forward-Auth Provider** — im Authentik Web-UI anlegen:
  Proxy Provider erstellen (Forward Auth Single Application),
  Application erstellen, Provider zuweisen.
  Erst danach funktioniert Forward-Auth live.
- [ ] **Traefik Dashboard Forward-Auth testen** — nach Provider-Anlage:
  traefik.mr-bytez.de aufrufen, Authentik Login-Flow pruefen.
- [ ] **Host-Level Tuning auf n8-vps deployen** — Config-Dateien liegen im Repo,
  muessen noch per `sudo cp` auf n8-vps angewendet werden (siehe DEPLOYMENT.md).

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
