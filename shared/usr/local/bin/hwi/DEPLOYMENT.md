# Deployment - hwi

**Aktualisiert:** 2026-02-17

---

## Symlink erstellen (ueber Anker)

```fish
sudo ln -sf /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh /usr/local/bin/hwi
```

## Verifizierung

```fish
which hwi
# Erwartet: /usr/local/bin/hwi

ls -la /usr/local/bin/hwi
# Erwartet: /usr/local/bin/hwi -> /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh

sudo hwi -h
# Sollte Hilfe anzeigen
```

## Voraussetzungen installieren

### Arch Linux

```fish
sudo pacman -S dmidecode smartmontools nvme-cli i2c-tools
```

### Debian/Ubuntu

```fish
sudo apt install dmidecode smartmontools nvme-cli i2c-tools
```

## Hosts

| Host | Status | Symlink-Ziel |
|------|--------|--------------|
| n8-kiste | ✅ Deployed | `/usr/local/bin/hwi` → Anker |
| n8-station | ✅ Deployed | `/usr/local/bin/hwi` → Anker |
| n8-archstick | 🔲 Noch zu deployen | `/usr/local/bin/hwi` → Anker |

## Nach Host-Deployment: Hardware-Audit

Nach jedem Deployment auf einem neuen Host einmal ausfuehren:

```fish
sudo hwi mrbz
# Erzeugt: /mr-bytez/projects/infrastructure/<hostname>/HARDWARE.md
```

> **HARDWARE.md ist gitignored!** Die Datei enthaelt sensible Hardware-Details
> und bleibt nur lokal auf dem Host. Sie kann von Claude Code (lokal) gelesen
> werden, aber NICHT von Claude.ai. Siehe `.gitignore` im Root.

## Hinweise

- Script benoetigt Root-Rechte (`sudo hwi`)
- Symlink geht ueber den stabilen Anker `/opt/mr-bytez/current/`
- Updates via `git pull` automatisch verfuegbar
- Rollback: Anker aendern, hwi-Version aendert sich automatisch mit
- Bestehende Symlinks auf n8-kiste und n8-station muessen auf den Anker-Pfad aktualisiert werden!
