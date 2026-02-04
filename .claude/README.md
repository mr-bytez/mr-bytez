# .claude/ – AI-Arbeitsverzeichnis

**Pfad:** `/mr-bytez/.claude/`  
**Zweck:** Kontext, Pläne und Konfiguration für Claude Code & Claude.ai  
**Erstellt:** 2026-02-04

---

## Struktur

```
.claude/
├── README.md              # Diese Datei
├── plans/                 # Aktive Architektur- & Implementierungspläne
│   └── mrbz-dev-plan.md   # Aktuell: mrbz-dev Container Stack
└── archive/               # Abgeschlossene Pläne
    └── .gitkeep           # Hält Ordner in Git
```

---

## Verzeichnisse

### `plans/`

Aktive Arbeits- und Planungsdokumente für laufende Implementierungen.

**Naming:** `<projekt>-plan.md` oder `<feature>-plan.md`

**Beispiele:**
- `mrbz-dev-plan.md` — Container Stack Architektur
- `mcp-server-plan.md` — MCP Server Implementation
- `sensitive-cleanup-plan.md` — Git History Bereinigung

### `archive/`

Abgeschlossene Pläne zur späteren Referenz.

**Naming:** `<projekt>-plan_YYYY-MM-DD.md` (Datum = Abschluss)

---

## Lifecycle

```
1. Neuer Plan        →  plans/xyz-plan.md erstellen
2. Implementation    →  Plan als Referenz, bei Bedarf updaten
3. Abgeschlossen     →  mv plans/xyz-plan.md archive/xyz-plan_2026-02-04.md
4. Fertiger Stack    →  Stack bekommt eigene README.md
```

---

## Best Practices

### Für Claude Code CLI

- `.claude/` ist Standard-Kontext-Ordner
- `CLAUDE.md` im Repo-Root für Projekt-Überblick
- Plans hier für aktuelle Arbeitsaufgaben

### Für Claude.ai (Web/Desktop)

- Plans können als Project Knowledge hochgeladen werden
- GitHub Integration synct automatisch

---

## Aktuell aktive Pläne

| Plan | Status | Beschreibung |
|------|--------|--------------|
| `mrbz-dev-plan.md` | 🟠 WIP | Docker Dev Container Stack — Phase 1 |

---

## Verwandte Dokumente

- `/mr-bytez/README.md` — Projekt-Überblick
- `/mr-bytez/ROADMAP.md` — Gesamtplanung
- `/mr-bytez/DEPLOYMENT.md` — Deployment-Guide
- `/mr-bytez/PROJECT_NOTES.md` — Arbeitsweise & Policies

---

**Letzte Aktualisierung:** 2026-02-04
