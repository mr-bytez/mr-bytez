# Fish Config Refactoring - Arbeitsanweisung

**Version:** 2.1  
**Erstellt:** 2026-01-31  
**Status:** [TODO] In Bearbeitung  
**Zweck:** DRY-Refactoring der Fish Shell Konfiguration  

---

## 5-3-3 Dokumentationsstruktur

### 5 Core Documents

| Dokument | Zweck | Status |
|----------|-------|--------|
| `README.md` | Übersicht, Quick-Start, Installation | [ ] TODO |
| `CLAUDE.md` | KI-Kontext, Projekt-Spezifika für Claude | [ ] TODO |
| `CHANGELOG.md` | Versionshistorie, Breaking Changes | [ ] TODO |
| `ROADMAP.md` | Geplante Features, Phasen, Milestones | [ ] TODO |
| `DEPLOYMENT.md` | Host-spezifische Deployment-Anleitung | [ ] TODO |

### 3 Organizational Folders

```
fish-config/
├── context/           # Hintergrund-Dokumentation
│   ├── ARCHITEKTUR.md       # Schema-Erklärung 000-100/101-200
│   ├── HOST_MATRIX.md       # Alle Hosts mit Flags
│   └── MIGRATION.md         # Alt → Neu Mapping
│
├── skills/            # How-To Anleitungen
│   ├── NEUER_HOST.md        # Anleitung: neuen Host hinzufügen
│   ├── NEUES_CONDITIONAL.md # Anleitung: neues Feature-Flag
│   └── DEBUGGING.md         # Troubleshooting Loader/Flags
│
└── configs/           # Referenz-Configs & Templates
    ├── 105-host.template.fish
    ├── 050-gui.fish
    └── 055-dev.fish
```

### 3 Hierarchical Levels

| Level | Pfad | Inhalt |
|-------|------|--------|
| **Shared** | `/usr/local/share/fish/` | 000-100 Dateien, für alle Hosts |
| **Host** | `~/.config/fish/` | 101-200 Dateien, host-spezifisch |
| **User** | `~/.config/fish/` | 190-199 User-Tweaks (optional) |

---

## Ziel

Umstellung von duplizierten Host-Configs auf ein DRY-System mit:
- Feature-Flags (MR_HAS_GUI, MR_IS_DEV, MR_DISPLAY_TYPE)
- Shared Conditionals mit Self-Check
- Klare Trennung: Shared vs Host durch Nummerierung

---

## Nummerierungsschema (NEU)

### Grundregel

| Bereich | Bedeutung |
|---------|-----------|
| `000-100` | **SHARED** (alle Hosts laden diese) |
| `101-200` | **HOST** (nur der jeweilige Host) |

**5er-Schritte** für Erweiterbarkeit.

---

### SHARED (000-100)

```
000-loader.fish        Basis-Loader (lädt alles andere)
005-theme.fish         Powerline/Theme Setup

010-nav.fish           Navigation Aliases (cd, z, etc.)
015-eza.fish           Eza Aliases (ls Ersatz)
020-docker.fish        Docker Aliases
025-git.fish           Git Aliases
030-systemd.fish       Systemd Aliases
035-pacman.fish        Pacman/Yay Aliases
040-fastfetch.fish     Fastfetch Alias
045-misc.fish          Sonstige Aliases

050-gui.fish           GUI-Conditional (nur wenn MR_HAS_GUI=true)
055-dev.fish           DEV-Conditional (nur wenn MR_IS_DEV=true)

060-095               Reserviert für zukünftige Erweiterungen
100                   Ende Shared-Bereich
```

### HOST (101-200)

```
105-host.fish          Host-Flags setzen (MR_HAS_GUI, MR_IS_DEV, MR_DISPLAY_TYPE)
110-hostname.fish      Host-spezifische Aliases (n8-kiste.fish, n8-vps.fish, etc.)

115-200               Reserviert für zukünftige Erweiterungen
```

---

## Feature-Flags

### Übersicht

| Flag | Typ | Werte | Beschreibung |
|------|-----|-------|--------------|
| `MR_HAS_GUI` | bool | `true`/`false` | Hat grafische Oberfläche |
| `MR_IS_DEV` | bool | `true`/`false` | Ist Development-Host |
| `MR_DISPLAY_TYPE` | string | `4k`/`1920`/`headless` | Display-Auflösung |

### Host-Matrix

