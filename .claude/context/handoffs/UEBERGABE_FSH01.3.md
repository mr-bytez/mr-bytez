# Übergabe-Protokoll für #FSH01.3

## Chat-Info

| Feld | Wert |
|------|------|
| Vorgänger | #FSH01.2 |
| Chat-Link | https://claude.ai/chat/CURRENT (beim Schließen ergänzen) |
| Chat-Start | 2026-02-26 01:12 CET |
| Kette | #FSH01.1 → #FSH01.2 → #FSH01.3 |
| Haupt-Task | A2 Fish DRY-Refactoring |

## Chat-Name Vorschlag für Folge-Chat

> MR-ByteZ #FSH01.3 [Fish][Config] - A2 Hooks-Agents-Deploy Audit-Tasks Header-Audit - claude-code-hooks scaffold-agent versionierung --- 2026-02-XX-XX-XX

---

## Was in #FSH01.2 passiert ist

### 1. Report-Review aus #FSH01.1 (4 Audit-Reports)

Alle 4 Reports aus #FSH01.1 wurden strategisch geprüft und bewertet:

**Direkt klar (keine Diskussion nötig):**
- Repo produktionsbereit für A2
- 21 bare `rm` in Automation-Scripts akzeptabel
- 2 Header-Standards (7-Feld + 9-Zeilen-Box) beide behalten
- Gruvbox-Farbschema konsistent
- Altes mr-bytez.dev Repo: ~25 min Aufwand, dann löschbar

**Diskussionspunkte identifiziert:**
1. Lade-Reihenfolge Host-Flags → 008 (Shared) aus #FSH01.1 bestätigt
2. fail2ban auf n8-vps INAKTIV → Sicherheitsrisiko, muss geklärt werden
3. Paketinstallation als Phase 0 Pre-Flight
4. 5-3-3 Lücken (README.md + DEPLOYMENT.md in shared/etc/fish/)
5. Host-Config Inventur → eigenes B-Task (nicht A2)
6. Edge-Bookmarks (4620!) ohne Backup → eigener B-Task
7. Plasma-Scripts Ziel → shared/bin/plasma/ oder host-spezifisch?
8. A2-Handoff v2.1 teilweise veraltet → Rewrite nötig

### 2. Neue Audit-Aufgaben identifiziert

User erkannte: Report 4 (altes Repo) war nicht gründlich genug. Viel mehr Dokumente:

| Audit | Ziel | Umfang |
|-------|------|--------|
| Audit 5 | mr-bytez_chat_context/ | 15 Doks, ~250 KB |
| Audit 6 | claude/chat/ | 31 Doks, ~600 KB |
| Audit 7 | Merge-Vergleich 5+6 vs. Repo | Wartet auf 5+6 |
| Audit 8 | /srv Docker-Stacks | 8 Stacks, Daten |

Task-Prompts erstellt unter `/home/claude/audit-tasks/` → für Claude Code.

### 3. Claude Code Permissions optimiert

Neue `settings.local.json` erstellt mit 3 Stufen:
- **allow:** Lesende Befehle (ls, cat, grep, git log, docker ps, systemctl status)
- **ask:** Schreibende Git-Ops (commit, push, add) + SSH
- **deny:** Destruktive Ops (rm -rf, force-push) + Secrets-Zugriff

Zusätzlich: `includeCoAuthoredBy: false`

### 4. ⭐ Claude Code Hooks erstellt (7 Stück)

| # | Hook | Event | Zweck |
|---|------|-------|-------|
| 1 | bash-command-logger.sh | PreToolUse:Bash | Audit-Trail aller Commands |
| 2a | pre-commit-docs-check.sh | PreToolUse:Bash | CHANGELOG/ROADMAP im Staging? |
| 2b | handoff-lifecycle-check.sh | PreToolUse:Bash | Erledigte Handoffs bereinigt? |
| 3 | secrets-guard.sh | PreToolUse:Read | Blockiert Secrets/.env/SSH-Keys |
| 4 | dual-push-reminder.sh | PostToolUse:Bash | Erinnert an zweiten Remote |
| 5 | fish-syntax-guard.sh | PreToolUse:Bash | Blockiert Heredocs, warnt bei Bash-Syntax |
| 6 | session-start-info.sh | SessionStart | Zeigt Handoffs + Git-Status |

### 5. ⭐ Claude Code Agents erstellt (4 Stück)

| # | Agent | Zweck |
|---|-------|-------|
| 1 | audit-agent | Read-Only Auditor für Bestandsaufnahmen |
| 2 | deploy-agent | Fish-first Deployment auf Hosts |
| 3 | docs-agent | Dokumentation nach 5-5-3 Pattern |
| 4 | scaffold-agent | Neue Dateien mit korrektem Header/Banner/Version |

### 6. Versionierungs-Regel festgelegt

**Neue Regel:** Alle neuen Dateien starten bei `0.1.0`
- `0.1.0` → Erster Entwurf
- `0.x.y` → Iterative Verbesserungen
- `1.0.0` → Erst wenn stabil und bewährt, keine Fixes seit längerer Zeit

