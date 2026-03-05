# Policies — Grundprinzipien & Repo-Regeln

**Version:** 0.2.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-03-05
**Autor:** MR-ByteZ

---

## Grundprinzipien

- **Single Source of Truth:** Live-Checkout liegt unter `/mr-bytez`
- **Stabiler System-Anker:** System-Symlinks zeigen auf `/opt/mr-bytez/current` → `/mr-bytez`
- **Explizit statt Magie:** Keine stillen Side-Effects, alles nachvollziehbar
- **Security by Design:** Keine Klartext-Secrets, keine Symlinks in sensible User-State-Dateien
- **Fish-first:** Fish ist die Referenz-Shell für alle Skripte und Beispiele (→ `.claude/context/shell.md`)
- **Docs-first:** Dokumentation VOR Code committen (→ `.claude/context/documentation.md`)

---

## Repo-Policies

### Additive-Only Regel

Für zentrale Markdown-Dateien (README.md, DEPLOYMENT.md, CHANGELOG.md, ROADMAP.md) gilt:

- **Basis ist immer die bestehende Datei**
- Es werden **nur Ergänzungen** oder **kleine Korrekturen** gemacht
- **Keine Kürzungen/Entfernungen** — außer explizit erlaubt
- Vor Änderungen kurz erklären: **was** geändert wird, **wo** und **warum**

### CHANGELOG-Pflicht (pro Ordner)

Jeder Ordner mit eigenem CHANGELOG.md muss diesen aktualisieren wenn Dateien in diesem
Ordner geaendert werden. Der `pre-commit-docs-check.sh` Hook prueft das automatisch.

Aktiv gepflegte CHANGELOGs (6 Orte):
- Root `/mr-bytez/CHANGELOG.md` — Repo-weite Aenderungen
- `.claude/CHANGELOG.md` — Alle Aenderungen an `.claude/` (eigene Perspektive, kein 1:1 Copy vom Root)
- `.secrets/CHANGELOG.md` — Secrets-Repo Aenderungen
- `shared/etc/fish/CHANGELOG.md` — Fish Shell Config
- `projects/infrastructure/n8-vps/CHANGELOG.md` — VPS-Projekt
- `shared/usr/local/bin/hwi/CHANGELOG.md` — Hardware-Info Script

### Commit-Regeln

- Alle Commits MÜSSEN auf **n8-kiste** gemacht werden
- n8-vps ist **read-only** (nur `git pull`, nicht committen)
- Push immer zu **beiden** Remotes: origin (GitHub) + codeberg (Codeberg)
- Ausführliche Commit-Messages sind Pflicht (→ `.claude/context/git.md`)

### Sprache

- Dokumentation: **Deutsch**
- Code-Kommentare: **Deutsch**
- Commit-Messages: **Deutsch**
- Variablen/Funktionsnamen: **Englisch** (technische Konvention)

---

## Arbeitsweise mit Claude

- Bei Datei-Aenderungen: Immer Zeilennummer + Zeile davor und danach angeben fuer eindeutigen Kontext
- Aufgaben-Delegation: Strategisches im Chat besprechen, Mechanisches (Datei-Edits, Struktur-Anlage) an Claude Code delegieren

### Claude Code Selbst-Verifikation

Vor jedem Commit muss Claude Code eigenstaendig verifizieren:

1. **Erfolgskriterien pruefen** — Alle Kriterien des Tasks durchgehen, keines auslassen
2. **Geaenderte Dateien pruefen** — Jede geaenderte Datei nochmal lesen und auf Konsistenz pruefen
3. **Verweise pruefen** — Alle Querverweise zwischen Dateien auf Aktualitaet pruefen
4. **Kein Content verloren** — Bei Verschiebungen/Refactors: Original-Inhalt vollstaendig uebernommen?
5. **Erst committen wenn bestanden** — Verifikation dokumentieren, dann erst stagen und committen

---

## Verwandte Policies

- Secrets & Security → `.claude/context/security.md`
- Shell-Regeln → `.claude/context/shell.md`
- Git-Workflow → `.claude/context/git.md`
- Deployment → `.claude/context/deployment.md`
- Dokumentation → `.claude/context/documentation.md`

---

## Handoff-Policy

**Zweck:** Handoffs dokumentieren offene Aufgaben am Chat-Ende fuer Folge-Chats.

**Ablageort:** `.claude/context/handoffs/` (aktive Handoffs)
**Archiv:** `.claude/archive/handoffs/` (nur wenn explizit gewuenscht)

**Dateiname:** `HANDOFF_[Tag1][Tag2]_kurzbeschreibung.md`
Tags aus context/tags.md, Beschreibung kurz und praegnant.
Beispiel: `HANDOFF_[Security][Git]_git-filter-cleanup.md`

**Wann erstellen:**
- Nur wenn offene Aufgaben am Chat-Ende existieren
- Kein Handoff wenn alles erledigt ist

**Inhalt:**
- Zusammenfassung (was wurde gemacht, was ist offen)
- Offene TODOs mit konkreten Schritten
- Betroffene Dateien im Repo
- Chat-Referenz (Link zum Vorgaenger-Chat)
- Delegation: Explizit angeben ob Aufgaben an Claude Code delegierbar sind

**Lifecycle:**
1. **Aktiv** — Offene Aufgaben, liegt in `.claude/context/handoffs/`
2. **Erledigt** — Claude fragt VOR dem Commit: loeschen oder archivieren?
   - Default: Loeschen (wenn Inhalte in Roadmap/Context integriert)
   - Archivieren nur auf expliziten Wunsch → `.claude/archive/handoffs/`
   - Loeschen/Archivieren gehoert in denselben Commit wie die erledigten Aenderungen
   - Kein separater Folge-Commit fuer Handoff-Bereinigung!
3. **Aktualisiert** — Teilweise erledigte Aufgaben im Handoff markieren
   - Task-Status aktualisieren (Offen → Erledigt), Header anpassen
   - Gehoert in denselben Commit wie die erledigten Aenderungen
   - Kein separater Folge-Commit fuer Handoff-Aktualisierung!

**Selbst-Verifikation:**
- Claude prueft bei jedem Chat-Start ob relevante Handoffs existieren
- Claude schlaegt proaktiv vor in `.claude/context/handoffs/` nachzuschauen
- Gilt auch ausserhalb von Ketten-Chats wenn Thema passt

**Dauerhafte Aufgaben gehoeren in die ROADMAP, nicht in Handoffs.**
Handoffs nur fuer Chat-Uebergaben bei laufender Arbeit und eigenstaendige Projekte
(z.B. mr-bytez-learn mit eigenem Repo).

### Delegation an Claude Code

Fuer direkte Claude Code Delegation wird der Handoff als Prompt-Vorlage genutzt.
Der tasks/-Ordner wurde aufgeloest — alles laeuft ueber Handoffs.
Wenn ein Handoff an Claude Code delegierbar ist, steht das im Feld "Delegation".
