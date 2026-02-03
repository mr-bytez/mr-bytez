# PROJECT_NOTES.md

**Projekt:** mr-bytez
**Scope:** Repo-Policy & Arbeitsweise
**Prinzip:** Fish-first, reproduzierbar, dokumentiert
**Aktualisiert:** 2026-02-04

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
- Datei-Generierung in Fish grundsätzlich mit `printf` + Redirect.

Beispiel (Pattern):

```fish
printf '%s\n' 'line1' 'line2' > file.txt
```

---

## 3) Tokens / Keys / `cat`-Alias (wichtig)

In diesem Projekt kann `cat` auf `bat` gemappt sein.

- **Nie Tokens/Keys mit dem `cat`-Alias lesen** (Formatierung/CRLF kann Secrets zerstören).
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

  - `/etc/fish -> /opt/mr-bytez/current/shared/etc/fish`
  - `/usr/local/share/micro -> /opt/mr-bytez/current/shared/usr/local/share/micro`

- **Verboten:** Deployment von `~/.ssh/config` (User-State). Stattdessen nur Template `config.example`.

Referenz: `DEPLOYMENT.md`

---

## 6) Doku-Workflow (verbindlich)

Wenn wir **Configs ändern**, **Deployment anpassen**, **Repos splitten/migrieren** oder **Security-Policies** verändern, dann gilt:

1. **Docs zuerst aktualisieren** (in derselben Arbeits-Session)
2. Danach erst Commit (nicht „Docs später")

Betroffene Dateien (typisch):

- `README.md` (Überblick + Status)
- `DEPLOYMENT.md` (Deployment-Guide + Policy)
- `PROJECT_NOTES.md` (Arbeitsweise/Regeln)
- `CHANGELOG.md` (was hat sich geändert)
- im Secrets-Repo: `SECRETS.md` (Token/Key-Hinweise, Recovery, Regeln)

### 6.1 Wichtige MD-Dateien: Update-Regel

Für zentrale Dateien wie `README.md`, `DEPLOYMENT.md`, `PROJECT_NOTES.md`, `CHANGELOG.md`, `ROADMAP.md` gilt:

- `README.md` ist **Überblick/Onboarding** (keine operativen Commands).
- Operative Commands/Schrittfolgen gehören nach `DEPLOYMENT.md`.
- **Basis ist immer die bestehende Datei.**
- Es werden **nur Ergänzungen** oder **kleine Korrekturen** gemacht.
- **Keine Kürzungen/Entfernungen** – außer du erlaubst es explizit.
- Vor Änderungen kurz erklären: **was** geändert wird, **wo** und **warum**.
- Wenn vorhanden: `Aktualisiert:`-Datum entsprechend pflegen.

Wichtig: **Keine Einzel-Commits für Kleinkram**, sondern sinnvolle Bündel.

---

## 7) Versioning & Changelog-Regeln

Wir nutzen SemVer (major.minor.patch) und Keep-a-Changelog als Struktur.

### Kein „Unreleased"

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

---

## 11) Fish Config Location (KRITISCH!)

Fish lädt Configs **NUR** aus `/etc/fish/`, **NICHT** aus `/usr/local/share/fish/`!

**Korrekt:**

- System-Config: `/etc/fish -> /opt/mr-bytez/current/shared/etc/fish`
- Repository: `shared/etc/fish/`

**Falsch (funktioniert NICHT):**

- ❌ `/usr/local/share/fish/` (wird von Fish IGNORIERT!)

**Warum wichtig:**

- Ohne korrekte Location lädt Fish die Config nicht
- Powerline Prompt fehlt
- Aliases/Functions fehlen
- Theme fehlt

**Deployment:**

```fish
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish
```

**Validierung:**

```fish
ls -la /etc/fish  # Sollte Symlink sein
fish --version    # Fish sollte Config laden
```

---

## 12) GitHub CLI statt SSH-Keys (Security)

**Prinzip:** OAuth-Token statt SSH-Keys auf Servern

**Warum:**

- ✅ Kein SSH Private Key auf Server nötig
- ✅ Token kann jederzeit revoked werden
- ✅ Browser-basierte Auth (einfacher)
- ✅ Funktioniert mit privaten Repos
- ✅ Kein SSH-Key-Management nötig

**Installation & Auth:**

```fish
# 1. GitHub CLI installieren
sudo pacman -S github-cli

# 2. Authentifizieren (Browser-Flow)
gh auth login
# → GitHub.com
# → HTTPS
# → Login with a web browser
# → Folge dem Link + One-time Code eingeben
```

**Clonen (Main Repo):**

```fish
gh repo clone mr-bytez/mr-bytez /tmp/mr-bytez-clone
```

**Clonen (Private Submodules):**

```fish
# Funktioniert NICHT mit `git submodule update` (braucht SSH-Key)
# Stattdessen manuell clonen mit gh:
gh repo clone mr-bytez/mr-bytez-secrets /tmp/secrets-clone
mv /tmp/secrets-clone /mr-bytez/shared/.secrets
```

**Deployment auf Servern:**

- **n8-vps:** Nur `gh` (kein SSH-Key!)
- **n8-kiste:** `gh` + SSH für Codeberg

**Token Management:**

```fish
# Status prüfen
gh auth status

# Token erneuern (bei Ablauf)
gh auth refresh

# Logout (Token revoken)
gh auth logout
```

---

## 13) Deployment-Workflow: n8-kiste = Master

**WICHTIG:** Alle Commits **IMMER** auf n8-kiste machen!

**Warum:**

- n8-kiste hat **BEIDE** Remotes (GitHub + Codeberg)
- n8-vps ist **read-only** (nur `git pull`, KEIN `git push`)
- Verhindert Sync-Probleme zwischen Remotes
- Klare Verantwortlichkeit (ein Master)

**Workflow (Development auf n8-kiste):**

```fish
cd /mr-bytez

# Änderungen machen
micro DEPLOYMENT.md

# Committen
git add .
git commit -m "[deployment][docs] DEPLOYMENT.md aktualisiert"

# Pushen zu BEIDEN Remotes
git push origin main      # GitHub
git push codeberg main    # Codeberg
```

**Workflow (Production auf n8-vps):**

```fish
cd /mr-bytez

# NUR pullen (NIEMALS pushen!)
git pull origin main

# Bei Submodule-Updates
cd shared/.secrets
git pull origin main
cd ../..
```

**Regel:** n8-vps = **NIEMALS** `git push`!

**Ausnahme:** Notfall-Hotfix direkt auf n8-vps

```fish
# Nur im Notfall (Server down, n8-kiste nicht erreichbar)
# Danach SOFORT auf n8-kiste synchronisieren!
ssh n8-kiste "cd /mr-bytez && git pull origin main"
```

---

## 14) symlinks.db Pflege

`shared/deployment/symlinks.db` muss bei **JEDEM** neuen Symlink aktualisiert werden!

**Format:** JSON mit Metadaten

**Wichtig:**

- Bei neuem Deployment: Eintrag in symlinks.db
- Bei Pfad-Änderung: symlinks.db updaten
- Vor Commit: symlinks.db validieren (JSON-Syntax)

**Struktur (Beispiel):**

```json
{
  "comment": "Fish Shell v2.0 - System-weite Config",
  "target": "/etc/fish",
  "source": "/mr-bytez/shared/etc/fish",
  "type": "directory",
  "permissions": "0755",
  "owner": "root:root",
  "requires_sudo": true
}
```

**Workflow bei neuem Symlink:**

```fish
# 1. Symlink deployen
sudo ln -sf /opt/mr-bytez/current/shared/etc/foo /etc/foo

# 2. symlinks.db updaten (manuell)
micro shared/deployment/symlinks.db
# → Eintrag hinzufügen (JSON-Format beachten!)

# 3. Validieren (optional)
python -m json.tool shared/deployment/symlinks.db > /dev/null
# → Kein Output = valides JSON

# 4. Commit mit BEIDEN Änderungen
git add shared/deployment/symlinks.db
git commit -m "[deployment] Neuer Symlink /etc/foo + symlinks.db update"
```

**Validierung vor Commit:**

```fish
# JSON-Syntax prüfen
python -m json.tool shared/deployment/symlinks.db

# Oder mit jq (falls installiert)
jq . shared/deployment/symlinks.db
```

**Wichtig:** symlinks.db ist die **Single Source of Truth** für Deployments!

---

**Letzte Aktualisierung:** 2026-02-04
