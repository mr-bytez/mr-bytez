# REPORT: Host-Config & Application-Data Inventur

**Datum:** 2026-02-26
**Hosts:** n8-kiste (Desktop/Server), n8-station (Desktop), n8-vps (VPS)
**Status:** READ-ONLY Audit — keine Aenderungen durchgefuehrt

---

## 1. Zusammenfassung

| Bereich | n8-kiste | n8-station | n8-vps |
|---------|----------|------------|--------|
| Thunderbird | 1,8G / ~100 Konten | 12G / 52 Konten | - |
| Messenger | Telegram 153M, ZapZap 435M | Telegram 79M | - |
| KDE | 10 Configs + Wallet 16K | 6 Configs + Wallet 68K | - |
| VS Code | 323M / 14 Extensions | 421M / 73 Extensions | - |
| Browser | Brave 944M, Edge 744M, Chromium 8M | Brave 389M, Edge 773M, Chromium 447M | - |
| Docker | 3 Stacks aktiv | - | 0 Stacks |
| SSH Keys | 14 Keys, 4 authorized | 10 Keys | 4 Keys, 1 authorized |
| Flatpak | 3 Apps (741M Daten) | 14 Apps (12,5G Daten) | - |
| Systemd User | rclone-gdrive | 3x rclone | - |
| System-Timers | 8 | - | 3 |
| Custom Systemd | cloudflared, rustdesk | - | - |
| Samba | 7 Shares | - | - |
| DNS/Unbound | 417 Zeilen | - | 1427 Zeilen |
| PostgreSQL | - | - | aktiv |
| Valkey | - | - | aktiv |
| fail2ban | - | - | **INAKTIV!** |

---

## 2. E-Mail & Kommunikation

### Thunderbird

| | n8-kiste | n8-station |
|--|----------|------------|
| Profil | `eze0y4hk.default-release` | `yrsnory7.default-release` |
| Groesse | 1,8G | 12G |
| Konten | ~100 | 52 |
| prefs.js | 29K (25.02.) | 12K (05.02.) |
| logins.json | 9,7K | 5,8K |
| key4.db | 295K | 295K |
| cert9.db | 229K | 229K |
| abook.sqlite | 262K | 262K |

**Bewertung:** BACKUP (zu gross fuers Repo) + SECRETS (logins.json, key4.db)

### Messenger

| App | n8-kiste | n8-station |
|-----|----------|------------|
| Telegram (Flatpak) | 153M | 79M |
| ZapZap (Flatpak) | 435M | - |
| Signal | - | - |

**Bewertung:** SKIP (Cloud-Sync, regenerierbar)

---

## 3. KDE / Desktop

### n8-kiste — KDE Configs

| Datei | Zeilen | Beschreibung |
|-------|--------|-------------|
| kglobalshortcutsrc | 328 | Globale Tastenkuerzel |
| kdeglobals | 175 | KDE Grundeinstellungen |
| kwinrc | 92 | Fenstermanager |
| plasma-org.kde.plasma.desktop-appletsrc | 306 | Desktop-Widgets/Panel |
| plasmashellrc | 11 | Plasma Shell |
| dolphinrc | 22 | Dateimanager |
| konsolerc | 23 | Terminal |
| kscreenlockerrc | 10 | Bildschirmsperre |
| powerdevilrc | 22 | Energieverwaltung |
| baloofilerc | 4 | Datei-Indexierung |

Weitere: kded5rc, kded6rc, kwinrulesrc, plasma-localerc, plasmanotifyrc, plasma-welcomerc
KDE Wallet: 16K (`~/.local/share/kwalletd/` — kdewallet.kwl, kdewallet_attributes.json, kdewallet.salt)
Autostart: keine
Themes/Icons: hicolor (Standard), keine Custom-Fonts

### n8-station — KDE Configs

| Datei | Status |
|-------|--------|
| kglobalshortcutsrc | EXISTS |
| kdeglobals | EXISTS |
| kwinrc | EXISTS |
| dolphinrc | EXISTS |
| konsolerc | EXISTS |
| plasmashellrc | EXISTS |

KDE Wallet: 68K
Autostart: `remmina-applet.desktop`

