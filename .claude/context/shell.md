# Shell — Fish-first & Konfiguration

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-25
**Autor:** MR-ByteZ

---

## Fish-first Prinzip

Fish ist die **Referenz-Shell** für Skripte und Beispiele in diesem Projekt.

### Verboten in Fish

- **Keine Heredocs/EOF** (`cat <<EOF` funktioniert nicht!)
- **Keine Bash-Syntax** (`$(command)` → `(command)`, `export` → `set -x`)

### Datei-Generierung

**Kleine Dateien (1-5 Zeilen):**
```fish
echo 'erste Zeile' > datei.txt
echo 'zweite Zeile' >> datei.txt
```

**Größere Dateien (6+ Zeilen):**
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

| Risiko | Command | Alias → | Problem |
|--------|---------|---------|---------|
| **HOCH** | `cat` | bat --color=auto | Anderes Output-Format, Farbcodes |
| **HOCH** | `grep` | function mit Info-Zeile auf stdout | Bricht Pipes |
| **HOCH** | `ls` | eza --icons | Anderes Format, Icons |
| **HOCH** | `df` | duf | Komplett anderes Programm |
| **HOCH** | `du` | dust | Komplett anderes Programm |
| mittel | `rm` | rm -Iv | Interaktive Rueckfrage |
| mittel | `cp` | cp -iv | Interaktive Rueckfrage |
| mittel | `mv` | mv -iv | Interaktive Rueckfrage |

**Regel:** `command cat`, `command grep`, `command ls` etc. in Scripts — IMMER.

**Hintergrund:** cat-Alias mit `--color=always` hat ANSI-Farbcodes in authorized_keys
geschrieben und SSH Key-Auth kaputt gemacht (Bug gefunden 2026-02-25, gefixt → `--color=auto`).

→ Langfristige Loesung: A2 Fish DRY-Refactoring (Alias-Umbenennung)

---

## Fish Loader System

Zentraler Loader: `shared/etc/fish/conf.d/00-loader.fish` (v2.1)

### Lade-Reihenfolge (Nummer = Priorität)

| Range | Bereich | Beschreibung |
|-------|---------|--------------|
| 00-09 | Theme + Basis | Nur shared (00-theme.fish, 00-loader.fish) |
| 10-69 | Shared → Host | Aliases, Variables (shared zuerst, host ergänzt) |
| 70-79 | Host-Kategorie | Desktop/Server Overrides |
| 80-89 | Host-spezifisch | Höchste Priorität für Overrides |
| 90-99 | User-Tweaks | Optionale persönliche Anpassungen |

### Debug-Modus

```fish
set -x FISH_LOADER_DEBUG 1
# Zeigt alle geladenen Dateien in stderr
```

---

## Verzeichnisstruktur

### Shared (alle Hosts)

```
shared/etc/fish/
├── conf.d/          # Loader + Theme (00-09)
├── aliases/         # Alias-Dateien (10-90)
├── variables/       # Variable-Dateien (10-90)
├── functions/       # Shared Functions
└── themes/          # Theme-Definitionen (mr-bytez.fish)
```

### Host-spezifisch (pro Host)

```
projects/infrastructure/<hostname>/root/home/<user>/.config/fish/
├── conf.d/          # Host conf.d (70-89)
├── aliases/         # Host Aliases (70-89)
├── variables/       # Host Variables (70-89)
└── functions/       # Host Functions (Vorrang vor shared)
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

---

## Bash (Sekundär)

Für Fälle wo Bash nötig ist (z.B. `scripts/hwi/hwi.sh`):

- Shebang: `#!/bin/bash`
- `set -euo pipefail` immer verwenden
- 2 Spaces Indentation
- Variablen: `"${variable}"` mit Quotes und Curly Braces
