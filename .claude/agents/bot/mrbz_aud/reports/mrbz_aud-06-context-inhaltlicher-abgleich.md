# mrbz_aud — Modul 06: Context inhaltlicher Abgleich

**Erstellt:** 2026-03-06
**Modul:** 06 — Context inhaltlicher Abgleich
**Scope:** `.claude/context/` Dateien vs. tatsaechlicher System-Status

---

## Zusammenfassung

| Severity | Anzahl |
|----------|--------|
| KRITISCH | 0 |
| MITTEL | 6 |
| INFO | 5 |

---

## Findings

### F06-01 [MITTEL] docker.md: Stacks als "Geplant" markiert die bereits existieren

**Datei:** `.claude/context/docker.md:54-61`
**Problem:** Die Tabelle "Geplante Stacks" listet ALLE Stacks als "Geplant", aber auf n8-vps existieren bereits 3 Stacks mit docker-compose.yml:
- `projects/infrastructure/n8-vps/stacks/traefik/docker-compose.yml`
- `projects/infrastructure/n8-vps/stacks/crowdsec/docker-compose.yml`
- `projects/infrastructure/n8-vps/stacks/authentik/docker-compose.yml`

**Erwartung:** Status mindestens auf "Aktiv" oder "Deployed" aktualisieren.
**Zusaetzlich:** CrowdSec und Authentik fehlen komplett in der Tabelle.

---

### F06-02 [MITTEL] infrastructure.md: Projekt-Location `mcp-server` existiert nicht

**Datei:** `.claude/context/infrastructure.md:83`
**Problem:** Tabelle "Projekt-Locations" referenziert `projects/infrastructure/mcp-server/` — dieses Verzeichnis existiert nicht im Repository.
**Pruefung:** `Glob projects/infrastructure/mcp-server/**/*` → No files found

---

### F06-03 [MITTEL] infrastructure.md: Projekt-Location `mrbz-dev` Stack existiert nicht

**Datei:** `.claude/context/infrastructure.md:82`
**Problem:** Tabelle referenziert `shared/stacks/mrbz-dev/` — dieses Verzeichnis existiert nicht (keine Dateien gefunden).
**Pruefung:** `Glob shared/stacks/mrbz-dev/**/*` → No files found
**Hinweis:** docker.md listet diesen Stack ebenfalls als "Geplant". Entweder als "Geplant" kennzeichnen oder Eintrag entfernen.

---

### F06-04 [MITTEL] shell.md: `010-ulimits.fish` in conf.d nicht dokumentiert

**Datei:** `.claude/context/shell.md:67-73`
**Problem:** Die Tabelle "Wichtige Dateien" listet conf.d-Dateien 000, 005, 008 — aber `010-ulimits.fish` (erstellt 2026-03-05) fehlt.
**Ist-Zustand conf.d:**
- `000-loader.fish` — dokumentiert
- `005-theme.fish` — dokumentiert
- `008-host-flags.fish` — dokumentiert
- `010-ulimits.fish` — NICHT dokumentiert

**shell.md zuletzt aktualisiert:** 2026-03-03 (vor Erstellung der Datei am 2026-03-05)

---

### F06-05 [MITTEL] tags.md: Tag-Zaehler in Root CLAUDE.md falsch

**Datei:** `CLAUDE.md` (Root, Zeile mit "68 Tags")
**Problem:** Root CLAUDE.md referenziert "68 Tags, 3-Zeichen-Index", tatsaechliche Zaehlung ergibt **70 Tags**:
- Generische Tags: 44 (Zeilen 24-67 in tags.md)
- Dienst-spezifische Tags: 26 (Zeilen 75-100 in tags.md)
- Gesamt: **70**

---

### F06-06 [MITTEL] infrastructure.md: Sanitization-Inkonsistenz

**Datei:** `.claude/context/infrastructure.md`
**Problem:** Hosts Matrix (Zeilen 19-29) verwendet sanitized Namen (host-dev, host-vps, etc.), aber SSH-Abschnitt (Zeilen 38-41) verwendet echte Hostnamen (n8-kiste, n8-vps, n8-station). Deployment-Status (Zeilen 106-115) wieder sanitized.
**Erwartung:** Entweder durchgaengig sanitized ODER durchgaengig echte Namen.

---

### F06-07 [INFO] shell.md: Falscher hwi-Pfad

