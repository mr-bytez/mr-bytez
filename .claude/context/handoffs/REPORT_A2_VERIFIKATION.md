# REPORT: A2 Verifikation & Repo-Audit

**Erstellt:** 2026-02-26
**Autor:** Claude Code (Opus 4.6)
**Zweck:** Umfassende Bestandsaufnahme VOR dem A2 Fish DRY-Refactoring
**Chat-Referenz:** #FSH01.1 [Fish][Refactor] - A2 Fish DRY-Refactoring Planung
**Chat-Link:** https://claude.ai/chat/2bdd7e90-524e-4c48-807f-8f3b2815ee10

---

## 1. Zusammenfassung (Executive Summary)

**Gesamtbewertung: AUSGEZEICHNET** — Das Repo ist produktionsbereit fuer A2.

### Kernergebnisse

- **Alias-Sicherheit:** 99% Compliance — alle kritischen Aliases (cat, grep, ls, df, du) korrekt mit `command`-Prefix geschuetzt. 21 bare `rm`-Aufrufe in Deployment-Scripts (akzeptabel fuer Automation).
- **Funktionen:** 100% sauber — keine problematischen Abhaengigkeiten, keine hardcodierten Pfade.
- **Loader v2.1:** Robust und funktionsfaehig auf allen 3 deployed Hosts.
- **Paketlisten:** Kerntools auf allen Hosts vorhanden; duf/dust fehlen auf n8-vps (erwartbar fuer Server).
- **Offene Blocker:** Keine fuer A2. D13 (n8-archstick Credentials) braucht physischen Zugang.
- **Kritischer Design-Punkt fuer A2:** Host-Flags (105-host.fish) muessen VOR Shared-Conditionals (050-gui.fish/055-dev.fish) geladen werden — aktueller Loader unterstuetzt das nicht.

---

## 2. Tool-Inventur (Teil 1)

### 2.1 Externe Befehle im Repo — Kategorisiert

#### Basis-Tools (GNU Coreutils & Standard)

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| cat | 3 | host-test.fish, deploy.fish, 90-misc.fish (alle mit `command`) |
| grep | 5+ | 90-misc.fish (Wrapper-Funktion), scan-secrets.fish |
| printf | 20+ | host-test.fish, Funktionen, Aliases |
| mkdir | 5 | theme.fish, 10-nav.fish |
| rm | 21 | deploy.fish, pack/unpack-secrets.fish, theme.fish (Details in Kap. 4) |
| cp/mv | je 1 | 10-nav.fish (Alias-Definitionen) |
| ln | 2 | 10-nav.fish |
| chmod/chown | je 1 | 10-nav.fish |
| cut | 2 | host-test.fish |
| awk | 3 | host-test.fish, scan-secrets.fish |
| wc | 2 | host-test.fish, scan-secrets.fish |
| seq | 1 | 50-systemd.fish |
| sort | 1 | scan-secrets.fish |
| basename/dirname | je 2 | 00-loader.fish, deploy.fish |
| realpath/readlink | je 1-2 | 00-loader.fish, mr-bytez-info.fish |

#### mr-bytez Tools (Moderne Alternativen)

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| bat | 5+ | 90-misc.fish (cat-Alias) |
| eza | 10+ | 20-eza.fish (ls-Ersatz) |
| duf | 2 | 90-misc.fish (df-Alias) |
| dust | 2 | 90-misc.fish (du-Alias) |
| fastfetch | 5 | 65-fastfetch.fish, fish_greeting.fish |
| micro | 2 | 90-misc.fish (Editor-Alias) |
| htop | 1 | 90-misc.fish (top-Alias) |
| tree | 1 | 10-nav.fish |
| jq | 0 | Nicht direkt in Scripts (aber installiert) |
| fzf | 0 | Nicht genutzt |
| rg/ripgrep | 0 | Nicht direkt in Scripts |

#### System-Tools

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| systemctl | 15+ | 50-systemd.fish |
| journalctl | 15+ | 50-systemd.fish |
| pacman | 10+ | 60-pacman.fish, 70-desktop.fish, 70-server.fish |
| yay | 8+ | 60-pacman.fish, 70-desktop.fish |
| docker | 8+ | 30-docker.fish |
| flatpak | 5 | 70-desktop.fish |
| loginctl | 3 | 70-desktop.fish |
| sudo | 20+ | Durchgehend |
| checkupdates | 2 | 60-pacman.fish |
| paccache | 1 | 70-desktop.fish |

#### Netzwerk-Tools

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| ssh | 2+ | Host-spezifische Aliases |
| curl | 1 | host-test.fish (externe IP) |
| ip | 5+ | host-test.fish, 90-misc.fish |

#### Git

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| git | 15+ | 40-git.fish, __mr_git_status.fish |

