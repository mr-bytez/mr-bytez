# Inventur: Handoff-Dateien vs. Roadmaps

**Erstellt:** 2026-02-10
**Autor:** MR-ByteZ
**Abgeglichen gegen:** `ROADMAP.md` (Root) + `.claude/ROADMAP.md`

---

## 1. Security — Git Clean/Smudge Filter

**Datei:** `2026-02-04-security-git-filter-handoff.md`
**Thema:** Hostname/Username-Sanitization via Git Clean/Smudge Filter + optionale History-Bereinigung.

**Wichtigste offene Aufgaben:**
- Pattern-Scanner Script erstellen (`mr-bytez-scan-sensitive.fish`)
- Clean/Smudge Filter implementieren (`hostname-clean.fish`, `hostname-smudge.fish`)
- `.gitattributes` erstellen
- Entscheidung: Git-History bereinigen (git filter-repo) oder nur ab jetzt filtern
- IP-Adressen scannen und Mapping erstellen
- Case-Handling Username klären

**Bereits in Roadmap:**
- Root `ROADMAP.md`, Phase 3 Prioritaet 2: "Sensitive Data Cleanup" deckt die History-Bereinigung und Pattern-Analyse ab (Milestones + Mapping-Tabelle vorhanden)

**Fehlt in Roadmap:**
- Der **Clean/Smudge Filter** als laufende Loesung (bidirektional, .gitattributes) ist NICHT in der Roadmap — dort steht nur die einmalige History-Bereinigung
- Pattern-Scanner als eigenstaendiges Tool fehlt
- IP-Adressen-Mapping als separater Schritt fehlt

**Empfehlung:** Roadmap-Eintrag erweitern (Clean/Smudge als eigenstaendigen Milestone ergaenzen). Handoff bleibt als Referenz — enthaelt vollstaendiges Mapping + technische Details.

---

## 2. Fish Config Refactoring (DRY)

**Datei:** `fish-config-refactoring-arbeitsanweisung.md`
**Thema:** Komplettes DRY-Refactoring der Fish Shell Config mit Feature-Flags, neuem Nummerierungsschema (000-200) und Self-Check Pattern.

**Wichtigste offene Aufgaben:**
- Neues Nummerierungsschema 000-100 (Shared) / 101-200 (Host) einfuehren
- Feature-Flags implementieren (`MR_HAS_GUI`, `MR_IS_DEV`, `MR_DISPLAY_TYPE`)
- Shared Conditionals (`050-gui.fish`, `055-dev.fish`) erstellen
- Loader-Reihenfolge anpassen (Host-Flags VOR Shared-Conditionals)
- Alle Shared Aliases umbenennen (10-nav → 010-nav etc.)
- 7-Phasen-Plan (Phase 0-7) komplett offen
- -> Details: `fish-config-refactoring-arbeitsanweisung.md`, Abschnitt "Phasen-Plan"

**Bereits in Roadmap:**
- Root `ROADMAP.md`, Phase 2: Fish-Config v2.1 als erledigt markiert — das ist aber die AKTUELLE Config, nicht das DRY-Refactoring

**Fehlt in Roadmap:**
- **Komplett.** Das DRY-Refactoring ist in keiner Roadmap erwaehnt. Es ist ein eigenstaendiges Projekt mit erheblichem Umfang (neues Schema, Loader-Umbau, 8 Hosts betroffen).

**Empfehlung:** Neuen Roadmap-Eintrag erstellen (Phase 2 oder eigenes Feature in Phase 3). Handoff bleibt als Arbeitsanweisung — enthaelt Host-Matrix, Datei-Mapping, Code-Templates.

---

## 3. Deployment Session 2026-02-08

**Datei:** `HANDOFF_2026-02-08.md`
**Thema:** 4 Aufgaben aus einer Session: SSH-Config Deployment, /etc/hosts, README-Baum, Git-Config Shared.

**Wichtigste offene Aufgaben:**
- **Aufgabe 1:** SSH-Config ins Secrets-Repo + Symlink-Deployment (7 Schritte)
  -> Details: `HANDOFF_2026-02-08.md`, Abschnitt "Aufgabe 1"
- **Aufgabe 2:** `/etc/hosts` auf n8-kiste dokumentieren (inkl. .local Domains fuer Docker-Stacks)
  -> Details: `HANDOFF_2026-02-08.md`, Abschnitt "Aufgabe 2"
