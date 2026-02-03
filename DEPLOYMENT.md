# DEPLOYMENT.md

**Projekt:** mr-bytez  \
**Geltungsbereich:** Live-System-Deployment (z. B. n8-kiste, n8-vps, …)  \
**Prinzip:** kontrolliert, reproduzierbar, Fish-first  \
**Stand:** 2026-02-03  \


---

## Ziel

Dieses Dokument beschreibt **wie** `mr-bytez` in ein System eingebunden wird – und **warum** genau so.

**Ziele:**

- reproduzierbares Setup (gleiches Ergebnis auf jedem Host)
- minimale System-Mutation (wenige, bewusst gesetzte Symlinks)
- einfache Rollbacks (atomarer Switch)
- Security-by-Design (keine Secrets im Klartext, keine Symlinks in sensible User-State-Dateien)

---

## Grundidee: stabiler Einstiegspunkt

Systemweit referenzieren wir **nicht direkt** `/mr-bytez`, sondern **immer**:

```text
/opt/mr-bytez/current  ->  /mr-bytez
```

Warum?

- `/mr-bytez` ist ein Git-Checkout (potenziell volatil)
- `/opt/mr-bytez/current` ist der **stabile Anker**, auf den alle System-Symlinks zeigen
- Versionswechsel/Wechsel des Checkouts: **ein Link**, kein Symlink-Wildwuchs

---

## Quickstart

### 1) Repo auschecken (inkl. Secrets-Submodule)

> Hinweis: Das Secrets-Repo ist ein privates Submodule (`shared/.secrets`).

```fish
git clone git@github.com:mr-bytez/mr-bytez.git /mr-bytez
cd /mr-bytez
git submodule update --init --recursive
```

### 2) Stabilen Pfad setzen

```fish
sudo mkdir -p /opt/mr-bytez
sudo ln -sfn /mr-bytez /opt/mr-bytez/current
```

### 3) Systemweite Konfigurationen einhängen

**Fish (systemweit):**

```fish
sudo ln -sfn /opt/mr-bytez/current/shared/usr/local/share/fish /usr/local/share/fish
```

**Micro (systemweit):**

```fish
sudo ln -sfn /opt/mr-bytez/current/shared/usr/local/share/micro /usr/local/share/micro
```

**Micro (User):**

```fish
mkdir -p ~/.config/micro
ln -sfn /usr/local/share/micro/settings.json ~/.config/micro/settings.json
ln -sfn /usr/local/share/micro/bindings.json ~/.config/micro/bindings.json
```

---

## Symlink-Policy

### Erlaubt

- systemweite Pfade unter `/usr/local/share/*`
- klar dokumentierte Ziele
- Templates (z. B. `*.example`)

### Verboten (bewusst)

- `~/.ssh/config` (User-State, hochsensibel)
- echte Home-Dateien/State-Dateien (Browser-Profile, Session-State, etc.)
- alles, was Secrets indirekt exponieren könnte

**Merksatz:**

> Entwickler-State ≠ Repository-State

---

## SSH-Konfiguration: nur Template

Es gibt **kein** Deployment von `~/.ssh/config` aus dem Repo.

Stattdessen liegt im Repo eine **Vorlage**:

- `shared/home/mrohwer/.ssh/config.example`

Wenn du eine SSH-Konfig brauchst, kopierst du sie **lokal** nach `~/.ssh/config` und passt sie host-spezifisch an.

Warum?

- verhindert „kaputte“ SSH-Configs, wenn `/mr-bytez` mal kurz weg ist
- verhindert Leaks durch versehentlich versionierte Hostdetails
- hält Auth/Keys strikt lokal

---

## Secrets & Submodule

### Wo liegen Secrets?

- ausschließlich im **privaten** Submodule: `shared/.secrets`
- nur **verschlüsselt** (Age), plus Metadaten (`*.info`)

### Wichtige Regeln

- **keine Klartext-Secrets** in diesem Repo
- Secrets niemals symlinken
- Tokens/Keys nie mit `cat` lesen, wenn `cat` auf `bat` zeigt
  - nutze: `command cat` oder `/usr/bin/cat`
  - sanitize (Fish): `string replace -a   '' | string trim`

Details:

- `shared/.secrets/SECRETS.md`
- `PROJECT_NOTES.md`

---

## symlinks.db

`shared/deployment/symlinks.db` beschreibt **was grundsätzlich deploybar wäre**.

Wichtig:

- Eintrag ≠ automatische Aktivierung
- Templates sind ok
- sensible Ziele (z. B. SSH-Config) sind **nur als Template** enthalten

Wenn du neue Deployments einführst:

- immer zuerst die Policy prüfen
- dann dokumentieren (hier in DEPLOYMENT.md)

---

## Update-Workflow

### Repo aktualisieren

```fish
cd /mr-bytez
git pull --ff-only
git submodule update --init --recursive
```

### System-Links bleiben stabil

Da `/usr/local/share/*` auf `/opt/mr-bytez/current/...` zeigt, brauchst du in der Regel **keine** weiteren Anpassungen – solange der Anker korrekt ist.

---

## Rollback / Switch

Rollback bedeutet: **Checkout wechseln** und den Anker neu setzen.

Beispiel (Prinzip):

- du hast einen alternativen Checkout (z. B. `/mr-bytez-v1_fish_micro_secrets`)
- du switchst den Anker:

```fish
sudo ln -sfn /mr-bytez-v1_fish_micro_secrets /opt/mr-bytez/current
```

Danach zeigen alle System-Symlinks automatisch auf die „neue“ Version.

---

## Troubleshooting

### „Terminal schließt sich nach Enter“

Das passiert typischerweise, wenn ein Terminal-Profil „Command ausführen und schließen“ nutzt oder ein Shell-Exec am Ende steht.

Empfehlung:

- Terminal-Profil prüfen: **nicht automatisch schließen**
- keine `exec bash`/`exec fish` in Einmal-Kommandos verwenden

### Submodule Probleme

- `git submodule sync --recursive`
- `git submodule update --init --recursive`

Wenn SSH nicht geht: zuerst `ssh -T git@github.com` testen.

---

## Dokumentationspflicht

Wenn du an einer der folgenden Stellen etwas änderst, muss es hier dokumentiert werden:

- Symlink-Strategie / Ankerpfad
- neue systemweite Links
- Änderungen an Secrets-Handling
- Ausnahmen (z. B. „Template-only“ Regeln)

---

**Stand:** 2026-02-03

