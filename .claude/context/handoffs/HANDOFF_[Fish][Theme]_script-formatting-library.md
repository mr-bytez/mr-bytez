# Script-Formatting-Library fuer MR-ByteZ

**Chat-Referenz:** #SEC01.4
**Chat-Link:** https://claude.ai/chat/1616d1af-6021-4c46-ba65-ea9a0d06a2cf
**Status:** Teilweise erledigt (A2 Phase 3) — Rest ist Kosmetik, niedrige Prioritaet
**Passt zu:** A2 (Fish DRY-Refactoring) — Kern in Phase 3 umgesetzt
**Abhaengigkeit:** Keine, kann jederzeit umgesetzt werden
**Aktualisiert:** 2026-03-01

---

## Vision

Einheitliches Look & Feel fuer alle Fish-Scripts im MR-ByteZ Repo.
Eine zentrale Library statt duplizierter Funktionen in jedem Script.

## Ziel-Datei

`shared/lib/format.fish` — zentrale Formatting-Library

## Funktionen

| Funktion | Zweck | Herkunft |
|----------|-------|----------|
| `mr_bytez_banner` | Logo-Ausgabe (voll + --compact) | `shared/lib/banner.fish` → hierhin verschieben |
| `_msg` | Info-Meldung (cyan) | `deploy.fish` |
| `_success` | Erfolgs-Meldung (gruen) | `deploy.fish` |
| `_warn` | Warnung (gelb) | `deploy.fish` |
| `_error` | Fehler (rot, stderr) | `deploy.fish` |
| `_skip` | Uebersprungen (brblack) | `deploy.fish` |
| `_link` | Symlink-Aktion | `deploy.fish` |
| `_copy` | Copy-Aktion | `deploy.fish` |
| `_section` | Sektions-Header mit Linie | `deploy.fish` |
| `_box` | Zusammenfassungs-Box mit Rahmen | Neu (aus deploy.fish Zusammenfassung extrahieren) |

## Farb-Schema (Gruvbox)

- **yellow:** Banner, Sektions-Header, Warnungen, Box-Rahmen
- **green:** Erfolg
- **red:** Fehler
- **cyan:** Info-Meldungen
- **brblack:** Uebersprungene/inaktive Elemente
- **normal:** Standard-Text

## Symbole

`→` Info | `⊘` Skip | `📋` Copy | `🔗` Symlink | `⚠️` Warnung | `✅` Erfolg | `❌` Fehler

## Betroffene Scripts

- `.secrets/deploy.fish` — aktuell eigene Funktionen (erste Migration)
- `shared/deployment/pack-secrets.fish`
- `shared/deployment/unpack-secrets.fish`
- `shared/deployment/derive_key.fish`
- `shared/etc/fish/functions/hwi.fish` (zukuenftig)
- Alle neuen Scripts

## Prinzip

Jedes Script sourced `shared/lib/format.fish` am Anfang.
Fallback auf lokale Funktionen wenn Library nicht verfuegbar.

```fish
# Am Script-Anfang:
set -l format_path /mr-bytez/shared/lib/format.fish
if test -f "$format_path"
    source "$format_path"
else
    # Fallback ueber Anker
    set -l format_anchor /opt/mr-bytez/current/shared/lib/format.fish
    if test -f "$format_anchor"
        source "$format_anchor"
    end
end
```

## Migration

1. ~~`shared/lib/format.fish` erstellen mit allen Funktionen~~ ✅ A2 Phase 3
2. ~~`shared/lib/banner.fish` Inhalt nach `format.fish` verschieben~~ → banner.fish bleibt separat, format.fish sourced es
3. ~~`banner.fish` entfernen oder als Wrapper belassen~~ → Bleibt, format.fish sourced banner.fish
4. ~~`deploy.fish` lokale Funktionen entfernen, format.fish sourcen~~ ✅ deploy.fish v0.4.0 sourced format.fish
5. ~~`pack-secrets.fish` + `unpack-secrets.fish` migriert~~ ✅ A2 Phase 3
6. `derive_key.fish` migrieren — **offen**
7. Regel in `shell.md` als Pflicht dokumentieren — **offen**

---

## Regel fuer Context-Dateien (nach Umsetzung)

Nach Fertigstellung muss die Regel in die Context-Dateien.
**WICHTIG:** Keine Redundanz! Policy EINMAL definieren, Rest verweist nur.
Siehe: `.claude/context/policies.md` ("Keine Redundanz"-Prinzip)

### 1. `.claude/context/shell.md` — EINZIGE Definition (Source of Truth)

Neue Sektion "Script-Formatierung":
- Alle Fish-Scripts MUESSEN `shared/lib/format.fish` sourcen
- Keine eigenen Farb-/Output-Funktionen in einzelnen Scripts
- Banner-Aufruf am Script-Anfang Pflicht
- Einheitliche Symbole und Farben (Gruvbox)

### 2. Root `CLAUDE.md` — NUR Kurzregel + Verweis

Unter Shell-Regeln ergaenzen:
`Scripts sourcen shared/lib/format.fish (→ shell.md)`

### 3. Projektanweisungen — KEIN eigener Eintrag noetig!

Verweisen bereits auf `shell.md`, Regel wird automatisch geerbt.
