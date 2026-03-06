# DEPLOYMENT.md

**Projekt:** mr-bytez
**Geltungsbereich:** Live-System-Deployment (z. B. n8-kiste, n8-vps, …)
**Prinzip:** kontrolliert, reproduzierbar, Fish-first, GitHub CLI
**Stand:** 2026-03-06

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
rm -rf /mr-bytez/.secrets

# Geclontes Repo an richtige Stelle verschieben
mv /tmp/secrets-clone /mr-bytez/.secrets

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

### 5. Paket-Dependencies installieren

```fish
# Micro Editor: Clipboard-Support (PFLICHT!)
# X11:
sudo pacman -S xclip

# Wayland (alternativ):
# sudo pacman -S wl-clipboard
```

> **WICHTIG:** Ohne `xclip` (X11) oder `wl-clipboard` (Wayland) funktioniert
> Kopieren/Einfügen in micro NICHT! Die Clipboard-Methode `external` in
> `settings.json` setzt ein installiertes Clipboard-Tool voraus.

### 6. Systemweite Konfigurationen einhängen

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

**hwi — Hardware Info Script:**

```fish
sudo ln -sf /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh /usr/local/bin/hwi

# Prüfen
ls -la /usr/local/bin/hwi
# → /usr/local/bin/hwi -> /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh
```

> **Was ist hwi?** Hardware-Audit-Script das detaillierte Hardware-Infos eines Hosts erfasst
> und als `HARDWARE.md` ablegt. Details: `shared/usr/local/bin/hwi/`

### 7. User Fish Config & Micro Settings deployen

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

### 8. Default Shell zu Fish ändern

```fish
sudo chsh -s /usr/bin/fish mrohwer
```

### 9. Neu einloggen & testen

```fish
exit
# Neu einloggen via SSH
```

**Erwartetes Ergebnis:**
- ✅ Powerline Prompt (bunt, mit Pfeilen)
- ✅ Fastfetch mit mr-bytez ASCII Art
- ✅ Fish Config geladen (siehe Debug-Output)
- ✅ Alle Aliases funktionieren (`ll`, `gst`, `dps`)
- ✅ Micro mit Gruvbox-Theme & external Clipboard (xclip/wl-clipboard)

### 10. Hardware-Audit durchfuehren

Nach jedem Host-Deployment einmal ausfuehren, um die Hardware zu dokumentieren:

```fish
sudo hwi mrbz
# Erzeugt: /mr-bytez/projects/infrastructure/<hostname>/HARDWARE.md
```

> **WICHTIG:** `HARDWARE.md` enthaelt sensible Hardware-Details und wird
> **NICHT committet** (in `.gitignore`). Die Datei bleibt nur lokal auf dem Host
> und kann von Claude Code (lokal) gelesen werden — nicht von Claude.ai.
> Details zum Script: `shared/usr/local/bin/hwi/`

---

## Host-Level Tuning (manuelles Deployment)

Die folgenden Config-Dateien werden per **Copy** (nicht Symlink) deployed, da systemd
und Docker nicht ueber Symlinks lesen. Aktuell manuell — spaeter in deploy.fish integriert.

### 1. Configs kopieren

```fish
# sysctl (Kernel-Parameter)
sudo cp /opt/mr-bytez/current/shared/etc/sysctl.d/90-mr-bytez.conf /etc/sysctl.d/

# PAM Limits (File Descriptors)
sudo cp /opt/mr-bytez/current/shared/etc/security/limits.d/90-mr-bytez.conf /etc/security/limits.d/

# Docker Default-Ulimits
sudo mkdir -p /etc/docker
sudo cp /opt/mr-bytez/current/shared/etc/docker/daemon.json /etc/docker/

# systemd System-Limits
sudo mkdir -p /etc/systemd/system.conf.d
sudo cp /opt/mr-bytez/current/shared/etc/systemd/system.conf.d/90-mr-bytez.conf /etc/systemd/system.conf.d/

# systemd User-Limits
sudo mkdir -p /etc/systemd/user.conf.d
sudo cp /opt/mr-bytez/current/shared/etc/systemd/user.conf.d/90-mr-bytez.conf /etc/systemd/user.conf.d/
```

### 2. Aktivieren