### Konsole Profile

| | n8-kiste | n8-station |
|--|----------|------------|
| Profil 1 | mrohwer (FiraCode Nerd Font 11pt) | Schriftart (FiraCode Nerd Font Mono 12pt) |
| Profil 2 | Schriftart (FiraCode Nerd Font Mono 12pt) | - |
| Bookmarks | bookmarks.xml + .bak | bookmarks.xml + .bak |

### Dolphin

| | n8-kiste | n8-station |
|--|----------|------------|
| Bookmarks (user-places.xbel) | 46 | 70 |

**Bewertung:** REPO (klein genug, versionierbar)

---

## 4. Entwicklungs-Tools

### VS Code

| | n8-kiste | n8-station |
|--|----------|------------|
| Groesse | 323M | 421M |
| Extensions | 14 | 73 |
| settings.json | 169 Bytes | vorhanden |
| keybindings.json | fehlt | - |

**n8-kiste Extensions (14):**
- markdownlint, containers, language-pack-de, debugpy, python, pylance, python-envs
- makefile-tools, remote-explorer, remote-containers, remote-ssh, remote-ssh-edit
- chatgpt (OpenAI), markdown-all-in-one

**n8-station Extensions (73):**
- **Web:** eslint, prettier, tailwindcss, html-css, vetur, volar, vue-snippets, react-snippets, jinja
- **PHP:** intelephense, composer, profiler, xdebug, php-pack, php-intellisense
- **Python:** python, pylance, debugpy, python-envs, autodocstring, python-indent
- **Go:** golang.go
- **Dart/Flutter:** dart-code, flutter
- **Git:** githistory, git-graph, gitignore, github-copilot, copilot-chat, vscode-pull-request-github
- **Remote:** remote-ssh, remote-containers, remote-explorer, remote-repositories, azure-repos, codespaces
- **Sonstiges:** live-server, rest-client, code-runner, todo-tree, pdf, errorlens, rainbow-csv, icons, bookmarks, project-manager, cmake-tools, java-debug, xml, yaml, dotenv

### Git Config (identisch auf allen 3 Hosts)

```
user.name = Michael Rohwer
user.email = mrohwer@mr-bytez.de
init.defaultBranch = main
core.editor = micro
push.default = current / autoSetupRemote = true
pull.rebase = true
alias.lg = log --oneline --graph --decorate
```

**Bewertung:** REPO (settings.json, Extensions-Liste als Textdatei)

### NPM Global

| | n8-kiste | n8-vps |
|--|----------|--------|
| @modelcontextprotocol/server-github | ja | nein |
| node-gyp | ja | ja |
| npm | ja | ja |
| semver | ja | ja |

### Claude Code

n8-kiste: `~/.claude/` mit paste-cache (20 Dateien), history.jsonl, shell-snapshots, todos (7), debug (1)
Credentials: **FEHLT** (kein `.credentials` File)

**Bewertung:** SKIP (Session-Daten, regenerierbar)

---

## 5. Browser

### n8-kiste (native Installationen)

| Browser | Groesse | Bookmarks | Extensions |
|---------|---------|-----------|------------|
| Brave | 944M | 138 | 5 |
| Microsoft Edge | 744M | **4620** | 22 |
| Chromium | 8M | - | - |

### n8-station (3 native + 8 Flatpak Browser)

| Browser | Groesse | Typ |
|---------|---------|-----|
| Microsoft Edge | 773M | nativ |
| Chromium | 447M | nativ |
| Brave | 389M | nativ |
| Firefox | ~0 (Flatpak Daten) | Flatpak |
| Waterfox | ~0 | Flatpak |
| LibreWolf | ~0 | Flatpak |
| ungoogled-chromium | ~0 | Flatpak |
| Chrome | ~0 | Flatpak |
| Chrome Dev | ~0 | Flatpak |

**Bewertung:**
- Bookmarks: BACKUP (Edge mit 4620 Bookmarks! Export als HTML)
- Extensions: REPO (Liste als Textdatei)
- Profile: SKIP (zu gross, regenerierbar)

---

## 6. System-Konfigurationen

### /etc Configs

