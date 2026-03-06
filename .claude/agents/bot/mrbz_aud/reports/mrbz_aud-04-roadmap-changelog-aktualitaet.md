# mrbz_aud — Modul 04: ROADMAP/CHANGELOG Aktualitaet

**Datum:** 2026-03-06
**Status:** FINDINGS

## Zusammenfassung

Pruefung der 4 zentralen Planungsdateien (Root ROADMAP, Root CHANGELOG, .claude/ROADMAP,
.claude/CHANGELOG) sowie der n8-vps ROADMAP und des VPS-SEC Handoffs auf Aktualitaet
und Konsistenz. 10 Findings identifiziert: 2 MITTEL (Widersprueche und veraltete Status),
6 INFO (veraltete Querverweise und Zaehler) und 2 NEEDS_REVIEW (strategische Entscheidungen noetig).

## Geprueft

| Datei | Status |
|-------|--------|
| `ROADMAP.md` (Root) | FINDINGS |
| `CHANGELOG.md` (Root) | FINDINGS |
| `.claude/ROADMAP.md` | FINDINGS |
| `.claude/CHANGELOG.md` | OK |
| `projects/infrastructure/n8-vps/ROADMAP.md` | FINDINGS |
| `projects/infrastructure/n8-vps/.claude/CLAUDE.md` | FINDINGS |
| `.claude/context/handoffs/HANDOFF_[VPS][SEC]_crowdsec-traefik-authentik-deployment.md` | OK |

## Findings

### [MITTEL] Root ROADMAP: Widerspruch "public Repo" vs. "bleibt privat"

- **Datei:** `ROADMAP.md`
- **Problem:** Kompakt-Uebersicht (Zeile 466) sagt unter "Done":
  `Main-Repo mr-bytez als public Repo (GitHub + Codeberg)`
  Aber A5-Abschnitt (Zeile 249) sagt:
  `Hauptrepo bleibt privat bis A5 abgeschlossen`
  A5 ist noch nicht abgeschlossen — das Repo ist also privat, nicht public.
- **Erwartung:** Konsistente Aussage zum Repo-Status
- **Empfehlung:** Kompakt-Uebersicht korrigieren: "public Repo" durch "privates Repo (public nach A5)" ersetzen, oder als Ziel-Zustand kennzeichnen

### [MITTEL] Root ROADMAP: A4 Status veraltet — Authentik-Prerequisite erfuellt

- **Datei:** `ROADMAP.md`
- **Problem:** A4-Abschnitt (Zeile 219) sagt: `Status: Geplant — wartet auf Authentik`
  Aber Authentik (VPS-Pipeline Schritt 3) ist ✅ erledigt (Zeile 383):
  `Schritt 3 ✅ Authentik SSO (deployed, Forward-Auth live, Secret-Key Bugfix, Stack-Haertung)`
  Die Abhaengigkeit ist erfuellt, der Status-Text spiegelt das nicht wider.
  Ebenso sagt Zeile 193: `Abhaengigkeiten: Traefik (B14) ✅, Authentik (Schritt 3 der VPS-Pipeline)`
  — hier fehlt das ✅ hinter Authentik.
- **Erwartung:** Status aktualisiert, z.B. "Geplant — Prerequisites erfuellt, nach Priorisierung"
- **Empfehlung:** A4 Status-Zeile und Abhaengigkeiten-Zeile aktualisieren (Authentik ✅)

### [INFO] .claude/ROADMAP Phase 5: mrbz_aud als unchecked/GEPLANT, aber Bot ist gebaut

- **Datei:** `.claude/ROADMAP.md`
- **Problem:** Phase 5 (Zeile 68) zeigt:
  `- [ ] mrbz_aud Docs-Audit-Bot → Projekt A7 in Root ROADMAP.md`
  Aber der Bot existiert in `.claude/agents/bot/mrbz_aud/`, Phase 1 ist getestet,
  Root ROADMAP sagt: "Bereit (Bot gebaut, Phase 1 getestet, Phase 2+3 ausstehend)"
- **Erwartung:** Checkbox teilweise/ganz markiert, Status aktualisiert
- **Empfehlung:** `- [x]` oder `- [~]` setzen mit Vermerk "(Bot gebaut, Phase 1 getestet)"

### [INFO] .claude/ROADMAP Gesamtbild: Verweis auf "A1-A5" veraltet

