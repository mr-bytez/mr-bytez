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
- PATH via `shared/etc/fish/variables/10-paths.fish` (fish_user_paths)
- Auth: OAuth mit Claude Max Plan

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

## MCP Server (Geplant)

- TypeScript MCP Server für n8-vps Production
- Tools: Filesystem, Docker, Git, Database, RAG (Qdrant)
- Entwicklung im mrbz-dev Container
- Deployment: Native Installation mit systemd Service
- Auth: Bearer Token → später Authentik OAuth2

**Status:** Geplant nach Claude Dev Container (→ `ROADMAP.md`)
