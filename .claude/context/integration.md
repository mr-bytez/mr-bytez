# Integration — Claude, GitHub & MCP

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Claude.ai GitHub Integration

### Status

- **Repository:** `mr-bytez/mr-bytez` (GitHub)
- **Integration:** Claude.ai Projects → GitHub Integration (aktiv ✅)
- **Branch:** main
- **Berechtigungen:** Read-Only

### Was Claude.ai KANN

- ✅ Alle Dateien im Repository lesen via `project_knowledge_search`
- ✅ Code, Configs, Dokumentation durchsuchen und analysieren
- ✅ Konkrete Dateipfade und Inhalte referenzieren

### Was Claude.ai NICHT KANN

- ❌ Keine direkten Commits, Push, PRs oder Branch-Verwaltung
- ❌ Für Schreibzugriff → Claude Code CLI verwenden

### Workflow

**IMMER zuerst im Repository suchen:**
```
project_knowledge_search → query: "relevante keywords"
```

**NIEMALS annehmen:**
- ❌ "Ich habe keinen Zugriff auf das Repository..."
- ❌ "Bitte lade die Datei hoch..."

**IMMER tun:**
- ✅ `project_knowledge_search` verwenden
- ✅ Bei Fund direkt mit Arbeit beginnen

---

## Sync-Strategie

**Nach jedem Push → SOFORT "Sync now" klicken!**

```fish
# 1. Committen & Pushen
git push origin main && git push codeberg main

# 2. Claude.ai → Projekt → Project Knowledge → Zahnrad → "Sync now"

# 3. Kurz warten (5-10 Sekunden)

# 4. Weiterarbeiten mit Claude — sieht jetzt aktuelle Version
```

**Warum so wichtig?**
- GitHub Integration hat Verzögerung (mehrere Minuten)
- Ohne Sync sieht Claude alte Datei-Versionen
- Führt zu veralteten Antworten und Doppelarbeit

**Symptome wenn NICHT gesynct:**
- Claude schlägt Änderungen vor die schon gemacht wurden
- Claude findet neue Dateien/Abschnitte nicht
- Claude arbeitet mit veralteter Struktur

---

## Claude Code CLI

### Installation

```fish
# Native Installer (empfohlen, kein Node.js nötig)
curl -fsSL https://claude.ai/install.sh | bash
```

- Installiert nach `~/.local/bin/claude`
- PATH via `shared/etc/fish/variables/10-paths.fish` (`~/.local/bin` in fish_user_paths)
- Auth: OAuth mit Claude Max Plan
- Modell: Claude Opus 4.6 (seit 05.02.2026)

### Einsatzgebiete

- **Schreibzugriff** auf Repository (Dateien erstellen, editieren, committen)
- **Intelligente Aufgaben** (Analyse, Refactoring, komplexe Edits)
- **CLAUDE.md** wird automatisch als Kontext gelesen

### Workflow mit Claude.ai + Claude Code

```
Claude.ai (Planer/Moderator)
    ↓ formuliert Aufgaben
User (Moderator)
    ↓ delegiert an
Claude Code (Executor)
    ↓ erstellt/editiert Dateien
User
    ↓ prüft + committet
Claude.ai
    ↓ Sync → sieht Ergebnis
```

---

## Claude Opus 4.6 — Features (seit 05.02.2026)

| Feature | Deutsch | Beschreibung | Relevant fuer |
|---------|---------|-------------|---------------|
| **Effort Control** | Aufwandssteuerung | `/effort` in Claude Code: medium/high/max | Alltaegliche Nutzung |
| **Agent Teams** | Agenten-Teams | Paralleles Arbeiten mit mehreren Agenten | A2 (Fish DRY-Refactoring) |
| **Context Compaction** | Kontextverdichtung | Automatische Zusammenfassung bei langem Kontext | A4 (MCP Server) |
| **1M Token Context Window** | Kontextfenster | 1 Million Tokens via API | RAG-Workflow mit Qdrant (A4) |

---

## Claude Code — Context-Management

### Context Window (Kontextfenster)

- Standard: 200k Tokens (alle Modelle)
- Context = Nachrichten + Antworten + gelesene Dateien + Tool-Outputs + Thinking
- Performance degradiert deutlich ab ~70% Auslastung
- Auto-Compact (automatische Verdichtung) triggert bei ca. 75%

### Wann /clear oder neuen Chat starten

- Context-Meter (Kontextanzeige unten rechts) bei >70%
- Themenwechsel (anderes Projekt/andere Aufgabe)
- Claude faengt an Sachen zu vergessen oder Loops (Schleifen) zu bauen
- Nach jedem abgeschlossenen Milestone (Meilenstein)

### Befehle

| Befehl | Zweck |
|--------|-------|
| `/clear` | Context komplett zuruecksetzen (zwischen Aufgaben) |
| `/compact <Anweisung>` | Gezielt verdichten, z.B. `/compact Fokus auf Fish-Aenderungen` |
| `Esc + Esc` / `/rewind` | Checkpoint (Sicherungspunkt) waehlen, ab dort zusammenfassen |

### Session-State Pattern (Sitzungszustand-Muster)

Bei langen Sessions Fortschritt in Datei sichern statt Context vollaufen lassen:

1. `Schreib den aktuellen Fortschritt in session-notes.md`
2. `/clear`
3. `@session-notes.md` — Weiter wo wir aufgehoert haben

### Subagents (Unter-Agenten)

Fuer Recherche-Aufgaben Subagents nutzen — laufen in separatem Context:

```
Nutze einen Subagent um unser Fish-Alias-System zu analysieren
und berichte die Ergebnisse zurueck.
```

Haelt den Haupt-Context sauber fuer die eigentliche Implementierung.

### CLAUDE.md schlank halten

Jede Zeile in CLAUDE.md wird bei JEDER Nachricht erneut verarbeitet.
Nur essentielle Regeln und Verweise dort ablegen, Details in context/*.md.

---

## MCP Server — Kandidaten

Ergaenzend zum geplanten eigenen MCP Server (siehe unten) gibt es
fertige MCP Server die sofort nutzbar sind:

| Server | Zweck | Prioritaet | API-Key noetig? |
|--------|-------|------------|-----------------|
| Sequential Thinking | Strukturierter Denkprozess fuer komplexe Architektur | Hoch | Nein |
| Context7 | Echtzeit-Dokumentation aus Quell-Repos | Mittel | Nein |
| GitHub MCP | PRs, Issues, CI/CD direkt aus Claude Code | Mittel | Ja (PAT) |

### Installation (Beispiel)

```fish
# Sequential Thinking — kein API-Key, sofort einsetzbar
claude mcp add sequential-thinking --scope user -- npx -y @modelcontextprotocol/server-sequential-thinking
```

### Verwaltung

```fish
claude mcp list           # Alle konfigurierten Server anzeigen (Server auflisten)
claude mcp get <n>     # Details zu einem Server (Server-Details abrufen)
claude mcp remove <n>  # Server entfernen
/mcp                      # Status innerhalb Claude Code pruefen
```

**Detailplanung eigener MCP Server:** → `ROADMAP.md` (A4)

---

## MCP Server (Geplant)

- TypeScript MCP Server für n8-vps Production
- Tools: Filesystem, Docker, Git, Database, RAG (Qdrant)
- Entwicklung im mrbz-dev Container
- Deployment: Native Installation mit systemd Service
- Auth: Bearer Token → später Authentik OAuth2

**Status:** Geplant nach Claude Dev Container (→ `ROADMAP.md`)
