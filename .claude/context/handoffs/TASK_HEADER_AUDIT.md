# TASK: Header-Audit & Korrektur — Alle Dateien im Repo

**Aufgabe für:** Claude Code (audit-agent → dann manuell korrigieren)
**Priorität:** Hoch (vor A2 Phase 1 erledigen)
**Geschätzter Aufwand:** ~30-45 min

---

## Phase 1: Audit (audit-agent)

Prüfe ALLE Dateien im Repo auf Header-Konformität.

### Zu prüfen

```
/mr-bytez/
├── shared/lib/*.fish
├── shared/etc/fish/conf.d/*.fish
├── shared/etc/fish/functions/*.fish
├── shared/etc/fish/aliases/*.fish
├── shared/etc/fish/variables/*.fish
├── shared/etc/fish/themes/*.fish
├── shared/deployment/*.fish
├── .secrets/deploy.fish
├── .secrets/deployment/*.fish
├── scripts/*.fish
├── .claude/hooks/*.sh
├── .claude/agents/*.md
├── .claude/context/*.md
├── .claude/context/handoffs/*.md
└── Docker: compose.yml, Dockerfile (wenn vorhanden)
```

### Prüfkriterien pro Datei

| Kriterium | Erwartung |
|-----------|-----------|
| Header vorhanden? | Ja — Banner oder Box |
| Header-Typ korrekt? | Script=7-Feld, Config=Box, Agent=YAML |
| Dateiname im Header? | Muss mit tatsächlichem Dateinamen übereinstimmen |
| Pfad im Header? | Muss mit tatsächlichem Pfad übereinstimmen |
| Version vorhanden? | Ja — Format X.Y.Z |
| Erstellt-Datum? | Ja — Format YYYY-MM-DD |
| Autor? | MR-ByteZ oder Michael Rohwer |
| Zweck? | Ja — nicht leer |
| Shebang korrekt? | Fish: `#!/usr/bin/env fish`, Bash: `#!/bin/bash` |
| Banner-Stil? | Kompakt `┌──┘` für Scripts, `╔══╝` für Configs |

### Report-Format

Erstelle: `.claude/context/handoffs/REPORT_HEADER_AUDIT.md`

Pro Datei eine Zeile:

```
| Datei | Header | Typ | Version | Datum | Status |
|-------|--------|-----|---------|-------|--------|
| 00-loader.fish | Box ✅ | Config ✅ | 2.1.0 ✅ | ✅ | OK |
| banner.fish | 7-Feld ⚠️ | Lib ✅ | 1.0.0 ✅ | ✅ | Banner-Stil alt |
| 10-nav.fish | Keiner ❌ | Alias | — | — | FEHLT KOMPLETT |
```

Kategorien:
- **OK** — Korrekt, nichts zu tun
- **BANNER-STIL** — Alter `====` Stil statt kompakt `┌──┘`
- **FELDER FEHLEN** — Header da, aber unvollständig
- **FEHLT KOMPLETT** — Kein Header vorhanden
- **FALSCHER TYP** — Script hat Box statt 7-Feld oder umgekehrt

---

## Phase 2: Korrektur (Claude Code direkt)

Nach Review des Reports alle Dateien korrigieren:

1. **FEHLT KOMPLETT** → Header nach scaffold-agent Template einfügen
2. **BANNER-STIL** → `====` durch `┌──┘` oder `╔══╝` ersetzen
3. **FELDER FEHLEN** → Fehlende Felder ergänzen
4. **FALSCHER TYP** → Header-Typ anpassen

### Vorsicht bei

- Bestehende Versionen NICHT ändern!
- Bestehende Erstellt-Daten NICHT ändern!
- Autor "Michael Rohwer" auf "MR-ByteZ" vereinheitlichen? → User fragen!
- Versionsvariablen (MRBYTEZ_VERSION, script_version, theme_version) → separater Task!

---

## Phase 3: Commit

```
[Fish][Config] Header-Audit — Alle Dateien auf MR-ByteZ Standard

- X Dateien korrigiert (fehlende Header, Banner-Stil, fehlende Felder)
- Einheitlicher Kompakt-Banner ┌──┘ für Scripts
- Einheitliche 9-Zeilen-Box ╔══╝ für Configs
- Alle Felder vollständig (Datei, Pfad, Autor, Version, Erstellt, Zweck)

Chat: https://claude.ai/chat/<id>
```
