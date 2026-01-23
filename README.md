# mr-bytez

**Version:** 0.2.0
**Status:** Secrets-Management implementiert
**Erstellt:** 2026-01-22
**Autor:** Michael Rohwer

---

## Übersicht

Meta-Repository für komplette Infrastruktur-Verwaltung.

**Kernkonzept:**
- Zentrale Verwaltung aller Hosts, Configs & Secrets
- Polyrepo-Ansatz (Submodules für Projekte)
- Single Source of Truth in `/mr-bytez`
- Disaster Recovery über Master-Password + Git

---

## Struktur

```
/mr-bytez/
├── shared/              # Shared Resources (alle Hosts)
│   ├── etc/            # System-Configs
│   ├── home/           # User Home-Directories
│   ├── .secrets/       # Age-verschlüsselte Secrets (IM Git!)
│   └── deployment/     # Deployment-Scripts
├── projects/           # Projekte (Submodules)
│   ├── infrastructure/ # Hosts (n8-vps, n8-kiste, etc.)
│   └── web/           # Web-Projekte
├── .claude/            # Claude Integration
└── .config/            # Repository-weite Configs
```

---

## Status

**Phase 1:** Foundation ✅
- [x] Repository erstellt
- [x] Basis-Struktur angelegt
- [x] SSH-Key für Codeberg generiert
- [x] Codeberg Repository verbunden
- [x] Secrets-Management (Age-Encryption)
- [x] derive_key.fish (Master-Password Derivation)
- [x] symlinks.db (Deployment-Datenbank)

**Phase 2:** Host-Setup (nächster Schritt)
- [ ] Submodules hinzufügen (n8-vps, n8-kiste)
- [ ] Fish-Config Basis erstellen
- [ ] Docs-Struktur aufbauen

---

## Dokumentation

- **Secrets:** `shared/.secrets/SECRETS.md`
- **Deployment:** `shared/deployment/`
- **Strukturplan:** Im Claude.ai Projekt-Context

---

## Kontakt

**Autor:** Michael Rohwer
**Email:** mail@mr-bytez.de
**Repository:** [Codeberg](https://codeberg.org/n8lauscher/mr-bytez) (privat)

---

**Lizenz:** GPL v3
