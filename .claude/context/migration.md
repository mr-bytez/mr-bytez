# Migration — Alte → Neue Struktur

**Version:** 1.0.0
**Erstellt:** 2026-02-05
**Autor:** Michael Rohwer

---

## Übersicht

### Alt (vorher):
```
/mr-bytez/
├── README.md
├── PROJECT_NOTES.md          ← ALT
├── DEPLOYMENT.md
├── CHANGELOG.md
├── ROADMAP.md
└── .claude/
    ├── README.md              ← ALT
    └── plans/                 ← ALT
        └── mrbz-dev-plan.md
```

### Neu (nachher):
```
/mr-bytez/
├── README.md
├── CHANGELOG.md
├── ROADMAP.md
└── .claude/
    ├── README.md              ← Angepasst
    ├── CLAUDE.md              ⭐ NEU
    ├── CHANGELOG.md           ⭐ NEU
    ├── ROADMAP.md             ⭐ NEU
    ├── context/               ⭐ NEU
    │   ├── policies.md
    │   ├── shell.md
    │   ├── security.md
    │   ├── git.md
    │   ├── docker.md
    │   ├── deployment.md
    │   ├── documentation.md
    │   ├── integration.md
    │   ├── infrastructure.md
    │   └── structure.md
    ├── archive/               ⭐ UMBENENNEN (plans → archive)
    ├── skills/
    └── configs/
```

---

## Änderungen

### 1. PROJECT_NOTES.md → Aufteilen

**Alt:**
```
/mr-bytez/PROJECT_NOTES.md
```

**Neu:**
```
.claude/context/
├── policies.md         ← Grundprinzipien, Repo-Policies
├── shell.md            ← Fish-first, Bash, Syntax
├── security.md         ← Secrets, Tokens, cat-Alias, Sanitization
├── git.md              ← Commit-Format, Branches, Workflow
├── deployment.md       ← Symlinks, Anker (aus DEPLOYMENT.md)
├── documentation.md    ← Doku-Workflow, MD-Update-Regel
└── integration.md      ← Claude GitHub, MCP, Sync
```

**Mapping:**

| PROJECT_NOTES.md Abschnitt | Neue Datei |
|-----------------------------|------------|
| Grundprinzipien | policies.md |
| Shell-Standard: Fish-first | shell.md |
| Tokens / Keys / cat-Alias | security.md |
| Secrets-Policy | security.md |
| Deployment-Policy | deployment.md |
| Doku-Workflow | documentation.md |
| MD-Update-Regel | documentation.md |
| Claude GitHub Integration | integration.md |
| Git Commit-Format | git.md |

### 2. DEPLOYMENT.md → Split

**Alt:**
```
/mr-bytez/DEPLOYMENT.md        # Gesamtes Deployment
```

**Neu:**
```
.claude/context/deployment.md  # Deployment-Policies (Symlinks, Anker)

Pro-Projekt DEPLOYMENT.md:
projects/infrastructure/n8-kiste/DEPLOYMENT.md
projects/infrastructure/n8-vps/DEPLOYMENT.md
shared/stacks/mrbz-dev/DEPLOYMENT.md
```

### 3. plans/ → archive/

**Umbenennen:**
```fish
mv .claude/plans .claude/archive
```

**Warum:**
- "plans" klingt nach "könnte mal"
- ROADMAP.md steuert Progress
- archive/ für abgeschlossene Arbeit

### 4. .claude/README.md → Anpassen

**Alt:** Generelle Struktur-Doku

**Neu:** Kurze Übersicht für GitHub

**Inhalt (neu):**
```markdown
# .claude/ — AI-Arbeitsverzeichnis

**Für Claude Code & Claude.ai**

## Struktur
- CLAUDE.md → Zentrale Steuerung
- context/ → Globale Policies
- archive/ → Abgeschlossene Arbeit
- skills/ → AI-Skills
- configs/ → Configs

→ Details: CLAUDE.md
```

### 5. .claude/CLAUDE.md → NEU erstellen

**Zweck:** Zentrale Steuerung für Claude

**Verweist auf:**
- context/ (Policies)
- Aktive Projekte
- ROADMAP.md (Was läuft)

**Template:** Siehe structure.md Abschnitt "CLAUDE.md — Aufbau"

### 6. Neue .claude/ Dateien

**Erstellen:**
```
.claude/CHANGELOG.md    # .claude/ spezifische Historie
.claude/ROADMAP.md      # .claude/ spezifische Planung
```

**Inhalt CHANGELOG.md:**
```markdown
# .claude/ Changelog

## [1.0.0] - 2026-02-05

### Added
- Neue Struktur implementiert (5-3-3 Pattern)
- context/ mit 9 Dateien erstellt
- CLAUDE.md als zentrale Steuerung

### Changed
- PROJECT_NOTES.md aufgeteilt in context/
- plans/ → archive/ umbenannt
- README.md angepasst
```

**Inhalt ROADMAP.md:**
```markdown
# .claude/ Roadmap

## Phase 1: Foundation ✅ DONE
- [x] Struktur definiert
- [x] Migration-Plan erstellt

## Phase 2: Migration 🔴 IN PROGRESS
- [ ] Struktur implementieren
- [ ] Projekte migrieren (n8-kiste, n8-vps, mrbz-dev)
- [ ] CLAUDE.md für alle erstellen

## Phase 3: Nutzung
- [ ] Dokumentation nutzen
- [ ] Skills entwickeln
- [ ] Configs anlegen
```

---

## Reihenfolge — Migration Schritte

### Schritt 1: Backup ✅
```fish
cd /mr-bytez
git add .
git commit -m "[Docs][Structure] Pre-Migration Backup"
git push origin main
git push codeberg main
```