```fish
# sysctl sofort anwenden
sudo sysctl --system

# systemd neu laden
sudo systemctl daemon-reexec

# Docker neu starten (ACHTUNG: stoppt alle Container!)
sudo systemctl restart docker

# Danach Docker-Stacks neu starten
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose up -d
# ... weitere Stacks
```

### 3. Fish ulimit-Workaround

Die Datei `shared/etc/fish/conf.d/010-ulimits.fish` wird automatisch ueber den Fish-Loader
geladen. Sie setzt `ulimit -Sn 65536` bei jedem Login, weil auf Arch Linux das Soft-Limit
trotz PAM limits.d und systemd DefaultLimitNOFILE bei SSH-Login auf 1024 bleibt.

### 4. Verifizieren

```fish
# sysctl pruefen
sysctl vm.swappiness net.core.netdev_max_backlog

# ulimit pruefen (nach Re-Login!)
ulimit -Sn  # Soft: 65536
ulimit -Hn  # Hard: 65536

# Docker pruefen
docker run --rm alpine sh -c 'ulimit -n'  # 65536
```

---

## CrowdSec (natives Deployment)

CrowdSec laeuft als nativer systemd-Service (nicht Docker). Config-Dateien im Repo
unter `shared/etc/crowdsec/`, Deployment per Copy wie Host-Level Tuning.

### 1. Pakete installieren (AUR)

```fish
# CrowdSec Security Engine + Firewall Bouncer
yay -S crowdsec cs-firewall-bouncer
```

> **Hinweis:** Die Installation generiert automatisch:
> - `acquis.d/setup.sshd.yaml`, `setup.linux.yaml`, `setup.auditd.yaml` (Log-Quellen)
> - Einen Firewall-Bouncer API-Key in der Bouncer-Config
> - CrowdSec wird als systemd-Service registriert

### 2. Collections installieren

Nach der Paket-Installation sind keine Collections aktiv. Alle 8 manuell installieren:

```fish
sudo cscli collections install \
  crowdsecurity/linux \
  crowdsecurity/sshd \
  crowdsecurity/base-http-scenarios \
  crowdsecurity/http-cve \
  crowdsecurity/http-dos \
  crowdsecurity/traefik \
  crowdsecurity/whitelist-good-actors \
  crowdsecurity/auditd
```

Optional fuer Firewall Bouncer (iptables-Szenarien):

```fish
sudo cscli collections install crowdsecurity/iptables
```

### 3. Config-Dateien deployen

```fish
# Haupt-Acquisition (Traefik Access-Log)
sudo cp /opt/mr-bytez/current/shared/etc/crowdsec/acquis.yaml /etc/crowdsec/

# Lokale Config-Overrides (LAPI-Bind, WAL-Mode, Log-Level)
sudo cp /opt/mr-bytez/current/shared/etc/crowdsec/config.yaml.local /etc/crowdsec/

# Firewall Bouncer Config (Template — Key muss angepasst werden!)
sudo cp /opt/mr-bytez/current/shared/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml \
  /etc/crowdsec/bouncers/
```

### 4. Bouncer API-Keys einrichten

**Firewall Bouncer:**

```fish
# Key wurde bei Installation auto-generiert — pruefen:
sudo grep api_key /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
# Falls "CHANGE_ME_AFTER_INSTALL" → neuen Key generieren:
sudo cscli bouncers add firewall-bouncer
# → Key in /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml eintragen
```

**Traefik Bouncer (Plugin):**

```fish
# Neuen Bouncer-Key fuer Traefik generieren
sudo cscli bouncers add traefik-bouncer
# → Key in Traefik .env eintragen: CROWDSEC_BOUNCER_API_KEY=<key>
# Pfad: projects/infrastructure/n8-vps/stacks/traefik/.env
```

### 5. UFW-Regel fuer Docker-LAPI-Zugriff

Traefik (Docker) muss die LAPI auf dem Host erreichen (172.17.0.1:8080):

```fish
sudo ufw allow in on br+ to any port 8080 proto tcp comment "CrowdSec LAPI fuer Docker"
```

> **Warum `br+`?** Docker-Bridge-Interfaces heissen `br-*`. Die Wildcard `br+`
> matcht alle aktuellen und zukuenftigen Docker-Bridges.

### 6. Services starten und aktivieren