- **Datei:** `.claude/ROADMAP.md`
- **Problem:** Zeile 78 sagt:
  `Fuer die vollstaendige Projekt-Uebersicht (A1-A5, B-Tasks, D-Tasks, Timing-Matrix):`
  Root ROADMAP hat inzwischen A6 (Cloud-Sync), A7 (mrbz_aud), A8 (mrbz_dep), A9 (Master-Key).
- **Erwartung:** "A1-A9" oder "alle A-Projekte"
- **Empfehlung:** Verweis auf "A1-A9" aktualisieren

### [INFO] Root CHANGELOG [Unreleased]: Handoff-Zaehler inkonsistent

- **Datei:** `CHANGELOG.md`
- **Problem:** Unter "Removed" (Zeile 232):
  `Verbleibend: 1 Handoff (mr-bytez-learn — eigenes Projekt)`
  Aber unter "Added" im selben [Unreleased]-Block wurde der VPS-SEC Handoff erstellt.
  Tatsaechlich existieren 2 Handoffs (VPS-SEC + mr-bytez-learn). ROADMAP sagt korrekt "2 verbleibend".
- **Erwartung:** Zaehler im CHANGELOG-Eintrag ist zeitlich korrekt (zum Zeitpunkt der Loeschung war 1 uebrig), aber im [Unreleased]-Kontext verwirrend
- **Empfehlung:** Bei naechstem Release den Zaehler im Kontext klaeren oder entfernen

### [INFO] n8-vps CLAUDE.md: "Naechster Schritt" veraltet

- **Datei:** `projects/infrastructure/n8-vps/.claude/CLAUDE.md`
- **Problem:** Sektion "Aktuell" (letzte Zeile) sagt:
  `Naechster Schritt: Authentik SSO (Schritt 3)`
  Aber Schritt 3 (Authentik) ist ✅ erledigt. Naechster Schritt waere Schritt 4 (Portainer).
- **Erwartung:** Aktuellen naechsten Schritt referenzieren
- **Empfehlung:** Auf "Schritt 4: Portainer + Watchtower" aktualisieren

### [INFO] n8-vps ROADMAP: Header-Datum vs. Footer-Datum Mismatch

- **Datei:** `projects/infrastructure/n8-vps/ROADMAP.md`
- **Problem:** Header sagt `Aktualisiert: 2026-03-04`, Footer sagt `Letzte Aktualisierung: 2026-03-05`.
  Zwei verschiedene Datumsangaben fuer dasselbe Konzept.
- **Erwartung:** Ein einheitliches Aktualisierungsdatum
- **Empfehlung:** Footer-Zeile entfernen (redundant zum Header) oder Header-Datum angleichen

### [INFO] n8-vps ROADMAP: "Geplante Stacks" listet bereits deployte Stacks

- **Datei:** `projects/infrastructure/n8-vps/ROADMAP.md`
- **Problem:** Zeile 59: `Authentik → Portainer+Watchtower → WireGuard → CrowdSec → ...`
  listet Authentik und CrowdSec als "geplant", obwohl beide ✅ deployed sind.
- **Erwartung:** Nur tatsaechlich offene Stacks als "geplant" listen, oder deployed markieren
- **Empfehlung:** Liste aktualisieren: `✅ Authentik → Portainer+Watchtower → WireGuard → ✅ CrowdSec → ...`

### [NEEDS_REVIEW] Root CHANGELOG [Unreleased]: Sehr grosser Block ohne Versionierung

- **Datei:** `CHANGELOG.md`
- **Problem:** Der [Unreleased]-Block enthaelt ca. 230 Zeilen mit Aenderungen seit Version 0.15.2
  (2026-03-01). Inhalt: VPS Stack-Haertung, Authentik, mrbz_aud, WebFetch, Agent-Umbau,
  Placeholder-Cleanup, CrowdSec Middleware, Host-Level Tuning, Statusline, deploy.fish,
  und vieles mehr — mindestens 8-10 thematische Bloecke.
- **Erwartung:** Regelmaessige Versionierung
- **Empfehlung:** Entscheidung noetig: Soll der [Unreleased]-Block in eine oder mehrere
  versionierte Releases aufgeteilt werden? Vorschlag: Mindestens ein Release vor naechstem
  groesseren Feature-Block schneiden.

### [NEEDS_REVIEW] Root ROADMAP A7 ETA: "Q1 2026" waehrend Q1 fast vorbei

- **Datei:** `ROADMAP.md`
- **Problem:** A7 mrbz_aud (Zeile 338): `ETA: Q1 2026`
  Aktuelles Datum: 2026-03-06 (Q1 endet in 24 Tagen). Bot ist "Bereit" aber Phase 2+3
  und Orchestrator End-to-End Test sind noch offen, Cron noch nicht aktiv.
  Ob alles in Q1 fertig wird, ist fraglich.