**Versionierungs-Chaos im Repo identifiziert:**
- `MRBYTEZ_VERSION` = 2.0.0 in banner.fish
- `theme_version` = 2.0.0 in mr-bytez.fish ABER 1.0.0 in 00-theme.fish (Konflikt!)
- `script_version` = verschiedene Werte in Deployment-Scripts
- Meiste Dateien: nur im Header-Kommentar, keine Variable
→ Vereinheitlichung als Punkt in A2

### 7. Header-Audit-Task erstellt

Einmaliger Task: Alle bestehenden Dateien im Repo auf Header-Konformität prüfen und korrigieren.
- Phase 1: Audit (audit-agent) → Report
- Phase 2: Korrektur (Claude Code)
- Phase 3: Ein sauberer Commit

---

### 8. ⭐ 5-3-3 Pattern → 5-5-3 Pattern

Struktur-Aufräumung beschlossen:

| Aktion | Was | Grund |
|--------|-----|-------|
| ❌ Löschen | `docs/` (Root) | Leer |
| ❌ Löschen | `.claude/projects/` | Obsolet (GitHub-Repo direkt integriert) |
| ❌ Löschen | `.claude/configs/` | Leer (.gitkeep), settings.local.json liegt direkt in .claude/ |
| ✅ Behalten | `.claude/skills/` | Für zukünftige Claude Skills |
| 🆕 Erstellen | `.claude/hooks/` | Claude Code Hooks |
| 🆕 Erstellen | `.claude/agents/` | Claude Code Agents |
| 🆕 Erstellen | `.claude/logs/` | Generiert (.gitignore) |

**5-5-3 Pattern:**

5 Docs: README, CLAUDE, CHANGELOG, ROADMAP, DEPLOYMENT
5 Ordner: context/, archive/, skills/, hooks/, agents/
3 Ebenen: Root, .claude/, Projekte

```
.claude/
├── context/    # 1. Policies, Handoffs, Reports
├── archive/    # 2. Abgeschlossenes
├── skills/     # 3. Claude Skills (Zukunft)
├── hooks/      # 4. Claude Code Hooks
├── agents/     # 5. Claude Code Agents
└── logs/       # (generiert, .gitignore)
```

**Zu aktualisieren:** `.claude/context/structure.md` (5-3-3 → 5-5-3)

---

## Erstellte Dateien (14 Stück, alle v0.1.0)

### Im Repo zu platzieren:

```
/mr-bytez/.claude/
├── hooks/                          # 7 Hook-Scripts (Bash)
│   ├── bash-command-logger.sh
│   ├── pre-commit-docs-check.sh
│   ├── handoff-lifecycle-check.sh
│   ├── secrets-guard.sh
│   ├── dual-push-reminder.sh
│   ├── fish-syntax-guard.sh
│   └── session-start-info.sh
├── agents/                         # 4 Subagents (Markdown)
│   ├── audit-agent.md
│   ├── deploy-agent.md
│   ├── docs-agent.md
│   └── scaffold-agent.md
└── settings.local.json             # PERSÖNLICH (nicht committen!)
```

### Zusätzliche Dateien (nicht im Repo):

- `INSTALLATION.md` — Schritt-für-Schritt Anleitung
- `TASK_HEADER_AUDIT.md` → nach `.claude/context/handoffs/` kopieren

---

## Commit-Vorschlag

```
[Config][Structure] Claude Code Hooks v0.1.0 + Agents v0.1.0 + 5-5-3 Pattern

- 5-3-3 → 5-5-3: hooks/ und agents/ als neue Ordner, configs/ und projects/ gelöscht
- docs/ (Root) gelöscht (war leer)
- 7 Hooks: bash-logger, pre-commit-docs-check, handoff-lifecycle,
  secrets-guard, dual-push-reminder, fish-syntax-guard, session-start
- 4 Agents: audit-agent (read-only), deploy-agent, docs-agent, scaffold-agent
- Automatische Regel-Enforcement: CHANGELOG, Handoffs, Fish-Syntax, Secrets
- Audit-Trail für alle Bash-Commands
- Versionierungs-Regel: Neue Dateien starten bei 0.1.0

Chat: https://claude.ai/chat/<id>
```

**WICHTIG vor dem Commit:**
- CHANGELOG + ROADMAP aktualisieren
- `structure.md` aktualisieren (5-3-3 → 5-5-3)
- `.gitignore` ergänzen (`.claude/logs/`)
- **NICHT committen:** settings.local.json, .claude/logs/

---

## 5-5-3 Pattern (NEU, ersetzt 5-3-3)

**Entscheidung:** 5-3-3 wird zu 5-5-3 — neuer Pattern-Name.

**5 Dokumente:**
1. README.md
2. CLAUDE.md
3. CHANGELOG.md
4. ROADMAP.md
5. DEPLOYMENT.md

**5 Ordner (.claude/):**
1. `context/` — Policies, Handoffs, Reports
2. `archive/` — Abgeschlossenes
3. `skills/` — Claude Skills (Zukunft)
4. `hooks/` — Claude Code Hooks (NEU)
5. `agents/` — Claude Code Agents (NEU)
+ `logs/` — generiert, in .gitignore

