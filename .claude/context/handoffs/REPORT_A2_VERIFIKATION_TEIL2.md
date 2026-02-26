# REPORT: A2 Verifikation Teil 2 — Script-Formatierung & Paketlisten

**Erstellt:** 2026-02-26
**Autor:** Claude Code (Opus 4.6)
**Vorgaenger:** REPORT_A2_VERIFIKATION.md (Teil 1, selber Chat)
**Zweck:** Ergaenzende Bestandsaufnahme — Script-Formatierung + Paketlisten-Luecken
**Chat-Referenz:** #FSH01.1 [Fish][Refactor] - A2 Fish DRY-Refactoring Planung
**Chat-Link:** https://claude.ai/chat/2bdd7e90-524e-4c48-807f-8f3b2815ee10

---

## 1. Zusammenfassung

### Kernergebnisse

- **Formatierung:** 2 Header-Standards aktiv (7-Feld Deployment + 9-Zeilen-Box Config). Farb-Schema ist konsistent (Gruvbox).
- **Duplikate:** 4 Formatting-Funktionen (_msg, _success, _error, _warn) in 3 Dateien identisch kopiert — Hauptziel fuer `format.fish` Library.
- **shared/lib/:** `banner.fish` existiert (mr_bytez_banner), `format.fish` fehlt komplett.
- **Paketlisten:** 6 Basis-Tools (ripgrep, less, tar, etc.) fehlten im ersten Entwurf. n8-vps hat die groessten Luecken (kein ripgrep, less, fd).
- **Backup-Dateien:** 1 entfernbare Datei (`mr-bytez.fish.v1.0.bak`).
- **Verwaiste Scripts:** Keine gefunden — alle Scripts werden referenziert.

---

## 2. Script-Formatierung Audit

### 2.1 Header/Banner Status — Alle Scripts

#### Deployment-Scripts (7-Feld Header + Banner)

| Datei | Header | Version | Banner | Lokale Funktionen | Status |
|-------|--------|---------|--------|-------------------|--------|
| `.secrets/deploy.fish` | 7-Feld ✅ | 0.3.0 | mr_bytez_banner ✅ | _msg, _success, _error, _warn, _skip, _link, _copy, _section (7) | PRODUKTION |
| `shared/deployment/pack-secrets.fish` | 7-Feld ✅ | 0.1.0 | mr_bytez_banner ✅ | _msg, _success, _error, _warn (4) — DUPLIKATE | PRODUKTION |
| `shared/deployment/unpack-secrets.fish` | 7-Feld ✅ | 0.2.0 | mr_bytez_banner ✅ | _msg, _success, _error, _warn (4) — DUPLIKATE | PRODUKTION |
| `shared/deployment/derive_key.fish` | 7-Feld ✅ | 0.2.0 | mr_bytez_banner ✅ | Keine (inline set_color) | PRODUKTION |
| `shared/deployment/generate_pwd.fish` | 8-Feld ✅ | 1.0.0 | Kein Banner ❌ | generate_pwd Wrapper | PRODUKTION |
| `scripts/scan-secrets.fish` | Kommentar ⚠️ | 2.0 | Kein Banner ❌ | Keine (inline set_color) | WARTUNG |

#### Shared Config (9-Zeilen-Box Header)

| Datei | Header | Version | set_color | Status |
|-------|--------|---------|-----------|--------|
| `shared/etc/fish/conf.d/00-loader.fish` | 9-Zeilen-Box ✅ | 2.1.0 | Debug-Output (brblack) | PRODUKTION |
| `shared/etc/fish/conf.d/00-theme.fish` | 9-Zeilen-Box ✅ | 1.1.0 | Theme-System (8 Helper) | PRODUKTION |

#### Shared Aliases (9-Zeilen-Box Header)

