# DEPLOYMENT.md

**Projekt:** mr-bytez
**Geltungsbereich:** Live-System-Deployment (z. B. n8-kiste, n8-vps, …)
**Prinzip:** kontrolliert, reproduzierbar, Fish-first, GitHub CLI
**Stand:** 2026-02-04

> **WICHTIG:** Alle Änderungen an diesem Repo IMMER auf n8-kiste machen!
> n8-vps ist read-only (nur pullen, nicht committen)!

---

## Ziel

Dieses Dokument beschreibt **wie** `mr-bytez` in ein System eingebunden wird – und **warum** genau so.

**Ziele:**

- reproduzierbares Setup (gleiches Ergebnis auf jedem Host)
- minimale System-Mutation (wenige, bewusst gesetzte Symlinks)
- einfache Rollbacks (atomarer Switch)
- Security-by-Design (keine Secrets im Klartext, OAuth statt SSH-Keys)
- GitHub CLI für Auth (kein SSH-Key auf Server nötig!)

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

## Prerequisites

**Benötigt:**
- Arch Linux (fresh install)
- User `mrohwer` (sudo-Berechtigung)
- Internet-Verbindung
- GitHub Account (mr-bytez)

**Repository-Struktur:**
- Main Repo: `mr-bytez/mr-bytez` (PUBLIC)
- Secrets Submodule: `mr-bytez/mr-bytez-secrets` (PRIVATE)

---

## Quickstart (Full Deployment)

### 1. GitHub CLI installieren & authentifizieren

```fish
# GitHub CLI installieren
sudo pacman -S github-cli

# Authentifizieren (Browser-Flow)
gh auth login
# → GitHub.com
# → HTTPS
# → Login with a web browser
# → Folge dem Link + One-time Code eingeben
```

**Warum GitHub CLI?**
- ✅ Kein SSH-Key auf Server nötig (OAuth Token)
- ✅ Einfache Browser-Auth
- ✅ Token kann revoked werden
- ✅ Funktioniert mit privaten Repos

### 2. Main Repo clonen (PUBLIC)

```fish
# Clone in temporäres Verzeichnis
gh repo clone mr-bytez/mr-bytez /tmp/mr-bytez-clone

# Nach /mr-bytez verschieben
sudo mv /tmp/mr-bytez-clone /mr-bytez

# Ownership setzen
sudo chown -R mrohwer:mrohwer /mr-bytez
```

### 3. Secrets Submodule clonen (PRIVATE)

> **WICHTIG:** `git submodule update` funktioniert NICHT ohne SSH-Key!
> Wir clonen das Submodule manuell mit `gh` (hat Auth!)

```fish
# Secrets-Repo separat clonen
gh repo clone mr-bytez/mr-bytez-secrets /tmp/secrets-clone

# Alten Submodule-Ordner entfernen (falls vorhanden)
rm -rf /mr-bytez/shared/home/mrohwer/.secrets

# Geclontes Repo an richtige Stelle verschieben
mv /tmp/secrets-clone /mr-bytez/shared/home/mrohwer/.secrets

# Submodule-Status updaten (optional)
cd /mr-bytez
git submodule update --init --recursive
```

### 4. Stabilen Anchor setzen

```fish
sudo mkdir -p /opt/mr-bytez
sudo ln -sfn /mr-bytez /opt/mr-bytez/current

# Prüfen
ls -la /opt/mr-bytez/
# → current -> /mr-bytez
```

### 5. Systemweite Konfigurationen einhängen

**Fish (systemweit nach /etc/fish):**

> **KRITISCH:** Fish lädt NUR aus `/etc/fish/`, NICHT aus `/usr/local/share/fish/`!

```fish
# Original /etc/fish sichern (falls vorhanden)
sudo mv /etc/fish /etc/fish.backup

# Symlink setzen (GANZES /etc/fish ersetzt!)
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish

# Prüfen
ls -la /etc/fish
# → /etc/fish -> /opt/mr-bytez/current/shared/etc/fish
```

**Micro (systemweit):**