| Datei | n8-kiste | n8-station | n8-vps |
|-------|----------|------------|--------|
| fstab | 110 Z. | 11 Z. | ja |
| hosts | 16 Z. | 12 Z. | ja |
| hostname | 1 Z. | 1 Z. | ja |
| locale.conf | 1 Z. | 1 Z. | ja |
| vconsole.conf | 2 Z. | - | - |
| mkinitcpio.conf | 16 Z. | 81 Z. | ja |
| pacman.conf | 100 Z. | 100 Z. | ja |
| makepkg.conf | 168 Z. | - | - |
| samba/smb.conf | 146 Z. | - | - |
| nftables.conf | 26 Z. | - | - |
| ufw/ufw.conf | 10 Z. | - | ja |
| wireguard/ | - | - | ja (leer?) |

### sysctl.d (n8-kiste)

- `99-ipv6-disable.conf`
- `99-valkey.conf`

### Systemd Custom (n8-kiste)

| Unit | Beschreibung |
|------|-------------|
| cloudflared.service | Cloudflare Tunnel |
| cloudflared-update.service | Auto-Update |
| cloudflared-update.timer | Timer dafuer |
| rustdesk.service | Remote Desktop |

### Systemd User Units

| | n8-kiste | n8-station |
|--|----------|------------|
| rclone-gdrive | ja | rclone-googleDrive |
| - | - | rclone-oneDrive-Business |
| - | - | rclone-oneDrive-privat |
| wireplumber | ja (enabled) | - |
| pipewire | ja (enabled) | - |

### Timers (n8-kiste: 8 aktiv)

certbot-renew, man-db, etckeeper, systemd-tmpfiles-clean, shadow, logrotate, archlinux-keyring-wkd-sync, fstrim

### Timers (n8-vps: 3 aktiv)

systemd-tmpfiles-clean, shadow, archlinux-keyring-wkd-sync

### DNS / Netzwerk

| | n8-kiste | n8-station | n8-vps |
|--|----------|------------|--------|
| DNS | 10.10.10.1 | 10.10.10.1 (via NM) | 127.0.0.1 (Unbound) |
| Unbound | 417 Zeilen | - | 1427 Zeilen |
| NM connections | keine | nicht vorhanden | - |

**Bewertung:** REPO (alle /etc Configs, Systemd Units)

---

## 7. Anwendungsdaten

### SSH Keys

| Key | n8-kiste | n8-station | n8-vps |
|-----|----------|------------|--------|
| id_ed25519 (Haupt) | ja | ja | - |
| id_ed25519_codeberg | ja | ja | ja |
| id_ed25519_github | ja | ja | ja |
| id_ed25519_forgejo | ja | ja | - |
| id_ed25519_tinyssh_unlock | ja | - | - |
| id_ed25519_timme_grills | Symlink | - | - |
| id_ed25519_timme_xinro | Symlink | - | - |
| authorized_keys | 4 Eintraege | vorhanden + .bak | 1 Eintrag |
| config | ja + .bak | ja + .bak | ja + .bak |
| config.symlink.bak | ja (alter Symlink) | - | - |

**Bewertung:** SECRETS (private Keys + config im Secrets-Repo)

### Samba (nur n8-kiste)

7 Shares auf Interface 10.10.10.1:

| Share | Pfad | Beschreibung |
|-------|------|-------------|
| videos-series | /media/videos/series | Jellyfin Serien (20TB) |
| videos-movies | /media/videos/movies | Jellyfin Filme (12TB) |
| videos-tmp | /media/videos/tmp | Video-Sortierung (PRIVAT, 0700!) |
| jdown | /srv/jdownloader/ | JDownloader |
| music | /media/music | Musik (2TB) |
| immich | /media/immich | Immich Photos (8TB) |
| sort | /media/sort | Allg. Sortierung (2TB) |
| media | /srv/samba/media | Read-Only fuer User "media" |

**Bewertung:** REPO (smb.conf bereits unter /etc)

### Docker (n8-kiste)

| Stack | Status | Compose-Pfad |
|-------|--------|-------------|
| grills-reduziert.de | running(3) | `/mr-bytez/projects/web/grills-reduziert.de/docker/` |
| portainer | running(1) | `/srv/docker/portainer/` |
| watchtower | running(1) | `/srv/docker/watchtower/` |

