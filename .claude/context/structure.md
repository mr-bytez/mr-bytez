# .claude/ Struktur — 5-5-3 Pattern

**Version:** 2.0.0
**Erstellt:** 2026-02-05
**Aktualisiert:** 2026-02-27
**Autor:** MR-ByteZ

---

## Pattern: 5-5-3

### 5 Dokumente (ueberall gleich):
```
README.md       → Mensch: Uebersicht (GitHub-Darstellung)
CLAUDE.md       → KI: Zentrale Steuerung + Verweise
CHANGELOG.md    → Historie (Was wurde gemacht)
ROADMAP.md      → Planung (Was kommt als naechstes)
DEPLOYMENT.md   → Deployment-Anleitung
```

### 5 Ordner (.claude/):
```
context/        → Details, Policies, Design-Docs
skills/         → AI-Skills (Custom Prompts)
hooks/          → Claude Code Event-Hooks (Bash-Scripts)
agents/         → Claude Code Agents (Spezialisierte Sub-Agenten)
archive/        → Abgeschlossene Arbeit
```

### 3 Ebenen:
```
Root            → Gesamtes Repo
.claude/        → KI-Context ROOT
Projekte        → Pro Host/Stack
```

---

## Root-Level

```
/mr-bytez/
├── README.md              # Mensch: Projekt-Übersicht
├── CHANGELOG.md           # Versions-Historie
├── ROADMAP.md             # Phasen & Milestones
├── .gitignore
├── .gitmodules
│
└── .claude/               # KI-Context ROOT
    ├── README.md              # GitHub-Darstellung
    ├── CLAUDE.md              # Zentrale Steuerung
    ├── CHANGELOG.md           # .claude/ Historie
    ├── ROADMAP.md             # .claude/ Planung
    │
    ├── context/               # Globale Policies & Daten
    ├── skills/                # AI-Skills (Custom Prompts)
    ├── hooks/                 # Claude Code Event-Hooks (7 Scripts)
    ├── agents/                # Claude Code Agents (4 Spezialisten)
    └── archive/               # Abgeschlossene Arbeit
```

**Root hat KEIN DEPLOYMENT.md** (Deployment-Infos in .claude/context/deployment.md)

---

## .claude/context/ — Globale Policies

### Inhalt:
```
context/
├── policies.md            # Grundprinzipien, Repo-Policies
├── shell.md               # Fish-first, Bash, Syntax
├── security.md            # Secrets, Tokens, Age, Sanitization Matrix
├── git.md                 # Commit-Format, Branches, Workflow
├── docker.md              # Container, Netzwerke, Naming (mrbz-*)
├── deployment.md          # Symlinks, Anker, Host-Setup
├── documentation.md       # Doku-Workflow, MD-Update-Regel
├── integration.md         # Claude GitHub, MCP, Sync, Opus 4.6
├── infrastructure.md      # Hosts-Matrix (sanitized), IPs, SSH
├── structure.md           # Dieses Dokument
├── tags.md                # Tag-Registry (Commits & Chat-Benennung)
├── migration.md           # Alte → Neue Struktur (archiviert)
├── claude-ai-projektanweisungen.txt  # Versionierte Projektanweisungen
│
└── handoffs/              # Aktive Handoff-Dokumente
    └── HANDOFF_[Tag1][Tag2]_beschreibung.md
```

### Zweck:
- **Gilt für ALLE Projekte**
- **EINMAL dokumentiert**
- **Projekte verweisen zurück**

### Beispiel-Verweis in Projekt CLAUDE.md:
```markdown
## Globale Policies
→ Siehe Root: .claude/context/policies.md
→ Fish-first, Git-Format, Secrets
```

---

## Projekte — Zwei Typen

### Typ 1: Physical Hosts (n8-kiste, n8-vps)

**Location:** `projects/infrastructure/<hostname>/`

```
projects/infrastructure/n8-kiste/
├── README.md                  # Host-Übersicht
├── CHANGELOG.md               # Host-Historie
├── ROADMAP.md                 # Host-Planung
├── DEPLOYMENT.md              # Host-Deployment
│
├── .claude/                   # Host KI-Context
│   ├── CLAUDE.md                  # Verweist auf Root + Host
│   ├── context/                   # Host-spezifisch
│   │   └── hardware.md                # CPU, RAM, Disks
│   ├── skills/                    # Host-Skills
│   └── configs/                   # Host-Configs
│
└── root/                      # Fish Configs für diesen Host
    └── home/mrohwer/.config/fish/
        ├── aliases/
        ├── variables/
        └── functions/
```

### Typ 2: Docker Stacks (mrbz-dev)

**Location:** `shared/stacks/<stackname>/`

```
shared/stacks/mrbz-dev/
├── README.md                  # Stack-Übersicht
├── CHANGELOG.md               # Stack-Historie
├── ROADMAP.md                 # Stack-Planung
├── DEPLOYMENT.md              # Stack-Deployment
│
├── .claude/                   # Stack KI-Context
│   ├── CLAUDE.md                  # Verweist auf Root + Stack
│   ├── context/                   # Stack-spezifisch
│   │   ├── adr-decisions.md           # Architektur-Entscheidungen
│   │   └── network.md                 # Container-Netzwerk
│   ├── skills/                    # Stack-Skills
│   └── configs/                   # Stack-Configs
│
├── docker-compose.yml         # Stack-Definition
├── Dockerfile                 # Container-Image
├── entrypoint.fish            # Container-Startup
│
└── root/                      # Container Fish Configs
    └── home/mrohwer/.config/fish/
```

