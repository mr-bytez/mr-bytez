# n8-vps — ROADMAP

> **Pfad:** `projects/infrastructure/n8-vps/ROADMAP.md`
> **Version:** 0.2.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Host-Planung fuer n8-vps (vollstaendige Pipeline)

---

## Aktuelle Planung

### Service-Pipeline (10-Schritte-Plan)

Traefik ist live — der kritische Pfad zum produktiven n8-vps Server.

```
Schritt  Status   Beschreibung                              Aufwand
────────────────────────────────────────────────────────────────────
  1      ✅       Pakete (deploy.fish v0.5.1) + Port 22     erledigt
  2      ✅       Traefik Reverse Proxy (B14)               erledigt
  3      🟠 WIP   Authentik SSO (auth.mr-bytez.de)          Stack erstellt
  4      ○        Portainer + Watchtower                    30 Min
  5      ○        WireGuard VPN (Port 61820 offen)          1-2h
  6      ○        CrowdSec IDS/IPS                          1h
  7      ○        Monitoring (Prometheus+Grafana+UptimeKuma) 2-3h
  8      ○        Backup Borg/borgmatic (VOR Prod-Daten!)   2h
  9      ○        Produktiv-Services (Forgejo→Vault→NC→...) variabel
 10      ○        DNS-Optimierung (TTLs, PTR, Tokens)       30 Min
```

Pipeline-Visualisierung:
```
✅ Traefik → 🟠 Authentik → Portainer → WireGuard
                  │                         │
                  ↓                         ↓
             CrowdSec → Monitoring → Backup → Services
```

→ Details: `docs/n8-vps-server-dokumentation.md`

---

## VPS-spezifische Details

### Hetzner Robot Firewall

Externe Hardware-Firewall — Default: discard, IPv6 gefiltert.
6 Regeln eingehend: ICMP, TCP Established, SSH 61020, HTTP, HTTPS, UDP Established.

### UFW (lokale Firewall)

6 Regeln: SSH LIMIT 61020, HTTP 80, HTTPS 443, WG 61820, Docker FWD+DNS.
IPv6 komplett deaktiviert.

### Geplante Stacks (Reihenfolge)

Authentik → Portainer+Watchtower → WireGuard → CrowdSec → Monitoring → Backup → Produktiv-Services

→ Details zu jedem Stack: `docs/n8-vps-server-dokumentation.md`

---

**Letzte Aktualisierung:** 2026-03-04