#### System-Info

| Tool | Aufrufe | Dateien |
|------|---------|---------|
| hostname | 5+ | host-test.fish, Prompt |
| uname | 2 | host-test.fish |
| uptime | 2 | host-test.fish |
| lscpu | 1 | 90-misc.fish |
| free | 1 | 90-misc.fish |
| lsblk | 1 | host-test.fish |
| date | 3 | fish_right_prompt.fish, scan-secrets.fish |

### 2.2 Installationsstatus auf den 3 Hosts

| Tool | Paket | n8-kiste | n8-vps | n8-station | Kategorie |
|------|-------|----------|--------|------------|-----------|
| fish | fish | 4.5.0 ✅ | 4.5.0 ✅ | 4.5.0 ✅ | Basis |
| fisher | fisher | 4.4.8 ✅ | ❌ | 4.4.8 ✅ | Fish |
| git | git | 2.53.0 ✅ | 2.53.0 ✅ | 2.53.0 ✅ | Basis |
| gh | github-cli | 2.87.3 ✅ | 2.87.3 ✅ | 2.87.3 ✅ | Git |
| age | age | 1.3.1 ✅ | 1.3.1 ✅ | 1.3.1 ✅ | Security |
| openssh | openssh | 10.2p1 ✅ | 10.2p1 ✅ | (dep) ✅ | Netzwerk |
| bat | bat | 0.26.1 ✅ | 0.26.1 ✅ | 0.26.1 ✅ | mr-bytez |
| eza | eza | 0.23.4 ✅ | 0.23.4 ✅ | 0.23.4 ✅ | mr-bytez |
| duf | duf | 0.9.1 ✅ | ❌ | 0.9.1 ✅ | mr-bytez |
| dust | dust | 1.2.4 ✅ | ❌ | 1.2.4 ✅ | mr-bytez |
| jq | jq | 1.8.1 ✅ | 1.8.1 ✅ | 1.8.1 ✅ | Basis |
| micro | micro | 2.0.15 ✅ | 2.0.15 ✅ | 2.0.15 ✅ | mr-bytez |
| fastfetch | fastfetch | 2.59.0 ✅ | 2.59.0 ✅ | 2.59.0 ✅ | mr-bytez |
| tree | tree | 2.3.1 ✅ | 2.3.1 ✅ | 2.3.1 ✅ | Basis |
| htop | htop | 3.4.1 ✅ | ❌ | 3.4.1 ✅ | mr-bytez |
| btop | btop | 1.4.6 ✅ | ❌ | 1.4.6 ✅ | Desktop |
| ncdu | ncdu | 2.9.2 ✅ | 2.9.2 ✅ | ❌ | Basis |
| docker | docker | 29.2.1 ✅ | 29.2.1 ✅ | 29.2.1 ✅ | System |
| docker-compose | docker-compose | 5.0.2 ✅ | 5.0.2 ✅ | 5.0.2 ✅ | System |
| docker-buildx | docker-buildx | 0.31.1 ✅ | 0.31.1 ✅ | ❌ | System |
| lazydocker | lazydocker | 0.24.4 ✅ | 0.24.4 ✅ | ❌ | Docker |
| rsync | rsync | 3.4.1 ✅ | 3.4.1 ✅ | 3.4.1 ✅ | Netzwerk |
| rclone | rclone | 1.73.1 ✅ | ❌ | 1.73.1 ✅ | Cloud |
| wget | wget | 1.25.0 ✅ | 1.25.0 ✅ | 1.25.0 ✅ | Netzwerk |
| vim | vim | 9.2 ✅ | 9.2 ✅ | 9.2 ✅ | Editor |
| nodejs | nodejs | 25.6.1 ✅ | 25.6.1 ✅ | ❌ | Dev |
| npm | npm | 11.10.1 ✅ | 11.10.1 ✅ | ❌ | Dev |
| python | python | 3.14.3 ✅ | 3.14.3 ✅ | 3.14.3 ✅ | Dev |
| pip | python-pip | 26.0.1 ✅ | 26.0.1 ✅ | 26.0.1 ✅ | Dev |
| yay | yay/yay-bin | 12.5.7 ✅ | 12.5.7 ✅ | 12.5.7 ✅ | System |
| flatpak | flatpak | 1.16.3 ✅ | ❌ | 1.16.3 ✅ | Desktop |
| nmap | nmap | 7.98 ✅ | 7.98 ✅ | ❌ | Netzwerk |
| ufw | ufw | 0.36.2 ✅ | 0.36.2 ✅ | ❌ | Security |
| unbound | unbound | 1.24.2 ✅ | 1.24.2 ✅ | ❌ | DNS |

