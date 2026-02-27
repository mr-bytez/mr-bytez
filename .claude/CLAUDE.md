# mr-bytez — Claude Context

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-27
**Autor:** MR-ByteZ

---

## Verweise

| Bereich | Pfad |
|---------|------|
| Context (Policies) | `.claude/context/` |
| Skills (AI-Skills) | `.claude/skills/` |
| Hooks (Event-Hooks) | `.claude/hooks/` |
| Agents (Sub-Agenten) | `.claude/agents/` |
| Archive (Abgeschlossenes) | `.claude/archive/` |

---

## Quick Start

1. **Lies:** `README.md` (Root) — Projekt-Übersicht für Menschen
2. **Dann:** `ROADMAP.md` (Root) — Was läuft, was kommt
3. **Details:** `.claude/context/` — Alle Policies & Konventionen

---

## Wichtige Policies

→ Grundprinzipien: `.claude/context/policies.md`
→ Fish-first Shell: `.claude/context/shell.md`
→ Git-Workflow + Cross-Repo-Regel: `.claude/context/git.md`
→ Secrets & Security: `.claude/context/security.md`
→ Deployment & Anker: `.claude/context/deployment.md`
→ Dokumentation: `.claude/context/documentation.md`

---

## Struktur-Pattern

Dieses Repo folgt dem **5-5-3 Pattern** (5 Docs, 5 Ordner, 3 Ebenen).
→ Vollstaendig dokumentiert in: `.claude/context/structure.md`

---

## Claude Code Hooks (7)

Event-basierte Automatisierung in `.claude/hooks/`:

| Hook | Event | Zweck |
|------|-------|-------|
| `session-start-info.sh` | SessionStart | Zeigt offene Handoffs und Git-Status |
| `secrets-guard.sh` | PreToolUse/Read | Blockiert Zugriff auf entschluesselte Secrets |
| `fish-syntax-guard.sh` | PreToolUse/Bash | Blockiert Heredocs/EOF und Bash-Fallen |
| `dual-push-reminder.sh` | PostToolUse/Bash | Erinnert nach git push an Codeberg |
| `pre-commit-docs-check.sh` | PreToolUse/Bash | Prueft CHANGELOG/ROADMAP im Staging |
| `handoff-lifecycle-check.sh` | PreToolUse/Bash | Prueft erledigte Handoffs |
| `bash-command-logger.sh` | PreToolUse/Bash | Audit-Trail in `.claude/logs/` |

---

## Claude Code Agents (4)

Spezialisierte Sub-Agenten in `.claude/agents/`:

| Agent | Zweck |
|-------|-------|
| `docs-agent.md` | Dokumentation pflegen (5-5-3, Additive-Only, Tags) |
| `audit-agent.md` | Read-only Auditor (Bestandsaufnahmen, Reports) |
| `deploy-agent.md` | Deployment auf Hosts (Anker-System, Fish-first) |
| `scaffold-agent.md` | Neue Dateien mit korrektem Header/Banner erstellen |

---

## Aktive Projekte

| Projekt | Typ | Pfad |
|---------|-----|------|
| n8-kiste | Physical Host | `projects/infrastructure/n8-kiste/` |
| n8-vps | Physical Host | `projects/infrastructure/n8-vps/` |
| mrbz-dev | Docker Stack | `shared/stacks/mrbz-dev/` |

---

## Hosts-Übersicht

8 verwaltete Hosts: n8-kiste, n8-station, n8-vps, n8-book, n8-bookchen, n8-maxx, n8-broker, n8-archstick
→ Details: `.claude/context/infrastructure.md`

---

## Aktuell

→ Siehe: `ROADMAP.md` (Root) für Gesamtplanung
→ Siehe: `.claude/ROADMAP.md` für .claude/-spezifische Planung

---

## Policies

→ Siehe Root: `CLAUDE.md` — Alle Policies und Shell-Regeln
→ Detail-Policies: `.claude/context/` (shell, git, security, docker, deployment, ...)
