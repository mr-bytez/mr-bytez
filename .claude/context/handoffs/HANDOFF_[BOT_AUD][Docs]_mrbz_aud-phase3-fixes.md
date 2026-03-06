# Handoff: mrbz_aud Phase 3 — Findings manuell abarbeiten

**Erstellt:** 2026-03-06
**Kontext:** mrbz_aud Docs-Audit-Bot (Projekt A7), Phase 3 Test
**Letzter Commit:** `0e86205` — NEEDS_REVIEW Entscheidungen + Pipeline-Reports
**Chat:** https://claude.ai/chat/a56b522a-839a-40ef-832d-14fbf6871e88

---

## Zusammenfassung

Phase 1 (Audit, 8 Module) und Phase 2 (Verifikation, Gesamt-Report) sind komplett durchgelaufen.
6 NEEDS_REVIEW Entscheidungen wurden getroffen und umgesetzt. Jetzt steht Phase 3 an:
Die 20 MITTEL-Findings und 32 INFO-Findings aus dem Gesamt-Report abarbeiten.

**WICHTIG:** Phase 3 wird NICHT automatisiert ueber den Fix-Agent gestartet, sondern
manuell auf einem Branch durchgefuehrt. Grund: Erster Test, Sicherheit, Review-Moeglichkeit.

---

## Aufgabe

### Schritt 1: Branch erstellen
```fish
cd /mr-bytez
git checkout -b test/mrbz-aud-phase3
```

### Schritt 2: MITTEL-Findings abarbeiten (priorisiert)

Gesamt-Report lesen: `.claude/agents/bot/mrbz_aud/reports/mrbz_aud-09-gesamt-report.md`

**Block A — Quick-Fixes (8 Ein-Zeilen-Korrekturen):**

| # | Finding | Datei | Aenderung |
|---|---------|-------|-----------|
| 13 | Zaehler "11 Policy-Dateien" → 18 | `CLAUDE.md:62` | Zahl aendern |
| 14 | Tag-Zaehler 68 → 70 | `CLAUDE.md:63` | Zahl aendern |
| 15 | Toter Pfad scripts/hwi/hwi.sh | `.claude/context/shell.md:209` | Pfad korrigieren |
| 17 | mcp-server Eintrag existiert nicht | `.claude/context/infrastructure.md:83` | Eintrag entfernen |
| 18 | mrbz-dev Eintrag existiert nicht | `.claude/context/infrastructure.md:82` | Eintrag entfernen/kennzeichnen |
| 19 | 010-ulimits.fish nicht dokumentiert | `.claude/context/shell.md:67-73` | In Tabelle ergaenzen |
| 11 | ROADMAP "public Repo" Widerspruch | `ROADMAP.md` (Kompakt-Uebersicht) | "public" korrigieren |
| 12 | ROADMAP A4 Status veraltet | `ROADMAP.md` (A4 Abschnitt) | Authentik-Status aktualisieren |

→ Nach Block A: Ergebnis pruefen, ggf. committen auf Branch.

**Block B — Header-Korrekturen (7 Findings, mittlere Komplexitaet):**

| # | Finding | Datei | Aenderung |
|---|---------|-------|-----------|
| 4 | CHANGELOG.md ohne Header | `CHANGELOG.md` | Standard-Header ergaenzen |
| 5 | DEPLOYMENT.md Header unvollstaendig | `DEPLOYMENT.md` | Header normalisieren |
| 6 | ROADMAP.md fehlende Version/Autor | `ROADMAP.md` | Version + Autor ergaenzen |
| 7 | .claude/CHANGELOG.md fehlend | `.claude/CHANGELOG.md` | Version + Aktualisiert |
| 8 | .claude/README.md fehlende Version | `.claude/README.md` | Version ergaenzen |
| 9 | hwi/ Docs Header (4 Dateien) | `shared/usr/local/bin/hwi/*.md` | Header standardisieren |
| 10 | scan-secrets.fish Version | `scripts/scan-secrets.fish` | 2.0 → 2.0.0, Autor |

→ Nach Block B: Ergebnis pruefen, ggf. committen auf Branch.

**Block C — Inhaltliche Aenderungen (5 Findings, hoehere Komplexitaet):**

