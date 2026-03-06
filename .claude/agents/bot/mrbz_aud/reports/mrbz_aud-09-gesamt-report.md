# mrbz_aud — Gesamt-Report

**Datum:** 2026-03-06
**Module:** 8/8 erfolgreich
**Gesamt-Findings:** 58 (nach Deduplizierung)

## Zusammenfassung

Das mr-bytez Repository ist strukturell solide aufgestellt. Die Kernbereiche (Root, .claude/, n8-vps, shared/etc/fish/, hwi/) erfuellen das 5-5-3 Pattern weitgehend. Die groessten Luecken liegen bei fehlenden Docs fuer n8-kiste, n8-station und die 5 Minimal-Hosts, bei inkonsistenten Header-Formaten (3 verschiedene Box-Stile bei Fish-Dateien) sowie bei veralteten Zahlenwerten und Status-Angaben in ROADMAP, CHANGELOG und Context-Dateien. Secrets sind korrekt gepackt, keine ungesicherten Aenderungen. Keine KRITISCH-Findings.

## Findings nach Severity

### KRITISCH (0)

Keine.

### MITTEL (20)

1. **[M02] .claude/ fehlt DEPLOYMENT.md**
   - Problem: .claude/ ist als Voll-5-5-3 definiert, hat aber kein DEPLOYMENT.md (4/5 Docs)
   - Empfehlung: DEPLOYMENT.md in `.claude/` erstellen
   - Betroffene Dateien: `.claude/DEPLOYMENT.md` (nicht vorhanden)

2. **[M02] n8-kiste hat 0/5 Voll-5-5-3 Docs**
   - Problem: Nur HARDWARE.md und Fish-Configs vorhanden, keine der 5 erwarteten Docs
   - Empfehlung: Mindestens README.md und CHANGELOG.md erstellen
   - Betroffene Dateien: `projects/infrastructure/n8-kiste/`

3. **[M02] n8-station hat 0/5 Voll-5-5-3 Docs**
   - Problem: Nur HARDWARE.md und Fish-Configs vorhanden, keine der 5 erwarteten Docs
   - Empfehlung: Mindestens README.md und CHANGELOG.md erstellen
   - Betroffene Dateien: `projects/infrastructure/n8-station/`

4. **[M03] Root CHANGELOG.md ohne Header-Metadaten**
   - Problem: Kein Version-, Erstellt-, Aktualisiert- oder Autor-Feld
   - Empfehlung: Standard-Metadaten-Header ergaenzen
   - Betroffene Dateien: `CHANGELOG.md`

5. **[M03] Root DEPLOYMENT.md unvollstaendiger Header**
   - Problem: Hat nur "Stand:" statt Erstellt/Aktualisiert, kein Version-Feld, kein Autor
   - Empfehlung: Header auf Standard-Format bringen
   - Betroffene Dateien: `DEPLOYMENT.md`

6. **[M03] Root ROADMAP.md fehlende Version und Autor**
   - Problem: Hat Erstellt + Aktualisiert, aber weder Version noch Autor
   - Empfehlung: Version + Autor ergaenzen
   - Betroffene Dateien: `ROADMAP.md`

7. **[M03] .claude/CHANGELOG.md fehlende Version und Aktualisiert**
   - Problem: Kein Version-Feld, kein Aktualisiert-Datum
   - Empfehlung: Version + Aktualisiert ergaenzen
   - Betroffene Dateien: `.claude/CHANGELOG.md`

8. **[M03] .claude/README.md fehlende Version**
   - Problem: Kein Version-Feld vorhanden
   - Empfehlung: Version ergaenzen
   - Betroffene Dateien: `.claude/README.md`

9. **[M03] hwi/ Docs unvollstaendige Header (4 Dateien)**
   - Problem: 4 von 5 hwi-Docs haben unvollstaendige oder fehlende Header-Metadaten
   - Empfehlung: Alle hwi-Docs auf Standard-Format bringen
   - Betroffene Dateien: `shared/usr/local/bin/hwi/CHANGELOG.md`, `DEPLOYMENT.md`, `README.md`, `ROADMAP.md`

10. **[M03] scan-secrets.fish: Version nicht SemVer-konform**
    - Problem: Version `2.0` statt `2.0.0`, Autor als Klarname statt "MR-ByteZ"
    - Empfehlung: Version zu `2.0.0` korrigieren, Autor auf "MR-ByteZ" aendern
    - Betroffene Dateien: `scripts/scan-secrets.fish`