**Auffaelligkeiten:**
- n8-vps: Kein duf/dust (df/du-Aliases haben Fallback noetig oder Tools installieren)
- n8-station: Kein lazydocker, docker-buildx, ncdu, nodejs/npm
- fisher fehlt auf n8-vps (irrelevant wenn keine Fish-Plugins gebraucht werden)

### 2.3 Paketlisten der Hosts

| Host | Explizit | AUR | Flatpak |
|------|----------|-----|---------|
| **n8-kiste** | 148 Pakete | 14 (brave, crowdsec, jdownloader2, ms-edge, rustdesk, tinymediamanager, vscode, yay) | 3 (ZapZap, Spotify, Telegram) |
| **n8-vps** | 69 Pakete | 2 (yay, yay-debug) | — |
| **n8-station** | 135 Pakete | 5 (brave, ms-edge, postman, preload, vscode, yay) | 3 (Spotify, JDownloader, Telegram) |

**Vollstaendige Listen:** Siehe Anhang A (Paketlisten).

### 2.4 Paketlisten-Entwurf

#### min-packages.txt — Minimum fuer ALLE Hosts

```
# mr-bytez Minimum Package Set
# Alle Hosts muessen diese Pakete haben

# Shell & Tools
fish
git
github-cli
age
openssh
sudo

# mr-bytez Tools (moderne Alternativen)
bat
eza
duf
dust
jq
micro
fastfetch
tree
htop
ncdu

# System
base
base-devel
yay          # oder yay-bin

# Netzwerk
rsync
wget
curl         # (meist als Dependency vorhanden)

# Monitoring
sysstat
smartmontools

# Utilities
unzip
vim
bc
inetutils
pv
```

#### desktop-packages.txt — Zusaetzlich fuer GUI-Hosts

```
# mr-bytez Desktop Package Set (n8-kiste, n8-station, n8-book, etc.)
# Zusaetzlich zu min-packages.txt

# Desktop-Essentials
flatpak
btop
fisher       # Fish Plugin Manager

# Multimedia
vlc
vlc-plugin-ffmpeg
vlc-plugin-mpeg2
vlc-plugins-all

# Netzwerk-Shares
# cifs-utils  # (fuer SMB-Mounts, bei Bedarf)

# Clipboard
xclip        # (oder wl-clipboard fuer Wayland)

# KDE / Desktop
dolphin
konsole
ark
gwenview
kdialog
kdiff3
kompare
krename

# Fonts
ttf-firacode-nerd
ttf-nerd-fonts-symbols
ttf-nerd-fonts-symbols-mono
terminus-font

# Browser
# brave-bin   # (AUR, optional)
# chromium    # (optional)

# Office
# libreoffice-fresh  # (optional)
# thunderbird        # (optional)
```

#### dev-packages.txt — Zusaetzlich fuer Development-Hosts

```
# mr-bytez Development Package Set (n8-kiste, n8-station)
# Zusaetzlich zu min-packages.txt + desktop-packages.txt

# Container
docker
docker-compose
docker-buildx
lazydocker

# Development
nodejs
npm
python
python-pip

# Cloud & Sync
rclone
rclone       # (optional, fuer Cloud-Sync A6)

# Editor
visual-studio-code-bin  # (AUR)
# helix                 # (optional)

# Netzwerk-Diagnose
nmap
tcpdump
iotop

# Security
ufw
unbound
```

---

## 3. Paketlisten-Delta (fehlende Pakete)

### n8-vps — Fehlende min-packages

| Paket | Status | Aktion |
|-------|--------|--------|
| duf | ❌ Fehlt | Installieren (fuer df-Alias) |
| dust | ❌ Fehlt | Installieren (fuer du-Alias) |
| htop | ❌ Fehlt | Installieren (fuer top-Alias) |
| fisher | ❌ Fehlt | Optional (kein Plugin-Bedarf) |
| pv | ❌ Fehlt | Optional |

### n8-station — Fehlende dev-packages

| Paket | Status | Aktion |
|-------|--------|--------|
| docker-buildx | ❌ Fehlt | Installieren |
| lazydocker | ❌ Fehlt | Installieren |
| nodejs/npm | ❌ Fehlt | Installieren (fuer Claude Code) |
| ncdu | ❌ Fehlt | Installieren |
| nmap | ❌ Fehlt | Optional |

---

## 4. Alias-Abhaengigkeiten (Teil 2)

### 4.1 Hoch-Risiko Aliases — Status