```fish
# CrowdSec Engine
sudo systemctl enable --now crowdsec

# Firewall Bouncer
sudo systemctl enable --now cs-firewall-bouncer
```

### 7. CrowdSec Console Enrollment

```fish
# Enroll-Key von https://app.crowdsec.net holen, dann:
sudo cscli console enroll --name n8-vps --tags production --tags n8-vps --tags traefik --tags nativ <ENROLL_KEY>
# Enrollment in Console bestätigen (Browser: Accept enroll)

# Console Management aktivieren (noetig fuer Blocklisten-Empfang!)
sudo cscli console enable console_management
sudo systemctl reload crowdsec
```

### 8. Community-Blocklisten abonnieren (Console)

Im Community-Plan sind **3 kostenlose Blocklisten** enthalten.
Abonnierung ueber https://app.crowdsec.net → Blocklists → Subscribe.

**Aktive Blocklisten (Stand 2026-03-06):**

| Blockliste | Kategorie | IPs | Zweck |
|------------|-----------|-----|-------|
| Firehol greensnow.co | General | ~4.600 | Brute-Force + Angriffs-IPs |
| Firehol cruzit.com | Behaviors | ~13.200 | Kompromittierte Hosts, breiter Schutz |
| CVE-2025-55182 React2Shell | CrowdSec | ~12.600 | Aktive CVE-Ausnutzer |

**Nicht gewaehlt (mit Begruendung):**

| Blockliste | IPs | Grund |
|------------|-----|-------|
| Firehol BotScout | 2.886 | Spam-Bots, wenig relevant ohne Forum |
| Free proxies list | 6.999 | Blockt auch legitime Proxy-Nutzer |
| CVE-2024-4577 PHP-CGI | 2.470 | Kein PHP auf n8-vps |
| Firehol voipbl.org | 51.941 | Kein VoIP auf n8-vps |
| TOR Blocklist | 2.237 | Blockt legitime Tor-Nutzer |
| OTX Web Scanners | 2.590 | 3 Monate veraltet |
| OTX Georgs Honeypot | 0 | Liste leer |
| Firehol SSL proxies | 558 | Zu klein, wenig Impact |
| Firehol xroxy.com | 43 | Vernachlaessigbar |
| Firehol dyndns.org | 34 | Vernachlaessigbar |
| Firehol cybercrime tracker | 215 | C&C-Server, wenig relevant eingehend |

> **Hinweis:** Blocklisten-Decisions kommen ueber CAPI (Pull alle 2h).
> Remediation-Typ: **Ban** (fuer alle drei Listen).

### 9. Verifizieren

```fish
# Services pruefen
sudo systemctl status crowdsec cs-firewall-bouncer

# Collections pruefen
sudo cscli collections list

# Bouncer pruefen
sudo cscli bouncers list

# Firewall-Chains pruefen (CROWDSEC_CHAIN in INPUT/FORWARD/DOCKER-USER)
sudo iptables -L INPUT -n | grep CROWDSEC
sudo iptables -L FORWARD -n | grep CROWDSEC
sudo iptables -L DOCKER-USER -n | grep CROWDSEC

# LAPI-Zugriff von Docker pruefen
docker run --rm alpine wget -qO- http://172.17.0.1:8080/v1/decisions 2>&1 | head -1

# Log-Quellen pruefen (keine Duplikate!)
sudo cscli machines list
sudo cscli metrics
```

---

## Symlink-Policy

### Erlaubt

- systemweite Pfade unter `/etc/*` (Fish)
- systemweite Pfade unter `/usr/local/share/*` (Micro)
- User-Config in `~/.config/*` (XDG-konform)
- klar dokumentierte Ziele
- Templates (z. B. `*.example`)

### Verboten (bewusst)

- echte Home-Dateien/State-Dateien (Browser-Profile, Session-State, etc.)
- alles, was Secrets indirekt exponieren koennte
- SSH Private Keys aus dem PUBLIC Repo deployen

**Merksatz:**

> Entwickler-State ≠ Repository-State

---

## SSH-Konfiguration

SSH-Config und SSH-Keys werden ueber das **private Secrets-Repo** deployt.

- Gemeinsame SSH-Config: `.secrets/mrohwer/shared/home/mrohwer/.ssh/config`
- Deployment via Anker: `/opt/mr-bytez/current/.secrets/mrohwer/shared/home/mrohwer/.ssh/config`
- Sanitized Template bleibt im Public Repo: `shared/home/mrohwer/.ssh/config.example`
- **GitHub CLI verwendet OAuth (kein SSH-Key noetig!)**

