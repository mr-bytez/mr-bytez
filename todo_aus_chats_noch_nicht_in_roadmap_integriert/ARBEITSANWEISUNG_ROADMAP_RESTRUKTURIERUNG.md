# Arbeitsanweisung: Roadmap-Restrukturierung + Inventur-Integration

**Erstellt:** 2026-02-10
**Autor:** MR-ByteZ
**Zweck:** Übergabe-Dokument für Claude Code — enthält ALLE Ergebnisse aus Chat 3 (Inventur-Kategorisierung)
**Ablage im Repo:** `todo_aus_chats_noch_nicht_in_roadmap_integriert/ARBEITSANWEISUNG_ROADMAP_RESTRUKTURIERUNG.md`

---

## Kontext

In Chat 3 wurden ALLE offenen Aufgaben aus drei Quellen inventarisiert und kategorisiert:

1. `todo_aus_chats_noch_nicht_in_roadmap_integriert/INVENTUR.md` (6 Handoff-Dateien)
2. `ROADMAP.md` (Root — offene Einträge Phase 2-4)
3. `.claude/ROADMAP.md` (Phase 4+5)

Ergebnis: **40 Aufgaben** in 4 Kategorien + Timing-Matrix.

---

## Kategorien-Definition

- **A: Eigenes Projekt** → Groß genug für 5-3-3 Pattern (eigene ROADMAP.md, CLAUDE.md, README.md, CHANGELOG.md, ggf. DEPLOYMENT.md + `.claude/context/`)
- **B: Root-Roadmap Eintrag** → Zu klein für eigenes Projekt, wird als Milestone/Task in Root-Roadmap geführt
- **C: Policy/Konvention** → Kein Projekt, gehört in `.claude/context/`
- **D: Prerequisite/Sub-Task** → Gehört unter ein bestehendes A- oder B-Projekt

---

## Kategorie A: Eigene Projekte (5-3-3 Pattern)

### A1: Secrets-Repo Restrukturierung (HÖCHSTE PRIORITÄT — Basis für alles)

**Umfang:**
- Secrets-Submodule (`shared/home/mrohwer/.secrets`) auf 5-3-3 Pattern migrieren
- symlinks.db ins private Submodule verschieben
- Eigene CLAUDE.md, ROADMAP.md, README.md, CHANGELOG.md im Secrets-Repo
- Secrets-Inventar vollständig und konsistent

**Quellen:**
- `.claude/ROADMAP.md` Phase 4 (Secrets-Submodule 5-3-3 + symlinks.db)
- Inventur #3 (SSH-Config Secrets-Deployment)

**B/D-Tasks die hier mitlaufen:**
- B1: SSH-Config Secrets-Deployment (→ Details: `HANDOFF_2026-02-08.md`, Aufgabe 1)
- B9: Submodule n8-vps einrichten (nach A1)
- B10: Submodule n8-kiste einrichten (nach A1)
- D9: symlinks.db verschieben (Teil des Projekts)
- D13: Credentials n8-archstick aktualisieren (→ Details: `HANDOFF_SMB_DEPLOYMENT.md`)

**5-3-3 Ort:** Im Secrets-Repo selbst (anderes Repo — hier nur Roadmap-Verweis)

---

### A2: Fish DRY-Refactoring

**Umfang:**
- Komplettes DRY-Refactoring der Fish Shell Config
- Neues Nummerierungsschema 000-200
- Feature-Flags (MR_HAS_GUI, MR_IS_DEV, MR_DISPLAY_TYPE)
- Shared Conditionals, Loader-Umbau
- 8 Hosts betroffen
- 7-Phasen-Plan

**Quellen:**
- Inventur #2 (→ Details: `fish-config-refactoring-arbeitsanweisung.md`)
- Root ROADMAP Phase 2 (Bash-Config, mr-bytez-info.fish)