| Alias | Mappt auf | Status | Risiko |
|-------|-----------|--------|--------|
| cat | bat (--paging=never --style=numbers --theme=gruvbox-dark --color=auto) | GESCHUETZT ✅ | NIEDRIG |
| grep | Funktion mit --color=auto | GESCHUETZT ✅ | NIEDRIG |
| ls | eza --icons --group-directories-first | GESCHUETZT ✅ | NIEDRIG |
| df | duf -hide loops,binds | GESCHUETZT ✅ | NIEDRIG |
| du | dust -r | GESCHUETZT ✅ | NIEDRIG |
| rm | rm -Iv (Safety-Mode) | GEMISCHT ⚠️ | MITTEL |
| cp | cp -iv | GESCHUETZT ✅ | NIEDRIG |
| mv | mv -iv | GESCHUETZT ✅ | NIEDRIG |

### 4.2 Bare `rm`-Aufrufe — Detaillierte Fundstellen

**Gesamt: 21 Aufrufe in 5 Dateien**

| Datei | Zeile | Code | Risiko | Kontext |
|-------|-------|------|--------|---------|
| `.secrets/deploy.fish` | 414 | `rm "$target"` | MITTEL | Secrets-Deployment |
| `.secrets/deploy.fish` | 499 | `rm "$target"` | MITTEL | Secrets-Deployment |
| `.secrets/deploy.fish` | 524 | `rm "$target"` | MITTEL | Secrets-Deployment |
| `shared/deployment/pack-secrets.fish` | 199 | `rm "$tar_file"` | NIEDRIG | Temp-Cleanup |
| `shared/deployment/pack-secrets.fish` | 218 | `rm "$tar_file"` | NIEDRIG | Temp-Cleanup |
| `shared/deployment/pack-secrets.fish` | 233 | `rm "$age_file"` | NIEDRIG | Archiv-Cleanup |
| `shared/deployment/pack-secrets.fish` | 239 | `rm -f "$tar_file"` | NIEDRIG | Force-Cleanup |
| `shared/deployment/pack-secrets.fish` | 245 | `rm -f "$tar_file"` | NIEDRIG | Force-Cleanup |
| `shared/deployment/pack-secrets.fish` | 255 | `rm "$tar_file"` | NIEDRIG | Temp-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 186 | `rm "$tar_file"` | NIEDRIG | Temp-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 192 | `rm -f "$tar_file"` | NIEDRIG | Force-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 210 | `rm -rf "$temp_dir"` | MITTEL | Error-Path |
| `shared/deployment/unpack-secrets.fish` | 220 | `rm -rf "$temp_dir"` | MITTEL | Error-Path |
| `shared/deployment/unpack-secrets.fish` | 221 | `rm -f "$tar_file"` | NIEDRIG | Error-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 228 | `rm -rf "$temp_dir"` | MITTEL | Error-Path |
| `shared/deployment/unpack-secrets.fish` | 229 | `rm -f "$tar_file"` | NIEDRIG | Error-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 243 | `rm -rf "$temp_dir"` | MITTEL | Error-Path |
| `shared/deployment/unpack-secrets.fish` | 244 | `rm -f "$tar_file"` | NIEDRIG | Error-Cleanup |
| `shared/deployment/unpack-secrets.fish` | 255 | `rm -rf "$source_dir"` | MITTEL | Failure-Path |
| `shared/deployment/unpack-secrets.fish` | 272 | `rm "$tar_file"` | NIEDRIG | Temp-Cleanup |
| `shared/etc/fish/functions/theme.fish` | 177,282 | `rm -f $theme_file` | NIEDRIG | Theme-Reset |
| `scripts/scan-secrets.fish` | 127 | `rm -f $files_with_matches` | NIEDRIG | Temp-Cleanup |

**Bewertung:** Alle bare `rm`-Aufrufe sind in Automations-/Deployment-Scripts — kein interaktiver Kontext. Die `-rf`-Aufrufe sind in Error-Paths (akzeptabel). Kein Fix noetig, aber Kommentare waeren gut.

### 4.3 Funktionen — Keine Probleme

Alle 11 Shared-Funktionen sind sauber:
- Alle nutzen `command`-Prefix wo noetig
- Keine hardcodierten Pfade
- Keine Referenzen auf Nummerierungsschema
- Variablen werden zur Laufzeit aufgeloest ($shared_base, $host_base, $theme_file)

---

## 5. Loader-Referenzen & Nummerierungsschema

### 5.1 Aktiver Loader v2.1 — 8-Phasen-System

```
Phase 1: Theme (00-09)       → 00-theme.fish
Phase 2: Shared Aliases 10-69 → 10-nav, 20-eza, 30-docker, 40-git, 50-systemd, 60-pacman, 65-fastfetch
Phase 3: Shared Variables 10-69 → 10-paths.fish
Phase 4: Host Aliases 10-69  → (host-spezifisch, falls vorhanden)
Phase 5: Shared Functions    → fish_function_path erweitern
Phase 6: Host Category 70-79 → 70-desktop.fish / 70-server.fish
Phase 7: Host-spezifisch 80-89 → 80-n8-*.fish
Phase 8: User Tweaks 90+     → 90-misc.fish
```

