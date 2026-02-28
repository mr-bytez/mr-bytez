# Fish Shell — Deployment

> **Pfad:** `shared/etc/fish/DEPLOYMENT.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-28
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ
> **Zweck:** Deployment-Anleitung fuer Fish-Konfiguration auf alle Hosts

---

## Deployment-Pfade

| Quelle (Repo) | Ziel (Host) |
|----------------|-------------|
| `shared/etc/fish/` | `/etc/fish/` (Symlink via Anker) |
| `projects/infrastructure/<host>/root/home/mrohwer/.config/fish/` | `~/.config/fish/` |

## Anker-System

Das Repo wird ueber den stabilen Anker `/opt/mr-bytez/current` bereitgestellt.
Symlinks zeigen auf den Anker, nie direkt auf `/mr-bytez`.

```
/etc/fish → /opt/mr-bytez/current/shared/etc/fish
```

## Lade-Reihenfolge

Der Loader (`000-loader.fish`) laedt alle Dateien in einer einzigen Schleife,
numerisch sortiert von 000 bis 200:

```
000-loader.fish → 005-theme.fish → 008-host-flags.fish
→ 010-nav.fish → 015-eza.fish → ... → 045-misc.fish
→ 050-gui.fish (prueft MR_HAS_GUI) → 055-dev.fish (prueft MR_IS_DEV)
→ 110-n8-*.fish (host-spezifisch)
```

## Voraussetzungen

Vor dem Deployment auf einem Host:
1. Pakete aus `shared/packages/min-packages.txt` installieren
2. Bei GUI-Hosts: `shared/packages/desktop-packages.txt`
3. Bei Dev-Hosts: `shared/packages/dev-packages.txt`
4. `/etc/fish` Symlink pruefen nach `pacman -Syu`

## Deployment-Schritte

1. Repo aktualisieren: `git pull` auf dem Host
2. Anker pruefen: `ls -la /opt/mr-bytez/current`
3. Symlink pruefen: `ls -la /etc/fish`
4. Shell neu laden: `exec fish`
5. Validierung: `echo $MR_HAS_GUI $MR_IS_DEV $MR_DISPLAY_TYPE`

## Referenzen

- Deployment-Policies: `.claude/context/deployment.md`
- Infrastruktur: `.claude/context/infrastructure.md`
