# Handoff: /etc/fish Symlink — Dauerhafter Pacman-Fix

**Vorheriger Chat:** MR-ByteZ - Archstick-Update, Fish-Loader, hwi-Deployment
**Chat-Link:** https://claude.ai/chat/CHAT_ID_HIER_ERSETZEN
**Datum:** 2026-02-18
**Status:** Problem identifiziert, Loesung definiert, Umsetzung offen

---

## Kontext: Was passiert ist

Bei `pacman -Syu` mit Fish-Update wird `/etc/fish/conf.d/` geleert.
Der Loader-Symlink (`00-loader.fish`) geht dabei verloren → Fish-Shell kaputt.

**Betroffen:** Alle Hosts — heute auf 3 Hosts gleichzeitig aufgetreten:
- n8-kiste ❌ (Quick-Fix: Symlink neu gesetzt)
- n8-station ❌ (Quick-Fix: Symlink neu gesetzt)
- n8-archstick ❌ (Quick-Fix: Symlink neu gesetzt)
- n8-vps ❌ (Quick-Fix: Symlink neu gesetzt)

**Ursache:** `/etc/fish` ist auf allen Hosts ein **echtes Verzeichnis**, kein Symlink.
Pacman betrachtet `/etc/fish/` als paket-eigenes Verzeichnis und raeumt es beim Update auf.

---

## Loesung: /etc/fish als Symlink

Die Loesung steht bereits in `DEPLOYMENT.md` (Schritt 6), wurde aber nie umgesetzt:

```fish
# 1. Original /etc/fish sichern
sudo mv /etc/fish /etc/fish.backup-YYYYMMDD

# 2. Symlink setzen (GANZES /etc/fish wird ersetzt!)
sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish

# 3. Verifizieren
ls -la /etc/fish
# Erwartet: /etc/fish -> /opt/mr-bytez/current/shared/etc/fish

# 4. Fish testen
fish -c "echo 'Fish laeuft'"
```

**Warum das funktioniert:**
- Wenn `/etc/fish` selbst ein Symlink ist, kann Pacman den Inhalt nicht ueberschreiben
- Pacman "besitzt" das Verzeichnis nicht mehr
- Alle Inhalte kommen aus dem Repo via Anker

**Moegliches Risiko:**
- Pacman koennte bei Fish-Updates Warnungen ausgeben (`.pacnew` Dateien)
- Fish-Paket koennte den Symlink ueberschreiben wollen → muss getestet werden

---

## Offene Aufgaben

### Aufgabe 1: Test auf n8-kiste (Prioritaet: Hoch)

**Was:** `/etc/fish` durch Symlink ersetzen und testen.

**Schritte:**
1. Backup: `sudo mv /etc/fish /etc/fish.backup-20260218`
2. Symlink: `sudo ln -sfn /opt/mr-bytez/current/shared/etc/fish /etc/fish`
3. Fish testen: `fish -c "echo test"` + neues Terminal oeffnen
4. Alle Funktionen pruefen: Prompt, Aliases, Loader-Debug
5. Pacman-Testlauf: `sudo pacman -S fish` (Fish neu installieren, schauen ob Symlink ueberlebt)

**Erwartetes Ergebnis:** Fish funktioniert, Symlink bleibt nach Pacman-Reinstall bestehen.

### Aufgabe 2: Rollout auf alle Hosts

**Nach erfolgreichem Test auf n8-kiste:**
- n8-station: Gleiches Verfahren
- n8-vps: Gleiches Verfahren
- n8-archstick: Gleiches Verfahren
- n8-book: Gleiches Verfahren (wenn deployed)

### Aufgabe 3: Alte Backups aufraeumen

Auf allen Hosts liegen mittlerweile mehrere Backups:
```
/etc/fish.backup
/etc/fish.backup-original
/etc/fish.backup-YYYYMMDD
```
Nach erfolgreichem Rollout: Alte Backups entfernen (ein aktuelles behalten).

### Aufgabe 4: Dokumentation aktualisieren

- `DEPLOYMENT.md` (Root): Schritt 6 als **kritisch** markieren, Warnung ergaenzen
- `.claude/context/deployment.md`: Pacman-Verhalten dokumentieren
- `symlinks.db`: Eintrag fuer `/etc/fish` verifizieren
- Optional: Pacman Hook evaluieren als zusaetzliche Absicherung

---

## Betroffene Dateien

| Datei | Aenderung |
|-------|-----------|
| `/etc/fish` (alle Hosts) | Verzeichnis → Symlink |
| `DEPLOYMENT.md` (Root) | Schritt 6 Warnung ergaenzen |
| `.claude/context/deployment.md` | Pacman-Verhalten dokumentieren |
| `shared/deployment/symlinks.db` | Eintrag verifizieren |

---

## Delegation

- **Aufgabe 1 (Test):** Manuell im Chat — erfordert Live-Validierung
- **Aufgabe 2 (Rollout):** Manuell im Chat oder Claude Code — wiederholende Schritte
- **Aufgabe 3 (Cleanup):** Claude Code delegierbar
- **Aufgabe 4 (Docs):** Claude Code delegierbar

---

## Quick-Fix (Notfall)

Falls der Symlink-Ansatz nicht funktioniert, bleibt der Quick-Fix:

```fish
sudo ln -sv /mr-bytez/shared/etc/fish/conf.d/00-loader.fish /etc/fish/conf.d/00-loader.fish
```

Muss aber nach **jedem** Fish-Update wiederholt werden.
