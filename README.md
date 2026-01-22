# mr-bytez

**Version:** 0.1.0
**Status:** Initial Setup
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
│   └── .secrets/       # Age-verschlüsselte Secrets
├── projects/           # Projekte (Submodules)
│   ├── infrastructure/ # Hosts (n8-vps, n8-kiste, etc.)
│   └── web/           # Web-Projekte
├── .claude/            # Claude Integration
└── .config/            # Repository-weite Configs
```

---

## Status

**Phase 1:** Initial Setup (in Progress)
- [x] Repository erstellt
- [x] Basis-Struktur angelegt
- [ ] SSH-Setup für Codeberg
- [ ] Initial Push

**Nächste Schritte:**
1. SSH-Key generieren & deployen
2. Codeberg Repository verbinden
3. Submodules hinzufügen (n8-vps, n8-kiste)

---

## Dokumentation

- **Strukturplan:** `shared/home/mrohwer/Documents/docs/architecture/`
- **Guides:** `shared/home/mrohwer/Documents/docs/guides/`
- **Wikis:** `shared/home/mrohwer/Documents/wikis/`

---

## Kontakt

**Autor:** Michael Rohwer
**Email:** mail@mr-bytez.de
**Repository:** Codeberg (privat)

---

**Lizenz:** GPL v3
