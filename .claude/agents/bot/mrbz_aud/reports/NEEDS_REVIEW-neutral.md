# NEEDS_REVIEW — 6 offene Entscheidungen (neutral, ohne Empfehlung)

**Quelle:** mrbz_aud Gesamt-Report vom 2026-03-06
**Zweck:** Reine Faktengrundlage fuer menschliche Entscheidung

---

## NR-1: Docs-Stufe fuer n8-kiste und n8-station

**Frage:** Sollen n8-kiste und n8-station bei Voll-5-5-3 bleiben oder auf Minimal (2 Docs) herabgestuft werden?

**Fakten:**
- `structure.md` definiert beide als **Voll-5-5-3** (5 Docs: README, CLAUDE, CHANGELOG, ROADMAP, DEPLOYMENT)
- Tatsaechlicher Inhalt beider Hosts: je **3 Dateien + 1 Verzeichnis**
  - `HARDWARE.md` (automatisch generiert von hwi)
  - `root/` mit 2 Fish-Dateien (Aliases + Test-Function)
- Keiner der 5 erwarteten Docs existiert (0/5)
- Zum Vergleich: n8-vps hat alle 5 Docs + Stacks + eigenes .claude/
- Minimal-Stufe (2 Docs: README + CHANGELOG) gilt fuer: n8-book, n8-bookchen, n8-broker, n8-maxx, n8-archstick

**Optionen:**
- A) Voll-5-5-3 beibehalten → 5 Docs pro Host erstellen
- B) Auf Minimal herabstufen → 2 Docs pro Host erstellen
- C) Eigene Stufe definieren (z.B. "Mittel" mit 3 Docs)

---

## NR-2: Fish-Header Box-Stil standardisieren

**Frage:** Soll ein einheitlicher Box-Stil fuer alle Fish-Dateien gelten?

**Fakten:**
- **9-box (╔══╗):** Aktueller Standard, genutzt in allen neueren Configs (18 Dateien)
  ```
  # ╔══════════════════════════════════════════════╗
  # ║  MR-ByteZ Fish Configuration Loader          ║
  # ╠══════════════════════════════════════════════╣
  # ║  Pfad:     shared/etc/fish/conf.d/000-...    ║
  # ║  Autor:    MR-ByteZ                          ║
  # ║  Version:  0.5.0                             ║
  # ╚══════════════════════════════════════════════╝
  ```
- **Aelterer Stil:** Existiert in einigen Dateien (genaue Anzahl: 21 laut Audit)
- **Kein Header:** 9 Dateien (hauptsaechlich Host-Test-Functions)
  ```
  function n8kiste-test --description "Test n8-kiste Host-Config"
      set -l G (set_color green)
      ...
  ```
- Shell-Hook-Dateien (.sh) nutzen eigenes Box-Format (0/9 nutzen den Fish-Standard)
- docs-agent.md definiert den 9-box-Stil als Referenz

**Optionen:**
- A) Alles auf 9-box migrieren (inkl. Test-Functions und .sh-Dateien)
- B) 9-box fuer Configs, kein Header fuer kleine Functions — beides akzeptabel
- C) Status quo beibehalten, mehrere Stile tolerieren

---

## NR-3: Relative vs. absolute Pfade in Fish-Headern

**Frage:** Sollen Fish-Header relative oder absolute Pfade verwenden?

**Fakten:**
- **docs-agent.md** definiert: Absolute Pfade (`/pfad/zur/datei`)
- **Realitaet:** 0/40 Fish-Dateien nutzen absolute Pfade
- Alle nutzen relative Pfade, z.B.:
  ```
  # ║  Pfad:  shared/etc/fish/conf.d/000-loader.fish  ║
  ```
  statt:
  ```
  # ║  Pfad:  /mr-bytez/shared/etc/fish/conf.d/000-loader.fish  ║
  ```
- Das Repo liegt unter `/mr-bytez` (Live-Checkout), Anker unter `/opt/mr-bytez/current`
- Relative Pfade sind unabhaengig vom Mount-Punkt
- Absolute Pfade waeren eindeutig aber an den Installationspfad gebunden

