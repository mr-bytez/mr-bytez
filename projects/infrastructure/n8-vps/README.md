# n8-vps — Host-Uebersicht

> **Pfad:** `projects/infrastructure/n8-vps/README.md`
> **Version:** 0.2.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-06
> **Autor:** MR-ByteZ
> **Zweck:** Host-Uebersicht fuer n8-vps (Hetzner EX63 Production Server)

---

## Server-Steckbrief

| Eigenschaft | Wert |
|-------------|------|
| **Hostname** | n8-vps |
| **Typ** | Hetzner EX63 Dedicated Server |
| **Standort** | Hetzner Rechenzentrum Falkenstein, Deutschland |
| **Prozessor** | Intel Core Ultra 7 265 (20 Kerne, 8P+12E) |
| **RAM** | 64 GB DDR5 5600 MT/s |
| **Storage** | 2x Micron 3500 954 GB NVMe (RAID 1) |
| **LVM-Layout** | 500 GB root, 100 GB home, 8 GB swap (~353 GB Reserve) |
| **OS** | Arch Linux (vanilla slim, installimage) |
| **IPv4** | `136.243.101.223` |
| **IPv6** | `2a01:4f8:171:ad1::2` |
| **SSH-Port** | 61020 (Key-Only, Password disabled) |
| **User** | `mrohwer` (sudo NOPASSWD, wheel-Gruppe) |
| **Rolle** | Production Server (read-only fuer Git, kein Commit!) |

---

## Netzwerk

- DNS: Wildcard `*.mr-bytez.de` → n8-vps (A + AAAA)
- Traefik Reverse Proxy auf Port 80/443
- WireGuard VPN vorbereitet (Port 61820/udp offen)
- Unbound lokaler DNS-Resolver (DoT zu Cloudflare + Quad9)

---

## Aktive Services

- **Traefik** v3.6 Reverse Proxy (Dashboard: traefik.mr-bytez.de)
- **Authentik** 2026.2.1 SSO (auth.mr-bytez.de, Forward-Auth fuer Dashboard)
- **CrowdSec** IDS/IPS (nativ, Firewall Bouncer + Traefik Plugin, 8 Collections,
  Console enrolled, 3 Community-Blocklisten)
- Fish Shell mit mr-bytez Integration (Powerline Prompt, rot = Production)

→ Geplante Services: `ROADMAP.md` (n8-vps Service-Pipeline)

---

## Verzeichnisstruktur

```
projects/infrastructure/n8-vps/
├── README.md              # Diese Datei
├── CHANGELOG.md           # Host-Historie
├── ROADMAP.md             # Host-Planung (verweist auf Root)
├── DEPLOYMENT.md          # Host-Deployment
├── .claude/
│   ├── CLAUDE.md              # Host KI-Context
│   └── context/
│       └── hardware.md        # Hardware-Details
├── docs/
│   └── n8-vps-server-dokumentation.md  # Detail-Referenzdoku
├── stacks/
│   ├── traefik/               # Traefik Reverse Proxy Stack
│   └── authentik/             # Authentik SSO Stack (3 Services)
└── root/
    └── home/mrohwer/.config/fish/
        ├── aliases/           # Host-Aliases (110-n8-vps.fish)
        └── functions/         # Host-Functions
```

---

## Verwandte Dateien

| Bereich | Pfad |
|---------|------|
| Detail-Doku | `docs/n8-vps-server-dokumentation.md` |
| Traefik Stack | `stacks/traefik/` |
| Globale Policies | `.claude/context/` (Root) |
| Secrets | `.secrets/` (Submodule) |
| Fish Shared | `shared/etc/fish/` |