- **Aufgabe 3:** README.md Struktur-Baum korrigieren — **teilweise erledigt** (Baum wurde in Phase 2+3 aktualisiert, Einrueckungsprobleme aber moeglicherweise noch vorhanden)
- **Aufgabe 4:** Git-Config als Shared-Config (.gitconfig Template oder Include)
  -> Details: `HANDOFF_2026-02-08.md`, Abschnitt "Aufgabe 4"

**Bereits in Roadmap:**
- Aufgabe 3 (README-Baum): teilweise durch die Phase 2+3 Migration erledigt
- Aufgabe 1 (SSH-Config): Root `ROADMAP.md` erwaehnt SSH-Policy als done, aber das neue Secrets-Deployment fehlt

**Fehlt in Roadmap:**
- SSH-Config Secrets-Deployment (Aufgabe 1) — neues Deployment-Konzept
- `/etc/hosts` Dokumentation (Aufgabe 2) — Host-Konfiguration
- Git-Config Shared (Aufgabe 4) — Deployment-Vereinfachung

**Empfehlung:** Aufgabe 1+2 als Roadmap-Eintrag (Phase 2, Host-Setup). Aufgabe 3 pruefen ob erledigt. Aufgabe 4 als Nice-to-have in Phase 2. Handoff bleibt als Referenz fuer Aufgaben 1+2 (enthaelt aktuelle SSH-Configs, /etc/hosts Eintraege).

---

## 4. SMB-Shares Deployment

**Datei:** `HANDOFF_SMB_DEPLOYMENT.md`
**Thema:** CIFS-Mounts von n8-kiste auf alle Desktop-Hosts deployen (Filme, Serien, JDownloader).

**Wichtigste offene Aufgaben:**
- Deploy-Script erstellen (`deploy-smb-mounts.fish`, idempotent)
- fstab-Template ins Repo (`shared/etc/fstab-snippets/smb-n8-kiste.conf`)
- VLC Desktop-Paketliste erstellen (`vlc-plugin-ffmpeg`, `vlc-plugin-mpeg2`, `vlc-plugin-x264`)
- 4 Commits ausstehend (Secrets, Feature, Packages, Docs)
- Credentials auf n8-archstick aktualisieren (neues Passwort)
- Rollout auf n8-station, n8-book, n8-kiste (localhost)
- -> Details: `HANDOFF_SMB_DEPLOYMENT.md`, Abschnitt "Was noch offen ist"

**Bereits in Roadmap:**
- **Nichts.** Komplett neues Thema.

**Fehlt in Roadmap:**
- SMB-Shares Deployment als eigenstaendiges Feature
- Deploy-Script Konzept
- Desktop-Paketlisten als Konzept (VLC Codecs etc.)

**Empfehlung:** Roadmap-Eintrag in Phase 2 (Host-Setup) oder als neues Feature. Handoff bleibt als Arbeitsanweisung — enthaelt getestete fstab-Konfiguration, Mount-Optionen, Host-Status-Matrix.

---

## 5. Chat-Benennungssystem v2