**B/D-Tasks die hier mitlaufen:**
- B2: /etc/hosts Dokumentation (Host-Matrix wird eh erstellt, → Details: `HANDOFF_2026-02-08.md`, Aufgabe 2)
- B3: README Struktur-Baum prüfen/fixen (→ Details: `HANDOFF_2026-02-08.md`, Aufgabe 3)
- B4: Git-Config Shared (→ Details: `HANDOFF_2026-02-08.md`, Aufgabe 4)
- B5: SMB-Shares Deployment (nach Fish DRY, → Details: `HANDOFF_SMB_DEPLOYMENT.md`)
- B6: Bash-Config (gleiche Struktur-Entscheidungen, parallel planen)
- B7: mr-bytez-info.fish (nutzt neue Metadaten-Tags)
- B17: VLC Desktop-Paketliste (Sub-Task von B5)

**5-3-3 Ort:** `shared/etc/fish/` — Docs leben beim Code

---

### A3: Claude Dev Container

**Umfang:**
- Docker Stack (Dockerfile, docker-compose.yml, .devcontainer)
- Arch Linux Container mit Fish, Claude Code, Tools
- mr-bytez Integration (Anker, Symlinks)
- VS Code Dev Container Support

**Quellen:**
- Root ROADMAP Phase 3, Priorität 1
- `.claude/archive/mrbz-dev-plan.md` (detaillierter Plan)

**B/D-Tasks die hier mitlaufen:**
- B8: Docs-Struktur (im Container testen)
- B11: Pre-Commit Hooks (im Container entwickeln)
- B13: Backup & Recovery (restore.fish im Container testen)
- D12: Projekt-Level .claude/ für mrbz-dev (wird beim Setup erstellt)
- D15: Rollback-Playbook (Teil von B13)
- D16: Recovery-Runbook (Teil von B13)

**5-3-3 Ort:** `shared/stacks/mrbz-dev/`

---

### A4: MCP Server

**Umfang:**
- TypeScript MCP Server mit 5 Tools (Filesystem, Docker, Git, Database, RAG)
- Qdrant Vector DB
- Traefik Reverse Proxy
- Bearer Token Auth → Authentik OAuth2
- Production Deployment auf n8-vps

**Quellen:**
- Root ROADMAP Phase 3, Priorität 2
- Inventur #6 (DNS/Traefik als Prerequisite)

**B/D-Tasks die hier mitlaufen:**
- B14: Traefik Setup (Prerequisite! → Details: `MR-ByteZ_DNS_Handoff_2026-02-09.md`)
- B12: Chat-Namer Skill (kann MCP-Integration nutzen, optional)
- B15: Submodule n8-station/n8-book (MCP kann sie managen)
- B16: Web-Projekte blog/shop (MCP kann sie managen)
- D1: DNS TTL hochsetzen (Teil von B14)
- D2: PTR-Records setzen (Teil von B14)
- D3: API-Token Age-Verschlüsselung (Teil von B14)
- D4: Alte API-Tokens aufräumen (Teil von B14)
- D14: Traefik ACME DNS-01 (Teil von B14)
- D17: Automatische Context-Sync (MCP-Feature)

**5-3-3 Ort:** Eigenes Repo oder `projects/infrastructure/mcp-server/`

---

### A5: Sensitive Data Cleanup

**Umfang:**
- Pattern-Scanner Script (Fish)
- Clean/Smudge Filter (bidirektional, .gitattributes)
- Hostname/Username/IP Mapping
- Git History Bereinigung (git filter-repo)
- Muss im Dev Container (A3) getestet werden!

**Quellen:**
- Inventur #1 (→ Details: `2026-02-04-security-git-filter-handoff.md`)
- Root ROADMAP Phase 3, Priorität 2

**B/D-Tasks die hier mitlaufen:**
- D5: Clean/Smudge Filter (Kern des Projekts)
- D6: Pattern-Scanner Script (Kern des Projekts)
- D7: IP-Adressen-Mapping (Kern des Projekts)
- B3: README Struktur-Baum nochmal prüfen (nach History-Rewrite)

