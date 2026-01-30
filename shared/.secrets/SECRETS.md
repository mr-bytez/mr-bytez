# SECRETS.md - Übersicht aller Secrets

**Pfad:** `/mr-bytez/shared/.secrets/`
**Erstellt:** 2026-01-23
**Autor:** Michael Rohwer

---

## ⚠️ WICHTIG

- Alle `.age` Dateien sind verschlüsselt
- Master-Password wird NIRGENDS gespeichert
- Derived Key bei Bedarf neu generieren

---

## Key-Derivation

```fish
# Derived Key generieren
cd /mr-bytez/shared/deployment
fish derive_key.fish secrets
# → Master-Password 2x eingeben
# → Derived Key wird angezeigt (43 Zeichen)
```

**Dokumentation:** `derive_key.README.md`

---

## Secrets-Übersicht

### SSH Keys

| Datei | Zweck | Salt | Info |
|-------|-------|------|------|
| `ssh/mrohwer/id_ed25519_codeberg.age` | Codeberg Git-Zugriff | secrets | [.info](ssh/mrohwer/id_ed25519_codeberg.info) |
| `ssh/mrohwer/id_ed25519_codeberg.pub` | Public Key (unverschlüsselt) | - | - |
| `ssh/mrohwer/id_ed25519_github.age` | GitHub Git-Zugriff | secrets | [.info](ssh/mrohwer/id_ed25519_github.info) |
| `ssh/mrohwer/id_ed25519_github.pub` | Public Key (unverschlüsselt) | - | - |

### API Tokens

| Datei | Zweck | Salt | Info |
|-------|-------|------|------|
| `api/codeberg.token.age` | Codeberg API (repo admin) | secrets | [.info](api/codeberg.token.info) |
| `api/github.token.age` | GitHub API (repo, workflow, user) | secrets | [.info](api/github.token.info) |

---

## Disaster Recovery

### Was du brauchst:

1. **Master-Password** (in deinem Kopf)
2. **Dieses Repository** (git clone)
3. **age** installiert (`pacman -S age`)

### Schritte:

```fish
# 1. Repo clonen (HTTPS, kein SSH nötig!)
git clone https://codeberg.org/n8lauscher/mr-bytez.git
cd mr-bytez

# 2. Derived Key generieren
cd shared/deployment
fish derive_key.fish secrets

# 3. SSH Key entschlüsseln
age -d ../. secrets/ssh/mrohwer/id_ed25519_codeberg.age > ~/.secrets/ssh/id_ed25519_codeberg
chmod 600 ~/.secrets/ssh/id_ed25519_codeberg

# 4. Jetzt SSH-Zugriff möglich!
git remote set-url origin git@codeberg.org:n8lauscher/mr-bytez.git
```

---

## Neue Secrets hinzufügen

```fish
# 1. Derived Key generieren
fish derive_key.fish secrets

# 2. Secret verschlüsseln
age -e -p -o shared/.secrets/PFAD/name.age /pfad/zum/secret
# → Derived Key als Passphrase eingeben (2x)

# 3. Info-Datei erstellen
# → Kopiere Template aus vorhandener .info Datei

# 4. Diese SECRETS.md aktualisieren!
```

---

**Letzte Aktualisierung:** 2026-01-30