- **Erwartung:** Realistisches ETA
- **Empfehlung:** Entscheidung noetig: ETA auf Q1-Q2 2026 aktualisieren, oder ambitioniert bei Q1 belassen?

## Konsistenz-Pruefung: Root CHANGELOG ↔ .claude/CHANGELOG

Die .claude/CHANGELOG trackt seit [0.6.0] alle .claude/-Aenderungen eigenstaendig.
Stichproben-Vergleich fuer [Unreleased]:

| Thema | Root CHANGELOG | .claude/CHANGELOG | Konsistent? |
|-------|---------------|-------------------|-------------|
| mrbz_aud Bot-Erstellung | ✅ vorhanden | ✅ vorhanden | Ja |
| Agent-Umbau (manual/bot) | ✅ vorhanden | ✅ vorhanden | Ja |
| BOT-Tag in tags.md | ✅ vorhanden | ✅ vorhanden | Ja |
| WebFetch-Konsolidierung | ✅ vorhanden | ✅ vorhanden | Ja |
| Versions-Korrektur 0.x.x | ✅ vorhanden | ✅ vorhanden | Ja |
| Placeholder-Cleanup | ✅ vorhanden | ✅ vorhanden | Ja |
| pre-commit-docs-check v0.2.0 | ✅ vorhanden | ✅ vorhanden | Ja |
| VPS Handoff-Update | ✅ (implizit) | ✅ vorhanden | Ja |
| structure.md v0.5.0 | ✅ (implizit) | ✅ vorhanden | Ja |

**Ergebnis:** Keine Konsistenz-Luecken gefunden. Beide CHANGELOGs sind synchron.

## ROADMAP: Erledigte Tasks vs. Realitaet

Stichproben-Verifikation ob als "erledigt" markierte Tasks wirklich umgesetzt sind:

| Claim | Verifikation | Status |
|-------|-------------|--------|
| A1: `.secrets/` als Submodule mit 5-5-3 Docs | Submodule existiert, README/CLAUDE/CHANGELOG/ROADMAP vorhanden | ✅ Korrekt |
| A1: pack-secrets.fish, unpack-secrets.fish | Beide in shared/deployment/ vorhanden | ✅ Korrekt |
| A1: deploy.fish in .secrets/ | .secrets/deploy.fish existiert | ✅ Korrekt |
| A1: symlinks.db verschoben | .secrets/deployment/symlinks.db existiert | ✅ Korrekt |
| A2: Fish-Config mit Loader, Theme, Feature-Flags | 000-loader.fish, mr-bytez.fish, 008-host-flags.fish alle vorhanden | ✅ Korrekt |
| A2: 8 Host-Configs | Alle 8 Hosts unter projects/infrastructure/ vorhanden | ✅ Korrekt |
| A7: Bot-Dateien komplett | 3 Agents, Orchestrator, README, reports/, logs/ vorhanden | ✅ Korrekt |
| VPS: Traefik Stack | stacks/traefik/ mit README + DEPLOYMENT vorhanden | ✅ Korrekt |
| VPS: CrowdSec Stack | stacks/crowdsec/ mit README + DEPLOYMENT vorhanden | ✅ Korrekt |
| VPS: Authentik Stack | stacks/authentik/ mit README + DEPLOYMENT vorhanden | ✅ Korrekt |
| Placeholder mcp-server geloescht | projects/infrastructure/mcp-server/ existiert nicht | ✅ Korrekt |
| Placeholder mrbz-dev geloescht | shared/stacks/mrbz-dev/ existiert nicht | ✅ Korrekt |
| 2 Handoffs verbleibend (VPS-SEC, Learn) | Genau diese 2 existieren in handoffs/ | ✅ Korrekt |

**Ergebnis:** Alle stichprobenartig geprueften erledigten Tasks sind tatsaechlich umgesetzt.

## Statistik

- Gepruefte Dateien: 7 (4 zentrale Planungsdateien + n8-vps ROADMAP + n8-vps CLAUDE.md + VPS-SEC Handoff)
- Stichproben-Verifikation: 13 Claims geprueft, alle korrekt
- CHANGELOG-Konsistenz: 9 Themen verglichen, alle synchron
- Findings: 10 (0 KRITISCH, 2 MITTEL, 6 INFO, 2 NEEDS_REVIEW)