### Docker Compose ausserhalb Repo (n8-kiste)

- /srv/docker/watchtower/
- /srv/docker/xray/
- /srv/docker/plex/
- /srv/docker/jellyfin/
- /srv/docker/portainer/
- /srv/docker/codex/
- /srv/docker/authentik/
- /srv/docker/nextcloud/
- /srv/authentik_bak/

**Bewertung:** REPO (docker-compose.yml Dateien) + SECRETS (env-Dateien mit Credentials)

### Dienste (n8-vps)

| Dienst | Status |
|--------|--------|
| PostgreSQL | **aktiv** |
| Valkey | **aktiv** |
| fail2ban | **INAKTIV!** |
| WireGuard | Verzeichnis existiert |
| Unbound | 1427 Zeilen Config |

---

## 8. Flatpak-Daten

### n8-kiste (11 Flatpak-Apps, ~3G Daten)

| App | Daten |
|-----|-------|
| Spotify | 2,3G |
| ZapZap | 435M |
| JDownloader | 184M |
| Telegram | 153M |
| Chromium | 24K |
| ungoogled-chromium | 24K |
| Chrome Dev | 24K |
| Chrome | 24K |
| Firefox | 20K |
| Waterfox | 20K |
| LibreWolf | 20K |

### n8-station (14 Apps, ~12,5G Daten)

| App | Daten |
|-----|-------|
| Spotify | **12G** |
| Thunderbird | 251M |
| JDownloader | 97M |
| Telegram | 79M |
| Mailspring | 17M |
| Evolution | 3,3M |
| Kontact | 2,3M |
| 7x Browser-Flatpaks | je 20-24K |

**Bewertung:** SKIP (Cloud-Sync, Cache-Daten)

---

## 9. Bewertungs-Matrix

### REPO (versionierbar, ins Hauptrepo)

| Was | Host | Pfad |
|-----|------|------|
| KDE Configs (10 Dateien) | n8-kiste | `~/.config/k*`, `~/.config/plasma*` |
| KDE Configs (6 Dateien) | n8-station | `~/.config/k*`, `~/.config/plasma*` |
| Konsole Profile | beide | `~/.local/share/konsole/` |
| Dolphin Places | beide | `~/.local/share/user-places.xbel` |
| VS Code settings.json | beide | `~/.config/Code/User/settings.json` |
| VS Code Extensions-Liste | beide | `code --list-extensions` → Textdatei |
| Git Config | alle 3 | `~/.gitconfig` |
| /etc Configs | alle 3 | diverse (fstab, hosts, pacman.conf, ...) |
| Samba Config | n8-kiste | `/etc/samba/smb.conf` |
| Unbound Config | n8-kiste, n8-vps | `/etc/unbound/unbound.conf` |
| Systemd Units | n8-kiste | cloudflared, rustdesk Services |
| Systemd User Units | beide | rclone-*.service |
| sysctl.d Configs | n8-kiste | `/etc/sysctl.d/` |
| Docker Compose Files | n8-kiste | `/srv/docker/*/docker-compose.yml` |
| NPM Global Liste | n8-kiste | `npm list -g` → Textdatei |
| Autostart | n8-station | `~/.config/autostart/` |

### SECRETS (ins Secrets-Repo, Age-verschluesselt)

| Was | Host | Pfad |
|-----|------|------|
| SSH Private Keys | alle 3 | `~/.ssh/id_ed25519*` |
| SSH Config | alle 3 | `~/.ssh/config` |
| SSH authorized_keys | alle 3 | `~/.ssh/authorized_keys` |
| KDE Wallet | beide Desktop | `~/.local/share/kwalletd/` |
| Thunderbird logins.json | beide Desktop | `~/.thunderbird/*/logins.json` |
| Thunderbird key4.db | beide Desktop | `~/.thunderbird/*/key4.db` |
| Docker .env Files | n8-kiste | `/srv/docker/*/.env` |

### BACKUP (zu gross fuers Repo, separates Backup)

