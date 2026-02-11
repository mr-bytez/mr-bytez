# .claude/ — AI-Arbeitsverzeichnis

**Pfad:** `.claude/`
**Zweck:** Kontext, Policies und Konfiguration für Claude Code & Claude.ai
**Erstellt:** 2026-02-04
**Aktualisiert:** 2026-02-11
**Autor:** MR-ByteZ

---

## Struktur

```
.claude/
├── CLAUDE.md              # ⭐ Zentrale Steuerung für Claude
├── README.md              # Diese Datei (GitHub-Darstellung)
├── CHANGELOG.md           # .claude/ Historie
├── ROADMAP.md             # .claude/ Planung
│
├── context/               # Globale Policies & Konventionen
│   ├── policies.md            # Grundprinzipien, Repo-Regeln
│   ├── shell.md               # Fish-first, Bash, Syntax
│   ├── security.md            # Secrets, Tokens, Sanitization
│   ├── git.md                 # Commit-Format, Branches
│   ├── docker.md              # Container, Netzwerke, Naming
│   ├── deployment.md          # Symlinks, Anker, Host-Setup
│   ├── documentation.md       # Doku-Workflow, Templates
│   ├── integration.md         # Claude GitHub, MCP, Sync
│   ├── infrastructure.md      # Hosts-Matrix, IPs, SSH
│   ├── structure.md           # 5-3-3 Pattern Definition
│   └── migration.md           # Migrationsplan Alt → Neu
│
├── archive/               # Abgeschlossene Pläne & Arbeit
├── skills/                # AI-Skills (Custom Prompts)
└── configs/               # Konfigurationen (JSON, YAML)
```

---

## Einstieg

→ Claude Code / Claude.ai: Starte mit `CLAUDE.md`
→ Menschen: Starte mit Root `README.md`

---

## Verwandte Dokumente

- `README.md` (Root) — Projekt-Übersicht
- `ROADMAP.md` (Root) — Gesamtplanung
- `CHANGELOG.md` (Root) — Versions-Historie