11. **[M04] Root ROADMAP: Widerspruch "public Repo" vs. "bleibt privat"**
    - Problem: Kompakt-Uebersicht sagt "public Repo", A5-Abschnitt sagt "bleibt privat bis A5 abgeschlossen"
    - Empfehlung: Kompakt-Uebersicht korrigieren
    - Betroffene Dateien: `ROADMAP.md`

12. **[M04] Root ROADMAP: A4 Status veraltet — Authentik-Prerequisite erfuellt**
    - Problem: A4 sagt "wartet auf Authentik", aber Authentik ist deployed
    - Empfehlung: A4 Status-Zeile und Abhaengigkeiten-Zeile aktualisieren
    - Betroffene Dateien: `ROADMAP.md`

13. **[M05+M06] Zaehler "11 Policy-Dateien" in Root CLAUDE.md veraltet**
    - Problem: Tatsaechlich 18 Dateien in `.claude/context/`
    - Empfehlung: Zaehler auf 18 aktualisieren oder Formulierung aendern
    - Betroffene Dateien: `CLAUDE.md:62`

14. **[M05+M06] Tag-Zaehler "68 Tags" in Root CLAUDE.md veraltet**
    - Problem: Tatsaechlich 70 Tags in tags.md (44 generisch + 26 dienst-spezifisch)
    - Empfehlung: Zaehler auf 70 aktualisieren
    - Betroffene Dateien: `CLAUDE.md:63`

15. **[M05+M06] Toter Pfad: scripts/hwi/hwi.sh in shell.md**
    - Problem: Script wurde nach `shared/usr/local/bin/hwi/hwi.sh` verschoben
    - Empfehlung: Pfad aktualisieren
    - Betroffene Dateien: `.claude/context/shell.md:209`

16. **[M06] docker.md: Stacks als "Geplant" markiert die bereits deployed sind**
    - Problem: Traefik, CrowdSec und Authentik existieren bereits, CrowdSec und Authentik fehlen komplett in Tabelle
    - Empfehlung: Status auf "Deployed" aktualisieren, fehlende Stacks ergaenzen
    - Betroffene Dateien: `.claude/context/docker.md:54-61`

17. **[M06] infrastructure.md: Projekt-Location `mcp-server` existiert nicht**
    - Problem: Referenziert `projects/infrastructure/mcp-server/` — wurde geloescht
    - Empfehlung: Eintrag entfernen
    - Betroffene Dateien: `.claude/context/infrastructure.md:83`

18. **[M06] infrastructure.md: Projekt-Location `mrbz-dev` existiert nicht**
    - Problem: Referenziert `shared/stacks/mrbz-dev/` — wurde geloescht
    - Empfehlung: Eintrag entfernen oder als "Geplant" kennzeichnen
    - Betroffene Dateien: `.claude/context/infrastructure.md:82`

19. **[M06] shell.md: `010-ulimits.fish` in conf.d nicht dokumentiert**
    - Problem: Datei am 2026-03-05 erstellt, shell.md zuletzt am 2026-03-03 aktualisiert
    - Empfehlung: In Tabelle "Wichtige Dateien" ergaenzen
    - Betroffene Dateien: `.claude/context/shell.md:67-73`

20. **[M06] infrastructure.md: Sanitization-Inkonsistenz**
    - Problem: Hosts Matrix sanitized (host-dev), SSH-Abschnitt echte Namen (n8-kiste)
    - Empfehlung: Durchgaengig einen Stil verwenden
    - Betroffene Dateien: `.claude/context/infrastructure.md`

### INFO (32)

1. **[M02] n8-book fehlen Minimal-Docs (0/2)**
   - Betroffene Dateien: `projects/infrastructure/n8-book/`

2. **[M02] n8-bookchen fehlen Minimal-Docs (0/2)**
   - Betroffene Dateien: `projects/infrastructure/n8-bookchen/`

3. **[M02] n8-broker fehlen Minimal-Docs (0/2)**
   - Betroffene Dateien: `projects/infrastructure/n8-broker/`

4. **[M02] n8-maxx fehlen Minimal-Docs (0/2)**
   - Betroffene Dateien: `projects/infrastructure/n8-maxx/`

