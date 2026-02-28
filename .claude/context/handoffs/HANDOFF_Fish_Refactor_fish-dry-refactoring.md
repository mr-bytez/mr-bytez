# HANDOFF: A2 Fish DRY-Refactoring

**Version:** 3.0
**Erstellt:** 2026-01-31
**Aktualisiert:** 2026-02-27
**Status:** 🟡 Phase 0+1+2 abgeschlossen — Phase 3 als naechstes
**Zweck:** DRY-Refactoring der Fish Shell Konfiguration aller 8 Hosts
**Autor:** MR-ByteZ

**Chat-Kette:** #FSH01.1 → #FSH01.2 → #FSH01.3 → ...
**Chat-Links:**
- #FSH01.1: https://claude.ai/chat/2bdd7e90-524e-4c48-807f-8f3b2815ee10
- #FSH01.2: https://claude.ai/chat/2423f16b-1f67-404a-b298-b1e9c71fe165
- #FSH01.3: https://claude.ai/chat/CURRENT
- #FSH01.4: https://claude.ai/chat/CURRENT

---

## Ziel

Umstellung von duplizierten Host-Configs auf ein DRY-System mit:
- Feature-Flags (MR_HAS_GUI, MR_IS_DEV, MR_DISPLAY_TYPE)
- Shared Conditionals mit Self-Check Pattern
- Klare Trennung: Shared (000-100) vs Host (101-200) durch Nummerierung
- Einheitliche Header, Versionierung und Formatierung aller Fish-Dateien
- Alias-Sicherheit: Originalnamen freilassen, neue sichere Aliases

**Kernproblem:** 70-desktop.fish ist bei 7 Hosts IDENTISCH kopiert (DRY-Verletzung).

---

## Entschiedene Punkte (aus #FSH01.1 + #FSH01.2 + #FSH01.3)

### ✅ Nummerierungsschema
- 000-100 = Shared (alle Hosts), 101-200 = Host-spezifisch
- 5er-Schritte fuer Erweiterbarkeit
- Host-Flags als **008-host-flags.fish** im Shared-Bereich (NICHT 105!)
- Loader bleibt einschleifig, numerisch sortiert

### ✅ Alias-Naming (Originale freilassen)

| Original | Neuer Alias | Tool | Risiko |
|----------|-------------|------|--------|
| cat | bcat | bat --color=always | HOCH |
| grep | rg | ripgrep | HOCH |
| ls | el | eza mit Icons + Optionen | HOCH |
| df | duf | duf (mit bisherigen Optionen) | HOCH |
| du | dust | dust (mit bisherigen Optionen) | HOCH |
| rm | rmi | rm -Iv (interaktiv) | MITTEL |
| cp | cpi | cp -iv (interaktiv) | MITTEL |
| mv | mvi | mv -iv (interaktiv) | MITTEL |

**Regel:** cat, ls, grep, df, du, rm, cp, mv = unveraenderte coreutils. Kein Alias mehr!

### ✅ Versionierung
- Alle neuen/geaenderten Dateien: Version 0.1.0
- Erst nach bewaehrtem Einsatz ohne Fixes → 1.0.0
- Version als Variable im Script UND im Header-Kommentar

### ✅ Header-Standard fuer Fish-Dateien

Kompakt-Banner (`┌──┘`) fuer alle Scripts:
```fish
#!/usr/bin/env fish
# ┌─────────────────────────────────────────────┐
# │  MR-ByteZ Fish Config                       │
# │  Datei: 010-nav.fish                        │
# │  Zweck: Navigation Aliases                  │
# │  Version: 0.1.0                             │
# │  Autor: MR-ByteZ                            │
# │  Erstellt: 2026-02-27                       │
# └─────────────────────────────────────────────┘
```

### ✅ 5-5-3 Pattern (nicht 5-3-3!)
- 5 Docs, 5 Ordner, 3 Ebenen
- configs/ existiert nicht mehr → context/ stattdessen

### ✅ Scope-Abgrenzung
- A2 = NUR Fish-bezogene Aufgaben
- Audits 5-8, Header-Audit repo-weit, fail2ban → eigene Tasks
- B-Tasks (B5, B6, B7, B17) als "mitlaufend" markiert