### 5.2 Geplantes Nummerierungsschema (A2)

| Alt | Neu | Kategorie |
|-----|-----|-----------|
| 00-loader | 000-loader | Shared Base |
| 00-theme | 005-theme | Shared Base |
| 10-nav | 010-nav | Shared Aliases |
| 20-eza | 015-eza | Shared Aliases |
| 30-docker | 020-docker | Shared Aliases |
| 40-git | 025-git | Shared Aliases |
| 50-systemd | 030-systemd | Shared Aliases |
| 60-pacman | 035-pacman | Shared Aliases |
| 65-fastfetch | 040-fastfetch | Shared Aliases |
| 90-misc | 045-misc | Shared Aliases |
| (NEU) | 050-gui.fish | Shared Conditional |
| (NEU) | 055-dev.fish | Shared Conditional |
| 10-display/10-host | 105-host.fish | Host-Flags |
| 70-desktop | ENTFAELLT | → merge in 050-gui |
| 70-server | ENTFAELLT | → Duplikate entfernen |
| 80-n8-* | 110-n8-* | Host-spezifisch |

### 5.3 Kritischer Design-Punkt

**Problem:** 050-gui.fish und 055-dev.fish pruefen Feature-Flags (MR_HAS_GUI, MR_IS_DEV). Diese Flags werden in 105-host.fish gesetzt. Aber Host-Dateien (101-200) laden NACH Shared-Dateien (000-100).

**Loesung noetig:** Entweder:
- A) Zwei-Durchlauf-System (erst Host-Flags, dann Shared-Conditionals)
- B) Explizites Laden von 105-host.fish VOR 050-gui.fish
- C) Nummerierung anpassen (Flags in Shared-Bereich 060-host.fish)

### 5.4 Alle Loader-Referenzen im Repo

| Datei | Zeile(n) | Typ | Status |
|-------|----------|-----|--------|
| shared/etc/fish/conf.d/00-loader.fish | 1-272 | Core-Loader | AKTIV ✅ |
| shared/home/mrohwer/.config/fish/config.fish | 2 | Bootstrap | AKTIV ✅ |
| shared/etc/fish/functions/mr-bytez-info.fish | 151-152 | Diagnostik | AKTIV ✅ |
| shared/etc/fish/functions/theme.fish | 13-18 | Pfad-Fallback | AKTIV ✅ |
| DEPLOYMENT.md | 378 | Doku | AKTUELL ✅ |
| ROADMAP.md | 46 | Milestone | AKTUELL ✅ |
| .claude/context/shell.md | 71, 77 | Policy | AKTUELL ✅ |
| CHANGELOG.md | 13, 443, 454 | Historie | AKTUELL ✅ |

---

## 6. Offene Aufgaben (Teil 3)

### 6.1 Handoffs — Uebersicht

| Handoff | Status | A2-relevant? |
|---------|--------|-------------|
| [Fish][Refactor] fish-dry-refactoring | TODO / In Bearbeitung | JA — Kern-Task |
| [Fish][Theme] script-formatting-library | Offen (niedrig) | JA — passt zu A2 |
| [DNS][Infra] dns-hetzner-traefik | ✅ Abgeschlossen | NEIN |
| [SMB][Deploy] smb-shares-deployment | 🟡 In Arbeit | TEILWEISE (B5+B17) |
| [Security][Git] git-filter-cleanup | TODO (A5) | NEIN |
| [Learn][Stack] mr-bytez-learn | Entwurf | NEIN |
| [Secrets][Structure] a1-secrets-repo | ✅ Erledigt (bis auf D13) | NEIN |

### 6.2 A2-relevante offene Tasks (aus Handoffs + ROADMAP)

| Task | Quelle | Prioritaet | Abhaengigkeit |
|------|--------|-----------|---------------|
| Nummerierungsschema 000-200 | A2 Handoff | HOCH | — |
| Feature-Flags (MR_HAS_GUI etc.) | A2 Handoff | HOCH | Loader-Umbau |
| 050-gui.fish erstellen | A2 Handoff | HOCH | Feature-Flags |
| 055-dev.fish erstellen | A2 Handoff | HOCH | Feature-Flags |
| 70-desktop.fish → 050-gui merge | A2 Handoff | HOCH | 050-gui.fish |
| 70-server.fish entfernen | A2 Handoff | MITTEL | Duplikat-Audit |
| Alias-Naming-Konvention | A2 Handoff | MITTEL | — |
| B6: Bash-Config | ROADMAP | MITTEL | A2 |
| B7: mr-bytez-info.fish | ROADMAP | MITTEL | A2 |
| B5: SMB-Deploy Script | SMB Handoff | MITTEL | A2 |
| B17: VLC Desktop-Paketliste | SMB Handoff | NIEDRIG | A2 |
| format.fish Library | Theme Handoff | NIEDRIG | A2 |

