# Hardware Info Script (hwi)

**Version:** 3.1.1
**Autor:** MR-ByteZ
**Zweck:** Multi-Distro Hardware-Audit mit flexiblem Output

## Installation

Siehe [DEPLOYMENT.md](DEPLOYMENT.md)

## Verwendung

```fish
sudo hwi              # Standard: ~/hostname_hardware.md
sudo hwi -o /backup   # Custom: /backup/hostname_hardware.md
sudo hwi mrbz         # mr-bytez: projects/infrastructure/hostname/HARDWARE.md
sudo hwi -h           # Hilfe anzeigen
```

## Features v3.1.1

- Multi-Distro Support (Arch/Debian/Ubuntu/Mint)
- Flexible Output-Modi (Standard/Custom/mr-bytez)
- Erweiterte SMART-Daten (Hours/Written/Health%/Temp/Media/Crit)
- Storage-Typen getrennt (NVMe/SSD/HDD)
- Multi-GPU Support mit Taktraten
- Health-Warnungen bei alternden/defekten Disks
- RAM-Detection mit decode-dimms Fallback inkl. Timings
- Redundante sudo-Aufrufe entfernt (Script laeuft als root)

## Voraussetzungen

- `dmidecode`, `lspci`, `smartctl`, `nvme-cli`
- Optional: `decode-dimms` (i2c-tools) fuer erweiterte RAM-Infos
- Root-Rechte (sudo)

## Repo-Pfad

```
shared/usr/local/bin/hwi/
├── README.md          # Diese Datei
├── CLAUDE.md          # KI-Context
├── CHANGELOG.md       # Historie
├── ROADMAP.md         # Planung
├── DEPLOYMENT.md      # Deployment-Guide
└── hwi.sh             # Das Script
```

## Changelog

### v3.1.1
- Redundante sudo-Aufrufe in get_ram_info() entfernt
- Parsing-Fixes fuer RAM-Typ und NVMe-Health

### v3.0.0
- Initial Multi-Distro Release