| Datei | Header | Version | set_color | Status |
|-------|--------|---------|-----------|--------|
| `shared/etc/fish/aliases/10-nav.fish` | 9-Zeilen-Box ✅ | 1.0.0 | Nein | PRODUKTION |
| `shared/etc/fish/aliases/20-eza.fish` | 9-Zeilen-Box ✅ | 1.0.0 | Nein | PRODUKTION |
| `shared/etc/fish/aliases/30-docker.fish` | 9-Zeilen-Box ✅ | 1.0.0 | Nein | PRODUKTION |
| `shared/etc/fish/aliases/40-git.fish` | 9-Zeilen-Box ✅ | 1.0.0 | Nein | PRODUKTION |
| `shared/etc/fish/aliases/50-systemd.fish` | 9-Zeilen-Box ✅ | 1.0.0 | Nein | PRODUKTION |
| `shared/etc/fish/aliases/60-pacman.fish` | Verifizierung noetig | — | Nein | PRODUKTION |
| `shared/etc/fish/aliases/65-fastfetch.fish` | Verifizierung noetig | — | Nein | PRODUKTION |
| `shared/etc/fish/aliases/90-misc.fish` | Verifizierung noetig | — | Nein | PRODUKTION |

#### Shared Functions

| Datei | Header | Version | set_color | Status |
|-------|--------|---------|-----------|--------|
| `functions/fish_prompt.fish` | 3-Feld ✅ | 2.1.0 | Ja (Prompt-Farben) | PRODUKTION |
| `functions/fish_right_prompt.fish` | Verifizierung noetig | — | Ja (Prompt-Farben) | PRODUKTION |
| `functions/fish_greeting.fish` | Verifizierung noetig | — | Ja (fastfetch) | PRODUKTION |
| `functions/fish_mode_prompt.fish` | Verifizierung noetig | — | Ja (Vi-Mode) | PRODUKTION |
| `functions/host-test.fish` | 9-Zeilen-Box ✅ | 1.2.0 | Ja (Diagnostik) | PRODUKTION |
| `functions/mr-bytez-info.fish` | Kommentar ✅ | — | Ja (Info/Banner) | PRODUKTION |
| `functions/theme.fish` | Verifizierung noetig | — | Ja (Theme-Mgmt) | PRODUKTION |
| `functions/__mr_smart_pwd.fish` | Verifizierung noetig | — | Nein | PRODUKTION |
| `functions/__mr_host_color.fish` | Verifizierung noetig | — | Ja (Farb-Definitionen) | PRODUKTION |
| `functions/__mr_git_status.fish` | Verifizierung noetig | — | Nein (Variablen) | PRODUKTION |
| `functions/__mr_docker_status.fish` | Verifizierung noetig | — | Nein (Variablen) | PRODUKTION |

#### Shared Library

| Datei | Header | Version | Inhalt |
|-------|--------|---------|--------|
| `shared/lib/banner.fish` | 7-Feld + Separator ✅ | 1.0.0 | `mr_bytez_banner [--compact]`, MRBYTEZ_VERSION="2.0.0" |

#### Host-spezifische Dateien (31 Dateien ueber 8 Hosts)

| Typ | Anzahl | Header | Status |
|-----|--------|--------|--------|
| 70-desktop.fish | 7 (identisch!) | Verifizierung noetig | DRY-Verletzung |
| 70-server.fish | 1 (n8-vps) | Verifizierung noetig | PRODUKTION |
| 80-n8-*.fish | 8 | 8-Feld (teilweise) | PRODUKTION |
| n8-*-test.fish | 7 | Minimal/Kein | Diagnostik-Helper |
| 10-display/host.fish | 8 | Verifizierung noetig | Config (kein Header erwartet) |

### 2.2 Duplikat-Funktionen — Was migriert werden muss

#### Identische Duplikate (3x vorhanden)

| Funktion | deploy.fish | pack-secrets.fish | unpack-secrets.fish | Signatur |
|----------|-------------|-------------------|---------------------|----------|
| `_msg` | :53-57 | :35-39 | :35-39 | `set_color cyan; echo "→ $argv"; set_color normal` |
| `_success` | :59-63 | :41-45 | :41-45 | `set_color green; echo "✅ $argv"; set_color normal` |
| `_error` | :65-69 | :47-51 | :47-51 | `set_color red; echo "❌ $argv" >&2; set_color normal` |
| `_warn` | :71-75 | :53-57 | :53-57 | `set_color yellow; echo "⚠️  $argv"; set_color normal` |

