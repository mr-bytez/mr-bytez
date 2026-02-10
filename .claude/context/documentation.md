# Documentation — Workflow & Regeln

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Docs-first Workflow

Wenn wir **Configs ändern**, **Deployment anpassen**, **Repos splitten/migrieren** oder **Security-Policies** verändern, dann gilt:

1. **Docs zuerst aktualisieren** (in derselben Arbeits-Session)
2. Danach erst Code committen (nicht "Docs später")

---

## Betroffene Dateien (typisch)

| Datei | Zweck |
|-------|-------|
| `README.md` | Überblick + Status (keine operativen Commands) |
| `DEPLOYMENT.md` | Deployment-Guide + operative Commands |
| `CHANGELOG.md` | Was hat sich geändert |
| `ROADMAP.md` | Was kommt als nächstes |
| `.claude/context/*.md` | Policies und Kontext |
| Secrets-Submodule Doku | Token/Key-Hinweise, Recovery |

---

## MD-Update-Regel (Additive-Only)

Für zentrale Markdown-Dateien gilt:

- **Basis ist immer die bestehende Datei**
- Es werden **nur Ergänzungen** oder **kleine Korrekturen** gemacht
- **Keine Kürzungen/Entfernungen** — außer explizit erlaubt
- Vor Änderungen kurz erklären: **was** geändert wird, **wo** und **warum**

### Zuordnung

- `README.md` = **Überblick/Onboarding** (keine operativen Commands)
- Operative Commands/Schrittfolgen → `DEPLOYMENT.md`
- Policies und Regeln → `.claude/context/*.md`

---

## 5-3-3 Pattern

Jedes Projekt/Verzeichnis folgt dem gleichen Muster:

### 5 Dokumente

```
README.md       → Mensch: Übersicht (GitHub-Darstellung)
CLAUDE.md       → KI: Zentrale Steuerung + Verweise
CHANGELOG.md    → Historie (Was wurde gemacht)
ROADMAP.md      → Planung (Was kommt als nächstes)
DEPLOYMENT.md   → Deployment-Anleitung
```

### 3 Ordner

```
context/        → Details, Policies, Design-Docs
skills/         → AI-Skills (Custom Prompts)
configs/        → Konfigurationen (JSON, YAML)
```

### 3 Ebenen

```
Root            → /mr-bytez/ (Gesamtes Repo)
.claude/        → /mr-bytez/.claude/ (KI-Context ROOT)
Projekte        → Pro Host/Stack
```

Vollständige Beschreibung → `.claude/context/structure.md`

---

## Sprache & Formatierung

- **Dokumentation:** Deutsch
- **Code-Kommentare:** Deutsch
- **Commit-Messages:** Deutsch
- **Variablen/Funktionsnamen:** Englisch (technische Konvention)

### Config-Datei Header-Template

```fish
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  Titel                                                                       ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /vollständiger/pfad                                   ║
# ║  Autor:    MR-ByteZ                                                          ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: YYYY-MM-DD                                                        ║
# ║  Aktualisiert: YYYY-MM-DD                                                    ║
# ║  Zweck:    Kurzbeschreibung                                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## Chat-Benennung (Claude.ai)

### Format v2

```
MR-ByteZ #<IDX><Nr>.<Chat> [Tag1][Tag2][Tag3][Tag4] - Beschreibung - keywords --- YYYY-MM-DD-HH-MM
```

Wobei:
- `<IDX>` = 3-Zeichen-Index aus `context/tags.md` (Haupt-Tag der Kette)
- `<Nr>` = Projektnummer (01, 02, ...)
- `<Chat>` = Chat-Nummer in der Kette (.1, .2, .3)
- Tags: Min 2, Max 4 — aus `context/tags.md`
- Tag-Reihenfolge: Grob → Fein (breiteste Kategorie zuerst)
- Keine Phasen-Tags (kein [Diskussion], [Planung], [Debug])
- Zeichenlimit: Min 100, Max 250
- Beschreibung: Sprechend und bei Suche findbar
- Keywords: Wichtige Begriffe, Tools, Themen

### Datum/Uhrzeit

- IMMER Erstellungsdatum + Uhrzeit des Chats verwenden (NICHT letztes Bearbeitungsdatum!)
- Format: YYYY-MM-DD-HH-MM (24h)
- Claude ermittelt Startzeit selbst via recent_chats Tool (UTC → Berlin CET +1h / CEST +2h)
- NICHT den User nach der Uhrzeit fragen!

### Ketten-System

Zusammengehoerige Chats werden ueber die Ketten-ID verknuepft:
- `#STR01.1` → Structure-Projekt 01, Chat 1
- `#STR01.2` → Structure-Projekt 01, Chat 2 (Fortsetzung)
- `#FSH01.1` → Fish-Projekt 01, Chat 1

Der Ketten-Prefix ist der 3-Zeichen-Index des **Haupt-Tags** aus `context/tags.md`.
Beim Folge-Chat: Nummer hochzaehlen (.1 → .2 → .3).
Status ergibt sich implizit — der letzte Chat in der Kette = aktueller Stand.

### Tag-Verwaltung

Beim Benennen eines neuen Chats:
1. `context/tags.md` pruefen ob passende Tags vorhanden
2. Fehlende Tags vorschlagen + via Claude Code in tags.md eintragen lassen
3. Min 2, Max 4 Tags waehlen — lieber praezise mit 4 als vage mit 2

### Beispiele

```
MR-ByteZ #STR01.3 [Structure][Docs][Roadmap][ClaudeCode] - Inventur Kategorisierung ABCD Roadmap Restrukturierung - 40-aufgaben timing-matrix phase-3-umbau --- 2026-02-10-18-05
MR-ByteZ #FSH01.1 [Fish][Config][Prompt] - Prompt System v2 Grundstruktur - keybindings abbr theme gruvbox --- 2026-02-07-14-30
MR-ByteZ #SEC01.1 [Security][Git] - Sensitive Data Cleanup Konzept - clean-smudge filter hostname mapping --- 2026-02-04-03-00
MR-ByteZ #DKR01.1 [Docker][Traefik][DNS] - SSL und Wildcard Setup n8-vps - acme letsencrypt reverse-proxy --- 2026-02-09-15-00
MR-ByteZ #MCP01.1 [MCP][Docker][Traefik][Security] - MCP Server Phase 1 Development - typescript qdrant tools --- 2026-03-01-10-00
```