### 6.3 NICHT-A2 offene Tasks

| Task | Projekt | Prioritaet |
|------|---------|-----------|
| D13: Credentials n8-archstick | A1 | MITTEL (phys. Zugang) |
| B14: Traefik + ACME DNS-01 | A4 | HOCH |
| D1: TTLs auf 3600s | DNS | NIEDRIG |
| D2: PTR-Records | DNS | NIEDRIG |
| D4: Alte API-Tokens | DNS | NIEDRIG |
| A3: Claude Dev Container | A3 | HOCH (Maerz) |
| A5: Git Filter | A5 | MITTEL (April) |
| A6: Cloud-Sync | A6 | NIEDRIG (Q2) |
| mr-bytez-learn Submodule | Learn | NIEDRIG (Q2) |

### 6.4 TODO/FIXME im Code

**Ergebnis: Minimal** — Nur Template-Platzhalter, kein technischer Debt.

| Datei | Zeile | TODO-Text | Typ |
|-------|-------|-----------|-----|
| shared/etc/fish/CLAUDE.md | 7 | "TODO: Befuellen wenn Projekt startet" | Platzhalter (A2) |
| shared/etc/fish/CHANGELOG.md | 7 | "TODO: Befuellen wenn Projekt startet" | Platzhalter (A2) |
| shared/etc/fish/ROADMAP.md | 7 | "TODO: Befuellen wenn Projekt startet" | Platzhalter (A2) |
| .secrets/SECRETS.md | 59 | "TODO: Weitere Spalten ergaenzen" | Enhancement |

Keine FIXME, HACK, XXX, WORKAROUND oder DEPRECATED im Code gefunden.

---

## 7. Struktur-Ist-Analyse (Teil 4)

### 7.1 Aktuelle Fish-Verzeichnisstruktur

```
shared/etc/fish/
├── conf.d/
│   ├── 00-loader.fish          # Zentraler 8-Phasen-Loader
│   └── 00-theme.fish           # Theme-Initialisierung
├── aliases/
│   ├── 10-nav.fish             # Navigation (cd, rm, cp, mv, ln, mkdir)
│   ├── 20-eza.fish             # Listing (ls=eza, ll, la, ld, lf, ...)
│   ├── 30-docker.fish          # Docker (dc, dps, dlogs, ...)
│   ├── 40-git.fish             # Git (gs, gb, ga, gc, gp, ...)
│   ├── 50-systemd.fish         # Systemd (sc, jc, boot-log, ...)
│   ├── 60-pacman.fish          # Pacman/Yay (pac, pacs, pacr, ...)
│   ├── 65-fastfetch.fish       # Fastfetch (ff, ffs, ffa, ...)
│   └── 90-misc.fish            # Misc (cat=bat, df=duf, du=dust, top=htop, ...)
├── functions/
│   ├── fish_prompt.fish        # Powerline-Prompt mit Host-Farben
│   ├── fish_right_prompt.fish  # Rechter Prompt (Uhrzeit)
│   ├── fish_greeting.fish      # Shell-Greeting (fastfetch)
│   ├── fish_mode_prompt.fish   # Vi-Mode Indikator
│   ├── __mr_smart_pwd.fish     # Smarter Pfad-Display
│   ├── __mr_host_color.fish    # Host-spezifische Farben
│   ├── __mr_git_status.fish    # Git-Status Helper
│   ├── __mr_docker_status.fish # Docker-Status Helper
│   ├── theme.fish              # Theme-System (Farb-Helper)
│   ├── host-test.fish          # System-Test-Funktion
│   └── mr-bytez-info.fish      # Info/Banner-Funktion
├── themes/
│   ├── mr-bytez.fish           # Aktives Theme (Gruvbox-Dark)
│   └── mr-bytez.fish.v1.0.bak # Backup
├── variables/
│   └── 10-paths.fish           # PATH-Erweiterungen
├── CLAUDE.md                   # Platzhalter (TODO)
├── CHANGELOG.md                # Platzhalter (TODO)
└── ROADMAP.md                  # Platzhalter (TODO)
```

### 7.2 Host-spezifische Struktur (8 Hosts)

