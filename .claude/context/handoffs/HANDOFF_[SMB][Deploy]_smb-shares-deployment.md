# 🔄 CHAT HANDOFF: SMB-Shares Deployment für mr-bytez

**Projekt:** mr-bytez
**Erstellt:** 2026-02-10
**Quell-Chat:** MR-ByteZ - [smb] - n8-kiste SMB Shares auf n8-archstick - cifs-utils fstab automount credentials DNS-Fix AdGuard hosts VLC Codecs vlc-plugin-ffmpeg mpeg2 x264 Dolphin KIO --- 2026-02-08-14-24
**Status:** 🟡 In Arbeit – Deployment-Script + Commits ausstehend

---

## 📋 Zusammenfassung

SMB-Freigaben von n8-kiste sollen auf **allen mr-bytez Hosts** einheitlich als lokale CIFS-Mounts verfügbar sein. Die Lösung wurde auf n8-archstick vollständig getestet und funktioniert. Jetzt muss ein Deploy-Script erstellt werden, das die Konfiguration auf alle Hosts ausrollen kann.

---

## ✅ Was wurde erledigt

### 1. DNS-Fix auf n8-kiste
- **Problem:** `/etc/hosts` auf n8-kiste hatte `127.0.1.1 n8-kiste` VOR `10.10.10.1 n8-kiste` → AdGuard DNS gab `127.0.1.1` als Antwort zurück
- **Fix:** Zeile `127.0.1.1 n8-kiste.local n8-kiste` in `/etc/hosts` auf n8-kiste **auskommentiert**
- **Verifiziert:** `dig @10.10.10.1 n8-kiste +short` → `10.10.10.1` ✅
- **Entscheidung:** DNS-Auflösung zentral über AdGuard, KEINE lokalen `/etc/hosts`-Einträge auf den Clients

### 2. VLC Codec-Pakete auf n8-archstick
- **Problem:** VLC auf n8-archstick hatte kein SMB-Modul und fehlende Codec-Plugins
- **Lösung:** Nicht SMB-Support in VLC fixen, sondern lokale CIFS-Mounts verwenden
- **Installierte Pakete:**
  ```
  vlc-plugin-ffmpeg
  vlc-plugin-mpeg2
  vlc-plugin-x264
  ```
- **⚠️ WICHTIG:** Diese Pakete müssen auf ALLEN Desktop-Hosts installiert werden!
- **Commit:** Noch ausstehend – als separate Paketliste für Desktop-Hosts

### 3. CIFS-Mounts auf n8-archstick (getestet & funktioniert)

#### Mountpoints erstellt
```
/mnt/n8-kiste/
├── filme        → //n8-kiste/videos-movies
├── serien       → //n8-kiste/videos-series
├── tmp          → //n8-kiste/videos-tmp
├── jd-sort      → //n8-kiste/jdown/sort
└── jd-entpackt  → //n8-kiste/jdown/entpackt
```

#### fstab-Einträge (finale Version, getestet)
```fstab
# ─────────────────────────────────────────────────────────────────────────────
# SMB-Shares: n8-kiste (on-demand via systemd.automount)
# Credentials: /mr-bytez/.secrets/smb-n8-kiste.creds
# ─────────────────────────────────────────────────────────────────────────────
//n8-kiste/videos-movies   /mnt/n8-kiste/filme        cifs  noauto,_netdev,x-systemd.automount,x-systemd.idle-timeout=300,x-systemd.mount-timeout=3,credentials=/mr-bytez/.secrets/smb-n8-kiste.creds,vers=3.0,uid=1000,gid=1000  0  0
//n8-kiste/videos-series   /mnt/n8-kiste/serien       cifs  noauto,_netdev,x-systemd.automount,x-systemd.idle-timeout=300,x-systemd.mount-timeout=3,credentials=/mr-bytez/.secrets/smb-n8-kiste.creds,vers=3.0,uid=1000,gid=1000  0  0
//n8-kiste/videos-tmp      /mnt/n8-kiste/tmp          cifs  noauto,_netdev,x-systemd.automount,x-systemd.idle-timeout=300,x-systemd.mount-timeout=3,credentials=/mr-bytez/.secrets/smb-n8-kiste.creds,vers=3.0,uid=1000,gid=1000  0  0
//n8-kiste/jdown/sort      /mnt/n8-kiste/jd-sort      cifs  noauto,_netdev,x-systemd.automount,x-systemd.idle-timeout=300,x-systemd.mount-timeout=3,credentials=/mr-bytez/.secrets/smb-n8-kiste.creds,vers=3.0,uid=1000,gid=1000  0  0
//n8-kiste/jdown/entpackt  /mnt/n8-kiste/jd-entpackt  cifs  noauto,_netdev,x-systemd.automount,x-systemd.idle-timeout=300,x-systemd.mount-timeout=3,credentials=/mr-bytez/.secrets/smb-n8-kiste.creds,vers=3.0,uid=1000,gid=1000  0  0
```

