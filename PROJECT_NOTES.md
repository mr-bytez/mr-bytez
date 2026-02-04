# PROJECT_NOTES.md

**Projekt:** mr-bytez
**Scope:** Repo-Policy & Arbeitsweise
**Prinzip:** Fish-first, reproduzierbar, dokumentiert
**Aktualisiert:** 2026-02-04

---

## 1) Grundprinzipien (kurz)

- **Single Source of Truth:** Live-Checkout liegt unter `/mr-bytez`.
- **Stabiler System-Anker:** System-Symlinks zeigen auf `/opt/mr-bytez/current`.
- **Explizit statt Magie:** keine stillen Side-Effects.
- **Security by Design:** keine Klartext-Secrets, keine Symlinks in sensible User-State-Dateien.

---

## 2) Shell-Standard: Fish-first

- Fish ist die **Referenz-Shell** für Skripte & Beispiele.
- **Keine Heredocs/EOF** in Fish (kein `cat <<EOF`).
- Datei-Generierung in Fish grundsätzlich mit `printf` + Redirect.

Beispiel (Pattern):

```fish
printf '%s\n' 'line1' 'line2' > file.txt
```

---

## 3) Tokens / Keys / `cat`-Alias (wichtig)

In diesem Projekt kann `cat` auf `bat` gemappt sein.

- **Nie Tokens/Keys mit dem `cat`-Alias lesen** (Formatierung/CRLF kann Secrets zerstören).
- Stattdessen immer:
  - `command cat` oder
  - `/usr/bin/cat`

Empfohlenes Sanitizing (Fish):

```fish
string replace -a \r '' | string trim
```

---

## 4) Secrets-Policy

- Secrets liegen ausschließlich im privaten Submodule: `shared/.secrets`.
- Im Hauptrepo: **keine** Klartext-Secrets.
- Im Secrets-Repo: nur **verschlüsselte** Dateien (z. B. `*.age`) + Metadaten (`*.info`) + Doku.
- Secrets **niemals** per Symlink ins System deployen.

Referenz: `shared/.secrets/SECRETS.md`

---

## 5) Deployment-Policy (Kurzfassung)

- Systemweite Symlinks zeigen **nur** auf:

```text
/opt/mr-bytez/current -> /mr-bytez
```

- Beispiele:

  - `/etc/fish -> /opt/mr-bytez/current/shared/etc/fish`
  - `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`

- **Verboten:** Deployment von `~/.ssh/config` (User-State). Stattdessen nur Template `config.example`.

Referenz: `DEPLOYMENT.md`

---

## 6) Doku-Workflow (verbindlich)

Wenn wir **Configs ändern**, **Deployment anpassen**, **Repos splitten/migrieren** oder **Security-Policies** verändern, dann gilt:

1. **Docs zuerst aktualisieren** (in derselben Arbeits-Session)
2. Danach erst Commit (nicht „Docs später")

Betroffene Dateien (typisch):

- `README.md` (Überblick + Status)
- `DEPLOYMENT.md` (Deployment-Guide + Policy)
- `PROJECT_NOTES.md` (Arbeitsweise/Regeln)
- `CHANGELOG.md` (was hat sich geändert)
- im Secrets-Repo: `SECRETS.md` (Token/Key-Hinweise, Recovery, Regeln)

### 6.1 Wichtige MD-Dateien: Update-Regel

Für zentrale Dateien wie `README.md`, `DEPLOYMENT.md`, `PROJECT_NOTES.md`, `CHANGELOG.md`, `ROADMAP.md` gilt:

- `README.md` ist **Überblick/Onboarding** (keine operativen Commands).
- Operative Commands/Schrittfolgen gehören nach `DEPLOYMENT.md`.
- **Basis ist immer die bestehende Datei.**
- Es werden **nur Ergänzungen** oder **kleine Korrekturen** gemacht.
- **Keine Kürzungen/Entfernungen** – außer du erlaubst es explizit.
- Vor Änderungen kurz erklären: **was** geändert wird, **wo** und **warum**.

---

## 7) Claude GitHub Integration (wichtig)

Das mr-bytez Repository ist über die **Claude.ai GitHub Integration** verbunden.

### Zugriff-Status

- **Repository:** `mr-bytez/mr-bytez` (GitHub)
- **Integration:** Claude.ai Projects → GitHub Integration (aktiv ✅)
- **Branch:** main
- **Berechtigungen:** Read-Only

### Was Claude KANN

- ✅ **Lesen:** Alle Dateien im Repository via `project_knowledge_search`
- ✅ **Analysieren:** Code, Configs, Dokumentation durchsuchen
- ✅ **Referenzieren:** Konkrete Dateipfade und Inhalte zitieren
- ✅ **Sync:** User kann "Sync now" klicken für Updates

### Was Claude NICHT KANN

- ❌ **Schreiben:** Keine direkten Commits ins Repository
- ❌ **Push:** Keine Änderungen pushen
- ❌ **PR:** Keine Pull Requests erstellen
- ❌ **Branch:** Keine Branch-Verwaltung

**Für Schreibzugriff:** Claude Code CLI verwenden (lokal auf n8-kiste)!

### Claude-Workflow

**IMMER zuerst im Repository suchen:**

```
project_knowledge_search → query: "relevante keywords"
```

**Beispiele:**
- Fish Config → `project_knowledge_search → "fish configuration loader"`
- Docker Stack → `project_knowledge_search → "docker stack traefik"`
- Deployment → `project_knowledge_search → "deployment symlinks"`

**NIEMALS annehmen:**
- ❌ "Ich habe keinen Zugriff auf das Repository..."
- ❌ "Bitte lade die Datei hoch..."
- ❌ "Ich kann das Repository nicht sehen..."

**IMMER tun:**
- ✅ `project_knowledge_search` verwenden
- ✅ Bei Fund direkt mit Arbeit beginnen
- ✅ Nur bei echtem Problem User informieren

### Sync-Strategie

**User synct manuell:**
- Nach größeren Commits
- Vor wichtigen Arbeiten
- Wenn Repository-Änderungen relevant sind

**Claude empfiehlt bei Bedarf:**
```
"Falls du kürzlich gepusht hast, bitte einmal
'Sync now' im Project Knowledge klicken."
```

### Verfügbare Dokumentation

**Via GitHub Integration (dynamisch):**
- Komplettes Repository durchsuchbar
- Fish Configs in `shared/etc/fish/`
- Docker Stacks in `projects/infrastructure/*/stacks/`
- Scripts in `scripts/`
- Alle Markdown-Docs

**In /mnt/project/ (statisch):**
- CLAUDE_ARBEITSWEISE.md
- CLAUDE_STRUKTUR_REFERENZ.md
- 00-uebersicht.md bis 06-hosts-uebersicht.md
- n8-vps_Installationsplan_v2_0_konsolidiert.md

**Wichtig:** `/mnt/project/` Dateien können veraltet sein - GitHub Integration ist die aktuelle Quelle!

---

## 8) Git Commit-Message Format (PFLICHT!)

Alle Commits MÜSSEN einem einheitlichen Format folgen.

### Standard-Format

```
[Kategorie1][Kategorie2] Kurze aussagekräftige Beschreibung

Optional: Ausführliche Beschreibung in folgenden Zeilen
- Detail 1
- Detail 2
- Detail 3
```

### Verfügbare Kategorien

**Hauptkategorien:**

- `[Docs]` - Dokumentations-Änderungen (README, DEPLOYMENT, PROJECT_NOTES, etc.)
- `[Config]` - Konfigurationsdateien (systemweit oder projekt-spezifisch)
- `[Fish]` - Fish Shell Configs, Functions, Aliases
- `[Docker]` - Docker Compose, Dockerfiles, Container-Configs
- `[Security]` - Security-relevante Änderungen, Secrets, Permissions
- `[Fix]` - Bug-Fixes, Korrekturen
- `[Feature]` - Neue Features, Funktionalität
- `[Refactor]` - Code-Umstrukturierung ohne Funktionsänderung
- `[Deploy]` - Deployment-bezogene Änderungen
- `[Test]` - Tests hinzufügen oder ändern
- `[CI/CD]` - Continuous Integration/Deployment
- `[Release]` - Release-Commits (mit Version)

**Spezial-Kategorien:**

- `[Submodule]` - Submodule-Updates
- `[Cleanup]` - Code-Aufräumarbeiten, Linting
- `[WIP]` - Work in Progress (nur für Feature-Branches!)
- `[Hotfix]` - Notfall-Fix in Production

### Multi-Tag Syntax

Wenn mehrere Bereiche betroffen sind, mehrere Tags verwenden:

```
✅ RICHTIG:
[Config][Fish] Loader v2.1 - Host-Override Mechanismus
[Docker][Traefik] SSL Wildcards konfiguriert
[Docs][Security] SECRETS.md erweitert - Recovery dokumentiert
[Fish][Feature] Powerline Prompt mit Git-Status

❌ FALSCH:
[Misc] Various changes
[Update] Config
Fixed stuff
```

### Ausführlichkeit ist PFLICHT

**Commit-Message muss beantworten:**
1. **Was** wurde geändert?
2. **Warum** wurde es geändert? (optional bei offensichtlichen Fixes)
3. **Wo** wurde es geändert? (Datei/Komponente)

**Beispiele:**

```
✅ AUSFÜHRLICH UND GUT:
[Fish][Config] Loader v2.1 - Hierarchische Override-Logik implementiert

- Shared Configs (00-69) laden zuerst
- Host-spezifische Overrides (70-89) danach
- User Tweaks (90-99) zum Schluss
- Debug-Modus via FISH_LOADER_DEBUG=1

Fixes: Konflikt zwischen n8-kiste und n8-vps Aliases

---

✅ GUT (für einfache Changes):
[Docs][PROJECT_NOTES] Abschnitt 8 hinzugefügt - Git Commit-Format

---

✅ GUT (Multi-File):
[Config][Docker] Traefik Stack v3 - Migration von v2

- docker-compose.yml auf neue Syntax
- Middlewares für SSL-Redirect
- Rate-Limiting konfiguriert
- Authentik Integration vorbereitet

---

❌ SCHLECHT - ZU KURZ:
[Docs] Update
[Fix] Fixed bug
[Config] Changes
Update README

---

❌ SCHLECHT - KEINE KATEGORIE:
Updated Fish config
Added new feature
Fixed deployment issue
```

### Wann welche Kategorie?

**[Docs]**
- README, DEPLOYMENT, PROJECT_NOTES, CHANGELOG, ROADMAP
- ADRs (Architecture Decision Records)
- Code-Kommentare (wenn standalone-Commit)

**[Config]**
- Systemweite Configs in `shared/`
- Host-spezifische Configs
- Environment-Variablen
- Symlink-Definitionen

**[Fish]**
- Fish Shell Configs (`conf.d/`, `functions/`, `aliases/`)
- Fish-spezifische Scripts
- Prompt-System, Theme

**[Docker]**
- docker-compose.yml
- Dockerfiles
- Stack-Konfigurationen
- Container-Umgebungen

**[Security]**
- Secrets (verschlüsselt!)
- Permissions-Änderungen
- SSH-Configs
- Firewall-Regeln
- Security-Patches

**[Fix]**
- Bug-Fixes
- Syntax-Korrekturen
- Broken-Links
- Permission-Fixes

**[Feature]**
- Neue Funktionalität
- Neue Commands/Scripts
- Neue Services/Stacks
- Erweiterte Config-Optionen

**[Deploy]**
- Deployment-Scripts
- symlinks.db Updates
- System-Integration
- Rollout-Prozesse

**[Release]**
- Version-Bumps
- CHANGELOG Updates für Release
- Git-Tags
- Production-Deployment

### Spezial-Fälle

**Mehrere Dateien, ein Thema:**

```
[Fish][Config] v2.1 Release - 8 Hosts konfiguriert

Neue Host-Configs:
- n8-vps (Server)
- n8-kiste (Desktop Dev)
- n8-station (Workstation)
- n8-book, n8-bookchen (Laptops)
- n8-maxx, n8-broker (Specialized)
- n8-archstick (Portable)

Dateien:
- projects/infrastructure/*/root/home/*/.config/fish/
```

**Submodule Updates:**

```
[Submodule] Secrets-Repo aktualisiert - Neue API-Tokens

- Codeberg Token erneuert
- GitHub Token hinzugefügt
- Recovery-Keys rotiert
```

**Hotfixes:**

```
[Hotfix][Security] SSH Port 22 → 61020

KRITISCH: Brute-Force Angriffe auf Port 22
- sshd_config angepasst
- UFW Rules aktualisiert
- SOFORT deployed auf n8-vps
```

### Commit-Workflow

```fish
# 1. Änderungen machen
micro PROJECT_NOTES.md

# 2. Status prüfen
git status

# 3. Staging
git add PROJECT_NOTES.md

# 4. Commit mit AUSFÜHRLICHER Message
git commit -m "[Docs][PROJECT_NOTES] Abschnitt 8 hinzugefügt - Git Commit-Format

- Standard-Kategorien definiert
- Multi-Tag Syntax dokumentiert
- Beispiele für gute/schlechte Commits
- Wann welche Kategorie verwenden"

# 5. Push
git push origin main
git push codeberg main
```

### Validierung vor Commit

**Checklist:**

- [ ] Mindestens eine Kategorie in `[...]`?
- [ ] Beschreibung aussagekräftig? (nicht nur "Update" oder "Fix")
- [ ] Bei Multi-File: Alle betroffenen Bereiche getaggt?
- [ ] Bei Breaking Change: Deutlich markiert?
- [ ] Bei Security: `[Security]` Tag vorhanden?

**Tools (optional):**

```fish
# Git Hook für Commit-Message Validierung
# TODO: Implementieren in .git/hooks/commit-msg
```

---

**Letzte Aktualisierung:** 2026-02-04
