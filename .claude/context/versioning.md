# Versionierung — Scripts & Projekte

**Version:** 1.0.0
**Erstellt:** 2026-02-25
**Aktualisiert:** 2026-02-25
**Autor:** MR-ByteZ

---

## Semantic Versioning (SemVer)

Alle Scripts und Projekte verwenden Semantic Versioning: MAJOR.MINOR.PATCH

### Phasen

- **0.x.y** — In Entwicklung, noch nicht stabil
  - 0.1.0 = Erste funktionsfaehige Version
  - 0.x+1.0 = Neue Features oder signifikante Aenderungen
  - 0.x.y+1 = Bugfixes innerhalb einer Minor-Version
- **1.0.0** — Erster stabiler Release. Kriterien:
  - Auf allen relevanten Hosts getestet
  - Alle bekannten Bugs gefixt
  - Dokumentiert (CHANGELOG, Help-Text, Header)
  - Zugehoeriges Roadmap-Projekt offiziell abgeschlossen
- **1.x.y+** — Normales SemVer nach stabilem Release
  - MAJOR: Breaking Changes (Aufruf-Syntax, Konfiguration)
  - MINOR: Neue Features, rueckwaertskompatibel
  - PATCH: Bugfixes, kosmetische Aenderungen

### Script-Konventionen

1. Version als Variable im Konfigurations-Block:
   `set script_version "X.Y.Z"`
2. Ueberall `$script_version` referenzieren — KEINE hardcoded Versionsnummern
3. Header-Kommentar verweist auf Variable:
   `# Version: siehe $script_version`
4. CHANGELOG im zugehoerigen Repo dokumentiert jede Versionsaenderung

### Aktuelle Script-Versionen (Stand: 2026-02-25)

| Script | Repo | Version | Status |
|--------|------|---------|--------|
| deploy.fish | Secrets | 0.3.0 | In Entwicklung |
| pack-secrets.fish | Hauptrepo | 0.1.0 | In Entwicklung |
| unpack-secrets.fish | Hauptrepo | 0.2.0 | In Entwicklung |
| derive_key.fish | Hauptrepo | 0.2.0 | In Entwicklung |

Kriterien fuer 1.0.0: A1 Phase 3 komplett abgeschlossen, alle Hosts deployed + verifiziert.