5. **[M02] n8-archstick fehlen Minimal-Docs (0/2)**
   - Betroffene Dateien: `projects/infrastructure/n8-archstick/`

6. **[M03] 8 Host-Test-Functions ohne Header**
   - Betroffene Dateien: `projects/infrastructure/*/root/.../functions/*-test.fish`

7. **[M03] config.fish ohne Header**
   - Betroffene Dateien: `shared/home/mrohwer/.config/fish/config.fish`

8. **[M03] Root CLAUDE.md ohne Metadaten**
   - Sonderstatus als Steuerungsdatei — optional

9. **[M03] 2 .txt Dateien ohne Header**
   - Sonder-Dateien fuer claude.ai Web-UI — kein Handlungsbedarf

10. **[M03] 2 HARDWARE.md ohne Header**
    - Automatisch generiert von hwi-Tool — kein Handlungsbedarf

11. **[M03] .claude/archive/ Dateien mit unvollstaendigen Headern**
    - Niedrige Prioritaet — Archiv-Dateien, keine aktive Nutzung

12. **[M03] hwi/CLAUDE.md fehlende Aktualisiert-Datum**
    - Betroffene Dateien: `shared/usr/local/bin/hwi/CLAUDE.md`

13. **[M03] Alle .sh Hook-Dateien nutzen eigenes Box-Format statt 7-Feld-Standard**
    - 0/9 .sh-Dateien nutzen den dokumentierten Standard
    - Betroffene Dateien: `.claude/hooks/*.sh`, `shared/etc/claude-code/statusline.sh`, hwi.sh

14. **[M03] 2 .sh Dateien mit relativen Pfaden**
    - Betroffene Dateien: `shared/etc/claude-code/statusline.sh`, `shared/usr/local/bin/hwi/hwi.sh`

15. **[M04] .claude/ROADMAP Phase 5: mrbz_aud als unchecked, aber Bot ist gebaut**
    - Empfehlung: Checkbox auf `[x]` setzen mit Status-Vermerk
    - Betroffene Dateien: `.claude/ROADMAP.md`

16. **[M04] .claude/ROADMAP Verweis auf "A1-A5" veraltet**
    - Tatsaechlich gibt es A1-A9
    - Betroffene Dateien: `.claude/ROADMAP.md`

17. **[M04] Root CHANGELOG [Unreleased]: Handoff-Zaehler inkonsistent**
    - "Verbleibend: 1" aber tatsaechlich 2 Handoffs
    - Betroffene Dateien: `CHANGELOG.md`

18. **[M04] n8-vps CLAUDE.md: "Naechster Schritt" veraltet**
    - Zeigt Schritt 3 (Authentik), sollte Schritt 4 (Portainer) sein
    - Betroffene Dateien: `projects/infrastructure/n8-vps/.claude/CLAUDE.md`

19. **[M04] n8-vps ROADMAP: Header-Datum vs. Footer-Datum Mismatch**
    - Header: 2026-03-04, Footer: 2026-03-05
    - Betroffene Dateien: `projects/infrastructure/n8-vps/ROADMAP.md`

20. **[M04] n8-vps ROADMAP: "Geplante Stacks" listet bereits deployte Stacks**
    - Authentik und CrowdSec als "geplant" obwohl deployed
    - Betroffene Dateien: `projects/infrastructure/n8-vps/ROADMAP.md`

21. **[M05] 6 Context-Dateien ohne Verweis aus zentraler CLAUDE.md-Navigation**
    - ARCHITEKTUR.md, HOST_MATRIX.md, MIGRATION.md, integration.md, versioning.md, webfetch-domains.md
    - Nur indirekt erreichbar

22. **[M05] structure.md Template-Pfade verweisen auf nicht-existierende Verzeichnisse**
    - `shared/stacks/` existiert nicht, Stacks liegen unter `projects/infrastructure/n8-vps/stacks/`
    - Betroffene Dateien: `.claude/context/structure.md:229-232`

23. **[M05] Shell-Regeln in Root CLAUDE.md redundant zu context/shell.md**
    - Grenzfall: Quick-Reference vs. Keine-Redundanz-Policy

24. **[M05] Additive-Only Regel an 5 Stellen eigenstaendig formuliert**
    - policies.md und documentation.md koennten konsolidiert werden
    - Agents brauchen eigenstaendige Regeln (isolierter Kontext)