**Datei:** `HANDOFF_X01-1_Chat-Benennungssystem.md`
**Thema:** Neues Ketten-basiertes Chat-Benennungssystem mit IDs (#F01.1), Tag-Pool und Registry.

**Wichtigste offene Aufgaben:**
- Arbeitsanweisung v2 schreiben (ersetzt aktuelle Chat-Benennung in Project Knowledge)
- TAG_REGISTRY.md initial befuellen
- Ablageort entscheiden (`context/git.md` vs. eigene `context/tags.md`)
- Ketten-Prefix-Liste finalisieren
- -> Details: `HANDOFF_X01-1_Chat-Benennungssystem.md`, Abschnitt "Offene Punkte"

**Bereits in Roadmap:**
- Root `ROADMAP.md`, Phase 3 Prioritaet 3: "Chat-Namer Skill" — deckt aber nur den Auto-Namer Skill ab, nicht das Benennungs-SYSTEM

**Fehlt in Roadmap:**
- Das Ketten-ID-System als Konvention
- TAG_REGISTRY.md
- Neues Chatname-Format `MR-ByteZ #<ID>.<Nr> [Tags] - Beschreibung`
- Integration mit Git-Commit-Tags

**Empfehlung:** Kein Roadmap-Eintrag noetig — ist eine Konvention/Policy, kein Feature. Stattdessen: Arbeitsanweisung finalisieren und in `.claude/context/documentation.md` oder eigener Datei ablegen. Handoff bleibt als Referenz bis Arbeitsanweisung steht.

---

## 6. DNS Hetzner Console API + Wildcard

**Datei:** `MR-ByteZ_DNS_Handoff_2026-02-09.md`
**Thema:** DNS-Infrastruktur fuer mr-bytez.de ueber Hetzner Console API, Wildcard Records fuer Traefik.

**Wichtigste offene Aufgaben:**
- API-Token mit Age verschluesseln fuer n8-vps
- Traefik docker-compose.yml mit ACME DNS-01 konfigurieren
- TTLs auf 3600s hochsetzen wenn stabil
- PTR-Records setzen (IPv4 + IPv6)
- Alte API-Tokens pruefen und aufraeumen
- -> Details: `MR-ByteZ_DNS_Handoff_2026-02-09.md`, Abschnitt "Offene Punkte"

**Bereits in Roadmap:**
- Root `ROADMAP.md`, Phase 3 Prioritaet 2: MCP Server erwaehnt Traefik Reverse Proxy (`mcp.mr-bytez.de`) — DNS ist Voraussetzung dafuer
- DNS-Setup selbst: **erledigt** (Wildcard Records stehen, API funktioniert)

**Fehlt in Roadmap:**
- DNS-Management als eigenstaendiges Thema (TTL-Optimierung, PTR, Token-Cleanup)
- Traefik-Setup als separater Milestone (aktuell unter MCP Server subsumiert, ist aber eigenstaendige Aufgabe)
- hcloud CLI Dokumentation / Referenz

**Empfehlung:** Traefik-Setup als eigenen Roadmap-Eintrag abtrennen (Prerequisite fuer MCP Server). DNS-Kernarbeit ist erledigt — offene Punkte (TTL, PTR) koennen als Sub-Tasks unter Traefik laufen. Handoff nach Traefik-Setup archivierbar — enthaelt vollstaendige DNS-Record-Uebersicht und CLI-Referenz.

---

## Zusammenfassende Tabelle

| # | Datei | Thema | In Roadmap? | Empfehlung |
|---|-------|-------|-------------|------------|
| 1 | `2026-02-04-security-git-filter-handoff.md` | Git Clean/Smudge Filter | Teilweise (History-Cleanup ja, Filter nein) | Roadmap erweitern + Referenz behalten |
| 2 | `fish-config-refactoring-arbeitsanweisung.md` | Fish DRY-Refactoring | Nein (komplett fehlend) | Neuen Roadmap-Eintrag + Referenz behalten |
| 3 | `HANDOFF_2026-02-08.md` | SSH-Config, /etc/hosts, README, Git-Config | Teilweise (README teilw. erledigt) | 3 Aufgaben in Roadmap + Aufgabe 3 pruefen |
| 4 | `HANDOFF_SMB_DEPLOYMENT.md` | SMB/CIFS Mounts | Nein (komplett fehlend) | Neuen Roadmap-Eintrag + Referenz behalten |
| 5 | `HANDOFF_X01-1_Chat-Benennungssystem.md` | Chat-Benennung v2 | Teilweise (Skill ja, System nein) | Policy-Datei erstellen, kein Roadmap-Eintrag |
| 6 | `MR-ByteZ_DNS_Handoff_2026-02-09.md` | DNS + Hetzner API | Teilweise (Traefik erwaehnt) | Traefik als eigenen Eintrag + nach Setup archivieren |

### Legende Empfehlung

- **Roadmap erweitern** = Bestehenden Eintrag um fehlende Aspekte ergaenzen
- **Neuen Roadmap-Eintrag** = Komplett neues Thema, braucht eigenen Abschnitt
- **Referenz behalten** = Handoff als Arbeitsanweisung/Referenz im Ordner belassen
- **Archivieren** = Nach Umsetzung nach `.claude/archive/` verschieben
- **Policy-Datei erstellen** = Ergebnis gehoert in `.claude/context/`, nicht in Roadmap