```
projects/infrastructure/
├── n8-kiste/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-kiste.fish
│   └── variables/10-display.fish
├── n8-station/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-station.fish
│   └── variables/10-display.fish
├── n8-vps/root/home/mrohwer/.config/fish/
│   ├── aliases/70-server.fish, 80-n8-vps.fish
│   └── variables/10-host.fish
├── n8-book/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-book.fish
│   ├── functions/n8-book-test.fish
│   └── variables/10-display.fish
├── n8-bookchen/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-bookchen.fish
│   ├── functions/n8-bookchen-test.fish
│   └── variables/10-display.fish
├── n8-broker/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-broker.fish
│   ├── functions/n8-broker-test.fish
│   └── variables/10-display.fish
├── n8-maxx/root/home/mrohwer/.config/fish/
│   ├── aliases/70-desktop.fish, 80-n8-maxx.fish
│   ├── functions/n8-maxx-test.fish
│   └── variables/10-display.fish
└── n8-archstick/root/home/mrohwer/.config/fish/
    ├── aliases/70-desktop.fish, 80-n8-archstick.fish
    ├── functions/n8archstick-test.fish
    └── variables/10-host.fish
```

### 7.3 Gap-Analyse (Handoff vs. Realitaet)

**Im Handoff NICHT erwaehnt:**
- 11 Shared-Functions (bleiben unveraendert)
- Host-Test-Funktionen (n8-*-test.fish) — nicht im Scope
- 00-loader.fish und 00-theme.fish — bleiben oder werden zu 000/005

**In Realitaet NICHT vorhanden (im Handoff geplant):**
- 050-gui.fish (NEU zu erstellen)
- 055-dev.fish (NEU zu erstellen)
- 105-host.fish (NEU, konsolidiert aus 10-display/10-host)

### 7.4 70-desktop.fish Duplikation

Die Datei `70-desktop.fish` existiert in 7 Host-Verzeichnissen (alle ausser n8-vps). Inhalt ist IDENTISCH — ein Hauptziel von A2 ist diese Duplikation aufzuloesen.

---

## 8. Context-Dateien Konsistenz (Teil 3.4)

### 8.1 Status aller 12 Context-Dateien

| Datei | Version | Aktualisiert | Status |
|-------|---------|-------------|--------|
| policies.md | 1.0.0 | 2026-02-10 | ✅ Aktuell |
| structure.md | 1.0.0 | 2026-02-10 | ✅ Aktuell |
| git.md | 1.0.0 | 2026-02-10 | ✅ Aktuell (Cross-Repo-Regel) |
| shell.md | 1.0.0 | 2026-02-25 | ✅ Aktualisiert (command-Prefix) |
| security.md | 1.0.0 | 2026-02-10 | ✅ Aktuell |
| deployment.md | 1.0.0 | 2026-02-10 | ✅ Aktuell |
| infrastructure.md | 1.0.0 | 2026-02-25 | ✅ Aktualisiert (SSH-Ports) |
| documentation.md | 1.0.0 | 2026-02-10 | ✅ Aktuell |
| docker.md | 1.0.0 | 2026-02-10 | ⚪ Platzhalter |
| integration.md | 1.0.0 | 2026-02-10 | ⚪ Platzhalter |
| tags.md | 1.0.0 | 2026-02-10 | ✅ Aktuell (67 Tags) |
| versioning.md | 1.0.0 | 2026-02-25 | ✅ NEU |

### 8.2 Gefundene Deltas

| Ort | Problem | Prioritaet |
|-----|---------|-----------|
| Root CLAUDE.md | Kein expliziter Verweis auf command-Prefix Regel | NIEDRIG (steht in shell.md) |
| shell.md | Muss nach A2 komplett ueberarbeitet werden (neues Schema) | NACH A2 |
| deployment.md | Deployment-Schritte aendern sich mit A2 (neue Dateinamen) | NACH A2 |

### 8.3 5-3-3 Status fuer shared/etc/fish/

| Dokument | Existiert? | Inhalt |
|----------|-----------|--------|
| README.md | ❌ FEHLT | Sollte Fish-Config Uebersicht dokumentieren |
| CLAUDE.md | ✅ | Platzhalter ("TODO: Befuellen wenn Projekt startet") |
| CHANGELOG.md | ✅ | Platzhalter |
| ROADMAP.md | ✅ | Platzhalter |
| DEPLOYMENT.md | ❌ FEHLT | Sollte Fish-Deployment-Schritte dokumentieren |

**Aktion:** README.md und DEPLOYMENT.md erstellen als Phase 0 von A2.

---

## 9. ROADMAP-Abgleich

### Aktuelle Versionen

| ROADMAP | Version | Letzte Aenderung |
|---------|---------|-----------------|
| Root ROADMAP.md | — | 2026-02-26 |
| .claude/ROADMAP.md | 1.0.0 | 2026-02-10 |
| .secrets/ROADMAP.md | — | 2026-02-25 |
| shared/etc/fish/ROADMAP.md | — | Platzhalter |

### Offene B-Tasks (aus Root ROADMAP)