```fish
sudo ln -sfn /opt/mr-bytez/current/shared/usr/local/share/micro /usr/local/share/micro

# Prüfen
ls -la /usr/local/share/micro
```

### 6. User Fish Config & Micro Settings deployen

**Fish User Config:**

```fish
# User-Config-Ordner erstellen
mkdir -p ~/.config/fish

# Symlink zu Repo-Config setzen
ln -sf /opt/mr-bytez/current/shared/home/mrohwer/.config/fish/config.fish ~/.config/fish/config.fish

# Prüfen
ls -la ~/.config/fish/config.fish
```

**Micro User Settings:**

```fish
# User-Config-Ordner erstellen
mkdir -p ~/.config/micro

# Symlinks zu System-Config setzen
ln -sf /usr/local/share/micro/settings.json ~/.config/micro/settings.json
ln -sf /usr/local/share/micro/bindings.json ~/.config/micro/bindings.json

# Prüfen
ls -la ~/.config/micro/
```

### 7. Default Shell zu Fish ändern

```fish
sudo chsh -s /usr/bin/fish mrohwer
```

### 8. Neu einloggen & testen

```fish
exit
# Neu einloggen via SSH
```

**Erwartetes Ergebnis:**
- ✅ Powerline Prompt (bunt, mit Pfeilen)
- ✅ Fastfetch mit mr-bytez ASCII Art
- ✅ Fish Config geladen (siehe Debug-Output)
- ✅ Alle Aliases funktionieren (`ll`, `gst`, `dps`)
- ✅ Micro mit Gruvbox-Theme & OSC52-Clipboard

---

## Symlink-Policy

### Erlaubt

- systemweite Pfade unter `/etc/*` (Fish)
- systemweite Pfade unter `/usr/local/share/*` (Micro)
- User-Config in `~/.config/*` (XDG-konform)
- klar dokumentierte Ziele
- Templates (z. B. `*.example`)

### Verboten (bewusst)

- `~/.ssh/config` (User-State, hochsensibel)
- echte Home-Dateien/State-Dateien (Browser-Profile, Session-State, etc.)
- alles, was Secrets indirekt exponieren könnte
- SSH Private Keys (niemals aus Repo deployen!)

**Merksatz:**

> Entwickler-State ≠ Repository-State

---

## SSH-Konfiguration: NUR Template

Es gibt **kein** Deployment von `~/.ssh/config` oder SSH-Keys aus dem Repo.

Stattdessen liegt im Repo eine **Vorlage**:

- `shared/home/mrohwer/.ssh/config.example`

Wenn du eine SSH-Konfig brauchst, kopierst du sie **lokal** nach `~/.ssh/config` und passt sie host-spezifisch an.

**Warum?**

- verhindert „kaputte" SSH-Configs, wenn `/mr-bytez` mal kurz weg ist
- verhindert Leaks durch versehentlich versionierte Hostdetails
- hält Auth/Keys strikt lokal
- **GitHub CLI verwendet OAuth (kein SSH-Key nötig!)**

---

## Secrets & Submodule

### Wo liegen Secrets?

- ausschließlich im **privaten** Submodule: `shared/home/mrohwer/.secrets`
- nur **verschlüsselt** (Age), plus Metadaten (`*.info`)

### Wichtige Regeln

- **keine Klartext-Secrets** in diesem Repo
- Secrets niemals symlinken
- Tokens/Keys nie mit `cat` lesen, wenn `cat` auf `bat` zeigt
  - nutze: `command cat` oder `/usr/bin/cat`
  - sanitize (Fish): `string replace -a    | string trim`

Details:

- `shared/home/mrohwer/.secrets/SECRETS.md`
- `PROJECT_NOTES.md`

---

## symlinks.db

`shared/deployment/symlinks.db` beschreibt **alle deployten Symlinks**.

**Wichtig:**

- Eintrag = was deployed werden kann/soll
- Templates sind dokumentiert
- Sensible Ziele (z. B. SSH-Config) sind **nur als Template** enthalten
- Bei Änderungen: `symlinks.db` manuell updaten

