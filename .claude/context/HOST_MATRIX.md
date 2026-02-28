# Host-Matrix — Fish Feature-Flags

> **Pfad:** `.claude/context/HOST_MATRIX.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-28
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ
> **Zweck:** Alle 8 Hosts mit Feature-Flags und Deployment-Status

---

## Host-Matrix

| Host | MR_HAS_GUI | MR_IS_DEV | MR_DISPLAY_TYPE | Deployed |
|------|------------|-----------|-----------------|----------|
| n8-kiste | true | true | 4k | ✅ |
| n8-station | true | true | 4k | ✅ |
| n8-book | true | true | 1920 | ✅ |
| n8-vps | false | true | headless | ✅ |
| n8-maxx | true | false | 4k | teilweise |
| n8-bookchen | true | false | 1920 | teilweise |
| n8-broker | true | false | 4k | teilweise |
| n8-archstick | true | false | 1920 | ✅ |

## Paket-Zuordnung

| Host | min | desktop | dev |
|------|-----|---------|-----|
| n8-kiste | ✅ | ✅ | ✅ |
| n8-station | ✅ | ✅ | ✅ |
| n8-book | ✅ | ✅ | ✅ |
| n8-vps | ✅ | ❌ | ✅ |
| n8-maxx | ✅ | ✅ | ❌ |
| n8-bookchen | ✅ | ✅ | ❌ |
| n8-broker | ✅ | ✅ | ❌ |
| n8-archstick | ✅ | ✅ | ❌ |

## Fehlende Pakete (Pre-Flight)

| Host | Fehlend |
|------|---------|
| n8-vps | duf, dust, htop, ripgrep, less |
| n8-station | docker-buildx, lazydocker, nodejs, npm, ncdu |

## Host-Pfade im Repo

```
projects/infrastructure/<host>/root/home/mrohwer/.config/fish/
```

Jeder Host hat dort:
- `aliases/` — Host-spezifische Aliases (110-n8-*.fish)
- `variables/` — wird nach Migration in 008-host-flags.fish konsolidiert
- `functions/` — Host-Test-Funktion

## Referenzen

- Architektur: `.claude/context/ARCHITEKTUR.md`
- Infrastruktur: `.claude/context/infrastructure.md`