#### Nur in deploy.fish (1x vorhanden)

| Funktion | Zeile | Signatur |
|----------|-------|----------|
| `_skip` | :77-81 | `set_color brblack; echo "⏭️  $argv"; set_color normal` |
| `_link` | :83-86 | `set_color cyan; echo "🔗 $argv"; set_color normal` |
| `_copy` | :88-91 | `set_color cyan; echo "📋 $argv"; set_color normal` |
| `_section` | :93-99 | `set_color yellow; echo ""; echo "═══ $argv ═══"; set_color normal` |

#### Theme-System Helper (in 00-theme.fish, zentral)

| Funktion | Zeile | Unterschied zu lokalen |
|----------|-------|----------------------|
| `__msg` | :199-214 | Theme-aware (nutzt $theme_* Variablen) |
| `__success` | :218-223 | Theme-aware |
| `__warn` | :227-232 | Theme-aware |
| `__error` | :236-241 | Theme-aware |
| `__header` | :245-251 | Theme-aware |

**Fazit:** Die lokalen _msg/_success/_error/_warn nutzen **hardcodierte Farben**, waehrend die Theme-Helper (__msg etc.) die **Theme-Variablen** verwenden. Die format.fish Library sollte die Theme-Variablen nutzen (mit Fallback auf hardcodierte Farben).

### 2.3 Farb-Schema Konsistenz

**Ergebnis: KONSISTENT** — Alle Scripts folgen dem Gruvbox-Schema.

| Farbe | Verwendung | Dateien | Status |
|-------|-----------|---------|--------|
| `cyan` | Info, _msg | Alle Deployment-Scripts, host-test.fish | ✅ Konsistent |
| `green` | Erfolg, _success | Alle Deployment-Scripts, Loader | ✅ Konsistent |
| `red` | Fehler, _error | Alle Deployment-Scripts, Loader | ✅ Konsistent |
| `yellow` | Warnungen, Header, Banner | Alle Deployment-Scripts, banner.fish | ✅ Konsistent |
| `brblack` | Inaktiv, Debug | deploy.fish, Loader-Debug | ✅ Konsistent |
| `normal` | Reset | Ueberall | ✅ Konsistent |
| `blue` | Sektionen (erweitert) | host-test.fish | ✅ Akzeptabel |
| `magenta` | Akzent (erweitert) | host-test.fish | ✅ Akzeptabel |

**Keine Abweichungen gefunden.** host-test.fish nutzt erweiterte Farben (blue, magenta) die ueber Gruvbox-Basis hinausgehen — ist akzeptabel fuer Diagnostik-Output.

### 2.4 Scripts OHNE Formatierung

| Datei | Kategorie | Grund |
|-------|-----------|-------|
| `shared/etc/fish/variables/10-paths.fish` | Config | Erwartet — nur PATH-Erweiterungen |
| `shared/etc/fish/themes/mr-bytez.fish` | Theme-Defs | Erwartet — nur Variablen-Definitionen |
| `shared/home/mrohwer/.config/fish/config.fish` | Bootstrap | Erwartet — 1 Zeile (`source ...`) |
| Host `10-display.fish` / `10-host.fish` (8x) | Config | Erwartet — nur Variablen |

**Fazit:** Nur Config/Variable-Dateien haben keine Formatierung — das ist korrekt und erwartet.

### 2.5 shared/lib/ Bestandsaufnahme

```
/mr-bytez/shared/lib/
└── banner.fish    # 33 Zeilen, v1.0.0
    ├── Funktion: mr_bytez_banner [--compact]
    ├── Global: MRBYTEZ_VERSION = "2.0.0"
    ├── Output: ASCII-Logo (7 Zeilen) oder Compact 1-Liner
    └── Farben: yellow (Gruvbox)
```