**3 Ebenen:**
1. Root → `/mr-bytez/`
2. .claude/ → `/mr-bytez/.claude/`
3. Projekte → Pro Host/Stack

### Aufräum-Aktionen VOR dem Commit

| Aktion | Was | Grund |
|--------|-----|-------|
| ❌ Löschen | `docs/` (Root) | Leer |
| ❌ Löschen | `.claude/projects/` | Obsolet (GitHub-Repo-Integration ersetzt das) |
| ❌ Löschen | `.claude/configs/` | Leer, settings.local.json liegt direkt in .claude/ |
| 🆕 Erstellen | `.claude/hooks/` | 7 Hook-Scripts |
| 🆕 Erstellen | `.claude/agents/` | 4 Agent-Dateien |
| 🆕 Erstellen | `.claude/logs/` | Generiert, .gitignore |
| 📝 Updaten | `.claude/context/structure.md` | 5-3-3 → 5-5-3 |
| 📝 Updaten | `.claude/context/documentation.md` | Pattern-Name anpassen |
| 📝 Updaten | Projektanweisungen | Pattern-Name anpassen |

---

## Offene Aufgaben für #FSH01.3

### Priorität 1: Aufräumen + Commit
1. Leere Ordner löschen (docs/, .claude/projects/, .claude/configs/)
2. Neue Ordner erstellen (hooks/, agents/, logs/)
3. Dateien ins Repo kopieren
4. .gitignore ergänzen (.claude/logs/)
5. structure.md + documentation.md → 5-5-3 aktualisieren
6. CHANGELOG + ROADMAP aktualisieren
7. Committen + Dual-Push

### Priorität 2: Audit-Tasks starten
5. settings.local.json auf n8-kiste deployen
6. Hooks testen (SessionStart, Fish-Guard, Pre-Commit)
7. Audits 5, 6, 8 parallel starten (3 Claude Code Konsolen)
8. Audit 7 wenn 5+6 fertig

### Priorität 3: Diskussionspunkte klären
9. fail2ban auf n8-vps
10. Plasma-Scripts Ziel (shared vs. host-spezifisch)
11. A2-Handoff komplett neu schreiben
12. Header-Audit-Task starten (scaffold-agent validiert danach)

### Priorität 4: Versionierungs-Vereinheitlichung
13. theme_version Konflikt (1.0.0 vs 2.0.0) auflösen
14. Einheitliches Schema für alle Versionsvariablen definieren

---

## Aktive Handoffs im Repo

| Handoff | Status | A2-relevant? |
|---------|--------|--------------|
| HANDOFF_[Fish][Refactor]_fish-dry-refactoring.md | In Arbeit | JA — Kern |
| HANDOFF_[Fish][Theme]_script-formatting-library.md | Offen | JA — Phase 3+4 |
| HANDOFF_[SMB][Deploy]_smb-shares-deployment.md | In Arbeit | TEILWEISE |
| HANDOFF_[Security][Git]_git-filter-cleanup.md | TODO (A5) | NEIN |
| HANDOFF_[Learn][Stack]_mr-bytez-learn.md | Entwurf | NEIN |
| HANDOFF_[Secrets][Structure]_a1-secrets-repo.md | Erledigt (bis D13) | NEIN |

## Aktive Reports im Repo

| Report | Pfad |
|--------|------|
| A2 Verifikation | .claude/context/handoffs/REPORT_A2_VERIFIKATION.md |
| Script-Formatierung | .claude/context/handoffs/REPORT_A2_VERIFIKATION_TEIL2.md |
| Host-Config Inventur | .claude/context/handoffs/REPORT_HOST_CONFIG_INVENTUR.md |
| Altes Repo Inventur | .claude/context/handoffs/REPORT_ALTES_REPO_INVENTUR.md |

---

## Lessons Learned (kumuliert)

1. CHANGELOG-Regel: Alle Docs VOR dem Commit aktualisieren
2. Cross-Repo-Regel: Secrets ↔ Hauptrepo synchron halten
3. sudo + command: Bei sudo kein `command` Prefix
4. Idempotenz-Check: diff-basiert funktioniert perfekt
5. Versionsnummern als Variable: Nie hardcoded
6. #15 cat-Alias-Falle: `command`-Prefix Pflicht in Scripts
7. Heredoc verboten: NIEMALS EOF/Heredoc in Fish!
8. #16 SSH + Fish: Bash-Syntax über SSH auf Fish-Hosts → Fish-Syntax oder `bash -c`
9. **#17 Versionierung:** Neue Dateien starten bei 0.1.0, nicht 1.0.0. Erst nach bewährtem Einsatz → 1.0.0
10. **#18 Header-Standard:** Kompakt-Banner `┌──┘` für Scripts, Box `╔══╝` für Configs, YAML-Frontmatter für Agents
11. **#19 Hooks sind Bash:** Claude Code Hooks laufen über /bin/sh — Ausnahme von Fish-first Regel
12. **#20 Pattern-Evolution:** 5-3-3 → 5-5-3 — Patterns dürfen wachsen wenn neue Ordner sinnvoll sind, aber leere Platzhalter konsequent entfernen
