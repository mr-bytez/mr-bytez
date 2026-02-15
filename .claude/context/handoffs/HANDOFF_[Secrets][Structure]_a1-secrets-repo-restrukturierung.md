# HANDOFF: A1 Secrets-Repo Restrukturierung — Phase 1

**Chat-Referenz:** #DOC01.3 (Pre-A1 Feinschliff)
**Chat-Link:** https://claude.ai/chat/91ec0fd5-6128-481d-a785-1568408de844
**Datum:** 2026-02-11
**Status:** Offen — Naechster Schritt in der Roadmap
**Delegation:** Strategisch in Claude.ai, Mechanisch an Claude Code

---

## Kontext

A1 ist das naechste Projekt nach Abschluss von C1+C2 (Policies).
Das Secrets-Repo `mr-bytez-secrets` wird auf das 5-3-3 Pattern migriert.

**Dieser Handoff deckt NUR Phase 1 ab:** Bestehende Repo-Inhalte sauber aufstellen.
Phase 2 (Migration der ~70 lokalen Secrets aus ~/.secrets/) folgt in einem separaten Chat.

---

## Aktueller Stand Secrets-Repo

**Repo:** mr-bytez-secrets (privat)
**Einbindung:** Submodule unter `shared/home/mrohwer/.secrets/`
**Branch:** main
**Letzter Commit:** `6891373` — 4 Commits insgesamt
**Remotes:** origin (Codeberg? GitHub?) — im ersten Chat pruefen!

### Aktuell versioniert (im Repo):

```
.secrets/
├── api/
│   ├── codeberg.token.age       # Age-verschluesselt
│   ├── codeberg.token.info      # Metadaten
│   ├── github.token.age         # Age-verschluesselt
│   └── github.token.info        # Metadaten
├── ssh/
│   └── mrohwer/                 # Leer im Submodule
├── domains.csv                  # 98 Domains, 3 Spalten
└── SECRETS.md                   # Dokumentation (Autor noch "Michael Rohwer")
```

### Unversioniert (nur lokal auf n8-kiste):

```
smb-n8-kiste.creds               # SMB-Credentials, muss geklaert werden
```

### NICHT Teil von Phase 1 (kommt in Phase 2):

Auf n8-kiste unter `~/.secrets/` liegen ~70 weitere Dateien in Kategorien:
ai/, backup/, cloud/, databases/, licenses/, personal/, services/,
ssl/, tools/, vpn/ — diese werden ERST in Phase 2 migriert.

---

## Ziel Phase 1

Das Secrets-Repo bekommt eine saubere 5-3-3 Struktur als Fundament
fuer die spaetere Migration aller Secrets.

### Zielstruktur:

```
mr-bytez-secrets/
├── README.md                    # Ueberblick, Recovery-Anleitung
├── CLAUDE.md                    # KI-Steuerung, Verweise
├── CHANGELOG.md                 # Historie
├── ROADMAP.md                   # Planung (Phase 1 + Phase 2)
├── SECRETS.md                   # Secrets-Inventar (aktualisiert)
│
├── .claude/                     # Minimal, kein eigener context/ noetig
│   └── CLAUDE.md                # Verweis auf Root-Policies
│
├── api/                         # API-Tokens (bestehend)
│   ├── codeberg.token.age
│   ├── codeberg.token.info
│   ├── github.token.age
│   └── github.token.info
│
├── ssh/                         # SSH-Keys + Config (bestehend + B1)
│   └── mrohwer/
│       ├── config               # NEU: Gemeinsame SSH-Config (B1)
│       ├── id_ed25519_codeberg  # Bereits vorhanden (lokal)
│       ├── id_ed25519_codeberg.pub
│       ├── id_ed25519_github    # Bereits vorhanden (lokal)
│       └── id_ed25519_github.pub
│
├── domains.csv                  # Domain-Inventar (bestehend)
│
├── .gitignore                   # Klartext-Secrets ausschliessen
│
└── deployment/
    └── symlinks.db              # NEU: Verschoben aus shared/deployment/ (D9)
```

---

## Aufgaben

### Aufgabe 1: 5-3-3 Docs erstellen

Im Secrets-Repo folgende Dateien erstellen:

- **README.md** — Ueberblick, Repo-Zweck, Recovery-Kurzanleitung, Verweis auf derive_key.fish
- **CLAUDE.md** — Verweis auf Root `.claude/context/security.md` fuer Policies
- **CHANGELOG.md** — Bisherige 4 Commits als Historie, neuer Eintrag fuer Migration
- **ROADMAP.md** — Phase 1 (5-3-3 Setup) + Phase 2 (Secrets-Migration) als Ausblick

### Aufgabe 2: SECRETS.md aktualisieren

- Autor: "Michael Rohwer" → "MR-ByteZ"
- Aktualisierungsdatum auf heute
- Inventar-Tabelle pruefen und aktualisieren
- Abschnitt fuer Phase 2 vorbereiten (Platzhalter fuer kommende Kategorien)