**Fehlend:**
- `format.fish` — **EXISTIERT NICHT** → Muss erstellt werden
- Geplanter Inhalt (aus Theme-Handoff): _msg, _success, _error, _warn, _skip, _link, _copy, _section, _box

**Migrations-Aufwand:**
- 3 Dateien muessen refactored werden (deploy.fish, pack-secrets.fish, unpack-secrets.fish)
- 2 Dateien brauchen ggf. Integration (derive_key.fish, scan-secrets.fish)
- 1 Datei optional (generate_pwd.fish)

---

## 3. Paketlisten-Ergaenzung

### 3.1 Fehlende Basis-Tools — Installationsstatus

| Tool | Paket | n8-kiste | n8-vps | n8-station | min? |
|------|-------|----------|--------|------------|------|
| ripgrep | ripgrep | 15.1.0 ✅ | ❌ | 15.1.0 ✅ | JA |
| less | less | 692 ✅ | ❌ | 692 ✅ | JA |
| sed | sed | 4.9 ✅ | 4.9 ✅ | 4.9 ✅ | (Dep) |
| findutils | findutils | 4.10.0 ✅ | 4.10.0 ✅ | 4.10.0 ✅ | (Dep) |
| tar | tar | 1.35 ✅ | 1.35 ✅ | 1.35 ✅ | (Dep) |
| gzip | gzip | 1.14 ✅ | 1.14 ✅ | 1.14 ✅ | (Dep) |

**Kritisch:** n8-vps fehlen `ripgrep` und `less`! Beide sind fuer mr-bytez Workflow relevant (rg fuer Suche, less als Pager fuer bat/man/git).

### 3.2 Desktop-Tools — Installationsstatus

| Tool | Paket | n8-kiste | n8-station | Empfehlung |
|------|-------|----------|------------|------------|
| wl-clipboard | wl-clipboard | ❌ | ❌ | Optional (X11: xclip vorhanden) |
| xdg-utils | xdg-utils | 1.2.1 ✅ | 1.2.1 ✅ | Bereits installiert |
| trash-cli | trash-cli | ❌ | ❌ | Optional (rm -Iv reicht) |
| fd | fd | 10.3.0 ✅ | 10.3.0 ✅ | Optional fuer desktop-packages |

### 3.3 Dev-Tools — Installationsstatus

| Tool | Paket | n8-kiste | n8-vps | n8-station | Empfehlung |
|------|-------|----------|--------|------------|------------|
| shellcheck | shellcheck | ❌ | ❌ | ❌ | Empfohlen (Fish/Bash Linting) |
| shfmt | shfmt | ❌ | ❌ | ❌ | Optional (kein Fish-Support) |
| tokei | tokei | ❌ | ❌ | ❌ | Optional (Code-Statistiken) |
| hyperfine | hyperfine | ❌ | ❌ | ❌ | Optional (Benchmarks) |

### 3.4 Aktualisierte Paketlisten

#### min-packages.txt (v2 — AKTUALISIERT)

```
# mr-bytez Minimum Package Set v2
# Alle Hosts muessen diese Pakete haben
# Aktualisiert: 2026-02-26

# === Shell & VCS ===
fish
git
github-cli
openssh
sudo

# === Security ===
age

# === mr-bytez Tools (moderne Alternativen) ===
bat          # cat-Ersatz
eza          # ls-Ersatz
duf          # df-Ersatz
dust         # du-Ersatz
ripgrep      # grep-Ersatz (NEU in v2)
jq           # JSON-Verarbeitung
micro        # Editor
fastfetch    # System-Info
tree         # Verzeichnisbaum
htop         # top-Ersatz
ncdu         # Disk-Usage interaktiv

# === Basis-Tools (meist als Dep vorhanden, aber sicherstellen) ===
less         # Pager (NEU in v2 — KRITISCH fuer bat/man/git)
tar          # Archivierung (pack/unpack-secrets)
gzip         # Kompression
curl         # HTTP-Client (meist Dep)

# === System ===
base
base-devel
yay          # AUR Helper (oder yay-bin)

# === Netzwerk ===
rsync
wget

# === Monitoring ===
sysstat
smartmontools

# === Utilities ===
unzip
vim
bc
inetutils
pv
```

