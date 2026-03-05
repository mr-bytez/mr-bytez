# n8-vps — Hardware-Details

> **Pfad:** `projects/infrastructure/n8-vps/.claude/context/hardware.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-05
> **Autor:** MR-ByteZ
> **Zweck:** Hardware-Spezifikationen des n8-vps Servers (aus hwi-Audit vom 2026-02-17)

---

## Server-Hardware

| Eigenschaft | Wert |
|-------------|------|
| **Modell** | Hetzner EX63 Dedicated Server |
| **Standort** | Falkenstein, Deutschland |
| **Mainboard** | ASRockRack W880M WS-1L |
| **Prozessor** | Intel Core Ultra 7 265 |
| **Kerne** | 20 Kerne (8P+12E, kein Hyperthreading) |
| **Taktfrequenz** | bis 4.6 GHz (Turbo) |
| **RAM** | 64 GB DDR5 5600 MT/s (2x Micron) |
| **Storage** | 2x Micron 3500 954 GB NVMe |
| **RAID** | RAID 1 (Spiegelung) |
| **GPU** | Intel Arrow Lake-S (integriert) |
| **Netzwerk** | 1 Gbit/s |

---

## LVM-Layout

| Volume | Groesse | Mountpoint |
|--------|---------|------------|
| root | 500 GB | `/` |
| home | 100 GB | `/home` |
| swap | 8 GB | swap |
| Reserve | ~353 GB | ungenutzt |

---

## Netzwerk-Adressen

| Typ | Adresse |
|-----|---------|
| **IPv4** | `136.243.101.223` |
| **IPv6** | `2a01:4f8:171:ad1::2` |
| **SSH-Port** | 61020 |
| **WireGuard-Port** | 61820/udp |

---

## Betriebssystem

- Arch Linux (vanilla slim, via Hetzner installimage)
- Kernel: Standard linux
- Init: systemd
- Shell: Fish (mr-bytez Integration)
- Locale: `en_US.UTF-8` (System), `de_DE.UTF-8` (verfuegbar)
- Timezone: `Europe/Berlin`
- Tastatur: `de-latin1-nodeadkeys`

---

**Hinweis:** Detailliertes SMART-Audit via `sudo hwi mrbz` auf dem Host erstellen.
Vollstaendiges Hardware-Audit: `projects/infrastructure/n8-vps/HARDWARE.md`
