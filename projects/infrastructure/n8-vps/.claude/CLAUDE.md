# n8-vps — Claude Context

> **Pfad:** `projects/infrastructure/n8-vps/.claude/CLAUDE.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Claude Code Steuerung fuer n8-vps Host

---

## Verweise

| Bereich | Pfad |
|---------|------|
| Hardware | `.claude/context/hardware.md` |
| Detail-Doku | `docs/n8-vps-server-dokumentation.md` |
| Traefik Stack | `stacks/traefik/` |
| Globale Policies | Root `.claude/context/` |

---

## Quick Start

1. **Lies:** `README.md` — Host-Uebersicht
2. **Dann:** `ROADMAP.md` — Aktuelle Planung (verweist auf Root)
3. **Details:** `docs/n8-vps-server-dokumentation.md` — Kompletter Ist-Zustand

---

## Wichtige Policies

→ Siehe Root: `.claude/context/policies.md`
→ Fish-first, Git-Format, Secrets

---

## Host-spezifische Hinweise

- **Read-Only:** Kein Commit auf n8-vps! Nur `git pull`.
- **SSH-Port:** 61020 (Key-Only)
- **Rolle:** Production Server (Powerline Prompt rot!)
- **Feature-Flags:** `MR_HAS_GUI=false`, `MR_IS_DEV=true`, `MR_DISPLAY_TYPE=headless`
- **Docker:** Installiert, `mrohwer` in docker-Gruppe

---

## Aktuell

→ Siehe: Root `ROADMAP.md` (n8-vps Service-Pipeline)
→ Naechster Schritt: Authentik SSO (Schritt 3)
