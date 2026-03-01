# Skill: Neuen Host hinzufuegen

> **Pfad:** `shared/etc/fish/skills/NEUER_HOST.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-01
> **Aktualisiert:** 2026-03-01
> **Autor:** MR-ByteZ
> **Zweck:** Schritt-fuer-Schritt Anleitung: Neuen Host ins Fish-System aufnehmen

---

## Voraussetzungen

- Hostname ist bekannt (Format: `n8-<name>`)
- Host hat Arch Linux + Fish installiert
- Pakete aus `shared/packages/min-packages.txt` installiert

## Schritte

### 1. Host-Flags eintragen

Datei: `shared/etc/fish/conf.d/008-host-flags.fish`

Neuen `case`-Block im `switch (hostname)` ergaenzen:

```fish
case n8-neuhost
    set -gx MR_HAS_GUI true    # oder false
    set -gx MR_IS_DEV false    # oder true
    set -gx MR_DISPLAY_TYPE 1920  # 4k, 1920 oder headless
```

Bei GUI-Hosts zusaetzlich Display-Skalierung setzen (GDK_SCALE, QT_SCALE_FACTOR).

### 2. Host-Alias-Datei erstellen

Datei: `projects/infrastructure/n8-neuhost/root/home/mrohwer/.config/fish/aliases/110-n8-neuhost.fish`

Verzeichnisse anlegen und Datei mit Standard-Header erstellen (scaffold-agent nutzen).

### 3. Host-Verzeichnisstruktur anlegen

```
projects/infrastructure/n8-neuhost/
└── root/home/mrohwer/.config/fish/
    ├── aliases/       110-n8-neuhost.fish
    ├── conf.d/        (leer, zukunftssicher)
    ├── functions/     (leer, zukunftssicher)
    └── variables/     (leer, zukunftssicher)
```

### 4. mr-bytez-info.fish aktualisieren

Datei: `shared/etc/fish/functions/mr-bytez-info.fish`

Neuen `case`-Block im Host-spezifischen Abschnitt ergaenzen.

### 5. Handoff/Docs aktualisieren

- HOST_MATRIX.md: Neuen Host eintragen
- infrastructure.md: Host-Details ergaenzen
- Handoff: Falls relevant, Phase notieren

### 6. Deployment

1. Repo auf Host klonen/pullen
2. Anker setzen: `sudo ln -sfn /mr-bytez /opt/mr-bytez/current`
3. Symlink: `sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish`
4. Shell neu laden: `exec fish`
5. Validierung: `echo $MR_HAS_GUI $MR_IS_DEV $MR_DISPLAY_TYPE`

## Checkliste

- [ ] 008-host-flags.fish: case-Block
- [ ] 110-n8-neuhost.fish: Host-Aliases
- [ ] Verzeichnisstruktur angelegt
- [ ] mr-bytez-info.fish: case-Block
- [ ] HOST_MATRIX.md aktualisiert
- [ ] Deployment + Validierung
