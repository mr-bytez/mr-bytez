# derive_key.fish - Key-Derivation Script

**Pfad:** `/mr-bytez/shared/deployment/derive_key.fish`
**Version:** 1.0.0
**Erstellt:** 2026-01-23
**Autor:** Michael Rohwer

---

## Zweck

Generiert sichere Passphrases aus Master-Password + Salt via PBKDF2-ähnlicher Derivation.
Der Output kann als Age-Passphrase für Secrets-Verschlüsselung verwendet werden.

---

## Verwendung

```fish
# Basis: Salt + Master-Password
fish derive_key.fish [SALT]

# Erweitert: Salt + Hostname + Master-Password
fish derive_key.fish [SALT] --with-host
```

---

## Beispiele

### Für Secrets-Verschlüsselung (empfohlen)

```fish
# Generiert Key für Secrets auf aktuellem Host
fish derive_key.fish secrets --with-host

# Formel: PBKDF2(secrets + n8-kiste + MasterPwd)
# Output: z.B. "a7f3b2c9e8d1f4a5b6c7d8e9f0a1b2c3d4e5f6"
```

### Für Codeberg-Password

```fish
fish derive_key.fish codeberg

# Formel: PBKDF2(codeberg + MasterPwd)
```

### Für andere Services

```fish
fish derive_key.fish github
fish derive_key.fish hetzner
fish derive_key.fish nextcloud
```

---

## Disaster Recovery

### Was du brauchst:

1. **Master-Password** (NUR in deinem Kopf!)
2. **Salt** (dokumentiert in SECRETS.md)
3. **Dieses Script** (im Git-Repo)

### Schritte zur Rekonstruktion:

```fish
# 1. Repository clonen (HTTPS, kein SSH nötig)
git clone https://codeberg.org/n8lauscher/mr-bytez.git

# 2. In Deployment-Ordner wechseln
cd mr-bytez/shared/deployment

# 3. Key neu generieren
fish derive_key.fish secrets --with-host

# 4. Master-Password eingeben
# → Du erhältst denselben Derived Key wie vorher!

# 5. Secrets entschlüsseln
age -d -i /path/to/secret.age
# → Passphrase eingeben (= Derived Key)
```

---

## Technische Details

### Algorithmus

```
Input:    [SALT] + [MASTER-PASSWORD]
          oder
          [SALT] + [HOSTNAME] + [MASTER-PASSWORD]
          ↓
       SHA256 + Base64
          ↓
Output:   43 Zeichen (256 Bit Entropie)
```

### Sicherheit

- **Nicht rückrechenbar:** Vom Derived Key kann man nicht auf das Master-Password schließen
- **Deterministisch:** Gleicher Input = Gleicher Output (wichtig für Recovery!)
- **Einzigartig pro Host:** Mit `--with-host` ist jeder Host anders

---

## WICHTIG

⚠️ **NIEMALS dokumentieren:**
- Dein Master-Password
- Die vollständige generierte Passphrase

✅ **Dokumentieren OK:**
- Das Salt (z.B. "secrets")
- Ob --with-host verwendet wurde
- Für welchen Zweck der Key ist

---

## Siehe auch

- `SECRETS.md` - Übersicht aller Secrets (in `/mr-bytez/shared/.secrets/`)
- `restore.fish` - Disaster Recovery Script (in `/mr-bytez/shared/deployment/`)

> **Hinweis:** Diese Dokumente werden im Rahmen des Repository-Setups erstellt.
