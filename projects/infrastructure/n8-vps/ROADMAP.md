# n8-vps — ROADMAP

> **Pfad:** `projects/infrastructure/n8-vps/ROADMAP.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Host-Planung fuer n8-vps (verweist auf Root-ROADMAP)

---

## Aktuelle Planung

Die n8-vps Service-Pipeline (10 Schritte) wird zentral in der Root-ROADMAP gefuehrt.

→ Siehe: Root `ROADMAP.md` → Abschnitt "n8-vps Service-Pipeline"

### Kurzuebersicht

| Schritt | Status | Beschreibung |
|---------|--------|-------------|
| 1 | ✅ | Pakete + Port 22 Cleanup |
| 2 | ✅ | Traefik Reverse Proxy |
| 3 | 📌 NEXT | Authentik SSO |
| 4-10 | ○ | Portainer, WireGuard, CrowdSec, Monitoring, Backup, Services, DNS |

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
