# n8-vps — Hardware-Details

> **Pfad:** `projects/infrastructure/n8-vps/.claude/context/hardware.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Hardware-Spezifikationen des n8-vps Servers (aus Server-Doku extrahiert)

---

## Server-Hardware

| Eigenschaft | Wert |
|-------------|------|
| **Modell** | Hetzner EX63 Dedicated Server |
| **Standort** | Falkenstein, Deutschland |
| **Prozessor** | Intel Xeon E5-2650 v4 |
| **Kerne/Threads** | 12 Kerne / 24 Threads |
| **Taktfrequenz** | 2.2 GHz (Turbo: 2.9 GHz) |
| **RAM** | 128 GB DDR4 ECC |
| **Storage** | 2x 1 TB NVMe SSD |
| **RAID** | RAID 1 (Spiegelung) |
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
