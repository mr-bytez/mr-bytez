# ROADMAP — hwi

**Aktualisiert:** 2026-03-05

---

## Erledigt

- ✅ v3.0.0: Multi-Distro Release
- ✅ v3.1.0: sudo-Cleanup + Parsing-Fixes
- ✅ v3.1.1: Verschiebung nach `shared/usr/local/bin/hwi/` + Anker-Symlink

---

## Erledigt (Deployment)

- ✅ n8-archstick: Symlink aktualisiert + `sudo hwi mrbz` ausgefuehrt
- ✅ n8-kiste: Symlink auf Anker-Pfad aktualisiert

## Offen

- 🔲 `hwi mrbz --context` — Kompakter Output fuer `.claude/context/hardware.md`
  Schreibt reduzierte Version (CPU, Kerne, RAM, Storage-Groesse, Mainboard) ohne
  sensible Daten (Seriennummern, MACs, SMART-Details). Single Source of Truth fuer
  alle committed Docs — README + Server-Doku referenzieren dann nur noch diese Datei.
  Abhaengigkeit: keine, kann jederzeit umgesetzt werden.
- 🔲 n8-station: Symlink auf Anker-Pfad aktualisieren + `sudo hwi mrbz` ausfuehren
- 🔲 n8-kiste: `sudo hwi mrbz` erneut ausfuehren (HARDWARE.md hat noch altes Datum 07.02.)