**5-3-3 Ort:** `.claude/context/` oder eigener Ordner (TBD — hängt davon ab ob es temporär ist)

---

## Kategorie B: Alle Root-Roadmap Einträge (Referenz)

| # | Aufgabe | Zugeordnet zu | Timing | Quelle/Details |
|---|---------|--------------|--------|----------------|
| B1 | SSH-Config Secrets-Deployment | A1 | Mit A1 | `HANDOFF_2026-02-08.md`, Aufgabe 1 |
| B2 | /etc/hosts Dokumentation | A2 | Mit A2 | `HANDOFF_2026-02-08.md`, Aufgabe 2 |
| B3 | README Struktur-Baum | A2 + A5 | Mit A2, nochmal nach A5 | `HANDOFF_2026-02-08.md`, Aufgabe 3 |
| B4 | Git-Config Shared | A2 | Mit A2 | `HANDOFF_2026-02-08.md`, Aufgabe 4 |
| B5 | SMB-Shares Deployment | A2 | Nach A2 | `HANDOFF_SMB_DEPLOYMENT.md` |
| B6 | Bash-Config | A2 | Mit A2 parallel | Root ROADMAP Phase 2 |
| B7 | mr-bytez-info.fish | A2 | Mit A2 | Root ROADMAP Phase 2 |
| B8 | Docs-Struktur | A3 | Mit A3 | Root ROADMAP Phase 2 |
| B9 | Submodule n8-vps | A1 | Nach A1 | Root ROADMAP Phase 2 |
| B10 | Submodule n8-kiste | A1 | Nach A1 | Root ROADMAP Phase 2 |
| B11 | Pre-Commit Hooks | A3 | Mit A3 | Root ROADMAP Phase 3 |
| B12 | Chat-Namer Skill | A4 | Nach A4 (optional) | Root ROADMAP Phase 3 |
| B13 | Backup & Recovery | A3 | Mit A3 | Root ROADMAP Phase 3 |
| B14 | Traefik Setup | A4 | Prerequisite für A4 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| B15 | Submodule n8-station/n8-book | A4 | Expansion | Root ROADMAP Phase 4 |
| B16 | Web-Projekte (blog, shop) | A4 | Expansion | Root ROADMAP Phase 4 |
| B17 | VLC Desktop-Paketliste | B5 | Sub-Task von B5 | `HANDOFF_SMB_DEPLOYMENT.md` |

---

## Kategorie C: Policies → `.claude/context/`

| # | Policy | Aktion | Zeitpunkt |
|---|--------|--------|-----------|
| C1 | Chat-Benennungssystem v2 | Arbeitsanweisung v2 schreiben, in `.claude/context/` ablegen | Sofort / unabhängig |
| C2 | TAG_REGISTRY.md | In `.claude/context/tags.md` oder `context/git.md` integrieren | Mit C1 zusammen |

**Details:** `HANDOFF_X01-1_Chat-Benennungssystem.md`

---

## Kategorie D: Alle Sub-Tasks (Referenz)

| # | Sub-Task | Gehört unter | Details |
|---|----------|-------------|---------|
| D1 | DNS TTL hochsetzen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D2 | PTR-Records setzen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D3 | API-Token Age-Verschlüsselung | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D4 | Alte API-Tokens aufräumen | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D5 | Clean/Smudge Filter | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D6 | Pattern-Scanner Script | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D7 | IP-Adressen-Mapping | A5 | `2026-02-04-security-git-filter-handoff.md` |
| D8 | Secrets-Submodule 5-3-3 | = A1 | Ist das A1-Projekt selbst |
| D9 | symlinks.db verschieben | A1 | `.claude/ROADMAP.md` Phase 4 |
| D10 | Skills entwickeln | Inkrementell | Pro A-Projekt wenn es startet |
| D11 | Configs anlegen | Inkrementell | Pro A-Projekt wenn es startet |
| D12 | Projekt-Level .claude/ | A3 | Für mrbz-dev beim Container-Setup |
| D13 | Credentials n8-archstick | A1 | `HANDOFF_SMB_DEPLOYMENT.md` |
| D14 | Traefik ACME DNS-01 | A4/B14 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` |
| D15 | Rollback-Playbook | A3/B13 | Root ROADMAP Phase 4 |
| D16 | Recovery-Runbook | A3/B13 | Root ROADMAP Phase 4 |
| D17 | Automatische Context-Sync | A4 | `.claude/ROADMAP.md` Phase 5 |

---

## Timing-Matrix: Optimale Reihenfolge

```
C1+C2 (Policies sofort — verbessert Workflow für alle folgenden Chats)
  ↓