25. **[M06] shell.md: `.claude/context/` unter Fish als "Policies" gelistet, aber leer**
    - `shared/etc/fish/.claude/context/` enthaelt nur `.gitkeep`

26. **[M06] shell.md: host-test.fish nicht dokumentiert**
    - Fehlt in der Functions-Dokumentation

27. **[M06] docker.md: CrowdSec und Authentik fehlen in Stacks-Tabelle**
    - Zusammenhang mit MITTEL-Finding #16

28. **[M06] tags.md: [rclone] Gross-/Kleinschreibung**
    - Folgt offiziellem Produktnamen, aber stilistisch inkonsistent

29. **[M07] Fehlende Host-Verzeichnisse (5 von 8 Hosts)**
    - Erwartet — nur deployed Hosts haben Secrets-Verzeichnisse

30. **[M07] Inkonsistente Host-Struktur (unterschiedliche Tiefe)**
    - Erwartet — spiegelt unterschiedliche Host-Rollen wider

31. **[M07] .age-Datei ohne entpacktes Gegenstueck**
    - `edge_browser_passwords.ods.age` — bewusst nur bei Bedarf entschluesselt

32. **[M07] n8-station ohne Forgejo-SSH-Key**
    - Nur relevant falls n8-station Forgejo-Zugang braucht

### NEEDS_REVIEW (6)

1. **[M02] n8-kiste und n8-station: Voll-5-5-3 gerechtfertigt?**
   - Frage: Haben diese Hosts genug aktiven Scope fuer Voll-5-5-3, oder reicht Minimal?
   - Betroffene Dateien: `.claude/context/structure.md:113`

2. **[M03] Fish-Config-Header: 3 verschiedene Box-Stile im Einsatz**
   - 9-box (18x), aelterer Stil (21x), kein Header (9x)
   - Stilbruch in aliases/ (050/055 vs. 010-045)
   - Entscheidung: Auf einen Standard migrieren oder mehrere akzeptieren?

3. **[M03] Fish Pfad-Felder: Durchgehend relativ statt absolut**
   - 0/40 Fish-Dateien nutzen absolute Pfade wie in docs-agent.md definiert
   - Entscheidung: Relative Pfade als Standard akzeptieren oder migrieren?

4. **[M04] Root CHANGELOG [Unreleased]: Sehr grosser Block ohne Versionierung**
   - Ca. 230 Zeilen, 8-10 thematische Bloecke seit 0.15.2
   - Entscheidung: Release schneiden oder weiter sammeln?

5. **[M04] Root ROADMAP A7 ETA: "Q1 2026" waehrend Q1 fast vorbei**
   - Phase 2+3 und Cron noch offen, Q1 endet in 24 Tagen
   - Entscheidung: ETA auf Q1-Q2 2026 aktualisieren?

6. **[M07] Unklare Backup-Verzeichnisstruktur bei n8-vps**
   - `backup/auth/authentik/` (API-Tokens) vs. `backup/authentik/` (DB-Secrets)
   - Entscheidung: Konsolidieren oder Trennung beibehalten?

## Modul-Status

| Modul | Status | Findings |
|-------|--------|----------|
| 01 Struktur-Inventar | OK | 0 |
| 02 5-5-3 Vollstaendigkeit | FINDINGS | 9 (3 MITTEL, 5 INFO, 1 NEEDS_REVIEW) |
| 03 Header + Versionierung | FINDINGS | 17 (7 MITTEL, 8 INFO, 2 NEEDS_REVIEW) |
| 04 ROADMAP/CHANGELOG Aktualitaet | FINDINGS | 10 (2 MITTEL, 6 INFO, 2 NEEDS_REVIEW) |
| 05 Cross-References + Redundanz | FINDINGS | 7 (3 MITTEL, 4 INFO) |
| 06 Context inhaltlicher Abgleich | FINDINGS | 11 (6 MITTEL, 5 INFO) |
| 07 Secrets Struktur | FINDINGS | 6 (5 INFO, 1 NEEDS_REVIEW) |
| 08 Secrets Freshness | OK | 0 |
| **Gesamt (vor Dedup)** | | **60** |
| **Gesamt (nach Dedup)** | | **58** |

## Widersprueche zwischen Modulen

Keine inhaltlichen Widersprueche festgestellt. Zwei Duplikate identifiziert und zusammengefuehrt:

