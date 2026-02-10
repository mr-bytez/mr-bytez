# 🎯 Chat Handoff Document

## 📋 Chat-Informationen

**Chat-Name:**
\`\`\`
MR-ByteZ - [security][TODO] - Git Clean Smudge Filter Hostname Mapping Sensitive Data Pattern Scanner IP-Adressen mrohwer n8-hosts History Rewrite --- 2026-02-04-03-00
\`\`\`

**Erstellungsdatum:** 2026-02-04 03:00
**Status:** TODO / In Bearbeitung
**Kategorie:** Security

---

## 🎯 Projektziel

**Hauptproblem:**
Das mr-bytez Repository soll öffentlich auf Codeberg/GitHub veröffentlicht werden, enthält aber aktuell sensitive Daten (Hostnamen, Usernamen, möglicherweise IP-Adressen), die NICHT öffentlich werden sollen.

**Anforderung:**
- Lokal mit echten Namen arbeiten (n8-kiste, mrohwer, etc.)
- Im Git-Commit automatisch generische Namen verwenden (mr-bytez-server-file, admin, etc.)
- Keine separaten Repos führen müssen
- Bidirektionale Transformation (clean/smudge)

---

## 🗺️ Hostname/Username Mapping

### Hostnamen

\`\`\`
LOKAL (privat)          →  GIT-REPO (öffentlich)
─────────────────────────────────────────────────
n8-kiste                →  mr-bytez-server-file
n8-vps                  →  mr-bytez-server-vps
n8-station              →  vpn-client-workstation
n8-book                 →  vpn-client-notebook

# Auch ohne Bindestrich:
n8kiste                 →  mr-bytez-server-file
n8vps                   →  mr-bytez-server-vps
n8station               →  vpn-client-workstation
n8book                  →  vpn-client-notebook
\`\`\`

### Username

\`\`\`
LOKAL (privat)          →  GIT-REPO (öffentlich)
─────────────────────────────────────────────────
mrohwer                 →  mr-bytez-admin
Mrohwer (Satzanfang)    →  Mr-bytez-admin (ODER mr-bytez-admin? - noch zu klären!)
mRohwer                 →  mr-bytez-admin (wenn alleinstehendes Wort)
\`\`\`

**Regel:** Case-insensitive bei alleinstehendem Wort ersetzen

---

## 🔍 Pattern-Kategorien

### 1. Hostnamen
- \`n8-kiste\`, \`n8-vps\`, \`n8-station\`, \`n8-book\`
- Ohne Bindestrich: \`n8kiste\`, \`n8vps\`, \`n8station\`, \`n8book\`
- In Pfaden: \`/mr-bytez/projects/infrastructure/n8-kiste/\`
- In SSH: \`ssh mrohwer@n8-kiste\`
- In Configs: \`hostname = n8-kiste\`

### 2. Username
- \`mrohwer\` (alle Schreibweisen)
- In Pfaden: \`/home/mrohwer/\`
- In Configs: \`USER=mrohwer\`
- Als SSH-User: \`mrohwer@host\`

### 3. IP-Adressen (zu identifizieren)
- Pattern: \`\\b([0-9]{1,3}\\.){3}[0-9]{1,3}\\b\`
- Manuelle Entscheidung welche ersetzt werden
- Public IPs (8.8.8.8, etc.) NICHT ersetzen

### 4. Weitere (optional, noch zu klären)
- Domain-Namen?
- Email-Adressen?
- SSH-Keys? (sollten nicht im Repo sein)

---

## 🛠️ Lösungsansatz: Git Clean/Smudge Filter

### Konzept

\`\`\`
LOKAL (Working Dir)     →  [clean filter]  →  REPO (Commit/Push)
echte Namen                                     generische Namen

REPO (Pull/Clone)       →  [smudge filter] →  LOKAL (Working Dir)
generische Namen                                echte Namen
\`\`\`

### Komponenten

#### 1. Filter-Scripts
**Pfad:** \`~/.config/git/filters/\`

**Scripts:**
- \`hostname-clean.fish\` - Ersetzt vor Commit (echt → generisch)
- \`hostname-smudge.fish\` - Ersetzt nach Checkout (generisch → echt)

#### 2. Git-Config

\`\`\`ini
# In ~/.gitconfig oder .git/config
[filter \"hostname\"]
    clean = ~/.config/git/filters/hostname-clean.fish
    smudge = ~/.config/git/filters/hostname-smudge.fish
\`\`\`

#### 3. .gitattributes
**Pfad:** \`/mr-bytez/.gitattributes\`

\`\`\`gitattributes
# Configs und Scripts
*.fish filter=hostname
*.sh filter=hostname
*.bash filter=hostname

# Dokumentation
*.md filter=hostname
*.txt filter=hostname

# Infrastructure Files
*.yml filter=hostname
*.yaml filter=hostname
*.conf filter=hostname
*.ini filter=hostname

# Alle Files in Infrastructure-Verzeichnissen
projects/infrastructure/** filter=hostname
\`\`\`

---

## 📊 Geplante Tools

### 1. Pattern-Scanner
**Script:** \`~/.local/bin/mr-bytez-scan-sensitive.fish\`

**Funktionen:**
- Scannt lokales Repo nach allen Pattern-Kategorien
- Zählt Vorkommen pro Pattern
- Sucht IP-Adressen mit Regex
- Listet betroffene Dateien auf
- Kann optional auch remote Repo scannen

**Output:**
\`\`\`
🔍 Scanning für sensitive Daten...

📁 Lokales Repo:
  ❌ 'mrohwer': 47 Vorkommen
  ❌ 'n8-kiste': 23 Vorkommen
  ❌ 'n8-vps': 15 Vorkommen
  ...

🌐 IP-Adressen gefunden:
  192.168.1.100 in file1.yml
  10.0.0.5 in file2.conf
  ...
\`\`\`

### 2. Clean-Filter
**Script:** \`~/.config/git/filters/hostname-clean.fish\`

**Funktionen:**
- Liest stdin, schreibt stdout (Git-Filter-Konvention)
- Ersetzt alle Patterns sequentiell
- Reihenfolge: Längste Strings zuerst (vermeidet Teil-Matches)
- Case-sensitive für Hostnamen
- Case-insensitive für Username (bei Wortgrenzen)

**Ersetzungsreihenfolge:**
1. Hostnamen (mit Bindestrich, längste zuerst)
2. Hostnamen (ohne Bindestrich)
3. Username (alle Varianten)
4. Optional: IP-Adressen (falls Mapping definiert)

### 3. Smudge-Filter
**Script:** \`~/.config/git/filters/hostname-smudge.fish\`

**Funktionen:**
- Reverse-Operation zu Clean-Filter
- Ersetzt generische → echte Namen
- Gleiche Reihenfolge wie Clean-Filter

---

## ⚠️ Offene Entscheidungen

### A) Git-History Bereinigung

**Problem:** Bereits gepushte Commits enthalten sensitive Daten!

**Option 1: Komplette History neu schreiben**
- Tool: \`git filter-repo\` (empfohlen über \`git filter-branch\`)
- ✅ Repo ist vollständig sauber
- ❌ Erfordert Force-Push
- ❌ Alle Collaborators müssen Repo neu clonen
- ⚠️ Alte Commits auf GitHub/Codeberg sind für immer im Cache

**Option 2: Nur ab jetzt filtern**
- ✅ Kein Force-Push nötig
- ✅ Keine Disruption für andere
- ❌ Alte Commits bleiben \"dreckig\"
- ❌ Sensitive Daten bleiben in History

**Status:** Noch nicht entschieden - hängt ab von:
- Wie weit ist Repo verbreitet?
- Gibt es andere Collaborators?
- Wie kritisch sind die Daten in alter History?

### B) Case-Handling für Username

**Frage:** Bei \`Mrohwer\` am Satzanfang:
- \`Mr-bytez-admin\` (behält Großschreibung bei)
- \`mr-bytez-admin\` (immer lowercase)

**Status:** Noch zu klären

### C) IP-Adressen Mapping

**Vorgehen:**
1. Erst scannen welche IPs vorkommen
2. Manuell entscheiden welche ersetzt werden
3. Mapping-Tabelle erstellen
4. In Filter einbauen

**Status:** Noch nicht gescannt

### D) Weitere sensitive Patterns

**Zu prüfen:**
- Domain-Namen (z.B. \`rohwer.de\`)
- Email-Adressen (z.B. \`m@rohwer.de\`)
- SSH-Keys (sollten nicht im Repo sein)
- Weitere?

**Status:** Noch nicht geprüft

---

## 🚀 Nächste Schritte (Priorisiert)

### 1. SOFORT: Bestandsaufnahme

\`\`\`fish
# Pattern-Scanner Script erstellen
# In: ~/.local/bin/mr-bytez-scan-sensitive.fish

# Ausführen und Output analysieren
mr-bytez-scan-sensitive.fish > /tmp/sensitive-scan-\$(date +%Y%m%d).txt

# Review:
# - Wie viele Vorkommen pro Pattern?
# - Welche Files sind betroffen?
# - Welche IP-Adressen gibt es?
# - Gibt es unerwartete Patterns?
\`\`\`

### 2. Entscheidungen treffen
- [ ] Git-History bereinigen? (Ja/Nein)
- [ ] Case-Handling für Username klären
- [ ] IP-Adressen Mapping definieren
- [ ] Weitere Patterns identifizieren

### 3. Filter implementieren
- [ ] \`hostname-clean.fish\` erstellen
- [ ] \`hostname-smudge.fish\` erstellen
- [ ] Git-Config einrichten
- [ ] \`.gitattributes\` erstellen
- [ ] Testen mit Test-Commit

### 4. (Optional) History bereinigen

\`\`\`fish
# Nur falls entschieden: Ja zu Option 1

# Backup erstellen
cp -r /mr-bytez /mr-bytez-backup-\$(date +%Y%m%d)

# git-filter-repo installieren
sudo pacman -S git-filter-repo

# Replacements-File erstellen
# (Aus Scanner-Output generieren)

# History neu schreiben
cd /mr-bytez
git filter-repo --replace-text /tmp/replacements.txt

# Force-Push
git push --force --all origin
\`\`\`

### 5. Dokumentation
- [ ] README im Repo updaten (ohne sensitive Infos!)
- [ ] Für andere Devs: Anleitung für Smudge-Filter Setup
- [ ] Checkliste für neue Hosts/User

---

## 📝 Wichtige Notizen

### Besonderheiten Fish Shell
- **KEIN \`grep\`** direkt verwenden (wegen Alias!)
- Immer \`command grep\` für sensitive Daten
- Filter müssen stdin/stdout verarbeiten (keine File-I/O)
- Bei EOF/heredoc: NICHT verwenden, nur \`printf\` oder \`echo\`

### Git-Filter Besonderheiten
- Filter arbeiten auf **Dateiinhalt**, nicht Dateinamen
- Werden bei **jedem** Checkout/Commit ausgeführt
- Müssen **idempotent** sein (mehrfach ausführbar)
- Performance: Bei großen Repos langsamer (Filter für jede Datei)

### Security-Aspekte
- Filter schützen NICHT vor direktem File-Zugriff
- Jemand mit Repo-Zugriff kann Filter umgehen
- Git-History ist in Remotes gecached (GitHub/Codeberg)
- Bei kritischen Daten: Lieber privates Repo

---

## 📚 Referenzen

### Git-Filter Dokumentation
- https://git-scm.com/docs/gitattributes#_filter
- https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes

### git-filter-repo
- https://github.com/newren/git-filter-repo
- Arch: \`sudo pacman -S git-filter-repo\`

### Regex für IP-Adressen

\`\`\`regex
\\b([0-9]{1,3}\\.){3}[0-9]{1,3}\\b
\`\`\`

---

## 💾 Dateien zum Sichern

Wenn dieses Projekt abgeschlossen ist:

**Scripts:**
- \`~/.local/bin/mr-bytez-scan-sensitive.fish\`
- \`~/.config/git/filters/hostname-clean.fish\`
- \`~/.config/git/filters/hostname-smudge.fish\`

**Configs:**
- \`~/.gitconfig\` (Filter-Sektion)
- \`/mr-bytez/.gitattributes\`

**Dokumentation:**
- Dieses Handoff-Document
- Pattern-Mapping-Tabelle
- IP-Adressen-Mapping (falls vorhanden)

---

## 🎯 Status-Tracking

**Aktueller Stand:**
- ✅ Problem verstanden
- ✅ Mapping-Tabelle definiert
- ✅ Lösungsansatz erarbeitet (Clean/Smudge Filter)
- ⏳ Pattern-Scanner noch zu erstellen
- ⏳ Bestandsaufnahme noch zu machen
- ⏳ Entscheidungen noch offen
- ⏳ Filter noch zu implementieren
- ⏳ Testing noch offen

**Next Action:**
Pattern-Scanner Script erstellen und Bestandsaufnahme durchführen.

---

## 🔗 Verwandte Chats

*(Hier später weitere Chat-Namen eintragen, die dieses Thema weiterbearbeiten)*

- *noch keine*

---

**Letzte Aktualisierung:** 2026-02-04 03:00
**Chat-Status:** In Bearbeitung / TODO"
