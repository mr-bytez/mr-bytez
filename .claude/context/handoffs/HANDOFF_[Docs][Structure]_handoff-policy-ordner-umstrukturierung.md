# Handoff: #DOC01.2 — Handoff-Policy + Ordner-Umstrukturierung

**Chat:** #DOC01.2
**Datum:** 2026-02-11
**Status:** Aktiv
**Vorgaenger:** #DOC01.1 https://claude.ai/chat/09dcbebc-6d2c-4ce4-a24f-6166e8ad9191
**Chat-Referenz:** https://claude.ai/chat/9669a74f-093d-4dc7-a481-68d64446baeb

---

## Zusammenfassung

Handoff-Policy definiert und Ordner-Umstrukturierung geplant.
Policy-Texte fertig formuliert — muessen in Dateien integriert werden.
3 erledigte Handoffs loeschen, 5 offene verschieben, Verweise aktualisieren.

---

## Aufgaben fuer Claude Code

**Alle Aufgaben sind an Claude Code delegierbar.**

### Aufgabe 1: Ordner erstellen

```fish
mkdir -p .claude/context/handoffs
mkdir -p .claude/archive/handoffs
```

### Aufgabe 2: Handoff-Policy in documentation.md einfuegen

In `.claude/context/documentation.md` folgenden Abschnitt am Ende einfuegen:

```markdown
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
```

### Aufgabe 3: Projektanweisungen updaten

In `.claude/context/claude-ai-projektanweisungen.md` den Abschnitt `Handoff-Dateien` ersetzen.

ALT (suchen):
```
Handoff-Dateien (Referenz fuer offene Aufgaben):
→ todo_aus_chats_noch_nicht_in_roadmap_integriert/
```

NEU (ersetzen mit):
```
Handoff-Policy:
→ .claude/context/documentation.md (Details)
Ablageort aktive Handoffs: .claude/context/handoffs/
Archiv: .claude/archive/handoffs/ (nur auf Wunsch)
Dateiname: HANDOFF_[Tag1][Tag2]_kurzbeschreibung.md (Tags aus context/tags.md)
Selbst-Verifikation: Bei jedem Chat-Start pruefen ob relevante Handoffs existieren.
Proaktiv vorschlagen dort nachzuschauen — auch bei neuen Themen ohne Kette.
Bei erledigten Handoffs: User fragen ob loeschen oder archivieren.
```

### Aufgabe 4: 3 erledigte Handoffs loeschen

Diese Dateien sind vollstaendig in Roadmap/Context integriert und koennen geloescht werden:

```fish
rm todo_aus_chats_noch_nicht_in_roadmap_integriert/HANDOFF_X01-1_Chat-Benennungssystem.md
rm todo_aus_chats_noch_nicht_in_roadmap_integriert/INVENTUR.md
rm todo_aus_chats_noch_nicht_in_roadmap_integriert/ARBEITSANWEISUNG_ROADMAP_RESTRUKTURIERUNG.md
```

### Aufgabe 5: 5 offene Handoffs verschieben + umbenennen

Von `todo_aus_chats_noch_nicht_in_roadmap_integriert/` nach `.claude/context/handoffs/`:

```fish
mv todo_aus_chats_noch_nicht_in_roadmap_integriert/2026-02-04-security-git-filter-handoff.md .claude/context/handoffs/HANDOFF_[Security][Git]_git-filter-cleanup.md
mv todo_aus_chats_noch_nicht_in_roadmap_integriert/fish-config-refactoring-arbeitsanweisung.md .claude/context/handoffs/HANDOFF_[Fish][Refactor]_fish-dry-refactoring.md
mv todo_aus_chats_noch_nicht_in_roadmap_integriert/HANDOFF_2026-02-08.md .claude/context/handoffs/HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md
mv todo_aus_chats_noch_nicht_in_roadmap_integriert/HANDOFF_SMB_DEPLOYMENT.md .claude/context/handoffs/HANDOFF_[SMB][Deploy]_smb-shares-deployment.md
mv todo_aus_chats_noch_nicht_in_roadmap_integriert/MR-ByteZ_DNS_Handoff_2026-02-09.md .claude/context/handoffs/HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md
```

### Aufgabe 6: Verweise aktualisieren

In folgenden Dateien alle Verweise auf `todo_aus_chats_noch_nicht_in_roadmap_integriert/` durch `.claude/context/handoffs/` ersetzen und die neuen Dateinamen verwenden:

- `ROADMAP.md` (Root)
- `CHANGELOG.md` (Root)
- `.claude/ROADMAP.md` (falls vorhanden)

Mapping alte → neue Namen:
| Alt | Neu |
|-----|-----|
| `todo_aus_chats.../2026-02-04-security-git-filter-handoff.md` | `.claude/context/handoffs/HANDOFF_[Security][Git]_git-filter-cleanup.md` |
| `todo_aus_chats.../fish-config-refactoring-arbeitsanweisung.md` | `.claude/context/handoffs/HANDOFF_[Fish][Refactor]_fish-dry-refactoring.md` |
| `todo_aus_chats.../HANDOFF_2026-02-08.md` | `.claude/context/handoffs/HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md` |
| `todo_aus_chats.../HANDOFF_SMB_DEPLOYMENT.md` | `.claude/context/handoffs/HANDOFF_[SMB][Deploy]_smb-shares-deployment.md` |
| `todo_aus_chats.../MR-ByteZ_DNS_Handoff_2026-02-09.md` | `.claude/context/handoffs/HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md` |
| `todo_aus_chats.../INVENTUR.md` | GELOESCHT — Verweis entfernen |
| `todo_aus_chats.../ARBEITSANWEISUNG_ROADMAP_RESTRUKTURIERUNG.md` | GELOESCHT — Verweis entfernen |
| `todo_aus_chats.../HANDOFF_X01-1_Chat-Benennungssystem.md` | GELOESCHT — Verweis entfernen |

### Aufgabe 7: Alten Ordner loeschen

```fish
rmdir todo_aus_chats_noch_nicht_in_roadmap_integriert/
```

(Nur wenn leer — nach Aufgabe 4+5 sollte er leer sein)

### Aufgabe 8: CHANGELOG.md updaten

Neuen Eintrag in CHANGELOG.md:

```markdown
### 2026-02-11
- [Docs][Structure] Handoff-Policy definiert und in documentation.md integriert
- [Structure] Handoff-Ordner umstrukturiert: todo_aus_chats.../ → .claude/context/handoffs/
- [Cleanup] 3 erledigte Handoffs geloescht (X01-1, INVENTUR, ARBEITSANWEISUNG_ROADMAP)
- [Docs] Projektanweisungen aktualisiert (neuer Handoff-Ablageort)
- [Structure] 5 offene Handoffs verschoben und nach Tag-Konvention umbenannt
```

### Aufgabe 9: Commit

```fish
git add -A
git commit -m "[Docs][Structure] Handoff-Policy + Ordner-Umstrukturierung

- Handoff-Policy in .claude/context/documentation.md definiert
- Neuer Ablageort: .claude/context/handoffs/ (aktiv), .claude/archive/handoffs/ (archiv)
- Dateinamens-Konvention: HANDOFF_[Tag1][Tag2]_kurzbeschreibung.md
- 3 erledigte Handoffs geloescht (X01-1, INVENTUR, ARBEITSANWEISUNG_ROADMAP)
- 5 offene Handoffs verschoben und umbenannt
- Alle Verweise in ROADMAP.md, CHANGELOG.md aktualisiert
- Projektanweisungen aktualisiert
- Alter Ordner todo_aus_chats_noch_nicht_in_roadmap_integriert/ entfernt

Chat: https://claude.ai/chat/9669a74f-093d-4dc7-a481-68d64446baeb"
git push origin main
git push codeberg main
```

---

## Betroffene Dateien

| Datei | Aktion |
|-------|--------|
| `.claude/context/documentation.md` | Handoff-Policy Abschnitt einfuegen |
| `.claude/context/claude-ai-projektanweisungen.md` | Handoff-Verweis aktualisieren |
| `.claude/context/handoffs/` | NEU — 5 Handoffs hierhin |
| `.claude/archive/handoffs/` | NEU — leerer Ordner fuer spaeter |
| `ROADMAP.md` | Verweise aktualisieren |
| `CHANGELOG.md` | Neuen Eintrag hinzufuegen |
| `todo_aus_chats.../` | 3 Dateien loeschen, 5 verschieben, Ordner loeschen |

---

## Claude Code Prompt

```
Lies .claude/context/handoffs/HANDOFF_[Docs][Structure]_handoff-policy-ordner-umstrukturierung.md und fuehre alle 9 Aufgaben der Reihe nach aus. Pruefe nach jeder Aufgabe ob sie erfolgreich war bevor du zur naechsten gehst.
```