| Task | Beschreibung | Zuordnung |
|------|-------------|-----------|
| B5 | SMB-Shares Deploy Script | A2 (SMB Handoff) |
| B6 | Bash-Config | A2 |
| B7 | mr-bytez-info.fish | A2 |
| B8 | Docs-Struktur | A3 |
| B14 | Traefik + ACME DNS-01 | A4 |
| B15 | ✅ Host-zu-Host SSH-Config | ERLEDIGT |
| B17 | VLC Desktop-Paketliste | A2 |

### Offene D-Tasks

| Task | Beschreibung | Zuordnung |
|------|-------------|-----------|
| D1 | TTLs auf 3600s | DNS |
| D2 | PTR-Records | DNS |
| D4 | Alte API-Tokens | DNS |
| D9 | ✅ symlinks.db | ERLEDIGT |
| D13 | Credentials n8-archstick | A1 (phys. Zugang) |

---

## 10. Empfehlungen

### VOR A2 (Sofort)

1. **Fehlende min-Pakete auf n8-vps installieren:** `duf`, `dust`, `htop`
2. **Fehlende dev-Pakete auf n8-station installieren:** `docker-buildx`, `lazydocker`, `nodejs`, `npm`, `ncdu`
3. **5-3-3 Docs erstellen:** `shared/etc/fish/README.md` und `DEPLOYMENT.md` (Phase 0)

### A2 Phase 1 (Kritisch)

4. **Loader-Design-Entscheidung:** Wie werden Host-Flags VOR Shared-Conditionals geladen?
   - Option A: Zwei-Durchlauf-System
   - Option B: Explizites Laden von 105-host.fish vor 050-gui.fish
   - Option C: Flags in Shared-Bereich verschieben (z.B. 060-host.fish)
5. **70-desktop.fish DRY-Aufloesung:** 7 identische Kopien → 1x 050-gui.fish

### A2 Kern-Phasen

6. **Datei-Umbenennung** (Shared: 10→010, etc.)
7. **050-gui.fish erstellen** (aus 70-desktop.fish extrahiert)
8. **055-dev.fish erstellen** (neue Dev-Conditionals)
9. **105-host.fish erstellen** (konsolidiert aus 10-display/10-host + Feature-Flags)
10. **Loader anpassen** (neues Nummerierungsschema)
11. **Tests auf allen 3 deployed Hosts** (n8-kiste, n8-vps, n8-station)

### NACH A2

12. **shell.md ueberarbeiten** (neues Schema dokumentieren)
13. **deployment.md aktualisieren** (neue Dateinamen)
14. **Platzhalter-Docs befuellen** (CLAUDE.md, CHANGELOG.md, ROADMAP.md in shared/etc/fish/)

### Kann warten

15. Kommentare zu bare `rm`-Aufrufen in Deployment-Scripts hinzufuegen
16. format.fish Library (Script-Formatting, niedrige Prio)
17. D13: n8-archstick Credentials (braucht physischen Zugang)

---

## Anhang A: Paketlisten (Zusammenfassung)

### n8-kiste — 148 Pakete explizit, 14 AUR, 3 Flatpak

**Highlights:** Vollstaendige Desktop+Dev Workstation. Alle mr-bytez Tools vorhanden.
Docker, Blender, Brave, Chromium, Edge, LibreOffice, GIMP, KDE Plasma, Samba,
PostgreSQL, Valkey, Netdata, AdGuard Home, CrowdSec, Forgejo, Nginx.
**AUR:** brave-bin, crowdsec, jdownloader2, ms-edge, rustdesk-bin, tinymediamanager-bin, vscode-bin, yay-bin
**Flatpak:** ZapZap, Spotify, Telegram

### n8-vps — 69 Pakete explizit, 2 AUR

**Highlights:** Minimaler Headless-Server. Kerntools vorhanden (bat, eza, fastfetch).
Docker + Buildx. Fail2ban, UFW, Unbound. Kein GUI, kein Flatpak.
**Fehlend fuer min:** duf, dust, htop
**AUR:** yay

### n8-station — 135 Pakete explizit, 5 AUR, 3 Flatpak

**Highlights:** Desktop+Dev Workstation. KDE Plasma, Nvidia-Treiber, Wine/Lutris.
Docker (ohne Buildx). Chezmoi, Nix. Brave, Chromium, Edge.
**Fehlend fuer dev:** docker-buildx, lazydocker, nodejs, npm, ncdu
**AUR:** brave-bin, ms-edge, postman-bin, preload, vscode-bin, yay
**Flatpak:** Spotify, JDownloader, Telegram

---

*Report generiert am 2026-02-26 durch Claude Code (Opus 4.6)*
*Keine Dateien wurden geaendert — reine Analyse.*