| Host | MR_HAS_GUI | MR_IS_DEV | MR_DISPLAY_TYPE |
|------|------------|-----------|-----------------|
| n8-kiste | true | true | 4k |
| n8-station | true | true | 4k |
| n8-book | true | true | 1920 |
| n8-maxx | true | false | 4k |
| n8-bookchen | true | false | 1920 |
| n8-broker | true | false | 4k |
| n8-archstick | true | false | 1920 |
| n8-vps | false | true | headless |

---

## Datei-Umbenennung

### Shared Aliases (Umbenennung)

| Alt | Neu |
|-----|-----|
| `10-nav.fish` | `010-nav.fish` |
| `20-eza.fish` | `015-eza.fish` |
| `30-docker.fish` | `020-docker.fish` |
| `40-git.fish` | `025-git.fish` |
| `50-systemd.fish` | `030-systemd.fish` |
| `60-pacman.fish` | `035-pacman.fish` |
| `65-fastfetch.fish` | `040-fastfetch.fish` |
| `90-misc.fish` | `045-misc.fish` |

### Shared Neu erstellen

| Datei | Inhalt |
|-------|--------|
| `050-gui.fish` | GUI-spezifisch (Flatpak, Power-Management, Session-Lock) |
| `055-dev.fish` | DEV-spezifisch (rsync, rclone base, curl helpers) |

### Host-Dateien (Umbenennung)

| Alt | Neu |
|-----|-----|
| `variables/10-display.fish` | `105-host.fish` |
| `aliases/70-desktop.fish` | **ENTFÄLLT** (→ 050-gui.fish) |
| `aliases/70-server.fish` | **ENTFÄLLT** (→ Duplikate entfernen) |
| `aliases/80-n8-kiste.fish` | `110-n8-kiste.fish` |
| `aliases/80-n8-vps.fish` | `110-n8-vps.fish` |

---

## Self-Check Pattern

Jede Conditional-Datei prüft ihren eigenen Flag am Anfang:

```fish
# 050-gui.fish
# Nur laden wenn GUI vorhanden
test "$MR_HAS_GUI" != "true"; and return

# Ab hier: GUI-spezifischer Code
# Flatpak, Power-Management, etc.
```

```fish
# 055-dev.fish
# Nur laden wenn DEV-Host
test "$MR_IS_DEV" != "true"; and return

# Ab hier: DEV-spezifischer Code
# rsync, rclone base, etc.
```

---

## Loader-Anpassung

Der Loader muss angepasst werden für das neue Schema:

```fish
# Shared laden (000-100)
for file in $shared_path/conf.d/0*.fish
    source $file
end

# Host laden (101-200)
for file in $host_path/1*.fish
    source $file
end
```

**Wichtig:** Host 105-host.fish muss VOR Shared 050-gui.fish laden!

### Lade-Reihenfolge

```
1. 000-loader.fish (Shared)
2. 005-theme.fish (Shared)
3. 010-045 Aliases (Shared)
4. === HOST 105-host.fish === (setzt Flags!)
5. 050-gui.fish (Shared, prüft MR_HAS_GUI)
6. 055-dev.fish (Shared, prüft MR_IS_DEV)
7. 110-hostname.fish (Host-spezifisch)
```

---

## 050-gui.fish Inhalt

Extrahiert aus altem `70-desktop.fish`:

```fish
# 050-gui.fish - GUI-spezifische Aliases
# Nur laden wenn GUI vorhanden
test "$MR_HAS_GUI" != "true"; and return

# === Flatpak Integration ===
alias upfl='flatpak update'
alias upflc='flatpak uninstall --unused'

# upa mit Flatpak (überschreibt Server-Version)
function upa -d "Update all: pacman + AUR + Flatpak"
    echo "📦 Pacman..."
    sudo pacman -Syu
    echo "🔧 AUR..."
    yay -Sua
    echo "📱 Flatpak..."
    flatpak update
end

# === Power Management ===
function zzz -d "Suspend to RAM"
    systemctl suspend
end

function zzzh -d "Hibernate to disk"
    systemctl hibernate
end

function zzzx -d "Hybrid sleep"
    systemctl hybrid-sleep
end

# === Session Lock Helpers ===
function __current_session_id
    loginctl list-sessions --no-legend | awk '{print $1}' | head -1
end

function __lock_session
    set session_id (__current_session_id)
    test -n "$session_id"; and loginctl lock-session $session_id
end
```

---

## 055-dev.fish Inhalt

DEV-spezifische Aliases:

