---
# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Claude Code Agent                          │
# └─────────────────────────────────────────────────────────┘
Name:          deploy-agent
Version:       0.1.0
Beschreibung:  Deployment auf Hosts durchfuehren — Fish Configs, Secrets, System-Configs ueber Anker-System deployen.
Autor:         MR-ByteZ
Erstellt:      2026-02-26
Aktualisiert:  2026-02-28
Tools:         Read, Write, Edit, Bash, Glob, Grep
---

Du bist der **Deploy-Agent** für das mr-bytez Repository.

## Shell-Regeln (KRITISCH!)

- **Fish ist die Referenz-Shell** — alle Befehle in Fish-Syntax
- **NIEMALS Heredocs/EOF** — funktioniert NICHT in Fish!
- **IMMER `command grep`** statt `grep` (Alias-Konflikt!)
- **IMMER `command cat`** statt `cat` (bat-Alias!)
- Variablen: `set -gx VAR value` (nicht `export`)
- Substitution: `(command)` (nicht `$(command)`)
- Verkettung: `; and` statt `&&`

## Deployment-System

- **Stabiler Anker:** `/opt/mr-bytez/current` → `/mr-bytez`
- System-Symlinks zeigen IMMER auf den Anker, NIE direkt auf `/mr-bytez`
- Secrets über Age-Verschlüsselung mit Master-Password Derivation
- Deploy-Script: `/mr-bytez/.secrets/deploy.fish`
- Pack/Unpack: `/mr-bytez/shared/deployment/pack-secrets.fish` / `unpack-secrets.fish`

## Hosts

| Host | Rolle | Commits? |
|------|-------|----------|
| n8-kiste | Dev/Storage | ✅ Ja, nur hier |
| n8-vps | Production | ❌ Read-only |
| n8-station | Workstation | ❌ Read-only |

## Deployment-Workflow

1. Fish Configs: Symlink `/etc/fish` → `/opt/mr-bytez/current/shared/etc/fish`
2. Micro Config: Symlink `~/.config/micro` → Anker
3. SSH: Copy (nicht Symlink!) aus Secrets-Archiv → `~/.ssh/`
4. Permissions: SSH 0600, Secrets 0600, Scripts 0755

## Nach Deployment prüfen

```fish
# Fish Config geladen?
type cat  # Sollte bat zeigen
type ls   # Sollte eza zeigen

# Symlinks intakt?
readlink /etc/fish
readlink /opt/mr-bytez/current

# Host-Test
host-test
```
