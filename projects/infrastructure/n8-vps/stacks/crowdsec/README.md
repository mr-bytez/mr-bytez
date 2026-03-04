# CrowdSec Security Engine — n8-vps

**Version:** 0.1.0
**Erstellt:** 2026-03-04
**Aktualisiert:** 2026-03-04
**Autor:** MR-ByteZ

---

## Uebersicht

CrowdSec als Intrusion Prevention System auf n8-vps. Analysiert Traefik Access-Logs
und blockiert boesartige IPs ueber drei Bouncer-Mechanismen.

---

## Architektur

```
                    ┌─────────────────────────────────────────┐
                    │              CrowdSec CAPI              │
                    │        (app.crowdsec.net, Cloud)         │
                    └──────────────┬──────────────────────────┘
                                   │ Enrollment + Threat Intel
                                   ▼
┌──────────────┐    ┌─────────────────────────────────────────┐
│   Traefik    │───▶│  CrowdSec Agent (mrbz-crowdsec)        │
│  Access-Log  │    │  LAPI auf 127.0.0.1:8080                │
│  (JSON)      │    │  Subnet: 172.21.0.0/24                  │
└──────────────┘    └──────────┬──────────────┬───────────────┘
                               │              │
                    ┌──────────▼──┐    ┌──────▼──────────────┐
                    │  Traefik    │    │  Firewall Bouncer   │
                    │  Plugin     │    │  (systemd, manuell) │
                    │  (Docker)   │    │  (nftables/iptables)│
                    └─────────────┘    └─────────────────────┘
```

### Drei Bouncer-Typen

| Bouncer | Typ | Wo | Funktion |
|---------|-----|-----|----------|
| Traefik Plugin | Docker | Traefik Container | HTTP-Requests auf Anwendungsebene blockieren |
| Firewall Bouncer | Systemd | Host (n8-vps) | IPs auf Netzwerkebene blockieren (nftables) |
| Central API | Cloud | app.crowdsec.net | Threat Intelligence, IP-Reputation, Dashboard |

---

## Stack-Details

| Eigenschaft | Wert |
|------------|------|
| Image | `crowdsecurity/crowdsec:latest` |
| Container | `mrbz-crowdsec` |
| Netzwerk (intern) | `mrbz-crowdsec-net` (172.21.0.0/24) |
| Netzwerk (extern) | `mrbz-proxy-net` (fuer Traefik Plugin) |
| LAPI Port | `127.0.0.1:8080` (nur lokal) |
| Log-Quelle | `/var/log/traefik/access.log` (JSON) |
| Collections | traefik, http-cve, http-probing, base-http-scenarios |

---

## Dateien

```
crowdsec/
├── docker-compose.yml          # Stack-Definition
├── config/
│   └── acquis.yaml             # Log-Acquisition (Traefik Access-Log)
├── .env.example                # Beispiel-Environment (→ .env kopieren)
├── README.md                   # Diese Datei
└── DEPLOYMENT.md               # Deployment-Anleitung (3 Phasen)
```

---

## Netzwerk-Integration

- **mrbz-crowdsec-net** (172.21.0.0/24): Internes Netzwerk fuer CrowdSec
- **mrbz-proxy-net** (extern): Geteiltes Netzwerk mit Traefik — ermoeglicht
  Traefik Plugin direkten Zugriff auf CrowdSec LAPI ohne Port-Binding

---

## Sicherheitshinweise

- **LAPI:** Nur auf `127.0.0.1:8080` gebunden — nicht oeffentlich erreichbar
- **Enroll-Key:** Einmalig verwendbar, nicht langlebig — nach Enrollment wertlos
- **Bouncer-Keys:** Langlebige API-Keys — in `.secrets/` verschluesselt ablegen
- **Access-Log:** Read-only gemountet, CrowdSec kann Traefik-Logs nicht veraendern
- **Central API:** Opt-in, sendet KEINE Log-Daten — nur Entscheidungen (IP + Aktion)

---

## Abhaengigkeiten

Voraussetzungen:
- Traefik Stack laeuft (Access-Log unter `/var/log/traefik/access.log`)
- Traefik Access-Log im JSON-Format (→ traefik.yml `accessLog.format: json`)
- Docker-Netzwerk `mrbz-proxy-net` existiert
- CrowdSec Central API Account (https://app.crowdsec.net/)

Abhaengige Services:
- Traefik Plugin (crowdsec-bouncer-traefik-plugin v1.5.1)
- Firewall Bouncer (systemd, manuell installiert)

---

## Referenzen

- **Docker-Konventionen:** `.claude/context/docker.md`
- **Traefik Stack:** `projects/infrastructure/n8-vps/stacks/traefik/`
- **CrowdSec Docs:** https://docs.crowdsec.net/
- **Traefik Plugin:** https://github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin
- **ROADMAP:** `projects/infrastructure/n8-vps/ROADMAP.md`
