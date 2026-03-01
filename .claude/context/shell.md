# Shell — Fish-first & Konfiguration

**Version:** 1.1.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-03-01
**Autor:** MR-ByteZ

---

## Fish-first Prinzip

Fish ist die **Referenz-Shell** fuer Skripte und Beispiele in diesem Projekt.

### Verboten in Fish

- **Keine Heredocs/EOF** (`cat <<EOF` funktioniert nicht!)
- **Keine Bash-Syntax** (`$(command)` → `(command)`, `export` → `set -x`)
- **Kein `&&`** — Fish nutzt `; and` oder Befehle untereinander

### Datei-Generierung

**Kleine Dateien (1-5 Zeilen):**
```fish
echo 'erste Zeile' > datei.txt
echo 'zweite Zeile' >> datei.txt
```

**Groessere Dateien (6+ Zeilen):**
```fish
printf '%s\n' \
    'Zeile 1' \
    'Zeile 2' \
    'Zeile 3' \
    > datei.txt
```

**Sehr komplexe Dateien (20+ Zeilen):**
→ IMMER Editor verwenden (micro/code)

### Alias-Fallen

- `cat` kann auf `bat` gemappt sein → `command cat` verwenden (→ `.claude/context/security.md`)
- `grep` kann Alias haben → `command grep` verwenden

### command-Prefix Pflicht in Scripts

Fish-Aliases ueberschreiben Standard-Linux-Commands. In **allen Scripts** (.fish)
muessen diese Commands mit `command`-Prefix verwendet werden:

| Risiko | Command | Neuer Alias | Tool | Problem |
|--------|---------|-------------|------|---------|
| **HOCH** | `cat` | bcat | bat --color=auto | Anderes Output-Format, Farbcodes |
| **HOCH** | `grep` | (kein Alias) | ripgrep direkt: `rg` | Bricht Pipes |
| **HOCH** | `ls` | el | eza --icons | Anderes Format, Icons |
| **HOCH** | `df` | duf | duf | Komplett anderes Programm |
| **HOCH** | `du` | dust | dust | Komplett anderes Programm |
| mittel | `rm` | rmi | rm -Iv | Interaktive Rueckfrage |
| mittel | `cp` | cpi | cp -iv | Interaktive Rueckfrage |
| mittel | `mv` | mvi | mv -iv | Interaktive Rueckfrage |

**Regel:** `command cat`, `command grep`, `command ls` etc. in Scripts — IMMER.
Die Originale (cat, ls, grep, df, du, rm, cp, mv) sind seit A2 Phase 1 **alias-frei** (unveraenderte coreutils).

**Hintergrund:** cat-Alias mit `--color=always` hat ANSI-Farbcodes in authorized_keys
geschrieben und SSH Key-Auth kaputt gemacht (Bug gefunden 2026-02-25, gefixt).

---

## Fish Loader System

Zentraler Loader: `shared/etc/fish/conf.d/000-loader.fish` (v0.5.0)

### Nummerierungsschema

| Bereich | Nummern | Beschreibung |
|---------|---------|--------------|
| Shared | 000-099 | Alle Hosts laden diese Dateien |
| Host | 100-200 | Nur der jeweilige Host |

5er-Schritte fuer Erweiterbarkeit. Zero-Padded (010, nicht 10).

### Wichtige Dateien

| Datei | Nummer | Beschreibung |
|-------|--------|-------------|
| 000-loader.fish | conf.d | Einschleifiger Loader (6 Verzeichnisse) |
| 005-theme.fish | conf.d | Prompt, Farben, Theme-System (Gruvbox) |
| 008-host-flags.fish | conf.d | Feature-Flags per switch/case |
| 010-nav.fish | aliases | Navigation + sichere Datei-Ops (rmi, cpi, mvi) |
| 015-eza.fish | aliases | el + eza-Aliases (ll, la, lt, ...) |
| 020-docker.fish | aliases | Docker Compose Shortcuts |
| 025-git.fish | aliases | Git Shortcuts (gs, ga, gc, gp, ...) |
| 030-systemd.fish | aliases | Systemd/Journalctl Shortcuts |
| 035-pacman.fish | aliases | Pacman/Yay (Headless-Basis, upa ohne Flatpak) |
| 040-fastfetch.fish | aliases | Fastfetch Alias |
| 045-misc.fish | aliases | Diverse: bcat, duf, dust, Editoren, Monitoring |
| 050-gui.fish | aliases | GUI-Conditional (Self-Check: MR_HAS_GUI) |
| 055-dev.fish | aliases | DEV-Conditional (Self-Check: MR_IS_DEV) |
| 110-n8-*.fish | aliases | Host-spezifische Aliases (pro Host) |