### Aufgabe 3: smb-n8-kiste.creds klaeren

Entscheidung treffen:
- Option A: Age-verschluesseln und versionieren
- Option B: In .gitignore aufnehmen (bleibt nur lokal)
- Option C: In Phase 2 verschieben (erst spaeter einordnen)

### Aufgabe 4: SSH-Config Deployment (B1)

Aus bestehendem Handoff `HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md`:

1. `ssh/mrohwer/config` erstellen im Secrets-Repo
   - Gemeinsame SSH-Config fuer alle Hosts
   - Eintraege: n8-kiste, n8-vps, Codeberg, GitHub
   - Port 61020 (nicht 22!)
2. SSH-Keys aus ~/.ssh/ ins Repo uebernehmen (falls noch nicht versioniert)
3. Symlink-Deployment dokumentieren:
   `ln -sf /opt/mr-bytez/current/shared/home/mrohwer/.secrets/ssh/mrohwer/config ~/.ssh/config`
4. DEPLOYMENT.md im Hauptrepo aktualisieren (neuer Schritt)
5. symlinks.db aktualisieren

### Aufgabe 5: symlinks.db verschieben (D9)

1. `shared/deployment/symlinks.db` → `shared/home/mrohwer/.secrets/deployment/symlinks.db`
2. Alle Verweise aktualisieren:
   - DEPLOYMENT.md
   - .claude/context/deployment.md
   - .claude/context/structure.md
3. Symlink im Hauptrepo erstellen falls noetig fuer Rueckwaertskompatibilitaet

### Aufgabe 6: .gitignore erstellen

Im Secrets-Repo eine .gitignore die sicherstellt:
- Keine unverschluesselten Secrets versehentlich committet werden
- Klartext-Dateien die in Phase 2 kommen ausgeschlossen sind
- Muster: `*.secret` (Klartext) erlaubt, aber bewusst gesteuert

### Aufgabe 7: Validierung + Commit

1. Secrets-Repo: git status — nur erwartete Aenderungen?
2. Hauptrepo: Submodule-Referenz aktualisieren
3. Beide Repos committen + pushen
4. CHANGELOG.md in beiden Repos aktualisieren (VOR dem Commit!)
5. Bestehenden Handoff `HANDOFF_[Deploy][SSH]_ssh-config-hosts-gitconfig.md` loeschen
   (B1 ist dann erledigt, B2-B4 in separate Handoffs falls noch offen)

---

## Mitlaufende Tasks (Referenz)

| Task | Beschreibung | In Phase 1? |
|------|-------------|-------------|
| B1 | SSH-Config Secrets-Deployment | ✅ Aufgabe 4 |
| B9 | Submodule n8-vps einrichten | ❌ Phase 2 |
| B10 | Submodule n8-kiste einrichten | ❌ Phase 2 |
| D9 | symlinks.db verschieben | ✅ Aufgabe 5 |
| D13 | Credentials n8-archstick | ❌ Phase 2 |

---

## Offene Fragen (im A1-Chat klaeren)

1. **Secrets-Repo Remotes:** Wo liegt das Repo? Nur Codeberg? Auch GitHub?
   Pruefen mit: `cd shared/home/mrohwer/.secrets && git remote -v`
2. **SSH-Keys im Repo:** Die Keys liegen lokal unter `~/.secrets/ssh/` —
   sind die identisch mit `ssh/mrohwer/` im Submodule oder Kopien?
3. **smb-n8-kiste.creds:** Age-verschluesseln oder gitignoren?
4. **derive_key.fish Standort:** Bleibt in `shared/deployment/` oder
   wandert auch ins Secrets-Repo? (Achtung: ist im PUBLIC Repo — bewusst!)

---

## Projektanweisungen-Update

VOR dem A1-Start muss in `claude-ai-projektanweisungen.txt` aktualisiert werden:
- C1+C2: "erledigt" statt "aktuell"
- A1: als "aktuell" markieren

Dies kann als erster Schritt im A1-Chat via Claude Code erledigt werden.

---

## Betroffene Dateien (Hauptrepo)

- shared/deployment/symlinks.db (VERSCHIEBEN nach Secrets-Repo)
- DEPLOYMENT.md (SSH-Config Schritt + symlinks.db Pfad)
- .claude/context/deployment.md (symlinks.db Pfad)
- .claude/context/structure.md (symlinks.db Pfad)
- CHANGELOG.md (A1 dokumentieren)
- ROADMAP.md (A1 Status aktualisieren)
- .claude/context/claude-ai-projektanweisungen.txt (C1+C2 erledigt, A1 aktuell)

## Betroffene Dateien (Secrets-Repo)

- README.md (NEU)
- CLAUDE.md (NEU)
- CHANGELOG.md (NEU)
- ROADMAP.md (NEU)
- SECRETS.md (UPDATE)
- .gitignore (NEU)
- ssh/mrohwer/config (NEU, B1)
- deployment/symlinks.db (NEU, verschoben aus Hauptrepo)
