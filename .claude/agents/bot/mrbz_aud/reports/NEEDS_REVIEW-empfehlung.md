# NEEDS_REVIEW — 6 offene Entscheidungen (mit Empfehlung)

**Quelle:** mrbz_aud Gesamt-Report vom 2026-03-06
**Zweck:** Empfehlungen von Claude Code basierend auf Repo-Kontext

---

## NR-1: Docs-Stufe fuer n8-kiste und n8-station

**Empfehlung: B) Auf Minimal herabstufen**

n8-kiste und n8-station haben aktuell je nur HARDWARE.md + 2 Fish-Dateien. Das ist weit entfernt von 5 Docs. Der Scope beider Hosts rechtfertigt keinen Voll-5-5-3 Aufwand:
- n8-kiste ist der physische Haupt-Host, hat aber kaum projektspezifische Konfiguration im Repo (Fish-Aliases + Test-Function)
- n8-station ist aehnlich duenn
- n8-vps dagegen hat Stacks, Docker-Configs, Security-Setup — dort macht Voll-5-5-3 Sinn

Minimal (README + CHANGELOG) wuerde den tatsaechlichen Scope abbilden. Falls n8-kiste spaeter mehr Konfiguration bekommt (z.B. eigene Stacks), kann die Stufe wieder hochgesetzt werden.

---

## NR-2: Fish-Header Box-Stil standardisieren

**Empfehlung: B) 9-box fuer Configs, kein Header fuer kleine Functions**

Der 9-box-Stil (╔══╗) ist bereits der de-facto-Standard fuer alle neuen Dateien. Die Test-Functions (`n8-kiste-test.fish` etc.) sind kleine Einzweck-Dateien mit 5-15 Zeilen — ein 10-zeiliger Header waere laenger als der eigentliche Code.

Pragmatische Regel:
- **Config-Dateien** (conf.d/, aliases/, completions/): 9-box Header Pflicht
- **Functions < 20 Zeilen:** Header optional
- **Shell-Hooks (.sh):** Eigenes Format behalten (sind Bash, nicht Fish)
- Aeltere Dateien bei naechster inhaltlicher Aenderung migrieren, kein Bulk-Update

---

## NR-3: Relative vs. absolute Pfade in Fish-Headern

**Empfehlung: B) docs-agent.md anpassen — relative Pfade als Standard**

40/40 Dateien nutzen relative Pfade. Das ist kein Zufall, sondern sinnvoll:
- Das Repo liegt unter `/mr-bytez`, aber der Anker ist `/opt/mr-bytez/current` — welchen absoluten Pfad waehlt man?
- Relative Pfade sind portabel und eindeutig innerhalb des Repos
- Eine Migration von 40 Dateien fuer einen fragwuerdigen Gewinn ist Aufwand ohne Nutzen

Die docs-agent.md Richtlinie sollte auf relative Pfade (vom Repo-Root) geaendert werden, da die Realitaet laengst so aussieht.

---

## NR-4: CHANGELOG [Unreleased] — Release schneiden oder weiter sammeln?

**Empfehlung: A) Jetzt Release schneiden — 0.16.0**

230 Zeilen Unreleased nach 5 Tagen ist viel. Die Aenderungen umfassen mehrere grosse Themen:
- VPS Security (Forward-Auth, Stack-Haertung)
- mrbz_aud Bot komplett gebaut
- Claude Code Config-Konsolidierung

Das sind substanzielle Aenderungen die einen Minor-Bump (0.16.0) rechtfertigen. Ein Release jetzt macht den CHANGELOG uebersichtlicher und gibt einen klaren Schnitt vor Phase 3 des Audit-Bots.

Timing: Erst Phase 3 abschliessen, dann Release schneiden — so landen die Audit-Fixes noch im selben Release.

---

## NR-5: ROADMAP A7 ETA — Q1 2026 realistisch?

**Empfehlung: A) Q1 2026 beibehalten**

Phase 2 ist gerade durchgelaufen, Phase 3 ist der naechste Schritt, Cron ist eine Zeile. Bei 25 verbleibenden Tagen in Q1 ist das machbar — sogar komfortabel. Eine ETA-Aenderung waere uebervorsichtig.

Falls Phase 3 unerwartete Probleme aufwirft, kann die ETA immer noch angepasst werden. Aber zum jetzigen Stand gibt es keinen Grund zur Annahme, dass Q1 nicht reicht.

---

## NR-6: Secrets Backup-Verzeichnisstruktur n8-vps

**Empfehlung: B) Trennung beibehalten**

Die Trennung hat eine inhaltliche Logik:
- `backup/auth/authentik/` = **OAuth/OIDC-Tokens** die andere Services nutzen (Jellyfin, Proxy Outpost) — Service-uebergreifend
- `backup/authentik/` = **Authentik-interne Secrets** (DB-Passwort, Secret Key) — nur Authentik selbst braucht diese
- `backup/auth/forgejo/` = **Forgejo OAuth-Credentials** — gleiche Kategorie wie die Auth-Tokens

Das ist keine Inkonsistenz, sondern eine bewusste Kategorisierung: `auth/` = Credentials die zwischen Services geteilt werden, direkt unter `backup/` = Service-eigene Secrets.

Einzige Verbesserung: Ein kurzes `backup/README.md` das die Struktur-Logik dokumentiert, damit die Entscheidung nicht verloren geht.