#### Mount-Optionen erklärt
| Option | Zweck |
|--------|-------|
| `noauto` | Nicht beim Boot mounten |
| `_netdev` | Wartet auf Netzwerk-Verfügbarkeit |
| `x-systemd.automount` | Mountet on-demand bei Zugriff |
| `x-systemd.idle-timeout=300` | Nach 5 Min Inaktivität auto-unmount (schützt Shutdown) |
| `x-systemd.mount-timeout=3` | Max 3s warten bei Mount-Fehler (statt 90s Default) |
| `credentials=...` | Pfad zur Credentials-Datei |
| `vers=3.0` | SMB-Protokoll Version 3.0 |
| `uid=1000,gid=1000` | Dateien gehören User mrohwer |

### 4. Credentials-Datei
- **Pfad:** `/mr-bytez/.secrets/smb-n8-kiste.creds`
- **Format:**
  ```
  username=mrohwer
  password=<SMB-PASSWORT>
  ```
- **Permissions:** `root:root 0600` (MUSS root gehören, da mount.cifs als root läuft!)
- **⚠️ WICHTIG:** Git speichert kein Ownership → Deploy-Script muss `chown root:root` + `chmod 0600` setzen
- **Passwort:** Wurde am 2026-02-10 auf n8-kiste neu gesetzt via `sudo smbpasswd mrohwer`
- **Existiert auf:** n8-kiste ✅ (n8-archstick hat noch das alte Passwort → muss aktualisiert werden)

---

## ❌ Was noch offen ist

### 1. Deploy-Script erstellen
- **Vorgeschlagener Pfad:** `shared/scripts/deploy-smb-mounts.fish` (Pfad noch zu bestätigen)
- **Was das Script tun muss:**
  1. `cifs-utils` prüfen/installieren
  2. Mountpoints unter `/mnt/n8-kiste/` erstellen
  3. fstab-Block einfügen (idempotent – nur wenn noch nicht vorhanden)
  4. Credentials-Datei: `chown root:root` + `chmod 0600`
  5. `systemctl daemon-reload`
  6. Automount-Units starten
  7. Verifikation: Testmount aller Shares
- **Prinzip:** Idempotent, kann mehrfach sicher ausgeführt werden
- **Alle Hosts gleich:** Auch n8-kiste bekommt die Mounts (localhost → sich selbst)

### 2. fstab-Template ins Repo
- **Linux unterstützt KEIN `/etc/fstab.d/`** → Template-Datei im Repo, Deploy-Script fügt Block in fstab ein
- **Vorschlag:** `shared/etc/fstab-snippets/smb-n8-kiste.conf` als Template

### 3. VLC Desktop-Paketliste
- Datei mit benötigten VLC-Codec-Paketen für Desktop-Hosts
- **Pakete:** `vlc-plugin-ffmpeg vlc-plugin-mpeg2 vlc-plugin-x264`
- **Separater Commit**

### 4. Commits ausstehend
Folgende Commits müssen gemacht werden:
1. **[Security][Secrets]** `smb-n8-kiste.creds` ins .secrets Submodul committen + pushen
2. **[Feature][SMB]** Deploy-Script + fstab-Template erstellen + committen
3. **[Config][Packages]** VLC Desktop-Paketliste erstellen + committen
4. **[Docs]** Relevante Dokumentation aktualisieren (DEPLOYMENT.md, CHANGELOG.md)

### 5. Credentials auf n8-archstick aktualisieren
- Das Passwort wurde auf n8-kiste neu gesetzt
- Die Credentials-Datei auf n8-archstick hat noch das alte Passwort
- Nach Commit+Push des .secrets Submoduls auf n8-kiste → `git pull` auf n8-archstick

### 6. Dolphin-Bookmarks (optional)
- Aktuell nutzt Dolphin auf n8-archstick SMB-Bookmarks (`smb://n8-kiste/...`)
- Könnten durch lokale Pfade (`/mnt/n8-kiste/...`) ersetzt werden
- **Nicht kritisch** – beide Wege funktionieren

---

## 🔧 Technische Details & Erkenntnisse