---

## Nummerierungsschema

### SHARED (000-100) — alle Hosts laden diese

```
000-loader.fish          Basis-Loader (laedt alles andere)
005-theme.fish           Powerline/Theme Setup, Prompt-Farben
008-host-flags.fish      Host-Flags setzen (switch/case auf $hostname)
                         MUSS vor 050/055 laden!

010-nav.fish             Navigation (cd, z, .., ...)
015-eza.fish             el + eza-Aliases
020-docker.fish          Docker Aliases (dps, dco, dcu...)
025-git.fish             Git Aliases (gs, ga, gc, gp...)
030-systemd.fish         Systemd Aliases
035-pacman.fish          Pacman/Yay Aliases
040-fastfetch.fish       Fastfetch Alias
045-misc.fish            Sonstige Aliases (bcat, duf, dust, rg, rmi, cpi, mvi...)

050-gui.fish             GUI-Conditional → test "$MR_HAS_GUI" != "true"; and return
055-dev.fish             DEV-Conditional → test "$MR_IS_DEV" != "true"; and return

060-099                  Reserviert fuer zukuenftige Shared-Erweiterungen
```

### HOST (101-200) — nur der jeweilige Host

```
110-n8-kiste.fish        Host-spezifische Aliases/Variablen
110-n8-vps.fish          (jeder Host hat seine eigene 110er Datei)
110-n8-station.fish
...

190-199                  User-Tweaks (optional, persoenliche Anpassungen)
```

**Lade-Reihenfolge im Loader (eine einzige Schleife):**
```
000 → 005 → 008 → 010 → 015 → ... → 045 → 050(prueft Flag) → 055(prueft Flag) → ... → 110 → 190
```

---

## Feature-Flags

### Host-Matrix

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

### 008-host-flags.fish (Shared, switch/case)

```fish
# 008-host-flags.fish — Host Feature-Flags
switch (hostname)
    case n8-kiste
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE 4k
    case n8-vps
        set -gx MR_HAS_GUI false
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE headless
    case n8-station
        set -gx MR_HAS_GUI true
        set -gx MR_IS_DEV true
        set -gx MR_DISPLAY_TYPE 4k
    # ... weitere Hosts
    case '*'
        # Unbekannter Host: Sicherer Default
        set -gx MR_HAS_GUI false
        set -gx MR_IS_DEV false
        set -gx MR_DISPLAY_TYPE headless
end
```

---

## Self-Check Pattern

Jede Conditional-Datei prueft ihren eigenen Flag am Anfang:

```fish
# 050-gui.fish — Nur laden wenn GUI vorhanden
test "$MR_HAS_GUI" != "true"; and return

# Ab hier: GUI-spezifischer Code
# Flatpak, Power-Management, Session-Lock, etc.
```

```fish
# 055-dev.fish — Nur laden wenn DEV-Host
test "$MR_IS_DEV" != "true"; and return

# Ab hier: DEV-spezifischer Code
# rsync, rclone base, curl helpers, Code Aliases
```

---

## Datei-Umbenennung (Alt → Neu)

### Shared Aliases

| Alt | Neu | Aenderung |
|-----|-----|-----------|
| 10-nav.fish | 010-nav.fish | Nur Nummer |
| 20-eza.fish | 015-eza.fish | Nummer + Alias-Umbenennung (ls→el) |
| 30-docker.fish | 020-docker.fish | Nur Nummer |
| 40-git.fish | 025-git.fish | Nur Nummer |
| 50-systemd.fish | 030-systemd.fish | Nur Nummer |
| 60-pacman.fish | 035-pacman.fish | Nur Nummer |
| 65-fastfetch.fish | 040-fastfetch.fish | Nur Nummer |
| 90-misc.fish | 045-misc.fish | Nummer + Alias-Umbenennung |

### Shared Neu erstellen

| Datei | Inhalt | Quelle |
|-------|--------|--------|
| 008-host-flags.fish | Feature-Flags (switch/case) | NEU |
| 050-gui.fish | GUI-Aliases (aus 7x 70-desktop.fish) | Merge |
| 055-dev.fish | DEV-Aliases | NEU |

