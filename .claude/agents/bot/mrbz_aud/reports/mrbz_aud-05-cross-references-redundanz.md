# mrbz_aud — Modul 05: Cross-References + Redundanz

**Datum:** 2026-03-06
**Status:** FINDINGS

## Zusammenfassung

Alle Cross-References (→ Siehe/Details-Verweise) in Root-Docs, .claude/ und Projekt-Docs geprueft.
3 MITTEL-Findings (veraltete Zaehler, toter Pfad) und 4 INFO-Findings (fehlende Navigation,
Template-Pfade, Redundanz) identifiziert. Keine toten Links zu nicht-existierenden Dateien
ausser dem verschobenen hwi-Script.

## Findings

### [MITTEL] Zaehler "11 Policy-Dateien" in Root CLAUDE.md veraltet

- **Datei:** `CLAUDE.md:62`
- **Problem:** `→ .claude/context/ — Alle 11 Policy-Dateien (shell, git, ...)` —
  tatsaechlich sind es **18 Dateien** in `.claude/context/` (ohne `handoffs/`):
  ARCHITEKTUR.md, claude-ai-projektanweisungen.txt, claude-ai-user-preferences.txt,
  deployment.md, docker.md, documentation.md, git.md, HOST_MATRIX.md, infrastructure.md,
  integration.md, MIGRATION.md, policies.md, security.md, shell.md, structure.md, tags.md,
  versioning.md, webfetch-domains.md
- **Erwartung:** Zaehler stimmt mit tatsaechlicher Dateianzahl ueberein
- **Empfehlung:** Zaehler auf 18 aktualisieren oder formulierung aendern
  (z.B. "Policy- und Context-Dateien" statt nur "Policy-Dateien")

### [MITTEL] Tag-Zaehler "68 Tags" in Root CLAUDE.md veraltet

- **Datei:** `CLAUDE.md:63`
- **Problem:** `→ .claude/context/tags.md — Tag-Registry (68 Tags, 3-Zeichen-Index)` —
  tatsaechlich enthaelt tags.md **70 Tags** (gezaehlt anhand der `| [Tag]`-Zeilen)
- **Erwartung:** Zaehler stimmt mit tatsaechlicher Tag-Anzahl ueberein
- **Empfehlung:** Zaehler auf 70 aktualisieren

### [MITTEL] Toter Pfad: scripts/hwi/hwi.sh in shell.md

- **Datei:** `.claude/context/shell.md:209`
- **Problem:** Referenziert `scripts/hwi/hwi.sh` — dieses Script wurde nach
  `shared/usr/local/bin/hwi/hwi.sh` verschoben (lt. CHANGELOG und hwi/CHANGELOG.md)
- **Erwartung:** Pfad zeigt auf den aktuellen Speicherort
- **Empfehlung:** Pfad auf `shared/usr/local/bin/hwi/hwi.sh` aktualisieren

### [INFO] 6 Context-Dateien ohne Verweis aus zentraler CLAUDE.md-Navigation

- **Datei:** `CLAUDE.md` (Root) und `.claude/CLAUDE.md`
- **Problem:** Folgende 6 Dateien in `.claude/context/` werden weder von Root `CLAUDE.md`
  noch von `.claude/CLAUDE.md` referenziert (nur aus anderen Context-Dateien, CHANGELOGs
  oder Projekt-Docs):
  - `ARCHITEKTUR.md` — referenziert von HOST_MATRIX.md, shared/etc/fish/README.md
  - `HOST_MATRIX.md` — referenziert von ARCHITEKTUR.md, NEUER_HOST.md Skill
  - `MIGRATION.md` — referenziert von ARCHITEKTUR.md
  - `integration.md` — referenziert von structure.md, .claude/README.md
  - `versioning.md` — nur im CHANGELOG erwaehnt
  - `webfetch-domains.md` — nur im CHANGELOG erwaehnt
- **Erwartung:** Alle Context-Dateien sind ueber die zentrale Navigation erreichbar
- **Empfehlung:** Entscheiden ob diese Dateien in `.claude/CLAUDE.md` unter einem
  zusaetzlichen Abschnitt (z.B. "Weitere Context-Dateien") verlinkt werden sollen,
  oder ob die indirekte Erreichbarkeit ausreicht

