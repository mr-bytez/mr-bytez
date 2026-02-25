# Deployment — Anker, Symlinks & Host-Setup

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-26
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

| Ziel (System) | Quelle (über Anker) | sudo | Methode |
|----------------|---------------------|------|---------|
| `/etc/fish` | `/opt/mr-bytez/current/shared/etc/fish` | ja | Symlink |
| `/usr/local/share/micro` | `/opt/mr-bytez/current/shared/usr/local/share/micro` | ja | Symlink |
| `/usr/local/bin/hwi` | `/opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh` | ja | Symlink |

## Secrets-Deployment (deploy.fish v2.0)

`deploy.fish` im Secrets-Repo deployt Dateien aus dem entpackten Archiv (`mrohwer/`).
Methode: **Copy** fuer alles ausser `.gitconfig` (dort **Symlink** ueber Anker).

| Ziel (System) | Quelle (Archiv) | Methode | Perms | sudo |
|----------------|-----------------|---------|-------|------|
| `~/.ssh/*` | `mrohwer/shared/` oder `infrastructure/<host>/` | Copy | 0600 (.pub: 0644) | nein |
| `~/.secrets/*` | `mrohwer/shared/` oder `infrastructure/<host>/` | Copy | 0600 | nein |
| `~/.gitconfig` | `mrohwer/shared/home/mrohwer/.gitconfig` | Symlink | — | nein |
| `/etc/hosts` | `mrohwer/infrastructure/<host>/etc/hosts` | Copy | 0644 | ja |

**Merge-Logik:** Datei-Level — Host-Datei existiert? → nimm die. Sonst → shared.

### Deployment-Workflow (Secrets)

```
1. git pull && git submodule update
2. cd /mr-bytez/.secrets/
3. fish /mr-bytez/shared/deployment/unpack-secrets.fish   # Archiv entpacken
4. fish /mr-bytez/.secrets/deploy.fish [--dry-run]        # Dateien deployen
```

---

## symlinks.db

Alle deployten Symlinks sind dokumentiert in `.secrets/deployment/symlinks.db` (JSON-Format, im privaten Submodule).

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
2. In `.secrets/deployment/symlinks.db` dokumentieren
3. In `DEPLOYMENT.md` dokumentieren

---

## Erlaubt / Verboten

### Erlaubt

- System-Configs via Anker-Symlink (`/etc/fish`, `/usr/local/share/micro`)
- Templates als Vorlage (z.B. `shared/home/mrohwer/.ssh/config.example`)
- Paket-Dependencies dokumentieren

### Verboten

- Echte Home-Dateien/State-Dateien (Browser-Profile, Session-State)
- Alles was Secrets indirekt exponieren koennte
- SSH Private Keys aus dem PUBLIC Repo deployen

> **Merksatz:** Entwickler-State ≠ Repository-State

Details zu Secrets-Policy → `.claude/context/security.md`

---

## SSH-Konfiguration

SSH-Config und SSH-Keys werden ueber das **private Secrets-Repo** deployt (nicht aus dem public Repo).
Deployment via `deploy.fish v2.0` (Copy-Methode, nicht Symlink).

- Gemeinsame SSH-Config: `.secrets/mrohwer/shared/home/mrohwer/.ssh/config`
- Host-spezifische Keys: `.secrets/mrohwer/infrastructure/<hostname>/home/mrohwer/.ssh/`
- Sanitized Template bleibt im Public Repo: `shared/home/mrohwer/.ssh/config.example`
- GitHub CLI verwendet OAuth (kein SSH-Key noetig!)

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

## Hinweis: pacman -Syu und Fish

Nach einem System-Update (`pacman -Syu`) kann Fish aktualisiert werden.
Dabei wird `/etc/fish/conf.d/` moeglicherweise geleert oder ueberschrieben.

**Nach jedem `pacman -Syu` pruefen:**

```fish
ls -la /etc/fish
# Muss Symlink sein: /etc/fish -> /opt/mr-bytez/current/shared/etc/fish
```

Falls nicht mehr korrekt → Symlink neu setzen (siehe `DEPLOYMENT.md` Troubleshooting).

---

## Quickstart-Referenz

Vollständiger Deployment-Guide mit 9-Schritt-Anleitung: → `DEPLOYMENT.md`
