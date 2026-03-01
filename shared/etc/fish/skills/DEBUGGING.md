# Skill: Fish-Config Debugging

> **Pfad:** `shared/etc/fish/skills/DEBUGGING.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-01
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ
> **Zweck:** Debugging-Anleitung fuer Fish-Konfiguration

---

## Loader-Debug aktivieren

```fish
set -gx FISH_LOADER_DEBUG 1
exec fish
```

Zeigt alle geladenen Dateien in stderr. Deaktivieren:

```fish
set -e FISH_LOADER_DEBUG
exec fish
```

## Validierung (Quick-Check)

```fish
# Feature-Flags gesetzt?
echo $MR_HAS_GUI $MR_IS_DEV $MR_DISPLAY_TYPE

# Neue Aliases verfuegbar?
type bcat el duf dust rmi cpi mvi

# Originale = coreutils (KEIN Alias)?
command -s cat ls grep df du rm cp mv

# GUI-Aliases (nur wenn MR_HAS_GUI=true)?
type zzz upfl upclean upchk flathub

# Diagnose-Funktion
mr-bytez-info
mr-bytez-info --check      # Symlinks pruefen
mr-bytez-info --structure   # Dateistruktur pruefen
```

## Haeufige Probleme

### Symlink /etc/fish fehlt nach pacman -Syu

Fish-Update kann `/etc/fish` ueberschreiben.

```fish
# Pruefen
ls -la /etc/fish

# Reparieren
sudo rm -rf /etc/fish
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish
exec fish
```

### Feature-Flags nicht gesetzt

Ursachen:
1. `008-host-flags.fish` hat keinen case-Block fuer diesen Host
2. Hostname stimmt nicht mit case-Block ueberein

```fish
# Hostname pruefen
hostname

# 008-host-flags.fish manuell laden
source /mr-bytez/shared/etc/fish/conf.d/008-host-flags.fish
echo $MR_HAS_GUI $MR_IS_DEV
```

### GUI-Aliases fehlen auf Desktop-Host

Ursachen:
1. `MR_HAS_GUI` nicht auf `true` gesetzt
2. `050-gui.fish` wird vor `008-host-flags.fish` geladen (Reihenfolge-Problem)

```fish
# Reihenfolge pruefen (Debug-Modus)
set -gx FISH_LOADER_DEBUG 1
exec fish
# 008-host-flags.fish muss VOR 050-gui.fish erscheinen
```

### Alias ueberschreibt coreutils

Seit A2 Phase 1 sind Originale alias-frei. Falls trotzdem ein Alias existiert:

```fish
# Welche Funktion/Alias liegt auf dem Command?
type cat
type ls

# Falls Alias: In welcher Datei definiert?
functions cat  # zeigt Quellcode
```

### Neue Datei wird nicht geladen

1. Zero-Padding pruefen: `060-xxx.fish`, nicht `60-xxx.fish`
2. Datei muss in einem der 6 Loader-Verzeichnisse liegen
3. Dateiendung muss `.fish` sein
4. Datei muss ausfuehrbar oder zumindest lesbar sein

```fish
# Pruefen ob Datei im Glob-Ergebnis
for f in /mr-bytez/shared/etc/fish/aliases/*.fish
    echo (basename $f)
end
```
