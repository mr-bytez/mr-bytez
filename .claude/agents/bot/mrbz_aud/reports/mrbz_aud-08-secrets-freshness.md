# mrbz_aud — Modul 08: Secrets Freshness

**Datum:** 2026-03-06
**Status:** OK

## Zusammenfassung

Timestamp-Vergleich aller .age-Dateien mit ihren entpackten Gegenstuecken durchgefuehrt.
Das zentrale Archiv `mrohwer.tar.age` ist neuer als alle entpackten Dateien — alle
Aenderungen sind korrekt gepackt. Keine ungesicherten Aenderungen gefunden.

## Analyse

### Archiv-Modell

Das Secrets-Repo nutzt ein Archiv-Modell: Alle entpackten Dateien unter `mrohwer/` werden
in `mrohwer.tar.age` gepackt. Einzelne `.age`-Dateien sind Sonderfaelle.

### mrohwer.tar.age (Haupt-Archiv)

| Eigenschaft | Wert |
|-------------|------|
| Timestamp | 2026-03-04 23:00:27 |
| Epoch | 1772661627 |
| Status | Neuer als alle entpackten Dateien |

### Neueste entpackte Dateien (Top 5)

| Timestamp | Datei | Delta zum Archiv |
|-----------|-------|-----------------|
| 2026-03-04 22:58:25 | `.../crowdsec/crowdsec_traefik_bouncer_api_key.secret` | +2 Min (Archiv neuer) |
| 2026-03-04 22:35:59 | `.../crowdsec/crowdsec_account_password.secret` | +24 Min (Archiv neuer) |
| 2026-03-04 22:34:31 | `.../crowdsec/crowdsec_account_email.secret` | +26 Min (Archiv neuer) |
| 2026-03-04 21:52:14 | `.../crowdsec/crowdsec_firewall_bouncer_api_key.secret` | +68 Min (Archiv neuer) |
| 2026-03-03 16:17:31 | `.../traefik/traefik-dashboard-auth.info` | +1 Tag (Archiv neuer) |

Alle entpackten Dateien sind aelter als das Archiv — korrekt gepackt.

### Einzelne .age-Datei

| Datei | .age Timestamp | Entpackt | Status |
|-------|---------------|----------|--------|
| `edge_browser_passwords.ods.age` | 2026-02-25 01:23:56 | Nicht vorhanden | Kein Gegenstueck (bereits in Modul 07 dokumentiert) |

Diese Datei wird bewusst nur bei Bedarf entschluesselt — kein Finding.

### Aelteste entpackte Dateien

| Timestamp | Datei |
|-----------|-------|
| 2026-02-24 23:09:18 | `.../shared/home/mrohwer/.gitconfig` |
| 2026-02-25 00:58:14 | `.../shared/home/mrohwer/.ssh/id_ed25519_codeberg.pub` |
| 2026-02-25 00:58:14 | `.../shared/home/mrohwer/.ssh/id_ed25519_github.pub` |

Alle aelter als das Archiv — korrekt.

## Findings

Keine Findings. Alle entpackten Dateien sind aelter als `mrohwer.tar.age`.
Es gibt keine ungesicherten Aenderungen die verloren gehen koennten.

## Statistik

- Gepruefte .age-Dateien: 2 (mrohwer.tar.age, edge_browser_passwords.ods.age)
- Gepruefte entpackte Dateien: 95
- Findings: 0 (0 KRITISCH, 0 MITTEL, 0 INFO, 0 NEEDS_REVIEW)
