# Hardware Info Script (hwi)

**Version:** 3.0.0
**Zweck:** Multi-Distro Hardware-Audit mit flexiblem Output

## Installation

```fish
ln -sf /mr-bytez/scripts/hwi/hwi.sh ~/.local/bin/hwi
```

## Verwendung

```fish
hwi              # Standard: ~/hostname_hardware.md
hwi -o /backup   # Custom: /backup/hostname_hardware.md
hwi mrbz         # mr-bytez: /mr-bytez/projects/infrastructure/hostname/HARDWARE.md
```

## Features v3.0.0

- Multi-Distro Support (Arch/Debian/Ubuntu/Mint)
- Flexible Output-Modi
- Erweiterte SMART-Daten (Hours/Written/Health%)
- Storage-Typen getrennt (NVMe/SSD/HDD)
- Multi-GPU Support mit Taktraten
- Health-Warnungen bei alternden/defekten Disks
