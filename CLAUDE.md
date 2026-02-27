# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Projekttyp

Infrastruktur-Meta-Repository — keine klassische Software mit Build/Test/Lint.
Verwaltet Arch Linux Hosts, Fish-Shell-Configs, Secrets (Age-encrypted) und Deployment.
Live-Checkout: `/mr-bytez`, stabiler Anker: `/opt/mr-bytez/current`.

## Shell-Regeln (Fish-first)

- **Fish ist die Referenz-Shell.** Alle Skripte und Befehle in Fish-Syntax.
- **Keine Heredocs/EOF** — `cat <<EOF` funktioniert nicht in Fish!
- **Kein `&&`** — Fish nutzt `; and` oder Befehle untereinander
- **`command grep`** statt `grep` (Alias-Konflikt!)
- **`command cat`** statt `cat` (bat-Alias kann Output verfaelschen)
- Variablen: `set -x VAR value` (nicht `export`)
- Substitution: `(cmd)` (nicht `$(cmd)`)
- Datei-Generierung: `printf '%s\n' 'Zeile1' 'Zeile2' > datei.txt`
- **Nach `pacman -Syu`:** `/etc/fish` Symlink pruefen! (→ `.claude/context/deployment.md`)

→ Details: `.claude/context/shell.md`

## Git-Workflow

- Commits **nur auf n8-kiste**, n8-vps ist read-only
- Push immer zu beiden Remotes: `git push origin main; git push codeberg main`
- Commit-Format: `[Tag1][Tag2] Beschreibung` — Tags aus `.claude/context/tags.md`
- CHANGELOG + ROADMAP im selben Commit aktualisieren, kein Folge-Commit
- Erledigte Handoffs im selben Commit loeschen/archivieren
- Bei strategischen Commits: Chat-Link als letzte Zeile der Message
- Kein Co-Authored-By in Commits — nicht erwuenscht, bitte unterdruecken

→ Details: `.claude/context/git.md`

## Sprache

- Dokumentation, Kommentare, Commits: **Deutsch**
- Variablen- und Funktionsnamen: **Englisch**

## Zentrale Policies

- **Additive-Only:** Zentrale MDs (README, DEPLOYMENT, CHANGELOG, ROADMAP) nur ergaenzen, nicht kuerzen
- **Docs-first:** Dokumentation VOR Code, alles in einem Commit
- **Keine Redundanz:** Policies EINMAL in `.claude/context/` definieren, Projekte verweisen zurueck
- **Secrets:** Nur Age-verschluesselt im Submodule `.secrets/`, nie Klartext im Repo
- **Deployment:** System-Symlinks zeigen auf `/opt/mr-bytez/current`, nie direkt auf `/mr-bytez`
- **CHANGELOG-Regel:** CHANGELOG + ROADMAP VOR dem Commit aktualisieren, alles in EINEM Commit

## Handoffs

Offene Aufgaben in `.claude/context/handoffs/`. Bei Chat-Start pruefen ob relevante Handoffs existieren.

## Claude Code Automation

→ `.claude/hooks/` — 7 Event-Hooks (Secrets-Guard, Fish-Syntax, Docs-Check, Dual-Push, ...)
→ `.claude/agents/` — 4 Agents (docs, audit, deploy, scaffold)

## Zentrale Steuerung & Detail-Policies

→ `.claude/CLAUDE.md` — Zentrale Steuerung mit allen Verweisen
→ `.claude/context/` — Alle 11 Policy-Dateien (shell, git, security, docker, deployment, ...)
→ `.claude/context/tags.md` — Tag-Registry (67 Tags, 3-Zeichen-Index)
→ `.claude/context/structure.md` — Repo-Aufbau, 5-5-3 Pattern, Verzeichnisstruktur
→ `.claude/context/infrastructure.md` — Hosts, Netzwerk, SSH
→ `ROADMAP.md` — Aktuelle Planung