**Aenderungen gegenueber v1:**
- `ripgrep` hinzugefuegt (grep-Ersatz, fehlt auf n8-vps)
- `less` hinzugefuegt (Pager, fehlt auf n8-vps)
- `tar`, `gzip`, `curl` explizit aufgenommen (Deployment-Abhaengigkeiten)

#### desktop-packages.txt (v2 — AKTUALISIERT)

```
# mr-bytez Desktop Package Set v2
# Zusaetzlich zu min-packages.txt
# Aktualisiert: 2026-02-26

# === Desktop-Essentials ===
flatpak
btop         # Erweiterter System-Monitor
fisher       # Fish Plugin Manager
fd           # Moderne find-Alternative (NEU in v2)

# === Multimedia ===
vlc
vlc-plugin-ffmpeg
vlc-plugin-mpeg2
vlc-plugins-all

# === Clipboard ===
xclip        # X11 Clipboard
# wl-clipboard  # Wayland (bei Bedarf aktivieren)

# === KDE / Desktop ===
dolphin
konsole
ark
gwenview
kdialog
kdiff3
kompare
krename

# === Fonts ===
ttf-firacode-nerd
ttf-nerd-fonts-symbols
ttf-nerd-fonts-symbols-mono
terminus-font

# === Browser (AUR, optional) ===
# brave-bin
# chromium

# === Office (optional) ===
# libreoffice-fresh
# thunderbird
```

**Aenderungen gegenueber v1:**
- `fd` hinzugefuegt (moderne find-Alternative, auf n8-kiste und n8-station bereits installiert)

#### dev-packages.txt (v2 — AKTUALISIERT)

```
# mr-bytez Development Package Set v2
# Zusaetzlich zu min-packages.txt + desktop-packages.txt
# Aktualisiert: 2026-02-26

# === Container ===
docker
docker-compose
docker-buildx
lazydocker

# === Development ===
nodejs
npm
python
python-pip

# === Linting (NEU in v2) ===
shellcheck   # Fish/Bash Script-Linting

# === Cloud & Sync ===
rclone

# === Editor ===
visual-studio-code-bin  # (AUR)

# === Netzwerk-Diagnose ===
nmap
tcpdump
iotop

# === Security ===
ufw
unbound

# === Optional (bei Bedarf aktivieren) ===
# shfmt       # Shell-Formatter (kein Fish-Support)
# tokei       # Code-Statistiken
# hyperfine   # Benchmark-Tool
# helix       # Alternativer Editor
```

**Aenderungen gegenueber v1:**
- `shellcheck` hinzugefuegt (empfohlen fuer Script-Qualitaet)
- Doppeltes `rclone` entfernt
- Optionale Tools als Kommentare

---

## 4. Zusaetzliche Entdeckungen

### 4.1 Backup-Dateien

| Datei | Groesse | Status | Empfehlung |
|-------|---------|--------|------------|
| `shared/etc/fish/themes/mr-bytez.fish.v1.0.bak` | 13KB | Veraltet (v1.0 Backup, aktiv ist v2.0) | ENTFERNEN |

Keine weiteren .bak/.old/.orig/.backup Dateien im Repo gefunden.

### 4.2 Verwaiste/Ungenutzte Scripts

**Ergebnis: KEINE gefunden.**

Alle Scripts werden referenziert:
- Deployment-Scripts: In CHANGELOG, README, ROADMAP dokumentiert
- Shared Functions: Ueber fish_function_path automatisch geladen
- Host-Test-Functions: Diagnostik-Helper (nicht automatisch geladen, aber benoetigt)
- Alias-Dateien: Alle vom Loader geladen

### 4.3 Temp/Cache-Dateien

Einige .tmp und Thumbs.db in `projects/web/grills-reduziert.de/` — alle korrekt per `.gitignore` ausgeschlossen. Kein Handlungsbedarf.

### 4.4 n8-vps Paket-Luecken (Zusammenfassung)

n8-vps hat die meisten fehlenden Pakete aus dem min-Set:

