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

Format für jeden neuen Chat:
```
MR-ByteZ - [kategorie] - Beschreibung - Keywords --- YYYY-MM-DD-HH-MM
```

- Minimum: 100 Zeichen, Maximum: 250 Zeichen
- Sprechend und bei Suche findbar
- Wichtige Begriffe/Tools/Themen im Namen
- IMMER Erstellungsdatum + Uhrzeit verwenden
