# PROJECT\_NOTES.md

**Projekt:** mr-bytez  \
**Scope:** Repo-Policy & Arbeitsweise  \
**Prinzip:** Fish-first, reproduzierbar, dokumentiert  \
**Aktualisiert:** 2026-02-03  \


---

## 1) Grundprinzipien (kurz)

- **Single Source of Truth:** Live-Checkout liegt unter `/mr-bytez`.
- **Stabiler System-Anker:** System-Symlinks zeigen auf `/opt/mr-bytez/current`.
- **Explizit statt Magie:** keine stillen Side-Effects.
- **Security by Design:** keine Klartext-Secrets, keine Symlinks in sensible User-State-Dateien.

---

## 2) Shell-Standard: Fish-first

- Fish ist die **Referenz-Shell** für Skripte & Beispiele.
- **Keine Heredocs/EOF** in Fish (kein `cat <<EOF`).
- Datei-Generierung in Fish grundsätzlich mit `` + Redirect.

Beispiel (Pattern):

```fish
printf '%s\n' 'line1' 'line2' > file.txt
```

---

## 3) Tokens / Keys / `cat`-Alias (wichtig)

In diesem Projekt kann `cat` auf `bat` gemappt sein.

- **Nie Tokens/Keys mit dem **``**-Alias lesen** (Formatierung/CRLF kann Secrets zerstören).
- Stattdessen immer:
  - `command cat` oder
  - `/usr/bin/cat`

Empfohlenes Sanitizing (Fish):

```fish
string replace -a \r '' | string trim
```

---

## 4) Secrets-Policy

- Secrets liegen ausschließlich im privaten Submodule: `shared/.secrets`.
- Im Hauptrepo: **keine** Klartext-Secrets.
- Im Secrets-Repo: nur **verschlüsselte** Dateien (z. B. `*.age`) + Metadaten (`*.info`) + Doku.
- Secrets **niemals** per Symlink ins System deployen.

Referenz: `shared/.secrets/SECRETS.md`

---

## 5) Deployment-Policy (Kurzfassung)

- Systemweite Symlinks zeigen **nur** auf:

```text
/opt/mr-bytez/current -> /mr-bytez
```

- Beispiele:

  - `/usr/local/share/fish -> /opt/mr-bytez/current/shared/usr/local/share/fish`
  - `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`

- **Verboten:** Deployment von `~/.ssh/config` (User-State). Stattdessen nur Template `config.example`.

Referenz: `DEPLOYMENT.md`

---

## 6) Doku-Workflow (verbindlich)

Wenn wir **Configs ändern**, **Deployment anpassen**, **Repos splitten/migrieren** oder **Security-Policies** verändern, dann gilt:

1. **Docs zuerst aktualisieren** (in derselben Arbeits-Session)
2. Danach erst Commit (nicht „Docs später“)

Betroffene Dateien (typisch):

- `README.md` (Überblick + Status)
- `DEPLOYMENT.md` (Deployment-Guide + Policy)
- `PROJECT_NOTES.md` (Arbeitsweise/Regeln)
- `CHANGELOG.md` (was hat sich geändert)
- im Secrets-Repo: `SECRETS.md` (Token/Key-Hinweise, Recovery, Regeln)

### 6.1 Wichtige MD-Dateien: Update-Regel

Für zentrale Dateien wie `README.md`, `DEPLOYMENT.md`, `PROJECT_NOTES.md`, `CHANGELOG.md`, `ROADMAP.md` gilt:

- `README.md` ist **Überblick/Onboarding** (keine operativen Commands).
- Operative Commands/Schrittfolgen gehören nach ``.
- **Basis ist immer die bestehende Datei.**
- Es werden **nur Ergänzungen** oder **kleine Korrekturen** gemacht.
- **Keine Kürzungen/Entfernungen** – außer du erlaubst es explizit.
- Vor Änderungen kurz erklären: **was** geändert wird, **wo** und **warum**.
- Wenn vorhanden: `Aktualisiert:`-Datum entsprechend pflegen.

Wichtig: **Keine Einzel-Commits für Kleinkram**, sondern sinnvolle Bündel.

---

## 7) Versioning & Changelog-Regeln

Wir nutzen SemVer (major.minor.patch) und Keep-a-Changelog als Struktur.

### Kein „Unreleased“

- Wir führen **keinen** dauerhaften `Unreleased`-Block.
- Stattdessen vergeben wir **direkt** die nächste Versionnummer, sobald klar ist, dass wir diese Änderung so committen.

Beispiel:

- Änderung geplant → erst lokal sammeln
- Änderung final → Docs + Version erhöhen → **ein** sauberer Commit

### Changelog-Tags (Kategorien)

Änderungen werden zusätzlich mit Tags versehen, z. B.:

- `[repo]` Struktur/Meta/Remotes
- `[deployment]` Anker/Symlink-Policy/Setup
- `[fish]` Shell/Loader/Aliases
- `[micro]` Editor-Config
- `[secrets]` Age/Keys/Tokens/Recovery
- `[security]` Policies/Hardening

Die Tags werden in `CHANGELOG.md` in den Bullet-Points genutzt.

---

## 8) Repo-Split / v1 parallel weiterführen

- Das alte v1-Repo bleibt lokal erhalten (z. B. `/mr-bytez-v1_fish_micro_secrets`).
- Aktivierung erfolgt über den Anker-Switch:

```fish
sudo ln -sfn /mr-bytez-v1_fish_micro_secrets /opt/mr-bytez/current
```

(Details: `DEPLOYMENT.md`)

---

## 9) Canvas-Regel (für diese Zusammenarbeit)

Wenn wir eine Datei überarbeiten:

- jede Datei als eigenes Canvas-Dokument
- Canvas-Name = Dateiname im Repo (z. B. `PROJECT_NOTES.md`)
- Inhalte so schreiben, dass du sie 1:1 ins Repo kopieren kannst

---

## 10) Micro-Standard (kurz)

- Micro-Defaults sind **systemweit** unter `shared/usr/local/share/micro` versioniert.
- User-Mapping erfolgt nach `~/.config/micro/` (Symlinks auf `settings.json` / `bindings.json`).
- Änderungen an Micro-Konfig werden **immer** in Docs + Changelog erfasst.

Referenz: `DEPLOYMENT.md`