### Shared Conf.d

| Alt | Neu |
|-----|-----|
| 00-loader.fish | 000-loader.fish |
| 00-theme.fish | 005-theme.fish |

### Host-Dateien

| Alt | Neu | Aenderung |
|-----|-----|-----------|
| variables/10-display.fish | Display-Variablen → in 008-host-flags.fish | ENTFAELLT |
| aliases/70-desktop.fish | → 050-gui.fish (Shared) | 7x GELOESCHT |
| aliases/70-server.fish | ENTFAELLT (Duplikate entfernen) | GELOESCHT |
| aliases/80-n8-*.fish | 110-n8-*.fish | Umbenannt |
| variables/10-host.fish | → in 008-host-flags.fish | ENTFAELLT |

---

## Paketlisten

### Ablageort: shared/packages/

| Datei | Hosts | Pakete |
|-------|-------|--------|
| min-packages.txt | Alle | fish, git, gh, age, openssh, bat, eza, micro, jq, tree, fastfetch, ripgrep, less, duf, dust, htop, curl, wget, tar, gzip, unzip, rsync, ncdu, fzf |
| desktop-packages.txt | GUI-Hosts | flatpak, vlc, firefox, btop, power-profiles-daemon, wl-clipboard |
| dev-packages.txt | Dev-Hosts | docker, docker-compose, docker-buildx, lazydocker, nodejs, npm, python, base-devel |

### Pre-Flight: Fehlende Pakete installieren

| Host | Fehlend |
|------|---------|
| n8-vps | duf, dust, htop, ripgrep, less |
| n8-station | docker-buildx, lazydocker, nodejs, npm, ncdu |

---

## format.fish Library

**Ablageort:** shared/lib/format.fish (oder shared/etc/fish/functions/format.fish)

Konsolidiert duplizierte Formatting-Funktionen aus:
- .secrets/deploy.fish (17 Funktionen)
- .secrets/deployment/pack-secrets.fish (4 Funktionen)
- .secrets/deployment/unpack-secrets.fish (4 Funktionen)

**Kern-Funktionen:**
- `_msg` / `_success` / `_error` / `_warn` / `_skip`
- `_section` / `_link` / `_copy`
- `mr_bytez_banner` (einheitliches ASCII-Logo)

**Integration:** Alle Scripts die Farb-Ausgabe nutzen → `source format.fish`

---

## Phasen-Plan

### Phase 0: Vorbereitung + Docs (45 min) ✅
- [x] 5-5-3 Docs fuer shared/etc/fish/ (README.md, DEPLOYMENT.md erstellen)
- [x] CLAUDE.md, CHANGELOG.md, ROADMAP.md in shared/etc/fish/ befuellen
- [x] Paketlisten-Dateien anlegen (shared/packages/) — mit pacman/yay/flatpak Sektionen
- [x] context/ARCHITEKTUR.md erstellen (Nummerierungsschema, Feature-Flags)
- [x] context/HOST_MATRIX.md erstellen (8 Hosts mit Flags)
- [x] context/MIGRATION.md erstellen (Alt→Neu Mapping)
- [ ] Fehlende Pakete auf n8-vps + n8-station installieren (verschoben — per SSH spaeter)

### Phase 1: Alias-Umbenennung (30 min) ✅
- [x] HOCH-Risiko: cat→bcat, ls→el, grep entfernt, df→duf, du→dust
- [x] MITTEL-Risiko: rm→rmi, cp→cpi, mv→mvi
- [x] Originale komplett alias-frei machen
- [x] command-Prefix Audit verifiziert (0 Treffer im gesamten Repo)
- [ ] Deploy + Test auf n8-kiste (verschoben — nach Phase 2+3)

### Phase 2: Nummerierung + Host-Flags (30 min) ✅
- [x] 008-host-flags.fish erstellt (conf.d/, switch/case, alle 8 Hosts)
- [x] Shared-Dateien umbenannt (git mv): 10→010, 20→015, 30→020, 40→025, 50→030, 60→035, 65→040, 90→045
- [x] Conf.d umbenannt: 00-loader→000-loader, 00-theme→005-theme
- [x] Einheitliche Header + Aktualisiert + Autor MR-ByteZ in allen 11 Dateien

