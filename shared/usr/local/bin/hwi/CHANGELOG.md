# CHANGELOG — hwi

Alle nennenswerten Aenderungen am hwi-Script.

---

## [3.1.1] - 2026-02-17

### Changed
- [Structure] Script verschoben: `scripts/hwi/` → `shared/usr/local/bin/hwi/`
  - Spiegelt Linux-Verzeichnisstruktur (`/usr/local/bin/`)
  - Konsistent mit `shared/etc/fish/` und `shared/usr/local/share/micro/`
- [Deploy] Symlink nutzt jetzt den stabilen Anker `/opt/mr-bytez/current/`
  - Alt: `/mr-bytez/scripts/hwi/hwi.sh`
  - Neu: `/opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh`
- [Docs] 5-3-3 Docs vervollstaendigt (CLAUDE.md, CHANGELOG.md, ROADMAP.md)

---

## [3.1.0] - 2026-02-07

### Fixed
- Redundante sudo-Aufrufe in get_ram_info() entfernt
- Parsing-Fixes fuer RAM-Typ und NVMe-Health

---

## [3.0.0] - 2026-02-07

### Added
- Initial Multi-Distro Release (Arch/Debian/Ubuntu/Mint)
- Flexible Output-Modi (Standard/Custom/mr-bytez)
- Erweiterte SMART-Daten
- Multi-GPU Support
- Health-Warnungen
- RAM-Detection mit decode-dimms Fallback