### Einschleifiger Loader (v0.5.0)

Der Loader iteriert ueber 6 Verzeichnisse in fester Reihenfolge:

```
1. Shared conf.d    → 005-theme, 008-host-flags
2. Shared aliases   → 010-055
3. Shared variables → 010-paths
4. Host conf.d      → (zukunftssicher, aktuell leer)
5. Host aliases     → 110-n8-*.fish
6. Host variables   → (zukunftssicher, aktuell leer)
```

Innerhalb jedes Verzeichnisses: Glob sortiert numerisch (zero-padded).
Shared (000-099) laedt immer VOR Host (100-200).

### Debug-Modus

```fish
set -gx FISH_LOADER_DEBUG 1
exec fish
# Zeigt alle geladenen Dateien in stderr
```

---

## Feature-Flags

Gesetzt in `008-host-flags.fish` per `switch (hostname)`:

| Flag | Werte | Beschreibung |
|------|-------|-------------|
| MR_HAS_GUI | true/false | Hat der Host eine GUI? |
| MR_IS_DEV | true/false | Ist der Host ein Dev-Host? |
| MR_DISPLAY_TYPE | 4k/1920/headless | Display-Aufloesung |

### Host-Matrix

| Host | MR_HAS_GUI | MR_IS_DEV | MR_DISPLAY_TYPE |
|------|------------|-----------|-----------------|
| n8-kiste | true | true | 4k |
| n8-station | true | true | 4k |
| n8-book | true | true | 1920 |
| n8-vps | false | true | headless |
| n8-maxx | true | false | 4k |
| n8-bookchen | true | false | 1920 |
| n8-broker | true | false | 4k |
| n8-archstick | true | false | 1920 |

### Self-Check Pattern

Jede Conditional-Datei prueft ihren eigenen Flag am Anfang:

```fish
# 050-gui.fish — Nur laden wenn GUI vorhanden
test "$MR_HAS_GUI" != "true"; and return

# Ab hier: GUI-spezifischer Code
```

```fish
# 055-dev.fish — Nur laden wenn DEV-Host
test "$MR_IS_DEV" != "true"; and return

# Ab hier: DEV-spezifischer Code
```

---

## Verzeichnisstruktur

### Shared (alle Hosts)

```
shared/etc/fish/
├── conf.d/          Loader (000) + Theme (005) + Host-Flags (008)
├── aliases/         Shared Aliases (010-055, nummeriert)
├── variables/       Pfad-Variablen (010-paths)
├── functions/       Fish Functions (Prompt, Helpers, mr-bytez-info)
├── themes/          Theme-Definitionen (mr-bytez.fish, Gruvbox)
├── skills/          Schritt-fuer-Schritt Anleitungen
├── .claude/context/ Fish-spezifische Policies
└── 5-5-3 Docs      CLAUDE.md, README.md, CHANGELOG.md, ROADMAP.md, DEPLOYMENT.md
```

### Host-spezifisch (pro Host)

```
projects/infrastructure/<hostname>/root/home/<user>/.config/fish/
├── conf.d/          Host conf.d (zukunftssicher)
├── aliases/         Host Aliases (110-n8-*.fish)
├── variables/       Host Variables (zukunftssicher)
└── functions/       Host Functions (Vorrang vor shared)
```

---

## Theme System

- Basiert auf **Gruvbox** Farbschema
- Semantische Variablen: `theme_primary`, `theme_error`, `theme_warning`, `theme_success`
- Helper-Funktionen: `__msg`, `__success`, `__warn`, `__error`, `__header`
- Host-spezifische Prompt-Farben via `__mr_host_color.fish`
- Powerline-Prompt mit Git-Status, Docker-Status, Smart-PWD

---

## Fish-Syntax Kurzreferenz

| Bash | Fish |
|------|------|
| `export VAR=value` | `set -x VAR value` |
| `$(command)` | `(command)` |
| `$HOME/.config` | `$HOME/.config` (gleich) |
| `if [ -f file ]` | `if test -f file` |
| `cat <<EOF` | `printf '%s\n' ...` |
| `source ~/.bashrc` | `source ~/.config/fish/config.fish` |
| `cmd1 && cmd2` | `cmd1; and cmd2` |

---

## Bash (Sekundaer)

Fuer Faelle wo Bash noetig ist (z.B. `scripts/hwi/hwi.sh`):

- Shebang: `#!/bin/bash`
- `set -euo pipefail` immer verwenden
- 2 Spaces Indentation
- Variablen: `"${variable}"` mit Quotes und Curly Braces

Minimale `.bashrc` unter `shared/etc/bash/.bashrc` fuer Hosts ohne Fish als Default-Shell.