### Phase 3: Conditionals + DRY + format.fish (45 min)
- [ ] format.fish Library erstellen (aus Secrets-Repo Funktionen)
- [ ] 050-gui.fish erstellen (aus 7x 70-desktop.fish extrahiert)
- [ ] 055-dev.fish erstellen (neue Dev-Conditionals)
- [ ] 7x 70-desktop.fish loeschen + 1x 70-server.fish loeschen
- [ ] 10-display.fish / 10-host.fish → in 008-host-flags.fish konsolidieren
- [ ] 80-n8-*.fish → 110-n8-*.fish umbenennen

### Phase 4: Loader umbauen (45 min)
- [ ] 000-loader.fish: Neue Lade-Reihenfolge implementieren
- [ ] Eine Schleife, numerisch sortiert (000→200)
- [ ] Testen: Flags vor Conditionals geladen?
- [ ] Debug-Modus (FISH_LOADER_DEBUG) anpassen
- [ ] mr-bytez-info.fish anpassen (B7)

### Phase 5: Testen + Deploy (60-90 min)
- [ ] n8-kiste testen (lokal, GUI+DEV)
- [ ] n8-vps testen (SSH, headless)
- [ ] n8-station testen (SSH, GUI+DEV)
- [ ] Restliche deployed Hosts (n8-book, n8-archstick)
- [ ] deploy-agent fuer SSH-Deployment

### Phase 6: Docs + Cleanup (45 min)
- [ ] shell.md ueberarbeiten (neues Schema dokumentieren)
- [ ] deployment.md aktualisieren (neue Dateinamen)
- [ ] B3: README Struktur-Baum aktualisieren
- [ ] Fish 5-5-3 Docs finalisieren
- [ ] skills/ erstellen: NEUER_HOST.md, NEUES_CONDITIONAL.md, DEBUGGING.md

---

## Mitlaufende B-Tasks (in A2 integriert)

| Task | Phase | Beschreibung |
|------|-------|-------------|
| B3 | 6 | README Struktur-Baum aktualisieren |
| B6 | 6 | Minimale .bashrc fuer Hosts ohne Fish-Default |
| B7 | 4 | mr-bytez-info.fish ans neue Schema anpassen |
| B17 | 0 | VLC Desktop-Paketliste → desktop-packages.txt |

## Nicht in A2 (eigene Tasks)

| Task | Warum nicht A2 |
|------|----------------|
| Audits 5-8 | Altes Repo + Docker, nicht Fish |
| Header-Audit repo-weit | Betrifft ALLE Dateien, nicht nur Fish |
| fail2ban (B18) | Security, kein Fish |
| Plasma-Scripts | Eigener B-Task, Ziel noch unklar |
| Edge-Bookmarks Backup | Eigener B-Task |
| Host-Config Inventur | Eigener B-Task |

---

## Validierung (nach Abschluss)

```fish
# Flags gesetzt?
echo $MR_HAS_GUI $MR_IS_DEV $MR_DISPLAY_TYPE

# Neue Aliases verfuegbar?
type bcat el rg duf dust rmi cpi mvi

# Originale = coreutils?
command -s cat ls grep df du rm cp mv

# GUI-Aliases (nur wenn MR_HAS_GUI=true)?
type zzz upfl

# Loader-Debug
set -gx FISH_LOADER_DEBUG 1
exec fish
```

---

## Referenzen

- Reports: REPORT_A2_VERIFIKATION.md, REPORT_A2_VERIFIKATION_TEIL2.md
- Reports: REPORT_HOST_CONFIG_INVENTUR.md, REPORT_ALTES_REPO_INVENTUR.md
- Theme-Handoff: HANDOFF_[Fish][Theme]_script-formatting-library.md
- Shell-Policies: .claude/context/shell.md
- Tag-Registry: .claude/context/tags.md

---

**Ende Handoff v3.0**