---

## Secrets & Submodule

### Wo liegen Secrets?

- ausschliesslich im **privaten** Submodule: `.secrets/` (Repo-Root)
- nur **verschlüsselt** (Age), plus Metadaten (`*.info`)

### Wichtige Regeln

- **keine Klartext-Secrets** in diesem Repo
- Secrets niemals symlinken
- Tokens/Keys nie mit `cat` lesen, wenn `cat` auf `bat` zeigt
  - nutze: `command cat` oder `/usr/bin/cat`
  - sanitize (Fish): `string replace -a    | string trim`

Details:

- `.secrets/SECRETS.md`
- `.claude/context/security.md`

---

## symlinks.db

`.secrets/deployment/symlinks.db` beschreibt **alle deployten Symlinks** (im privaten Submodule).

**Wichtig:**

- Eintrag = was deployed werden kann/soll
- Templates sind dokumentiert
- Sensible Ziele (z. B. SSH-Config) sind **nur als Template** enthalten
- Bei Änderungen: `symlinks.db` manuell updaten

**Format:** JSON mit Comment, Target, Source, Type, Permissions, Owner

**Beispiel:**

```json
{
  "comment": "Fish Shell — System-weite Config",
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
- dann in `.secrets/deployment/symlinks.db` dokumentieren
- dann hier in DEPLOYMENT.md dokumentieren

---

## Update-Workflow

### Repo aktualisieren

```fish
cd /mr-bytez

# Main Repo pullen
git pull --ff-only

# Secrets Submodule updaten (falls geaendert)
cd .secrets
git pull --ff-only
cd ..
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

### Nach pacman -Syu: Fish Loader-Symlink pruefen

**Symptom:** Nach einem System-Update (`pacman -Syu`) funktioniert Fish nicht mehr korrekt oder der Prompt fehlt.

**Ursache:** Wenn `fish` ueber pacman aktualisiert wird, kann `/etc/fish/conf.d/` geleert oder ueberschrieben werden. Der Loader-Symlink `/etc/fish/conf.d/000-loader.fish` geht dabei verloren.

**Fix:**

```fish
# Pruefen ob /etc/fish noch unser Symlink ist
ls -la /etc/fish
# Erwartet: /etc/fish -> /opt/mr-bytez/current/shared/etc/fish

# Falls /etc/fish kein Symlink mehr ist:
sudo mv /etc/fish /etc/fish.backup
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish

# Neu einloggen
exit
```

**Empfehlung:** Nach jedem `pacman -Syu` kurz pruefen ob `/etc/fish` noch korrekt verlinkt ist.

---

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

### Micro Clipboard funktioniert nicht

**Symptom:** Ctrl+Shift+C/V kopiert/fügt nicht ein in micro

**Ursache:** `xclip` (X11) oder `wl-clipboard` (Wayland) nicht installiert

**Fix:**

```fish
# X11:
sudo pacman -S xclip

# Wayland:
sudo pacman -S wl-clipboard

# Prüfen ob clipboard-Methode korrekt:
command grep clipboard /usr/local/share/micro/settings.json
# → "clipboard": "external"
```

### Submodule Probleme

**Symptom:** `.secrets/` leer oder Fehler bei `git submodule update`

**Fix:**

```fish
# Manuell clonen mit gh (hat Auth!)
gh repo clone mr-bytez/mr-bytez-secrets /tmp/secrets-clone
rm -rf /mr-bytez/.secrets
mv /tmp/secrets-clone /mr-bytez/.secrets
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
- Paket-Dependencies (xclip, wl-clipboard, etc.)

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

**2026-02-09:**
- Micro Clipboard: `terminal` (OSC52) → `external` (xclip) gewechselt
- `xclip` als Paket-Dependency dokumentiert (neuer Schritt 5)
- Wayland-Alternative `wl-clipboard` dokumentiert
- Troubleshooting: Micro Clipboard Sektion hinzugefügt
- Quickstart-Nummerierung angepasst (1-9 statt 1-8)
- Dokumentationspflicht: Paket-Dependencies ergänzt

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

**Stand:** 2026-03-05