### Schritt 2: .claude/ Basis erstellen ✅

```fish
cd /mr-bytez/.claude

# Ordner erstellen
mkdir -p context skills configs

# archive/ umbenennen
mv plans archive

# .gitkeep für leere Ordner
touch skills/.gitkeep configs/.gitkeep
```

### Schritt 3: context/ Dateien erstellen ✅

**Aus PROJECT_NOTES.md extrahieren:**

```fish
# Im nächsten Chat mit Claude:
# 1. PROJECT_NOTES.md analysieren
# 2. In 9 context/*.md Dateien aufteilen
# 3. Sanitization Matrix in security.md
```

**Dateien:**
```
context/policies.md
context/shell.md
context/security.md
context/git.md
context/docker.md
context/deployment.md
context/documentation.md
context/integration.md
context/infrastructure.md
```

### Schritt 4: .claude/ Root-Dateien ✅

```fish
# CLAUDE.md erstellen (Template siehe structure.md)
micro .claude/CLAUDE.md

# CHANGELOG.md erstellen
micro .claude/CHANGELOG.md

# ROADMAP.md erstellen
micro .claude/ROADMAP.md

# README.md anpassen (kurz für GitHub)
micro .claude/README.md
```

### Schritt 5: Projekte migrieren ✅

**Für jedes Projekt (n8-kiste, n8-vps, mrbz-dev):**

```fish
# Beispiel: n8-kiste
cd projects/infrastructure/n8-kiste

# .claude/ Struktur erstellen
mkdir -p .claude/context .claude/skills .claude/configs
touch .claude/skills/.gitkeep .claude/configs/.gitkeep

# 5 Dokumente erstellen
touch README.md CLAUDE.md CHANGELOG.md ROADMAP.md DEPLOYMENT.md

# context/hardware.md erstellen
micro .claude/context/hardware.md
```

**Wiederholen für:**
- projects/infrastructure/n8-vps/
- shared/stacks/mrbz-dev/

### Schritt 6: mrbz-dev-plan.md → README.md ✅

```fish
cd /mr-bytez

# Plan ins archive/ verschieben
mv .claude/archive/mrbz-dev-plan.md .claude/archive/mrbz-dev-plan_2026-02-05.md

# Plan als README.md ins Stack kopieren
cp .claude/archive/mrbz-dev-plan_2026-02-05.md shared/stacks/mrbz-dev/README.md

# README.md anpassen (Header ändern)
micro shared/stacks/mrbz-dev/README.md
```

### Schritt 7: .gitignore erweitern ✅

```fish
micro .gitignore
```

**Hinzufügen:**
```
# Sanitization (NIEMALS committen!)
*sanitization*
*matrix*
*-real.md
*.unsanitized
```

### Schritt 8: PROJECT_NOTES.md löschen ✅

```fish
# ERST wenn alles in context/ ist!
git rm PROJECT_NOTES.md
```

### Schritt 9: DEPLOYMENT.md → context/ ✅

```fish
# Deployment-Policies extrahieren
# Root DEPLOYMENT.md → .claude/context/deployment.md

# Dann Root DEPLOYMENT.md löschen
git rm DEPLOYMENT.md
```

### Schritt 10: Commit & Push ✅

```fish
cd /mr-bytez

git add .
git status  # Prüfen!

git commit -m "[Structure][Migration] Neue .claude/ Struktur implementiert

- 5-3-3 Pattern eingeführt
- PROJECT_NOTES.md aufgeteilt in context/
- plans/ → archive/ umbenannt
- CLAUDE.md als zentrale Steuerung
- Projekte migriert (n8-kiste, n8-vps, mrbz-dev)
- .gitignore erweitert (Sanitization)"

git push origin main
git push codeberg main
```

### Schritt 11: GitHub Sync ✅

**WICHTIG: Sofort nach Push!**

```
Claude.ai → Projekt → Project Knowledge →
→ GitHub Repo (Zahnrad) → "Sync now"
```

---

## Checkliste

- [ ] Backup (git commit + push)
- [ ] .claude/ Ordner (context, skills, configs)
- [ ] plans/ → archive/ umbenennen
- [ ] context/*.md Dateien erstellen (9 Dateien)
- [ ] .claude/CLAUDE.md erstellen
- [ ] .claude/CHANGELOG.md erstellen
- [ ] .claude/ROADMAP.md erstellen
- [ ] .claude/README.md anpassen
- [ ] n8-kiste migrieren (5 Docs + .claude/)
- [ ] n8-vps migrieren (5 Docs + .claude/)
- [ ] mrbz-dev migrieren (5 Docs + .claude/)
- [ ] mrbz-dev-plan.md → README.md
- [ ] .gitignore erweitern (Sanitization)
- [ ] PROJECT_NOTES.md löschen
- [ ] DEPLOYMENT.md → context/
- [ ] Commit & Push
- [ ] GitHub Sync (claude.ai)

---

## Nach Migration

### Neuer Chat starten ✅

**Mit Context:**
- structure.md (diese Datei)
- migration.md (Anleitung)
- Neue .claude/ Struktur im Repo

**Chat-Name:**
```
MR-ByteZ - [migration][structure] - .claude/ Struktur Migration Phase 2 -
context-dateien erstellen n8-kiste n8-vps mrbz-dev deployment --- 2026-02-05-XX-XX
```

### Nächste Schritte (im neuen Chat):

1. context/*.md Dateien befüllen (aus PROJECT_NOTES.md)
2. CLAUDE.md für Root + 3 Projekte erstellen
3. infrastructure.md + security.md (Sanitization)
4. Projekte finalisieren (ROADMAP, CHANGELOG)
5. mrbz-dev Phase 1 Implementation starten

---

**Letzte Aktualisierung:** 2026-02-05