| # | Finding | Datei | Aenderung |
|---|---------|-------|-----------|
| 16 | docker.md Stacks veraltet | `.claude/context/docker.md:54-61` | Tabelle aktualisieren |
| 20 | infrastructure.md Sanitization-Mix | `.claude/context/infrastructure.md` | Einheitlichen Stil |
| 1 | .claude/DEPLOYMENT.md fehlt | `.claude/DEPLOYMENT.md` | Neue Datei erstellen |
| 2 | n8-kiste Docs (README+CHANGELOG+DEPLOYMENT) | `projects/infrastructure/n8-kiste/` | 3 neue Dateien |
| 3 | n8-station Docs (README+CHANGELOG) | `projects/infrastructure/n8-station/` | 2 neue Dateien |

→ Nach Block C: Ergebnis pruefen, ggf. committen auf Branch.

### Schritt 3: INFO-Findings bewerten

32 INFO-Findings sind im Gesamt-Report. Davon empfohlen fuer diesen Durchgang:
- #15, #16: .claude/ROADMAP Checkbox + Verweis aktualisieren
- #18: n8-vps CLAUDE.md "Naechster Schritt" aktualisieren
- #19, #20: n8-vps ROADMAP Datum + Stacks

Rest: Bei naechstem Audit oder bei naechster inhaltlicher Aenderung der betroffenen Datei.

### Schritt 4: Branch mergen
```fish
git checkout main
git merge test/mrbz-aud-phase3
git push origin main; git push codeberg main
```

---

## Relevante Dateien

| Datei | Zweck |
|-------|-------|
| `.claude/agents/bot/mrbz_aud/reports/mrbz_aud-09-gesamt-report.md` | **Haupt-Referenz**: Alle Findings, priorisierte Reihenfolge |
| `.claude/agents/bot/mrbz_aud/reports/mrbz_aud-0[1-8]-*.md` | Einzel-Reports pro Modul (Details) |
| `.claude/agents/bot/mrbz_aud/reports/NEEDS_REVIEW-neutral.md` | Entscheidungsgrundlage (erledigt) |
| `.claude/context/structure.md` | Docs-Stufen (Voll/Erweitert/Minimal) — frisch aktualisiert |
| `.claude/context/documentation.md` | Header-Standards (9-box + Mini) — frisch aktualisiert |

---

## Kontext aus vorheriger Session

### Was bereits erledigt ist (NICHT nochmal machen!)
- Phase 1: Alle 8 Audit-Module durchgelaufen (51→58 Findings nach Dedup)
- Phase 2: Gesamt-Report erstellt (09), alle Findings konsolidiert
- 6 NEEDS_REVIEW Entscheidungen umgesetzt:
  - NR-1: Docs-Stufen (Voll/Erweitert/Minimal), n8-kiste=Erweitert, n8-station=Minimal
  - NR-2: Mini-Header (~30 Zeilen Schwelle)
  - NR-3: Relative Pfade Standard
  - NR-4: CHANGELOG in 0.16.0/0.17.0/0.18.0 aufgeteilt
  - NR-5: A7 ETA → Maerz 2026
  - NR-6: Secrets-Backup separat (eigener Task)
- Orchestrator-Fixes committed (Nesting-Guard + stdin)
- Docs-Stufen in structure.md v0.5.0 aktualisiert
- documentation.md v0.2.0 mit Mini-Header + Pfad-Konvention
- docs-agent.md mit relativen Pfaden + Mini-Header

### Uncommitted Changes (nicht zu diesem Task gehoerend)
```
geaendert: projects/infrastructure/n8-vps/stacks/crowdsec/README.md
geaendert: projects/infrastructure/n8-vps/stacks/crowdsec/config/acquis.yaml
geaendert: projects/infrastructure/n8-vps/stacks/crowdsec/docker-compose.yml
geaendert: projects/infrastructure/n8-vps/stacks/traefik/config/dynamic/middlewares.yml
```
Diese Aenderungen gehoeren NICHT zu Phase 3 — separat behandeln!

---

## Sicherheitshinweise

- **Branch verwenden:** Nicht direkt auf main arbeiten
- **Block fuer Block:** Nach jedem Block (A/B/C) Ergebnis pruefen
- **Kein automatischer Fix-Agent:** Manuell durcharbeiten, Claude Code macht die Fixes interaktiv
- **CHANGELOG + ROADMAP:** Wie immer im selben Commit aktualisieren
- **Handoff loeschen:** Dieses Handoff + das alte Phase-2 Handoff im Merge-Commit loeschen