| Was | Host | Groesse | Pfad |
|-----|------|---------|------|
| Thunderbird Profil | n8-kiste | 1,8G | `~/.thunderbird/` |
| Thunderbird Profil | n8-station | 12G | `~/.thunderbird/` |
| Edge Bookmarks | n8-kiste | - | Export als HTML (4620 Bookmarks!) |
| Brave Bookmarks | n8-kiste | - | Export als HTML (138 Bookmarks) |
| Browser Profile | beide | ~2-3G | `~/.config/Brave*/`, `~/.config/microsoft-edge/` |

### SKIP (regenerierbar, kein Backup noetig)

| Was | Grund |
|-----|-------|
| Telegram/ZapZap Daten | Cloud-Sync |
| Spotify Daten | Cloud-Sync (n8-station 12G Cache!) |
| VS Code Extensions-Cache | Reinstallierbar aus Liste |
| Claude Code Session-Daten | Temporaer |
| Flatpak Browser-Daten | Regenerierbar |
| Chromium Profile (8M) | Kaum genutzt |

---

## 10. Empfehlungen

### Sofort-Massnahmen

1. **fail2ban auf n8-vps aktivieren!** — Aktuell INAKTIV auf einem oeffentlichen VPS
2. **Edge Bookmarks exportieren** — 4620 Bookmarks ohne Backup
3. **Spotify Cache auf n8-station pruefen** — 12G Flatpak-Daten ist ungewoehnlich

### Repo-Integration (naechste Schritte)

1. **KDE Configs** → `projects/infrastructure/n8-kiste/root/home/mrohwer/.config/` (analog zu Fish)
2. **Konsole Profile** → `shared/home/mrohwer/.local/share/konsole/` oder host-spezifisch
3. **/etc Configs** → Bereits teilweise im Repo, fehlende ergaenzen (sysctl.d, nftables.conf)
4. **VS Code** → Extensions-Liste + settings.json ins Repo, ggf. shared
5. **Docker Compose** → `/srv/docker/` Stacks die NICHT im Repo sind inventarisieren
6. **Systemd Units** → cloudflared, rustdesk, rclone ins Repo aufnehmen
7. **NPM Global** → Liste als Referenz im Repo

### Secrets-Ergaenzung

1. SSH Keys + Configs → pruefen ob vollstaendig im `.secrets/` Submodule
2. KDE Wallet → ins Secrets-Repo aufnehmen
3. Thunderbird Credentials (logins.json, key4.db) → ins Secrets-Repo
4. Docker .env Files → pruefen ob vollstaendig

### Backup-Strategie (ausserhalb Repo)

1. **Thunderbird Vollbackup:** Regelmaessig (rsync/borg) — n8-kiste 1,8G, n8-station 12G
2. **Browser-Bookmarks:** Export-Script als Cron/Timer
3. **PostgreSQL (n8-vps):** pg_dump als Timer einrichten

---

## 11. Delta: Bereits im Repo vs. Fehlend

### Bereits im Repo (vollstaendig)

- Fish Shell Configs (shared + host-spezifisch)
- Git Config (als `.gitconfig` Template)
- SSH Config (im Secrets-Repo)
- Deployment Scripts

### Teilweise im Repo

- /etc Configs (hostname, hosts — aber fstab, pacman.conf, mkinitcpio.conf fehlen teilweise)
- Docker Stacks (grills-reduziert.de ja, /srv/docker/* Stacks fehlen)

### Komplett fehlend

- KDE/Plasma Configs
- Konsole Profile + Bookmarks
- Dolphin Places (user-places.xbel)
- VS Code settings.json + Extensions-Liste
- Systemd Custom Units (cloudflared, rustdesk)
- Systemd User Units (rclone-*)
- sysctl.d Configs
- nftables.conf
- Unbound Config (417/1427 Zeilen)
- Samba Config
- NPM Global Paketliste
- Autostart-Eintraege
- KDE Wallet (Secrets)
- Thunderbird Credentials (Secrets)
- Docker .env Files (Secrets)

---

**Hinweis:** Groessen-Daten fuer n8-station wurden mit `command du` nachgemessen (initiale Messung war durch `du`→`dust` Alias verfaelscht).
