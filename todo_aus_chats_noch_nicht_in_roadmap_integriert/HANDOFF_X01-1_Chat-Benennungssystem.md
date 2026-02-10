# 🔄 Chat-Handoff: #X01.1 — Chat-Benennungssystem v2

**Chat-ID:** #X01.1
**Datum:** 2026-02-10
**Status:** Konzept erarbeitet, Arbeitsanweisung noch nicht geschrieben
**Chatname:** `MR-ByteZ #X01.1 [Docs][Diskussion] - Chat-Benennungssystem v2 Konzept - ketten-id tags registry auto-naming 5-3-3 arbeitsanweisung --- 2026-02-10-21-55`

---

## 📋 Zusammenfassung

In diesem Chat wurde ein neues System zur Chat-Benennung konzipiert. Das bisherige System (ein einzelner Tag, statisches Format) reicht nicht aus für parallele Arbeit über mehrere Chats hinweg. Das neue System löst folgende Probleme:

- Zusammengehörige Chats erkennen (Chat-Ketten)
- Status ohne rückwirkiges Umbenennen tracken
- Konsistente Tags über Commits UND Chats hinweg
- Automatischer Namensvorschlag nach genug Kontext

---

## ✅ Erarbeitete Konzepte & Entscheidungen

### 1. Ketten-System mit IDs

Zusammengehörige Chats werden über eine Ketten-ID verknüpft:

```
#F01.1  →  Fish-Projekt 01, Chat 1
#F01.2  →  Fish-Projekt 01, Chat 2 (Fortsetzung)
#D03.1  →  Docker-Projekt 03, Chat 1
#X01.1  →  Übergreifend/Diskussion 01, Chat 1
```

**Ketten-Prefixe** (aus Hauptbereichen, erweiterbar):
- `#F` = Fish
- `#D` = Docker
- `#S` = Struktur/Repo
- `#H` = Hardware
- `#C` = Config (allgemein)
- `#X` = Diskussion/Übergreifend/Meta

**Regel:** Beim Folge-Chat einfach hochzählen: `.1` → `.2` → `.3`

### 2. Status gehört NICHT in den Chatnamen

**Begründung:** Wenn Chat .4 ein Projekt abschließt, müsste man Chat .1-.3 rückwirkend umbenennen → unpraktikabel.

**Lösung:** Status ergibt sich implizit:
- Der letzte Chat in der Kette (.3) = aktueller Stand
- Kein Tracker, kein Umbenennen, kein Status-Pflegen
- Bei Bedarf einfach Claude im aktuellen Chat fragen: "Was ist noch offen?"

### 3. Tags = nur Thema, keine Phasen

**Entscheidung:** Phasen wie Diskussion → Planung → Deploy → Debug sind der natürliche Lebenszyklus. Die Ketten-Nummer zeigt die Phase implizit.

Tags beschreiben nur **WAS** und **WO**, nicht die Phase:

```
✅  #F01.1 [Fish][Prompt] - Prompt System v2 Grundstruktur
✅  #F01.2 [Fish][Prompt] - Prompt System v2 Debugging
❌  #F01.1 [Fish][Prompt][Diskussion] - ...  ← Phase nicht taggen!
```

### 4. Gemeinsamer Tag-Pool für Commits UND Chats

Die gleichen Tags aus `.claude/context/git.md` werden für Chatnamen verwendet:

**Bestehende Tags (aus Git-Commits):**
`[Docs]`, `[Config]`, `[Fish]`, `[Docker]`, `[Security]`, `[Fix]`, `[Feature]`, `[Refactor]`, `[Deploy]`, `[Test]`, `[Release]`, `[Submodule]`, `[Cleanup]`, `[WIP]`, `[Hotfix]`, `[Structure]`

**Neue Tags (chat-spezifisch, noch nicht finalisiert):**
`[Diskussion]`, `[Planung]`, `[Debug]`, `[Migration]`, `[Template]`, `[Maintenance]`

→ Ob diese chat-spezifischen Tags wirklich nötig sind, ist noch offen (siehe "Tags = keine Phasen" oben — evtl. Widerspruch)

### 5. Auto-Vorschlag nach Turn 5-6

**Regel für die Arbeitsanweisung:**
- Turn 1-5: Kein Name, Context sammeln
- Nach Turn 5-6: Claude schlägt automatisch einen Namen vor
- User bestätigt oder korrigiert → Name steht

### 6. TAG_REGISTRY.md gegen Vergessen

**Problem:** In 6 Monaten weiß niemand ob es `[Wireguard]`, `[WG]` oder `[VPN]` hieß.

**Lösung:** Einfache Registry-Datei im Repo:

```markdown
# TAG_REGISTRY.md
| Tag          | Bedeutung              | Seit       |
|-------------|------------------------|------------|
| [Config]    | Konfigurationsdateien  | 2026-01   |
| [Docker]    | Container, Compose     | 2026-01   |
| [Fish]      | Fish Shell             | 2026-01   |
| ...         |                        |            |
```

**Aufwand:** Eine neue Zeile nur bei erstmaliger Verwendung eines neuen Tags.