1. **Tag-Zaehler "68 Tags"** — gemeldet von M05 und M06 → konsolidiert zu MITTEL #14
2. **Toter Pfad hwi in shell.md** — gemeldet von M05 (MITTEL) und M06 (INFO) → konsolidiert zu MITTEL #15

Modul-uebergreifende Konsistenz:
- M01 Inventar (253 Dateien) deckt sich mit M02 (5-5-3 Pruefung) und M03 (Header-Pruefung)
- M07 Secrets-Struktur (109 Dateien) und M08 Freshness (97 geprueft) sind konsistent
- M04 ROADMAP-Findings und M06 Context-Findings ergaenzen sich ohne Widerspruch

## Empfohlene Reihenfolge fuer Phase 3

### 1. MITTEL-Findings — Quick Fixes (geringe Komplexitaet)

| # | Finding | Aufwand |
|---|---------|---------|
| 13 | Zaehler "11 Policy-Dateien" → 18 in CLAUDE.md | 1 Zeile |
| 14 | Tag-Zaehler 68 → 70 in CLAUDE.md | 1 Zeile |
| 15 | hwi-Pfad in shell.md korrigieren | 1 Zeile |
| 17 | mcp-server Eintrag aus infrastructure.md entfernen | 1 Zeile |
| 18 | mrbz-dev Eintrag aus infrastructure.md entfernen/kennzeichnen | 1 Zeile |
| 19 | 010-ulimits.fish in shell.md ergaenzen | 1 Zeile |
| 11 | ROADMAP "public Repo" Widerspruch korrigieren | 1 Zeile |
| 12 | ROADMAP A4 Status + Authentik-Abhaengigkeit aktualisieren | 2 Zeilen |

### 2. MITTEL-Findings — Header-Korrekturen (mittlere Komplexitaet)

| # | Finding | Aufwand |
|---|---------|---------|
| 4 | CHANGELOG.md Header ergaenzen | 4 Zeilen |
| 5 | DEPLOYMENT.md Header normalisieren | 4 Zeilen |
| 6 | ROADMAP.md Version + Autor ergaenzen | 2 Zeilen |
| 7 | .claude/CHANGELOG.md Version + Aktualisiert | 2 Zeilen |
| 8 | .claude/README.md Version | 1 Zeile |
| 9 | hwi/ Docs Header (4 Dateien) | 16 Zeilen |
| 10 | scan-secrets.fish Version + Autor | 2 Zeilen |

### 3. MITTEL-Findings — Inhaltliche Aktualisierungen (hoehere Komplexitaet)

| # | Finding | Aufwand |
|---|---------|---------|
| 16 | docker.md Stacks-Tabelle aktualisieren | Tabelle umbauen |
| 20 | infrastructure.md Sanitization vereinheitlichen | Mehrere Abschnitte |
| 1 | .claude/DEPLOYMENT.md erstellen | Neue Datei |
| 2 | n8-kiste Docs erstellen (mindestens README + CHANGELOG) | 2 neue Dateien |
| 3 | n8-station Docs erstellen (mindestens README + CHANGELOG) | 2 neue Dateien |

### 4. INFO-Findings (nach Aufwand/Prioritaet)

Empfohlene Auswahl fuer Phase 3 (Rest bei naechstem Audit):
- #15, #16 (.claude/ROADMAP Checkbox + Verweis aktualisieren)
- #18 (n8-vps CLAUDE.md "Naechster Schritt")
- #19, #20 (n8-vps ROADMAP Datum + Stacks)

### 5. NEEDS_REVIEW (manuelles Review erforderlich)

Alle 6 NEEDS_REVIEW Findings erfordern menschliche Entscheidung vor Umsetzung.
Nicht durch Phase 3 automatisch behebbar.

## Statistik

| Metrik | Wert |
|--------|------|
| Gepruefte Dateien Hauptrepo | 132 |
| Gepruefte Dateien Secrets | 121 |
| Gepruefte Cross-References | 78 |
| Gepruefte ROADMAP-Claims | 13 (alle korrekt) |
| CHANGELOG-Konsistenz | 9 Themen (alle synchron) |
| **Findings gesamt (nach Dedup)** | **58** |
| KRITISCH | 0 |
| MITTEL | 20 |
| INFO | 32 |
| NEEDS_REVIEW | 6 |
