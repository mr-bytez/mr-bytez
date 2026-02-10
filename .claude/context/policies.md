# Policies — Grundprinzipien & Repo-Regeln

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
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
2. **Erledigt** — Claude fragt: loeschen oder archivieren?
   - Default: Loeschen (wenn Inhalte in Roadmap/Context integriert)
   - Archivieren nur auf expliziten Wunsch → `.claude/archive/handoffs/`

**Selbst-Verifikation:**
- Claude prueft bei jedem Chat-Start ob relevante Handoffs existieren
- Claude schlaegt proaktiv vor in `.claude/context/handoffs/` nachzuschauen
- Gilt auch ausserhalb von Ketten-Chats wenn Thema passt