**Optionen:**
- A) Auf absolute Pfade migrieren (40 Dateien aendern, docs-agent folgen)
- B) docs-agent.md anpassen: Relative Pfade als Standard definieren
- C) Beides erlauben mit Praeferenz dokumentieren

---

## NR-4: CHANGELOG [Unreleased] — Release schneiden oder weiter sammeln?

**Frage:** Soll aus dem grossen [Unreleased]-Block ein Release geschnitten werden?

**Fakten:**
- **[Unreleased] Groesse:** ~230 Zeilen (24% der gesamten CHANGELOG.md mit 975 Zeilen)
- **Letzter Release:** 0.15.2 vom 2026-03-01 (5 Tage her)
- **Inhalt:** 8-10 thematische Bloecke seit 0.15.2
- **Themen im Unreleased:**
  - VPS Security (Forward-Auth, Stack-Haertung)
  - Claude Code Config (WebFetch, Settings)
  - mrbz_aud Bot (komplett gebaut + Phase 1 getestet)
  - Orchestrator-Fixes
  - Docs-Stufen Policy
- CHANGELOG folgt Additive-Only Policy (nur ergaenzen, nicht kuerzen)

**Optionen:**
- A) Jetzt Release schneiden (z.B. 0.16.0)
- B) Weiter sammeln bis ein natuerlicher Meilenstein erreicht ist
- C) Thematisch aufteilen (mehrere Releases nachtraeglich)

---

## NR-5: ROADMAP A7 ETA — Q1 2026 realistisch?

**Frage:** Soll die ETA fuer A7 (mrbz_aud) angepasst werden?

**Fakten:**
- **Aktueller Stand A7:**
  - Erledigt: Ordnerstruktur, 3 Agent-Prompts, 8 Module, Orchestrator, README, Phase 1 Test
  - Offen: Phase 2 Verify, Phase 3 Fix, Orchestrator E2E Test, Cron-Eintrag
- **ETA im ROADMAP:** Q1 2026
- **Heute:** 2026-03-06 — Q1 endet am 2026-03-31 (25 Tage)
- **Phase 2** ist gerade durchgelaufen (Gesamt-Report liegt vor)
- **Phase 3** steht als naechstes an (Fix-Agent testen)
- **Cron** ist der letzte Schritt (eine Zeile)

**Optionen:**
- A) Q1 2026 beibehalten (25 Tage sollten reichen)
- B) Auf "Q1-Q2 2026" aendern (Puffer einbauen)
- C) Auf "Maerz 2026" praezisieren

---

## NR-6: Secrets Backup-Verzeichnisstruktur n8-vps

**Frage:** Soll die Backup-Struktur konsolidiert werden?

**Fakten:**
- **Zwei aehnlich benannte Verzeichnisse:**
  ```
  backup/auth/authentik/     ← API-Tokens + OIDC-Credentials
    ├── api_token
    ├── jellyfin_oidc_credentials.txt
    └── proxy_outpost_token.txt

  backup/authentik/          ← DB-Secrets
    ├── db.secret
    └── secret_key.secret

  backup/auth/forgejo/       ← Forgejo OAuth-Credentials
    ├── client_id
    └── client_secret
  ```
- **Logik der Trennung:** `backup/auth/` = Service-uebergreifende Auth-Tokens, `backup/authentik/` = Authentik-interne Secrets (DB, Secret Key)
- **Inkonsistenz:** Authentik-bezogene Dateien an zwei verschiedenen Orten
- Alle Dateien sind Age-verschluesselt im Secrets-Repo

**Optionen:**
- A) Alles unter `backup/auth/authentik/` zusammenfuehren
- B) Trennung beibehalten (Auth-Tokens vs. DB-Secrets = unterschiedliche Kategorien)
- C) Umbenennen: `backup/authentik/` → `backup/authentik-internal/` (Zweck klarer)

---

## Entscheidung (2026-03-06)

**NR-6 wird separat umgesetzt.** Die Secrets aus `backup/` gehoeren in den regulaeren
`authentik/`-Ordner im Secrets-Repo. Die aktuelle Struktur muss erst verifiziert werden
bevor Dateien verschoben werden. Eigener Task, Secrets-Repo betroffen — nicht in diesem Commit.