### Typ 3: Community-Projekte

**Location:** `projects/community/<projektname>/`

Community-Projekte sind eigenstaendige Repositories die als
Git Submodule eingebunden werden. Sie haben eine eigene 5-5-3 Struktur.

```
projects/community/mr-bytez-learn/
├── (eigenes Repo mit eigener 5-5-3 Struktur)
└── (eingebunden als Git Submodule)
```

**Aktuell geplant:**
- mr-bytez-learn (Lernplattform, GPL v3)

**Verweis:** `.claude/context/handoffs/HANDOFF_[Learn][Stack]_mr-bytez-learn-projektplan.md`

---

## Wann was wohin?

### Root context/:
```
Globale Policies           → .claude/context/policies.md
Arbeitsweise (Fish, Git)   → .claude/context/shell.md, git.md
Security-Regeln            → .claude/context/security.md
Hosts-Übersicht            → .claude/context/infrastructure.md
Docker-Standards           → .claude/context/docker.md
Handoffs (offene Aufgaben) → .claude/context/handoffs/
Claude.ai Projektanweisungen → .claude/context/claude-ai-projektanweisungen.txt
```

### Projekt context/:
```
Hardware-Details           → projects/.../context/hardware.md
Architektur-Entscheidungen → shared/stacks/.../context/adr-decisions.md
Netzwerk-Design            → shared/stacks/.../context/network.md
Projekt-Notizen            → .../context/notes.md
```

### skills/:
```
Globale AI-Skills          → .claude/skills/
Projekt-Skills             → .../claude/skills/
```

### hooks/:
```
Claude Code Event-Hooks    → .claude/hooks/
  PreToolUse (Bash)        → fish-syntax-guard, secrets-guard, pre-commit-docs-check,
                              handoff-lifecycle-check, bash-command-logger
  PostToolUse (Bash)       → dual-push-reminder
  SessionStart             → session-start-info
```

### agents/:
```
Claude Code Agents         → .claude/agents/
  docs-agent               → Dokumentation pflegen (5-5-3, Additive-Only)
  audit-agent              → Read-only Bestandsaufnahmen und Reports
  deploy-agent             → Deployment auf Hosts ueber Anker-System
  scaffold-agent           → Neue Dateien mit korrektem Header erstellen
```

---

## CLAUDE.md — Aufbau

### Standard-Struktur (überall gleich):

```markdown
# [Name] — Claude Context

## Verweise
- Context: ...
- Skills: ...
- Configs: ...
- Projekte: ... (nur Root)

## Quick Start
1. Lies: README.md
2. Dann: ROADMAP.md
3. Details: context/

## Wichtige Policies
→ Siehe: .claude/context/policies.md

## Aktuell
→ Siehe: ROADMAP.md
```

### Root CLAUDE.md zusätzlich:
- Verweist auf aktive Projekte
- Listet Hosts/Stacks

### Projekt CLAUDE.md zusätzlich:
- Verweist zurück auf Root-Policies
- Projekt-spezifische Quick-Infos

---

## Prinzipien

### 1. Keine Redundanz
✅ Policies EINMAL in Root context/
✅ Projekte verweisen zurück
❌ NICHT in jedem Projekt wiederholen

### 2. Klare Trennung
✅ Mensch (README, Root-Docs)
✅ KI (.claude/, CLAUDE.md)
✅ Global vs Projekt (context/)

### 3. Konsistenz
✅ Gleiche Struktur überall
✅ Sofort klar wo was ist
✅ Skalierbar & eigenständig

---

## Beispiele

### Beispiel: Fish-first Policy

**Dokumentiert in:** `.claude/context/shell.md`

**Projekt CLAUDE.md verweist:**
```markdown
## Shell-Policies
→ Siehe Root: .claude/context/shell.md
- Fish-first (KEINE Bash heredocs!)
- printf statt cat <<EOF
```

**NICHT kopieren in jedes Projekt!**

### Beispiel: Container-Naming

**Dokumentiert in:** `.claude/context/docker.md`

```markdown
# Docker Standards

## Naming Convention
- Physical Hosts: n8-* Prefix
- Container/Stacks: mrbz-* Prefix
- Sofortige Unterscheidung physisch vs virtuell
```

**Projekt verweist zurück!**

### Beispiel: Sanitization Matrix

**Dokumentiert in:** `.claude/context/security.md`

```markdown
## Sanitization Matrix

| Real          | Sanitized       |
|---------------|-----------------|
| mrohwer       | mr-bytez-admin  |
| n8-kiste      | host-dev        |
| n8-vps        | host-vps        |
```

**In .gitignore:**
```
*sanitization*
*matrix*
```

---

**Letzte Aktualisierung:** 2026-02-27
