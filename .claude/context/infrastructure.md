# Infrastructure — Hosts, Netzwerk & Locations

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-25
**Autor:** MR-ByteZ

---

## ⚠️ Sanitization aktiv

Dieses Dokument verwendet die **Sanitization Matrix** aus `.claude/context/security.md`.
Echte Hostnamen, IPs und User werden durch sanitized Werte ersetzt.

---

## Hosts Matrix

| Hostname | Typ | Prozessor | RAM | Rolle |
|----------|-----|-----------|-----|-------|
| host-dev | 🖥️ Physisch | i7-12700K | 64GB | Development & Storage Server |
| host-vps | 🖥️ Physisch | E5-2650v4 | 128GB | Hetzner EX63, Production Server |
| host-station | 🖥️ Physisch | - | - | Workstation |
| host-book | 💻 Physisch | - | - | Mobile Workstation (Laptop) |
| host-bookchen | 💻 Physisch | - | - | Small Laptop |
| host-maxx | 🎮 Physisch | - | - | Gaming/Specialized |
| host-broker | 📈 Physisch | - | - | Trading/Specialized |
| host-archstick | 🔌 Physisch | - | - | Portable USB Arch Linux |
| container-dev | 🐳 Container | (host-dev) | 8GB | Claude Dev Container |

---

## Netzwerk

### SSH

- SSH-Ports sind **host-spezifisch** (nicht einheitlich!):
  - n8-kiste: **61022**
  - n8-vps: **61020**
  - n8-station: **63022**
  - Weitere Hosts: noch nicht konfiguriert
- Auth: Key-basiert
- GitHub CLI: OAuth (kein SSH-Key noetig)
- SSH-Config: via Secrets-Repo (`.secrets/mrohwer/shared/home/mrohwer/.ssh/config`)
- Codeberg SSH: `AddressFamily inet` gesetzt (IPv6-Problem auf n8-vps)

### Secrets-Deployment Status

| Host | Archiv entpackt | deploy.fish | SSH verifiziert | Dual-Remote |
|------|----------------|-------------|-----------------|-------------|
| n8-kiste | ✅ | ✅ | ✅ | ✅ (origin+codeberg) |
| n8-vps | ✅ | ✅ | ✅ | ✅ (origin+codeberg) |
| n8-station | ✅ | ✅ | ✅ | ✅ (origin+codeberg) |

### WireGuard VPN

- Verbindet alle Hosts untereinander
- Ermöglicht sichere Remote-Verwaltung

### DNS

- AdGuard DNS für Filterung
- Lokale Auflösung über /etc/hosts oder AdGuard Rewrites

---

## Docker-Netzwerke (Geplant)

| Netzwerk | Subnet | Zweck |
|----------|--------|-------|
| mrbz-dev-net | 172.30.0.0/24 | Development Stack |
| mrbz-proxy-net | - | Traefik Reverse Proxy |

---

## Projekt-Locations

| Projekt | Pfad |
|---------|------|
| host-dev Config | `projects/infrastructure/n8-kiste/` |
| host-vps Config | `projects/infrastructure/n8-vps/` |
| container-dev Stack | `shared/stacks/mrbz-dev/` ⭐ NICHT in projects/ |
| MCP Server | `projects/infrastructure/mcp-server/` |
| Shared Configs | `shared/etc/fish/`, `shared/usr/local/share/micro/` |
| Secrets | `.secrets/` (Submodule, Repo-Root) |
| Scripts | `shared/usr/local/bin/` (hwi) |

---

## Host-spezifische Fish Config Pfade

```
projects/infrastructure/<hostname>/root/home/<user>/.config/fish/
├── conf.d/      # Host conf.d (zukunftssicher, aktuell leer)
├── aliases/     # Host Aliases (100-200, z.B. 110-n8-*.fish)
├── variables/   # Host Variables (zukunftssicher, aktuell leer)
└── functions/   # Host Functions (Vorrang vor shared)
```

Der Fish Loader erkennt den Host via `hostname` und lädt automatisch die passenden Configs.

---

## Deployment-Status

| Host | mr-bytez | Fish | Micro | Anker | Claude Code |
|------|----------|------|-------|-------|-------------|
| host-dev | ✅ | ✅ | ✅ | ✅ | ✅ |
| host-vps | ✅ | ✅ | ✅ | ✅ | ❌ |
| host-station | ✅ | ✅ | ✅ | ✅ | ❌ |
| host-book | ✅ | ✅ | ✅ | ✅ | ❌ |
| host-bookchen | ✅ | ✅ | ✅ | ✅ | ❌ |
| host-archstick | ✅ | ✅ | ✅ | ✅ | ❌ |
| host-maxx | ❓ | ❓ | ❓ | ❓ | ❌ |
| host-broker | ❓ | ❓ | ❓ | ❓ | ❌ |