```fish
# 055-dev.fish - Development-spezifische Aliases
# Nur laden wenn DEV-Host
test "$MR_IS_DEV" != "true"; and return

# === Rsync Shortcuts ===
alias rcp='rsync -avzP'
alias rmv='rsync -avzP --remove-source-files'
alias rsync-dry='rsync -avzPn'

# === Rclone Base ===
alias rcls='rclone ls'
alias rclsd='rclone lsd'
alias rcstat='rclone about'

# === Curl/Wget Helpers ===
alias curljson='curl -H "Content-Type: application/json"'
alias curlhead='curl -I'
alias wget-mirror='wget --mirror --convert-links --page-requisites'

# === Tar Shortcuts ===
alias tarx='tar -xvf'
alias tarc='tar -cvzf'
alias tarl='tar -tvf'

# === Code Helpers ===
alias codew='code --wait'
alias coder='code --reuse-window'
```

---

## 105-host.fish Template

Für jeden Host erstellen:

```fish
# 105-host.fish - Host-Flags für [HOSTNAME]
# Wird VOR Shared Conditionals geladen!

# === Feature Flags ===
set -gx MR_HAS_GUI true      # oder false
set -gx MR_IS_DEV true       # oder false
set -gx MR_DISPLAY_TYPE 4k   # oder 1920/headless

# === Display Config (nur wenn GUI) ===
if test "$MR_HAS_GUI" = "true"
    switch $MR_DISPLAY_TYPE
        case 4k
            set -gx GDK_SCALE 2
            set -gx QT_SCALE_FACTOR 2
        case 1920
            set -gx GDK_SCALE 1
            set -gx QT_SCALE_FACTOR 1
    end
end
```

---

## Phasen-Plan

### Phase 0: 5-3-3 Dokumentation aufsetzen
- [ ] Ordnerstruktur erstellen (context/, skills/, configs/)
- [ ] README.md erstellen
- [ ] CLAUDE.md erstellen
- [ ] CHANGELOG.md erstellen
- [ ] ROADMAP.md erstellen
- [ ] DEPLOYMENT.md erstellen

### Phase 1: Vorbereitung
- [ ] Backup aktuelle Configs
- [ ] Loader-Logik verstehen und dokumentieren
- [ ] context/ARCHITEKTUR.md erstellen
- [ ] context/HOST_MATRIX.md erstellen
- [ ] context/MIGRATION.md erstellen

### Phase 2: Shared Umbenennen
- [ ] 10-nav → 010-nav
- [ ] 20-eza → 015-eza
- [ ] 30-docker → 020-docker
- [ ] 40-git → 025-git
- [ ] 50-systemd → 030-systemd
- [ ] 60-pacman → 035-pacman
- [ ] 65-fastfetch → 040-fastfetch
- [ ] 90-misc → 045-misc

### Phase 3: Shared Conditionals erstellen
- [ ] 050-gui.fish erstellen
- [ ] 055-dev.fish erstellen

### Phase 4: Host-Dateien
- [ ] 105-host.fish für jeden Host erstellen
- [ ] 110-hostname.fish für jeden Host (aus alten 80-*.fish)
- [ ] Alte 70-desktop/server.fish löschen

### Phase 5: Loader anpassen
- [ ] Neue Lade-Reihenfolge implementieren
- [ ] Host-Flags VOR Shared-Conditionals laden

### Phase 6: Test
- [ ] n8-kiste testen (GUI + DEV)
- [ ] n8-vps testen (kein GUI, nur DEV)
- [ ] Restliche Hosts

### Phase 7: Skills-Dokumentation
- [ ] skills/NEUER_HOST.md erstellen
- [ ] skills/NEUES_CONDITIONAL.md erstellen
- [ ] skills/DEBUGGING.md erstellen
- [ ] configs/ Templates finalisieren

---

## Validierung

Nach Refactoring prüfen:

```fish
# Flags gesetzt?
echo $MR_HAS_GUI
echo $MR_IS_DEV
echo $MR_DISPLAY_TYPE

# GUI-Aliases vorhanden? (nur wenn MR_HAS_GUI=true)
type zzz
type upfl

# DEV-Aliases vorhanden? (nur wenn MR_IS_DEV=true)
type rcp
type rcls

# Host-spezifisch?
type [host-spezifischer-alias]
```

---

## Offene Fragen

1. **Loader-Umbau:** Wie genau Host 105 VOR Shared 050 laden?
   - Option A: Zwei Durchläufe (erst Host-Flags, dann Shared)
   - Option B: Loader explizit 105-host.fish zuerst sourcen

2. **User-Tweaks:** Behalten wir 90-99 für User-Tweaks?
   - Aktuell: Shared + Host 90-99
   - Vorschlag: Host 190-199 für User-Tweaks

---

**Ende Arbeitsanweisung**
