# Deployment — Anker, Symlinks & Host-Setup

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Anker-System

Systemweit referenzieren wir **nicht direkt** `/mr-bytez`, sondern immer den stabilen Anker:

```
/opt/mr-bytez/current  →  /mr-bytez
```

**Warum?**
- `/mr-bytez` ist ein Git-Checkout (potenziell volatil)
- `/opt/mr-bytez/current` ist der **stabile Anker** für alle System-Symlinks
- Versionswechsel/Rollback: **ein Link ändern**, kein Symlink-Wildwuchs

---

## Aktive System-Symlinks

| Ziel (System) | Quelle (über Anker) | sudo |
|----------------|---------------------|------|
| `/etc/fish` | `/opt/mr-bytez/current/shared/etc/fish` | ja |
| `/usr/local/share/micro` | `/opt/mr-bytez/current/shared/usr/local/share/micro` | ja |

---

## symlinks.db

Alle deployten Symlinks sind dokumentiert in `shared/deployment/symlinks.db` (JSON-Format).

**Format:**
```json
{
  "comment": "Beschreibung",
  "target": "/system/pfad",
  "source": "/mr-bytez/repo/pfad",
  "type": "directory|file",
  "permissions": "0755",
  "owner": "root:root",
  "requires_sudo": true
}
```

**Bei neuen Deployments:**
1. Policy prüfen (darf das deployed werden?)
2. In `shared/deployment/symlinks.db` dokumentieren
3. In `DEPLOYMENT.md` dokumentieren

---

## Erlaubt / Verboten

### Erlaubt

- System-Configs via Anker-Symlink (`/etc/fish`, `/usr/local/share/micro`)
- Templates als Vorlage (z.B. `shared/home/mrohwer/.ssh/config.example`)
- Paket-Dependencies dokumentieren

### Verboten

- `~/.ssh/config` (User-State, hochsensibel) — nur Template!
- Echte Home-Dateien/State-Dateien (Browser-Profile, Session-State)
- Alles was Secrets indirekt exponieren könnte
- SSH Private Keys aus Repo deployen

> **Merksatz:** Entwickler-State ≠ Repository-State

Details zu Secrets-Policy → `.claude/context/security.md`

---

## SSH-Konfiguration

Es gibt **kein** Deployment von `~/.ssh/config` oder SSH-Keys aus dem Repo.

- Repo enthält nur: `shared/home/mrohwer/.ssh/config.example`
- Lokal kopieren und host-spezifisch anpassen
- GitHub CLI verwendet OAuth (kein SSH-Key nötig!)

---

## Paket-Dependencies

Auf jedem Host benötigt:

```fish
# Basis
sudo pacman -S fish micro git github-cli

# Clipboard-Support (PFLICHT für Micro!)
sudo pacman -S xclip

# Moderne CLI-Tools
sudo pacman -S eza bat fastfetch duf dust htop tree jq ripgrep fd
```

---

## Rollback

Rollback = Checkout wechseln + Anker neu setzen:

```fish
# Beispiel: auf alternativen Checkout wechseln
sudo ln -sfn /mr-bytez-v1_fish_micro_secrets /opt/mr-bytez/current
```

Danach zeigen alle System-Symlinks automatisch auf die neue Version.

---

## Quickstart-Referenz

Vollständiger Deployment-Guide mit 9-Schritt-Anleitung: → `DEPLOYMENT.md`
