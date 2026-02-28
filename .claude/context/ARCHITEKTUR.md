# Fish DRY-Architektur

> **Pfad:** `.claude/context/ARCHITEKTUR.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-02-28
> **Aktualisiert:** 2026-02-28
> **Autor:** MR-ByteZ
> **Zweck:** Nummerierungsschema, Feature-Flags und Loader-Design der Fish-Konfiguration

---

## Nummerierungsschema

Alle Fish-Dateien werden ueber eine dreistellige Nummer sortiert.
Der Loader laedt in einer einzigen Schleife von 000 bis 200.

### Shared (000-099) — alle Hosts

```
000-loader.fish          Basis-Loader (laedt alles andere)
005-theme.fish           Powerline/Theme Setup, Prompt-Farben
008-host-flags.fish      Host-Flags setzen (switch/case auf $hostname)

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

### Host (100-200) — nur der jeweilige Host

```
110-n8-kiste.fish        Host-spezifische Aliases/Variablen
110-n8-vps.fish          (jeder Host hat seine eigene 110er Datei)
110-n8-station.fish
...

190-199                  User-Tweaks (optional, persoenliche Anpassungen)
```

### Lade-Reihenfolge

```
000 → 005 → 008 → 010 → 015 → ... → 045 → 050 → 055 → ... → 110 → 190
```

Der Loader iteriert einmal ueber alle Dateien, numerisch sortiert.
Keine separaten Schleifen fuer Unterverzeichnisse.

## Feature-Flags

Gesetzt in `008-host-flags.fish` per `switch (hostname)`:

| Flag | Typ | Werte | Beschreibung |
|------|-----|-------|-------------|
| MR_HAS_GUI | bool | true/false | Hat der Host eine grafische Oberflaeche? |
| MR_IS_DEV | bool | true/false | Ist der Host ein Entwicklungs-Host? |
| MR_DISPLAY_TYPE | string | 4k/1920/headless | Display-Aufloesung fuer EZA-Spalten etc. |

Flags werden als globale exportierte Variablen gesetzt:

```fish
set -gx MR_HAS_GUI true
set -gx MR_IS_DEV true
set -gx MR_DISPLAY_TYPE 4k
```

Unbekannte Hosts erhalten den sicheren Default: `false / false / headless`.

## Self-Check Pattern

Jede Conditional-Datei prueft ihren Flag am Anfang und bricht ab wenn nicht gesetzt:

```fish
# 050-gui.fish
test "$MR_HAS_GUI" != "true"; and return

# Ab hier nur GUI-Code
```

Voraussetzung: `008-host-flags.fish` muss VOR `050-gui.fish` geladen werden.
Das ist durch die Nummerierung (008 < 050) garantiert.

## Alias-Sicherheit

Originale coreutils bleiben unveraendert — keine Aliases auf Standardnamen:

| Original | Neuer Alias | Tool |
|----------|-------------|------|
| cat | bcat | bat --color=always |
| grep | rg | ripgrep |
| ls | el | eza mit Icons |
| df | duf | duf |
| du | dust | dust |
| rm | rmi | rm -Iv |
| cp | cpi | cp -iv |
| mv | mvi | mv -iv |

## Referenzen

- Host-Matrix: `.claude/context/HOST_MATRIX.md`
- Migration: `.claude/context/MIGRATION.md`
- Handoff: `.claude/context/handoffs/HANDOFF_Fish_Refactor_fish-dry-refactoring_v3.md`
