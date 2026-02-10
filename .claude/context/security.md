# Security — Secrets, Tokens & Sanitization

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Sanitization Matrix

Bei öffentlicher Kommunikation (Claude.ai, GitHub Issues, Docs) werden echte Hostnamen durch sanitized Namen ersetzt.

| Real          | Sanitized       |
|---------------|-----------------|
| mrohwer       | mr-bytez-admin  |
| n8-kiste      | host-dev        |
| n8-vps        | host-vps        |
| n8-book       | host-book       |
| n8-bookchen   | host-bookchen   |
| n8-station    | host-station    |
| n8-maxx       | host-maxx       |
| n8-broker     | host-broker     |
| n8-archstick  | host-archstick  |
| mrbz-dev      | container-dev   |

**WICHTIG:** Diese Matrix NIEMALS in öffentlichen Repos committen!

---

## cat/bat Alias-Falle

In diesem Projekt kann `cat` auf `bat` gemappt sein. Das zerstört Tokens/Keys durch Formatierung und CRLF.

**NIEMALS:**
```fish
cat ~/.secrets/token.age  # GEFAHR: bat-Alias!
```

**IMMER:**
```fish
command cat ~/.secrets/token.age
# oder
/usr/bin/cat ~/.secrets/token.age
```

**Empfohlenes Sanitizing (Fish):**
```fish
command cat token.txt | string replace -a \r '' | string trim
```

---

## Secrets-Policy

- Secrets liegen ausschließlich im privaten Submodule: `shared/home/mrohwer/.secrets/`
- Im Hauptrepo: **keine** Klartext-Secrets
- Im Secrets-Repo: nur **verschlüsselte** Dateien (z.B. `*.age`) + Metadaten (`*.info`) + Doku
- Secrets **niemals** per Symlink ins System deployen
- Age-Encryption mit Master-Password Derivation (`shared/deployment/derive_key.fish`)

**Details:** Siehe Dokumentation im Secrets-Submodule (`shared/home/mrohwer/.secrets/`)

---

## Permissions-Standard

| Typ              | Permission | Owner          |
|------------------|------------|----------------|
| Keys             | 0400       | root:root      |
| Secrets          | 0600       | service:service|
| Public Configs   | 0644       | root:root      |
| Private Configs  | 0600       | service:service|
| Scripts          | 0755       | root:root      |

---

## Verboten

- Klartext-Secrets in Code oder Environment-Variablen
- Secrets in Git-History (auch nicht gelöscht!)
- SSH Private Keys aus Repo deployen
- `~/.ssh/config` aus Repo deployen (nur Template!)
- Tokens/Keys mit `cat`-Alias lesen
