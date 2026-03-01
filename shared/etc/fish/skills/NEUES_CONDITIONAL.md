# Skill: Neues Conditional erstellen

> **Pfad:** `shared/etc/fish/skills/NEUES_CONDITIONAL.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-01
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ
> **Zweck:** Schritt-fuer-Schritt Anleitung: Neues Conditional (060-xxx.fish) erstellen

---

## Wann ein neues Conditional?

Wenn eine Gruppe von Aliases/Funktionen nur auf bestimmten Hosts geladen werden soll,
gesteuert ueber ein Feature-Flag.

Bestehende Conditionals:
- `050-gui.fish` → prueft `MR_HAS_GUI`
- `055-dev.fish` → prueft `MR_IS_DEV`

Reserviert fuer Erweiterungen: 060-099.

## Schritte

### 1. Nummer waehlen

Naechste freie Nummer im 5er-Raster: 060, 065, 070, ...

### 2. Flag definieren (falls noetig)

Falls kein passender Flag existiert, neuen in `008-host-flags.fish` ergaenzen:

```fish
set -gx MR_HAS_FEATURE true  # oder false
```

Fuer alle 8 Hosts im switch/case den Wert setzen.

### 3. Datei erstellen

Ablageort: `shared/etc/fish/aliases/060-feature.fish`

Template (Self-Check Pattern):

```fish
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ Fish Config                                  │
# │  Datei:    060-feature.fish                             │
# │  Pfad:     shared/etc/fish/aliases/060-feature.fish     │
# │  Zweck:    Feature-spezifische Aliases und Funktionen   │
# │  Version:  0.1.0                                        │
# │  Autor:    MR-ByteZ                                     │
# │  Erstellt: YYYY-MM-DD                                   │
# └─────────────────────────────────────────────────────────┘
#
# Self-Check: Nur laden wenn Feature vorhanden
# Hosts: <liste>
# Nicht: <liste>

test "$MR_HAS_FEATURE" != "true"; and return

# Ab hier: Feature-spezifischer Code
```

### 4. Docs aktualisieren

- shell.md: Neue Datei in Tabelle eintragen
- CHANGELOG.md (Root + Fish): Neues Conditional dokumentieren
- Handoff (falls vorhanden): Phase notieren

### 5. Testen

```fish
# Flag manuell setzen
set -gx MR_HAS_FEATURE true
source shared/etc/fish/aliases/060-feature.fish

# Pruefen ob Aliases verfuegbar
type <alias-name>
```

## Checkliste

- [ ] Nummer gewaehlt (5er-Raster)
- [ ] Flag in 008-host-flags.fish definiert (alle 8 Hosts)
- [ ] Datei mit Self-Check Pattern erstellt
- [ ] shell.md aktualisiert
- [ ] CHANGELOG ergaenzt
- [ ] Getestet auf mindestens 1 Host
