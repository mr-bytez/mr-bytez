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
- Bei groesseren/strategischen Commits: Chat-Link in die Commit-Message
  Format letzte Zeile: `Chat: https://claude.ai/chat/<id>`
  Ermoeglicht Rueckverfolgung warum eine Aenderung gemacht wurde
  Bei kleinen Fixes (Typo, Quick-Fix) nicht noetig

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

| Kategorie | Index | Verwendung |
|-----------|-------|------------|
| `[Docs]` | DOC | README, DEPLOYMENT, CHANGELOG, ROADMAP, ADRs |
| `[Config]` | CFG | Systemweite Configs, Environment-Variablen, Symlinks |
| `[Fish]` | FSH | Fish Shell Configs, Functions, Aliases, Prompt, Theme |
| `[Docker]` | DKR | docker-compose.yml, Dockerfiles, Stacks |
| `[Security]` | SEC | Secrets, Permissions, SSH, Firewall |
| `[Fix]` | FIX | Bug-Fixes, Syntax-Korrekturen, Permission-Fixes |
| `[Feature]` | FEA | Neue Funktionalität, Commands, Scripts, Services |
| `[Refactor]` | REF | Code-Umstrukturierung ohne Funktionsänderung |
| `[Deploy]` | DEP | Deployment-Scripts, symlinks.db, System-Integration |
| `[Test]` | TST | Tests hinzufügen oder ändern |
| `[Release]` | REL | Version-Bumps, Git-Tags, Production-Deployment |
| `[Submodule]` | SUB | Submodule-Updates |
| `[Cleanup]` | CLN | Aufräumarbeiten, Linting |
| `[Hotfix]` | HOT | Notfall-Fix in Production |
| `[Structure]` | STR | Ordner-/Dateistruktur, Migration |
| `[WIP]` | WIP | Work in Progress (nur für Feature-Branches!) |

> Vollstaendige Tag-Registry mit allen Tags: `context/tags.md`

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
- [ ] CHANGELOG aktualisiert (im selben Commit)?

---

## TAG_REGISTRY

Die zentrale Tag-Registry liegt in `context/tags.md`.
Alle Tags fuer Commits UND Chat-Benennung werden dort gepflegt.
Jeder Tag hat einen eindeutigen 3-Zeichen-Index.

> Vollstaendige Registry: `context/tags.md`

---

## Workflow

```fish
# 1. Änderungen machen
# 2. Status prüfen
git status

# 3. Staging
git add .

# 4. CHANGELOG (und ggf. ROADMAP) aktualisieren
#    IMMER VOR dem Commit! Nie als separater Folge-Commit.

# 5. Commit mit AUSFÜHRLICHER Message
git commit -m "[Kategorie] Beschreibung

- Detail 1
- Detail 2"

# 6. Push zu beiden Remotes
git push origin main && git push codeberg main

# 7. Claude.ai Sync (wenn relevant)
# Project Knowledge → Zahnrad → "Sync now"
```

### CHANGELOG-Regel

**CHANGELOG und ROADMAP werden VOR dem Commit aktualisiert — nicht danach!**

- Alle Aenderungen (Code, Doku, CHANGELOG, ROADMAP) gehoeren in EINEN Commit
- Kein separater "CHANGELOG aktualisiert"-Folge-Commit
- Bei jedem Commit pruefen: Gehoert ein CHANGELOG-Eintrag dazu?
- Root CHANGELOG: Fuer Repo-weite Aenderungen
- .claude/CHANGELOG: Fuer .claude/-spezifische Aenderungen

### Cross-Repo-Regel (Submodules)

**Aenderungen im Secrets-Repo muessen sich IMMER im Hauptrepo spiegeln!**

Bei JEDEM Secrets-Repo Commit pruefen:
1. **CHANGELOG.md (Hauptrepo)** — Braucht der Eintrag ein Update? (Fast immer: JA)
2. **ROADMAP.md (Hauptrepo)** — Wurde ein Task/Aufgabe erledigt?
3. **Handoff** — Wurde ein Handoff-Task erledigt?

Umgekehrt genauso: Aenderungen im Hauptrepo die das Secrets-Repo betreffen
→ .secrets/CHANGELOG.md und .secrets/ROADMAP.md pruefen.

**Reihenfolge bei Cross-Repo-Commits:**
1. Alle Docs in BEIDEN Repos aktualisieren (CHANGELOG, ROADMAP, Handoff)
2. Secrets-Repo committen + pushen
3. Hauptrepo committen (inkl. Submodule-Ref) + pushen
4. Alles in JE EINEM Commit pro Repo — keine Folge-Commits!

### Handoff-Bereinigung

**Erledigte Handoffs werden VOR dem Commit abgeschlossen — nicht danach!**

- Nach Erledigung aller Aufgaben: User fragen — loeschen oder archivieren?
- Loeschen/Archivieren gehoert in denselben Commit wie die erledigten Aenderungen
- Kein separater Folge-Commit fuer Handoff-Bereinigung

### Handoff-Aktualisierung

**Erledigte Aufgaben im Handoff werden VOR dem Commit markiert — nicht danach!**

- Task-Status im Handoff aktualisieren (Offen → Erledigt)
- Handoff-Header aktualisieren (Status, Chat-Referenzen, Commit-Hashes)
- Gehoert in denselben Commit wie die erledigten Aenderungen
- Kein separater Folge-Commit fuer Handoff-Aktualisierung!
- **Keine Hash-Endlosschleife:** Der letzte Commit-Hash (Handoff-/CHANGELOG-Update)
  wird NICHT nochmal im Handoff oder CHANGELOG nachgetragen.
  Handoffs dokumentieren inhaltliche Commits, nicht sich selbst.