### Warum CIFS-Mount statt Dolphin KIO?
- Dolphin nutzt KIO (`kio-smb`) für SMB-Zugriff → funktioniert nur innerhalb von KDE-Apps
- VLC und andere Nicht-KDE-Apps können `smb://` URLs nicht öffnen
- CIFS-Mount macht SMB-Shares als lokale Pfade verfügbar → funktioniert mit ALLEN Apps

### DNS-Auflösung
- Zentral über AdGuard auf n8-kiste (10.10.10.1:53)
- Keine lokalen `/etc/hosts`-Einträge für n8-kiste auf Clients nötig
- **Wichtig:** AdGuard DNS gibt die Einträge aus der lokalen `/etc/hosts` von n8-kiste weiter → dort muss die IP korrekt sein

### Avahi/mDNS
- Auf n8-archstick läuft **kein Avahi-Daemon** (`avahi-resolve` → "Daemon läuft nicht")
- Nicht benötigt, da DNS über AdGuard aufgelöst wird

### Shutdown-Timing
- Ohne `idle-timeout`: SMB-Mounts sind beim Shutdown aktiv → systemd wartet bis zu 90s pro Mount
- Mit `idle-timeout=300`: Mounts werden nach 5 Min Inaktivität automatisch gelöst
- Mit `mount-timeout=3`: Falls Mount fehlschlägt, nur 3s Timeout statt 90s

### Credentials + Git Ownership
- Git speichert keine Datei-Ownership-Informationen
- Nach `git clone/pull` gehört `smb-n8-kiste.creds` dem User (mrohwer:mrohwer)
- `mount.cifs` läuft als root → braucht `root:root` Ownership
- **Deploy-Script MUSS** nach jedem Pull: `sudo chown root:root` + `chmod 0600` setzen

---

## 📁 Betroffene Dateien im Repo

| Datei | Status | Beschreibung |
|-------|--------|--------------|
| `shared/home/mrohwer/.secrets/smb-n8-kiste.creds` | ✅ Erstellt, nicht committed | SMB Credentials |
| `shared/scripts/deploy-smb-mounts.fish` | ❌ Noch erstellen | Deploy-Script |
| `shared/etc/fstab-snippets/smb-n8-kiste.conf` | ❌ Noch erstellen | fstab-Template |
| `shared/deployment/symlinks.db` | ❌ Ggf. erweitern | Deployment-Doku |
| `DEPLOYMENT.md` | ❌ Ergänzen | SMB-Mount Doku |
| `CHANGELOG.md` | ❌ Ergänzen | Änderungshistorie |

---

## 🖥️ Host-Status

| Host | SMB-Mounts | VLC Codecs | Credentials | fstab |
|------|-----------|------------|-------------|-------|
| n8-kiste | ❌ | n/a (Server) | ✅ erstellt | ❌ |
| n8-archstick | ✅ getestet | ✅ installiert | ⚠️ altes PWD | ✅ eingetragen |
| n8-station | ❌ | ❌ | ❌ | ❌ |
| n8-book | ❌ | ❌ | ❌ | ❌ |
| n8-vps | ❌ | n/a | ❌ | ❌ |

---

## 🚀 Nächste Schritte (Reihenfolge)

1. **Deploy-Script Pfad bestätigen** → `shared/scripts/deploy-smb-mounts.fish` oder alternative Struktur?
2. **Deploy-Script erstellen** (Fish, idempotent, farbige Outputs)
3. **fstab-Template erstellen**
4. **Auf n8-kiste testen** (Deploy-Script ausführen, Mounts verifizieren)
5. **Alles committen** (3 separate Commits: Secrets, Feature, Packages)
6. **Push zu origin + codeberg**
7. **Auf n8-archstick: .secrets pullen** (neues Passwort)
8. **Auf n8-station deployen** (nächster Host)

---

## 📝 Kontext-Hinweise für neuen Chat

- Fish Shell ist die Standard-Shell → **KEIN heredoc/EOF verwenden!**
- Repo liegt unter `/mr-bytez/`, Anker unter `/opt/mr-bytez/current`
- Secrets im privaten Submodul: `/mr-bytez/.secrets/`
- Commits nur auf n8-kiste, Push zu origin (GitHub) + codeberg
- Commit-Format: `[Kategorie] Beschreibung` (siehe `.claude/context/git.md`)
- Deploy-Scripts müssen idempotent sein
- Farbige Outputs mit `set_color` und Emojis

---

**Letzte Aktualisierung:** 2026-02-10