**Format:** JSON mit Comment, Target, Source, Type, Permissions, Owner

**Beispiel:**

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

**Wenn du neue Deployments einführst:**

- immer zuerst die Policy prüfen
- dann in `symlinks.db` dokumentieren
- dann hier in DEPLOYMENT.md dokumentieren

---

## Update-Workflow

### Repo aktualisieren

```fish
cd /mr-bytez

# Main Repo pullen
git pull --ff-only

# Secrets Submodule updaten (falls geändert)
cd shared/home/mrohwer/.secrets
git pull --ff-only
cd ../..
```

### System-Links bleiben stabil

Da `/etc/fish` und `/usr/local/share/micro` auf `/opt/mr-bytez/current/...` zeigen, brauchst du in der Regel **keine** weiteren Anpassungen – solange der Anker korrekt ist.

---

## Rollback / Switch

Rollback bedeutet: **Checkout wechseln** und den Anker neu setzen.

Beispiel (Prinzip):

- du hast einen alternativen Checkout (z. B. `/mr-bytez-v1_fish_micro_secrets`)
- du switchst den Anker:

```fish
sudo ln -sfn /mr-bytez-v1_fish_micro_secrets /opt/mr-bytez/current
```

Danach zeigen alle System-Symlinks automatisch auf die „neue" Version.

---

## Troubleshooting

### Fish Prompt lädt nicht / Keine Farben

**Symptom:** Normaler Bash-Prompt oder Fish ohne Powerline

**Ursache:** `/etc/fish` zeigt nicht auf Repo-Config

**Fix:**

```fish
# Prüfen
ls -la /etc/fish

# Falls NICHT Symlink:
sudo mv /etc/fish /etc/fish.backup
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish

# Neu einloggen
exit
```

### Submodule Probleme

**Symptom:** `shared/home/mrohwer/.secrets` leer oder Fehler bei `git submodule update`

**Fix:**

```fish
# Manuell clonen mit gh (hat Auth!)
gh repo clone mr-bytez/mr-bytez-secrets /tmp/secrets-clone
rm -rf /mr-bytez/shared/home/mrohwer/.secrets
mv /tmp/secrets-clone /mr-bytez/shared/home/mrohwer/.secrets
```

### GitHub CLI Auth verloren

**Symptom:** `gh` Befehle schlagen fehl mit "authentication required"

**Fix:**

```fish
# Re-authenticate
gh auth login
# → Browser-Flow wiederholen
```

---

## Dokumentationspflicht

Wenn du an einer der folgenden Stellen etwas änderst, muss es hier dokumentiert werden:

- Symlink-Strategie / Ankerpfad
- neue systemweite Links
- Änderungen an Secrets-Handling
- Ausnahmen (z. B. „Template-only" Regeln)
- GitHub CLI Workflow

---

## Deployment-Regel

**WICHTIG: Alle Commits IMMER auf n8-kiste machen!**

**Warum?**
- n8-kiste hat beide Git-Remotes (GitHub + Codeberg)
- n8-vps ist read-only (nur `git pull`, KEIN `git push`)
- Verhindert Sync-Probleme zwischen Remotes

**Workflow:**
```fish
# Auf n8-kiste
cd /mr-bytez
git add .
git commit -m "[Tags] Message"
git push origin main      # GitHub
git push codeberg main    # Codeberg

# Auf n8-vps
cd /mr-bytez
git pull origin main      # Nur pullen!
```

---

## Changelog

**2026-02-04:**
- Fish-Config von `/usr/local/share/fish/` nach `/etc/fish/` verschoben
- GitHub CLI Workflow statt SSH Clone hinzugefügt
- Secrets Submodule manuell clonen (mit `gh`)
- User Fish Config Deployment dokumentiert
- Micro User Settings Deployment hinzugefügt
- symlinks.db Sektion wieder hinzugefügt
- Deployment-Regel: Commits nur auf n8-kiste
- SSH-Key Deployment entfernt (nicht nötig mit gh)

**2026-02-03:**
- Initial Version

---

**Stand:** 2026-02-04