A1 Secrets-Repo Restrukturierung + B1, D9, D13 → danach B9/B10
  ↓
A2 Fish DRY-Refactoring + B2, B3, B4, B6, B7 → danach B5+B17
  ↓
A3 Claude Dev Container + D12, B8, B11, B13, D15/D16
  ↓
A4 MCP Server + B14 (Traefik zuerst!), D1-D4, D14, D17 → danach B12, B15/B16
  ↓
A5 Sensitive Data Cleanup + D5-D7 → danach B3 nochmal prüfen
```

**Inkrementell (kein fester Zeitpunkt):**
- D10: Skills entwickeln — pro A-Projekt
- D11: Configs anlegen — pro A-Projekt

---

## Konkrete Aufgaben für Claude Code

### Aufgabe 1: Root `ROADMAP.md` umstrukturieren

**Was ändern:**
- Phase 1 (Done) → BLEIBT unverändert
- Phase 2 (In Progress) → Offene Tasks den A-Projekten zuordnen, Done bleibt
- Phase 3 → Komplett umstrukturieren nach A1→A2→A3→A4→A5 mit zugehörigen B/D-Tasks
- Phase 4 (Expansion) → B15/B16 bleiben, Rest ist jetzt in A-Projekten
- Kompakt-Übersicht → Aktualisieren
- Timing-Matrix als neue Sektion einfügen
- Für jedes A-Projekt: Verweis auf Handoff-Datei für Details (NICHT Inhalt kopieren!)
- Chat-Referenzen beibehalten

**Was NICHT ändern:**
- Done-Einträge nicht anfassen
- Handoff-Dateien nicht kopieren oder duplizieren
- Keine neuen Detail-Informationen erfinden

### Aufgabe 2: `.claude/ROADMAP.md` updaten

**Was ändern:**
- Phase 1-3 (Done) → BLEIBT unverändert
- Phase 4 → Aktualisieren:
  - "Secrets-Submodule auf 5-3-3" → Verweis auf A1 in Root-ROADMAP
  - "symlinks.db verschieben" → Verweis auf A1
  - "Skills/Configs" → Als "inkrementell pro Projekt" markieren
  - "Projekt-Level .claude/" → Als "inkrementell pro A-Projekt" markieren
- Phase 5 → Aktualisieren:
  - MCP Server → Verweis auf A4 in Root-ROADMAP
  - Dev Container → Verweis auf A3
  - Pre-Commit Hooks → Verweis auf B11 unter A3
  - Context-Sync → Verweis auf D17 unter A4
- Neue Sektion: Verweis auf Root-ROADMAP für Gesamtbild

### Aufgabe 3: 5-3-3 Ordnerstruktur für A-Projekte vorbereiten

**NUR Ordner + leere Placeholder-Dateien erstellen, NICHT befüllen!**

**A2 (Fish DRY):**
```
shared/etc/fish/
├── CLAUDE.md       # Placeholder: "# Fish DRY-Refactoring\n\nTODO: Befüllen wenn Projekt startet\n\nDetails: todo_aus_chats_noch_nicht_in_roadmap_integriert/fish-config-refactoring-arbeitsanweisung.md"
├── CHANGELOG.md    # Placeholder
├── ROADMAP.md      # Placeholder
├── README.md       # Existiert vermutlich schon — prüfen!
└── .claude/
    └── context/
        └── .gitkeep
