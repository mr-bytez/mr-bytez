# Security — Secrets, Tokens & Sanitization

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-24
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

- Secrets liegen ausschliesslich im privaten Submodule: `.secrets/` (Repo-Root)
- Im Hauptrepo: **keine** Klartext-Secrets
- Im Secrets-Repo: verschluesselte Dateien (`*.age`), Metadaten (`*.info`), Doku + 5-3-3 Docs
- Age-Encryption mit Master-Password Derivation (`shared/deployment/derive_key.fish`)

### Archiv-Modell (ab A1 Phase 2)

Das Secrets-Repo wird zum verschluesselten Home-User-Backup:
- `mrohwer.tar.age` — verschluesseltes Archiv (Single Source of Truth)
- `mrohwer/` — entschluesselt lokal, gitignored
- Struktur: `mrohwer/shared/` (alle Hosts) + `mrohwer/infrastructure/<hostname>/` (host-spezifisch)
- Deployment ueber Anker: `/opt/mr-bytez/current/.secrets/mrohwer/...`
- SSH-Config und .gitconfig werden via Secrets-Repo deployt (nicht mehr "nur Template")

**Details:** `.secrets/README.md`, `.secrets/SECRETS.md`

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
- SSH Private Keys aus dem PUBLIC Repo deployen
- Klartext-Secrets im PUBLIC Repo
- Tokens/Keys mit `cat`-Alias lesen