**Ablageort im 5-3-3 System:** Noch nicht entschieden:
- Option A: In `.claude/context/git.md` integrieren (da Commit-Tags schon dort)
- Option B: Eigene Datei `.claude/context/tags.md` (saubere Trennung)

### 7. Neues Chatname-Format

```
MR-ByteZ #<ID>.<Nr> [Tag1][Tag2] - Beschreibung - keywords --- YYYY-MM-DD-HH-MM
```

**Beispiele:**
```
MR-ByteZ #F01.1 [Fish][Prompt] - Prompt System v2 Grundstruktur - keybindings abbr theme gruvbox --- 2026-02-07-14-30
MR-ByteZ #D01.2 [Docker][Traefik] - SSL und Authentik Integration - reverse-proxy certs --- 2026-02-05-16-00
MR-ByteZ #X01.1 [Docs][Diskussion] - Chat-Benennungssystem v2 Konzept - ketten-id tags registry --- 2026-02-10-21-55
```

**Regeln (unverändert):**
- Minimum: 100 Zeichen, Maximum: 250 Zeichen
- Sprechend und bei Suche findbar
- IMMER Erstellungsdatum + Uhrzeit

---

## 🔍 Analyse der bisherigen Git-Commits

Die bestehende Commit-History wurde analysiert. Erkenntnisse:

**Inkonsistenzen gefunden:**
- Anfangs lowercase ohne Tags: `security: remove secrets...`, `chore: bump...`
- Dann gemischt: `[secrets] [github] [api]` (lowercase)
- Später sauber: `[Fish][Config]`, `[Scripts][Hardware]`
- Tag-Reihenfolge uneinheitlich

**Was gut funktioniert:**
- Multi-Tags wie `[Scripts][Hardware]`
- Versionsnummern im Commit
- Ausführliche Beschreibungen bei neueren Commits

**Offene Frage:** Tag-Hierarchie (WAS → WO → DETAIL) als feste Reihenfolge? Wurde diskutiert, aber nicht finalisiert.

---

## ❌ Offene Punkte / TODOs für Folge-Chat #X01.2

### Muss gemacht werden:
1. **Arbeitsanweisung v2 schreiben** — Konkrete Regeln für Claude (ersetzt aktuelle `ARBEITSANWEISUNG_CHAT_BENENNUNG.md` im Project Knowledge)
2. **TAG_REGISTRY.md initial befüllen** — Alle bestehenden Tags aus Commits + neue chat-spezifische Tags
3. **Ablageort entscheiden** — `context/git.md` erweitern oder eigene `context/tags.md`?
4. **Ketten-Prefix-Liste finalisieren** — Sind `#F`, `#D`, `#S`, `#H`, `#C`, `#X` ausreichend? Oder freiere Wahl?

### Sollte geklärt werden:
5. **Chat-spezifische Tags** — Brauchen wir `[Diskussion]`, `[Planung]`, `[Debug]` oder widerspricht das der "keine Phasen taggen" Entscheidung?
6. **Tag-Reihenfolge** — Feste Hierarchie (WAS → WO → DETAIL) oder flexibel?
7. **Alte Commits standardisieren?** — Rückwirkig die lowercase Commits fixen oder nur ab jetzt?

### Nice-to-have:
8. **Handoff-Dokument als Standard** — Soll jeder Chat am Ende ein Handoff bekommen? Oder nur bei unerledigten Themen?
9. **Integration mit ROADMAP.md** — Chat-Referenzen mit Ketten-IDs verknüpfen?

---

## 📁 Betroffene Dateien im Repo

| Datei | Aktion |
|-------|--------|
| `.claude/context/git.md` | Erweitern um Chat-Benennungsregeln ODER nur Tag-Referenz |
| `.claude/context/tags.md` | NEU erstellen (Tag-Registry) — falls eigene Datei |
| `.claude/context/documentation.md` | Chat-Benennung Abschnitt aktualisieren (neues Format) |
| `ARBEITSANWEISUNG_CHAT_BENENNUNG.md` (Project Knowledge) | Komplett überarbeiten mit neuem System |

---

## 🔗 Referenzen

- **Dieser Chat:** #X01.1
- **Bisheriger Chat-Namer Skill:** https://claude.ai/chat/54ddc814-8f3c-4efd-884f-23714d332ab1
- **ROADMAP Eintrag:** Chat-Namer Skill unter Priorität 3 (Enhancement)
- **Bestehende Regeln:** `.claude/context/git.md` (Commit-Format), `.claude/context/documentation.md` (Chat-Benennung)

---

## 💡 Kontext für Folge-Chat

Starte den Folge-Chat mit:

> "Wir arbeiten weiter an #X01 — Chat-Benennungssystem v2. Bitte lies das Handoff-Dokument und die offenen TODOs. Nächster Schritt: Arbeitsanweisung v2 formulieren."

Der Folge-Chat sollte heißen:
```
MR-ByteZ #X01.2 [Docs][Config] - Chat-Benennungssystem v2 Umsetzung - arbeitsanweisung tag-registry 5-3-3 --- YYYY-MM-DD-HH-MM
```
