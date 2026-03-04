# n8-vps — CHANGELOG

> **Pfad:** `projects/infrastructure/n8-vps/CHANGELOG.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Aenderungshistorie fuer den n8-vps Host

---

## [Unreleased]

### Added
- 5-5-3 Pattern umgesetzt: README, CHANGELOG, ROADMAP, DEPLOYMENT, CLAUDE.md, hardware.md

---

## Bisherige Meilensteine

### Maerz 2026

- deploy.fish v0.5.1 Stable — Pakete installiert (duf, dust, htop, ripgrep, less)
- Port 22 aus UFW + Hetzner Robot Firewall entfernt
- Traefik v3.6 Reverse Proxy deployed (Dashboard, LE-Cert, ACME DNS-01)
- Secrets-Deployment verifiziert (deploy.fish, SSH, Dual-Remote)

### Februar 2026

- Phase 0-4: OS (Arch Linux installimage), SSH-Hardening (Port 61020),
  Firewall (UFW + Hetzner Robot), Docker, Fish Shell
- mr-bytez Deployment (Anker, Symlinks, Fish Loader)
- DNS Wildcard Records fuer `*.mr-bytez.de` → n8-vps
- CAA Records fuer Let's Encrypt
- yay (AUR Helper) gebaut und installiert

---

**Letzte Aktualisierung:** 2026-03-04
