# Deployment - hwi

## Symlink erstellen
```fish
sudo ln -sf /mr-bytez/scripts/hwi/hwi.sh /usr/local/bin/hwi
```

## Verifizierung
```fish
which hwi
# Erwartet: /usr/local/bin/hwi

ls -la /usr/local/bin/hwi
# Erwartet: /usr/local/bin/hwi -> /mr-bytez/scripts/hwi/hwi.sh

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

| Host | Status | Pfad |
|------|--------|------|
| n8-station | ✅ Deployed | `/usr/local/bin/hwi` |
| n8-kiste | ✅ Deployed | `/usr/local/bin/hwi` |

## Hinweise

- Script benötigt Root-Rechte (`sudo hwi`)
- Symlink zeigt auf `/mr-bytez/scripts/hwi/hwi.sh`
- Updates via `git pull` automatisch verfügbar