```

**A3 (Dev Container):**
```
shared/stacks/mrbz-dev/
├── CLAUDE.md       # Placeholder mit Verweis auf .claude/archive/mrbz-dev-plan.md
├── CHANGELOG.md    # Placeholder
├── ROADMAP.md      # Placeholder
├── README.md       # Existiert vermutlich schon — prüfen!
└── .claude/
    └── context/
        └── .gitkeep
```

**A4 (MCP Server) — nur Ordner vorbereiten:**
```
projects/infrastructure/mcp-server/
├── CLAUDE.md       # Placeholder
├── CHANGELOG.md    # Placeholder
├── ROADMAP.md      # Placeholder
├── README.md       # Placeholder
└── .claude/
    └── context/
        └── .gitkeep
```

**A5 (Sensitive Data) — nur Ordner vorbereiten:**
```
.claude/projects/sensitive-data-cleanup/
├── CLAUDE.md       # Placeholder mit Verweis auf 2026-02-04-security-git-filter-handoff.md
├── ROADMAP.md      # Placeholder
└── context/
    └── .gitkeep
```

**A1 (Secrets-Repo) — NICHT hier erstellen!** Lebt im anderen Repo (`mr-bytez-secrets`). Nur Verweis in Root-ROADMAP.

### Aufgabe 4: Kategorie C in `.claude/context/` integrieren

**Chat-Benennungssystem v2:**
- Prüfe ob `.claude/context/documentation.md` einen Chat-Benennung Abschnitt hat
- Wenn ja: Abschnitt aktualisieren mit Verweis auf `HANDOFF_X01-1_Chat-Benennungssystem.md`
- Wenn nein: Neuen Abschnitt einfügen
- NICHT die komplette Arbeitsanweisung v2 schreiben — nur Verweis + Kurzfassung des neuen Formats

**TAG_REGISTRY:**
- Verweis in `.claude/context/git.md` einfügen dass TAG_REGISTRY geplant ist
- NICHT die Registry selbst erstellen (kommt in eigenem Chat #X01.2)

---

## Wichtige Prinzipien

1. **Keine Redundanz** — Handoff-Dateien bleiben als Referenz im Ordner `todo_aus_chats_noch_nicht_in_roadmap_integriert/`. Inhalte werden NICHT in die Roadmaps kopiert. Roadmap-Einträge VERWEISEN auf Handoffs für Details.

2. **Struktur first, Umsetzung später** — Wir erstellen nur Ordner und Placeholder. Kein Code, keine Configs, keine echten Docs.

3. **Handoff-Ordner bleibt** — `todo_aus_chats_noch_nicht_in_roadmap_integriert/` bleibt vorerst im Root. Kein permanenter Ort definiert.

4. **Autor überall: MR-ByteZ**

5. **Pfade relativ vom Repo-Root**

6. **Placeholder-Format:**
```markdown
# [Projekt-Name]

**Status:** Geplant
**Autor:** MR-ByteZ
**Erstellt:** 2026-02-10

TODO: Befüllen wenn Projekt startet.

**Referenz:** [Verweis auf Handoff-Datei]
```

---

## Verifikation nach Abschluss

Claude Code soll nach Abschluss folgendes prüfen:
- [ ] Root `ROADMAP.md` enthält alle 5 A-Projekte in korrekter Reihenfolge
- [ ] Alle 17 B-Tasks sind einem A-Projekt zugeordnet
- [ ] Alle 17 D-Tasks sind als Sub-Tasks referenziert
- [ ] Beide C-Tasks haben Verweise in `.claude/context/`
- [ ] `.claude/ROADMAP.md` Phase 4+5 verweist auf Root-ROADMAP
- [ ] 5-3-3 Ordner existieren für A2, A3, A4, A5 (A1 = anderes Repo)
- [ ] Keine Inhalte aus Handoffs kopiert — nur Verweise
- [ ] Alles commitfähig (keine kaputten Referenzen)
