# Git — Commit-Format & Workflow

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Remotes

| Remote | URL | Zweck |
|--------|-----|-------|
| origin | GitHub (`mr-bytez/mr-bytez`) | Primär, Claude.ai Integration |
| codeberg | Codeberg (`n8lauscher/mr-bytez`) | Mirror, Backup |

**Push immer zu beiden:**
```fish
git push origin main && git push codeberg main
```

---

## Commit-Regeln

- Commits **nur auf n8-kiste** machen
- n8-vps ist **read-only** (nur `git pull`)
- Ausführlichkeit ist **Pflicht**
- Commit-Message muss beantworten: **was**, **warum**, **wo**

---

## Commit-Format

```
[Kategorie1][Kategorie2] Kurze aussagekräftige Beschreibung

- Detail 1
- Detail 2
- Detail 3
```

---

## Kategorien

| Kategorie | Verwendung |
|-----------|------------|
| `[Docs]` | README, DEPLOYMENT, CHANGELOG, ROADMAP, ADRs |
| `[Config]` | Systemweite Configs, Environment-Variablen, Symlinks |
| `[Fish]` | Fish Shell Configs, Functions, Aliases, Prompt, Theme |
| `[Docker]` | docker-compose.yml, Dockerfiles, Stacks |
| `[Security]` | Secrets, Permissions, SSH, Firewall |
| `[Fix]` | Bug-Fixes, Syntax-Korrekturen, Permission-Fixes |
| `[Feature]` | Neue Funktionalität, Commands, Scripts, Services |
| `[Refactor]` | Code-Umstrukturierung ohne Funktionsänderung |
| `[Deploy]` | Deployment-Scripts, symlinks.db, System-Integration |
| `[Test]` | Tests hinzufügen oder ändern |
| `[Release]` | Version-Bumps, Git-Tags, Production-Deployment |
| `[Submodule]` | Submodule-Updates |
| `[Cleanup]` | Aufräumarbeiten, Linting |
| `[Hotfix]` | Notfall-Fix in Production |
| `[Structure]` | Ordner-/Dateistruktur, Migration |
| `[WIP]` | Work in Progress (nur für Feature-Branches!) |

---

## Multi-Tag Syntax

Mehrere Tags bei mehreren betroffenen Bereichen:

```
✅ RICHTIG:
[Config][Fish] Loader v2.1 - Host-Override Mechanismus
[Docker][Traefik] SSL Wildcards konfiguriert
[Docs][Security] SECRETS.md erweitert - Recovery dokumentiert

❌ FALSCH:
[Misc] Various changes
[Update] Config
Fixed stuff
```

---

## Beispiele

**Ausführlich und gut:**
```
[Fish][Config] Loader v2.1 - Hierarchische Override-Logik implementiert

- Shared Configs (00-69) laden zuerst
- Host-spezifische Overrides (70-89) danach
- User Tweaks (90-99) zum Schluss
- Debug-Modus via FISH_LOADER_DEBUG=1

Fixes: Konflikt zwischen n8-kiste und n8-vps Aliases
```

**Gut (einfache Changes):**
```
[Docs][PROJECT_NOTES] Abschnitt 8 hinzugefügt - Git Commit-Format
```

**Schlecht:**
```
[Docs] Update
[Fix] Fixed bug
Updated Fish config
```

---

## Validierung vor Commit

- [ ] Mindestens eine Kategorie in `[...]`?
- [ ] Beschreibung aussagekräftig?
- [ ] Bei Multi-File: Alle Bereiche getaggt?
- [ ] Bei Breaking Change: Deutlich markiert?
- [ ] Bei Security: `[Security]` Tag vorhanden?

---

## TAG_REGISTRY (geplant)

Eine zentrale Registry aller verwendeten Tags (fuer Commits UND Chat-Benennung) ist geplant.
Verhindert Inkonsistenzen wie `[Wireguard]` vs. `[WG]` vs. `[VPN]`.

**Ablageort:** Noch offen — entweder hier in `git.md` oder eigene Datei `context/tags.md`
**Details:** `todo_aus_chats.../HANDOFF_X01-1_Chat-Benennungssystem.md`
**Umsetzung:** Geplant in Folge-Chat #X01.2

---

## Workflow

```fish
# 1. Änderungen machen
# 2. Status prüfen
git status

# 3. Staging
git add .

# 4. Commit mit AUSFÜHRLICHER Message
git commit -m "[Kategorie] Beschreibung

- Detail 1
- Detail 2"

# 5. Push zu beiden Remotes
git push origin main && git push codeberg main

# 6. Claude.ai Sync (wenn relevant)
# Project Knowledge → Zahnrad → "Sync now"
```