| Paket | Status | Prioritaet |
|-------|--------|-----------|
| duf | ❌ | HOCH (df-Alias bricht ohne) |
| dust | ❌ | HOCH (du-Alias bricht ohne) |
| htop | ❌ | MITTEL (top-Alias) |
| ripgrep | ❌ | HOCH (grep-Modernisierung) |
| less | ❌ | HOCH (Pager fuer bat/man/git) |
| fd | ❌ | NIEDRIG (Server braucht kein fd) |

**Aktion vor A2:** `pacman -S duf dust htop ripgrep less` auf n8-vps ausfuehren.

### 4.5 Header-Format Standards (2 aktive)

**Standard 1: Deployment-Scripts (7-Feld)**
```fish
#!/usr/bin/env fish
# ============================================
# dateiname.fish — Kurzbeschreibung
# Pfad: /pfad/zur/datei.fish
# Autor: MR-ByteZ
# Erstellt: YYYY-MM-DD
# Version: X.Y.Z
# Zweck: Detaillierte Beschreibung
# ============================================
```

**Standard 2: Config/Shared (9-Zeilen-Box)**
```fish
# ╔══════════════════════════════════════════╗
# ║  Beschreibung                            ║
# ╠══════════════════════════════════════════╣
# ║  Pfad:     /pfad/zur/datei.fish          ║
# ║  Autor:    Michael Rohwer                ║
# ║  Version:  X.Y.Z                        ║
# ║  Erstellt: YYYY-MM-DD                   ║
# ║  Zweck:    Detaillierte Beschreibung     ║
# ╚══════════════════════════════════════════╝
```

**Empfehlung:** Beide Standards beibehalten. Standard 1 fuer ausfuehrbare Scripts, Standard 2 fuer Config-Dateien die vom Loader geladen werden.

---

## 5. Empfehlungen fuer A2

### Sofort (vor A2)

1. **n8-vps Pakete installieren:** `duf dust htop ripgrep less`
2. **n8-station Pakete installieren:** `docker-buildx lazydocker nodejs npm ncdu`
3. **Backup entfernen:** `mr-bytez.fish.v1.0.bak`

### A2 Phase: format.fish Library erstellen

4. **`shared/lib/format.fish` erstellen** mit:
   - _msg, _success, _error, _warn (aus den 3 Duplikaten)
   - _skip, _link, _copy, _section (aus deploy.fish)
   - Theme-Integration (nutze $theme_* Variablen mit Fallback)
5. **3 Scripts refactoren:** deploy.fish, pack-secrets.fish, unpack-secrets.fish
   - Lokale Funktions-Definitionen entfernen
   - `source shared/lib/format.fish` hinzufuegen
6. **2 Scripts optional:** derive_key.fish, scan-secrets.fish
   - Inline-set_color durch Library-Funktionen ersetzen

### A2 Phase: Header-Standardisierung

7. **Fehlende Header ergaenzen** in:
   - scan-secrets.fish (nur Kommentar → 7-Feld)
   - generate_pwd.fish (kein Banner → optional)
8. **Header verifizieren** in:
   - 60-pacman.fish, 65-fastfetch.fish, 90-misc.fish
   - fish_right_prompt.fish, fish_greeting.fish, fish_mode_prompt.fish
   - __mr_host_color.fish, __mr_smart_pwd.fish, __mr_git_status.fish, __mr_docker_status.fish
   - theme.fish
   - Alle 70-desktop.fish, Host-Variable-Dateien

### Paketlisten pflegen

9. **Paketlisten als Dateien im Repo ablegen:**
   - `shared/packages/min-packages.txt`
   - `shared/packages/desktop-packages.txt`
   - `shared/packages/dev-packages.txt`
10. **Installationsscript erstellen** (spaeter, nach A2):
    - `shared/scripts/install-packages.fish` — liest min/desktop/dev und installiert fehlende

---

*Report generiert am 2026-02-26 durch Claude Code (Opus 4.6)*
*Keine Dateien wurden geaendert — reine Analyse (ausser dieser Report-Datei).*
