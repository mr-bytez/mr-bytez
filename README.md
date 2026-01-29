# mr-bytez

**Version:** 0.3.0
**Status:** Fish Shell v2.0 + Micro Editor
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
├── shared/                      # Shared Resources (alle Hosts)
│   ├── usr/local/share/        # System-weite Configs
│   │   ├── fish/               # Fish Shell v2.0 (Hierarchischer Loader)
│   │   └── micro/              # Micro Editor Settings
│   ├── home/                   # User Home-Directories
│   ├── .secrets/               # Age-verschlüsselte Secrets (IM Git!)
│   └── deployment/             # Deployment-Scripts
├── projects/                   # Projekte (Submodules)
│   ├── infrastructure/         # Hosts (n8-vps, n8-kiste, etc.)
│   └── web/                    # Web-Projekte
├── .claude/                    # Claude Integration
└── .config/                    # Repository-weite Configs
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

**Phase 2:** Host-Setup (in Progress)
- [x] Fish-Config v2.0 (Hierarchischer Loader)
- [x] Host-spezifische Configs (8 Hosts)
- [x] Micro Editor-Konfiguration
- [ ] Docs-Struktur aufbauen
- [ ] Submodules hinzufügen (n8-vps, n8-kiste)

---

## Deployment

**Fish Shell:**
```fish
sudo ln -s /mr-bytez/shared/usr/local/share/fish /usr/local/share/fish
```

**Micro Editor:**
```fish
sudo ln -s /mr-bytez/shared/usr/local/share/micro /usr/local/share/micro
ln -s /usr/local/share/micro/settings.json ~/.config/micro/settings.json
ln -s /usr/local/share/micro/bindings.json ~/.config/micro/bindings.json
```

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