**Datei:** `.claude/context/shell.md:209`
**Problem:** Referenziert `scripts/hwi/hwi.sh` — der tatsaechliche Pfad ist `shared/usr/local/bin/hwi/hwi.sh`.
**Hinweis:** infrastructure.md (Zeile 86) hat den korrekten Pfad `shared/usr/local/bin/`.

---

### F06-08 [INFO] shell.md: `.claude/context/` unter Fish als "Policies" gelistet, aber leer

**Datei:** `.claude/context/shell.md:167`
**Problem:** Verzeichnisstruktur listet `shared/etc/fish/.claude/context/` als "Fish-spezifische Policies", aber das Verzeichnis enthaelt nur `.gitkeep`.
**Bewertung:** Entweder Platzhalter fuer zukuenftige Nutzung (dann als solchen kennzeichnen) oder aus der Doku entfernen.

---

### F06-09 [INFO] shell.md: Zusaetzliche Functions nicht dokumentiert

**Datei:** `.claude/context/shell.md:183-189`
**Problem:** Abschnitt "Theme System" erwaehnt Helper-Funktionen, aber die vollstaendige Functions-Liste ist:
- `fish_prompt.fish`, `fish_right_prompt.fish`, `fish_greeting.fish`, `fish_mode_prompt.fish` — Prompt-System
- `theme.fish` — Theme-Steuerung
- `__mr_smart_pwd.fish`, `__mr_git_status.fish`, `__mr_docker_status.fish`, `__mr_host_color.fish` — Helpers
- `mr-bytez-info.fish` — Info-Funktion
- `host-test.fish` — Host-Test (nicht erwaehnt in shell.md)

**Bewertung:** `host-test.fish` fehlt in der Dokumentation. Geringe Prioritaet.

---

### F06-10 [INFO] docker.md: Fehlende n8-vps Stacks in Tabelle

**Datei:** `.claude/context/docker.md:54-61`
**Problem:** CrowdSec und Authentik Stacks existieren auf n8-vps (`projects/infrastructure/n8-vps/stacks/crowdsec/`, `.../authentik/`), sind aber nicht in der "Geplante Stacks"-Tabelle aufgefuehrt.
**Zusammenhang:** Siehe auch F06-01 (Status-Update noetig).

---

### F06-11 [INFO] tags.md: [rclone] Gross-/Kleinschreibung

**Datei:** `.claude/context/tags.md:91`
**Problem:** Alle Tags verwenden CamelCase/PascalCase (z.B. [AdGuard], [UptimeKuma]), aber [rclone] ist komplett kleingeschrieben.
**Bewertung:** Folgt dem offiziellen Produktnamen "rclone". Akzeptabel, aber stilistisch inkonsistent.

---

## Geprueft ohne Findings

| Context-Datei | Pruefung | Ergebnis |
|---------------|----------|----------|
| tags.md | Alphabetische Sortierung (Generisch) | OK — alle 44 Tags korrekt sortiert |
| tags.md | Alphabetische Sortierung (Dienst-spezifisch) | OK — alle 26 Tags korrekt sortiert |
| tags.md | 3-Zeichen-Index eindeutig | OK — keine Duplikate |
| shell.md | Host-Matrix vs. 008-host-flags.fish | OK — alle 8 Hosts + Flags stimmen exakt ueberein |
| shell.md | Shared Aliases (010-055) | OK — alle 10 Dateien vorhanden und dokumentiert |
| shell.md | Variables (010-paths) | OK — vorhanden |
| shell.md | Loader-Reihenfolge (6 Verzeichnisse) | OK — korrekt dokumentiert |
| shell.md | Host-spezifische Aliases (110-n8-*.fish) | OK — alle 8 Hosts haben 110-*.fish |
| infrastructure.md | 8 Hosts im Repo | OK — alle 8 Host-Verzeichnisse vorhanden |
| infrastructure.md | `.secrets/` Submodule | OK — existiert |
| infrastructure.md | `shared/usr/local/share/micro/` | OK — bindings.json + settings.json vorhanden |
| infrastructure.md | `shared/usr/local/bin/` (hwi) | OK — hwi.sh + Docs vorhanden |

---

## Nicht geprueft (laut Modul-Spec)

| Datei | Grund |
|-------|-------|
| security.md | Koennte sensible Details enthalten — explizit ausgenommen |