### [INFO] structure.md Template-Pfade verweisen auf nicht-existierende Verzeichnisse

- **Datei:** `.claude/context/structure.md:229-232`
- **Problem:** Abschnitt "Projekt context/" zeigt Muster-Pfade:
  - `shared/stacks/.../context/adr-decisions.md`
  - `shared/stacks/.../context/network.md`
  - `.../context/notes.md`
  Das Verzeichnis `shared/stacks/` existiert nicht. Stacks liegen unter
  `projects/infrastructure/n8-vps/stacks/`. Die Pfade sind als Templates
  gemeint, koennten aber als tote Referenzen missverstanden werden.
- **Erwartung:** Template-Pfade spiegeln die tatsaechliche Struktur wider
- **Empfehlung:** Pfade an reale Struktur anpassen
  (z.B. `projects/.../stacks/.../context/adr-decisions.md`) oder als
  "Beispiel-Pfade (noch nicht umgesetzt)" kennzeichnen

### [INFO] Shell-Regeln in Root CLAUDE.md redundant zu context/shell.md

- **Datei:** `CLAUDE.md:13-18` vs. `.claude/context/shell.md`
- **Problem:** Root CLAUDE.md wiederholt 6 Shell-Regeln (Fish-first, Keine Heredocs,
  Kein &&, Variablen, Substitution, Datei-Generierung) die ausfuehrlicher in
  `.claude/context/shell.md` definiert sind. Gemaess "Keine Redundanz"-Policy
  (`.claude/context/policies.md`) sollen Policies EINMAL in context/ definiert werden.
- **Erwartung:** Root CLAUDE.md verweist nur, statt zu wiederholen
- **Empfehlung:** Grenzfall — die Kompakt-Zusammenfassung im Root CLAUDE.md dient als
  Quick-Reference fuer Claude Code (wird immer geladen). Der Verweis auf Details
  existiert (Zeile 21). Koennte als beabsichtigte Ausnahme gelten.
  NEEDS_REVIEW: Ist diese Redundanz gewollt oder soll sie aufgeloest werden?

### [INFO] Additive-Only Regel an mehreren Stellen eigenstaendig formuliert

- **Datei:** Mehrere Dateien
- **Problem:** Die Additive-Only Regel wird in 5 Dateien mit eigener Formulierung definiert:
  1. `CLAUDE.md:43` — "nur ergaenzen, nicht kuerzen"
  2. `.claude/context/policies.md:23` — eigener Abschnitt
  3. `.claude/context/documentation.md:32` — eigener Abschnitt
  4. `.claude/agents/manual/docs-agent.md:18` — Kurzregel
  5. `.claude/agents/bot/mrbz_aud/mrbz_aud-agent_fix.md:58` — Kurzregel
  Agents (4+5) brauchen eigenstaendige Regeln da sie isoliert laufen. Aber
  policies.md und documentation.md koennten konsolidiert werden (eine definiert,
  die andere verweist).
- **Erwartung:** Source of Truth fuer die Regel ist genau eine Datei in context/
- **Empfehlung:** In documentation.md auf policies.md verweisen statt die Regel
  erneut auszuformulieren. Root CLAUDE.md als Quick-Reference ist akzeptabel.

## Verwaiste Dateien

Keine vollstaendig verwaisten Dateien gefunden. Alle Dateien aus dem Modul-01 Inventar
sind mindestens aus einem CHANGELOG, einer Projekt-Doc oder einer Context-Datei
referenziert. Besonders schwach referenziert (nur CHANGELOG):
- `scripts/scan-secrets.fish`
- `.claude/context/versioning.md`
- `.claude/context/webfetch-domains.md`
- `.claude/context/claude-ai-user-preferences.txt`

Diese Dateien existieren und sind funktional, haben aber keine Navigation aus
den zentralen Docs.

## Statistik

- Gepruefte Cross-References: 78 (→ Siehe/Details-Verweise + Datei-Referenzen)
- Gepruefte Dateien: 66 (.md Dateien im Hauptrepo)
- Findings: 7 (0 KRITISCH, 3 MITTEL, 4 INFO, 0 NEEDS_REVIEW)
