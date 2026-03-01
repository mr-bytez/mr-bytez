# 🌐 MR-ByteZ DNS Handoff – Hetzner Console API + Wildcard Setup

**Chat:** MR-ByteZ - [DNS] - Hetzner Console API Setup hcloud CLI - Wildcard *.mr-bytez.de A AAAA Records LetsEncrypt Traefik ACME DNS-01 TTL Optimierung Backup
**Datum:** 2026-02-09
**Aktualisiert:** 2026-03-01
**Status:** 🟡 DNS erledigt — Optimierung wartet auf Traefik
**Delegation:** Teilweise Claude Code (TTL/PTR Befehle), teilweise manuell (Hetzner Robot)

---

## 📋 Zusammenfassung

In diesem Chat wurde die DNS-Infrastruktur fuer mr-bytez.de vollstaendig ueber die Hetzner Console API
eingerichtet. Ziel war die Vorbereitung fuer Traefik Reverse Proxy mit Let's Encrypt Wildcard-Zertifikaten
via DNS-01 Challenge.

**Update 2026-03-01:** Traefik-Setup-Tasks in eigenen Handoff ausgelagert:
→ `HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md`

---

## ✅ Was wurde erledigt

### 1. hcloud CLI Installation & Konfiguration (n8-kiste)

- **Paket:** `hcloud` v1.61.0 via `sudo pacman -S hcloud`
- **Context:** `mr-bytez-dns-management` erstellt und aktiviert
- **Config:** `~/.config/hcloud/cli.toml`
- **API-Token:** `mr-bytez-dns-management.secret` (erstellt 2026-02-09)
- **Token-Speicherort:** `~/.secrets/c/h/servers/dedicated/mr-bytez-dns-management.secret`

### 2. DNS Wildcard Records erstellt

Wildcard A + AAAA Records fuer `*.mr-bytez.de` → n8-vps:

| Record | Typ | Wert | TTL | Ziel |
|--------|-----|------|-----|------|
| `*.mr-bytez.de` | A | `136.243.101.223` | 300 | n8-vps |
| `*.mr-bytez.de` | AAAA | `2a01:4f8:171:ad1::2` | 300 | n8-vps |

### 3. TTLs auf 300s gesetzt

Alle bestehenden Records wurden temporaer auf TTL 300s (5 Min) gesetzt fuer schnelle Aenderungen
waehrend der Aufbauphase. **Spaeter auf 3600s hochsetzen wenn alles stabil laeuft!**

### 4. DNS Backup erstellt

- **Datei:** `~/mr-bytez-dns-backup-2026-02-09.json`
- **Inhalt:** Vollstaendiger JSON-Export aller DNS Records vor Aenderungen

### 5. CAA Records gesetzt

- `0 issue letsencrypt.org` — Erlaubt LE fuer Einzel-Zertifikate
- `0 issuewild letsencrypt.org` — Erlaubt LE fuer Wildcard-Zertifikate

### 6. Hetzner Console Migration

- Alte DNS Console (`dns.hetzner.com`) → Neue Hetzner Console (`api.hetzner.cloud`)
- Migration abgeschlossen, alte API nicht mehr noetig

---

## 🗺️ Aktuelle DNS-Architektur

### IP-Zuordnung

| Host | IPv4 | IPv6 | Zweck |
|------|------|------|-------|
| **Webhosting** | `78.47.47.61` | `2a01:4f8:d0a:4398::2` | Website mr-bytez.de |
| **n8-vps (EX63)** | `136.243.101.223` | `2a01:4f8:171:ad1::2` | Traefik, Docker Services |

### DNS-Record Uebersicht (Stand 2026-02-09)

| Name | Typ | Wert | Ziel-Host | TTL |
|------|-----|------|-----------|-----|
| `@` | A | `78.47.47.61` | Webhosting | 300 |
| `@` | AAAA | `2a01:4f8:d0a:4398::2` | Webhosting | 300 |
| `www` | A | `78.47.47.61` | Webhosting | 300 |
| `www` | AAAA | `2a01:4f8:d0a:4398::2` | Webhosting | 300 |
| `*` | A | `136.243.101.223` | n8-vps | 300 |
| `*` | AAAA | `2a01:4f8:171:ad1::2` | n8-vps | 300 |
| `autoconfig` | CNAME | `mail.your-server.de.` | Hetzner Mail | 300 |
| `@` | MX | `10 www545.your-server.de.` | Hetzner Mail | 300 |
| `@` | TXT | `v=spf1 mx -all` | SPF | 300 |
| `default2601._domainkey` | TXT | DKIM Public Key | DKIM | 300 |
| `_dmarc` | TXT | `v=DMARC1;p=quarantine;...` | DMARC | 300 |
| `@` | CAA | `0 issue letsencrypt.org` | Let's Encrypt | 300 |
| `@` | CAA | `0 issuewild letsencrypt.org` | Wildcard Certs | 300 |
| `_autodiscover._tcp` | SRV | `0 100 443 mail.your-server.de.` | Mail | 300 |
| `_imaps._tcp` | SRV | `0 100 993 mail.your-server.de.` | IMAP | 300 |
| `_pop3s._tcp` | SRV | `0 100 995 mail.your-server.de.` | POP3 | 300 |
| `_submission._tcp` | SRV | `0 100 587 mail.your-server.de.` | SMTP | 300 |

### Nameserver

- `ns1.your-server.de.` (konsoleH)
- `ns.second-ns.com.` (konsoleH)
- `ns3.second-ns.de.` (konsoleH)
- **Delegation Status:** ✅ valid
- **Registrar:** Hetzner

---

## 🔧 Hetzner API Infrastruktur

### API-Versionen

| | Alte DNS Console | Neue Hetzner Console |
|---|---|---|
| **API** | `dns.hetzner.com/api/v1` | `api.hetzner.cloud/v1` |
| **CLI** | Kein offizielles CLI | `hcloud` CLI |
| **Auth** | `Auth-API-Token` Header | `Authorization: Bearer` |
| **Status** | ⛔ Deprecated, Ende Mai 2026 | ✅ Aktiv |

### Zone-Info

- **Zone ID:** 514609
- **Zone Name:** mr-bytez.de
- **Mode:** primary
- **Record Count:** 18
- **Zone Status:** ok
- **Erstellt:** 2026-01-13

### Vorhandene API-Tokens

| Token-Datei | Zweck | Erstellt |
|-------------|-------|---------|
| `mr-bytez-dns-management.secret` | hcloud CLI + Traefik ACME | 2026-02-09 |
| `n8-vps_console_api_token.secret` | Hetzner Console API (alt?) | 2026-01-08 |
| `n8-vps_dns_manage_token.secret` | Alter DNS Console Token? | 2026-01-08 |

**Token-Speicherort:** `~/.secrets/c/h/servers/dedicated/`

---

## 📝 Wichtige hcloud CLI Befehle

```fish
# Zone auflisten
hcloud zone list

# Zone Details
hcloud zone describe mr-bytez.de -o json | python3 -m json.tool

# Alle Records auflisten
hcloud zone rrset list mr-bytez.de
hcloud zone rrset list mr-bytez.de -o json | python3 -m json.tool

# Record erstellen
hcloud zone rrset create --name 'subdomain' --type A --ttl 300 --record '1.2.3.4' mr-bytez.de

# Record loeschen
hcloud zone rrset delete mr-bytez.de 'subdomain' A

# TTL aendern
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de '@' A

# Records eines RRSets setzen (ueberschreiben)
hcloud zone rrset set-records --record '1.2.3.4' mr-bytez.de 'subdomain' A

# Records hinzufuegen
hcloud zone rrset add-records --record '5.6.7.8' mr-bytez.de 'subdomain' A

# Hilfe
hcloud zone rrset --help
hcloud zone rrset create --help
```

---

## ⏳ Offene Punkte / Naechste Schritte

### ~~Prioritaet 1: Traefik Setup~~ → AUSGELAGERT

**Ausgelagert in:** `HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md`
- API-Token Age-Verschluesselung (D3)
- Traefik docker-compose.yml (D14)
- Token als Docker Secret
- Wildcard-Zertifikat testen

### Prioritaet 2: DNS Optimierung (NACH Traefik-Stabilisierung)

- [ ] TTLs auf 3600s hochsetzen (D1) — **Bedingung:** Traefik + Wildcard-Cert stabil
- [ ] PTR-Record fuer `136.243.101.223` → `mr-bytez.de` in Hetzner Robot setzen (D2)
- [ ] PTR-Record fuer IPv6 setzen (D2)
- [ ] HTTPS-Record (optional, beschleunigt Verbindungsaufbau)

**Befehle fuer TTL-Hochsetzung:**
```fish
# Alle Records auf 3600s setzen (einzeln pro Record-Typ)
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de '@' A
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de '@' AAAA
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de 'www' A
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de 'www' AAAA
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de '*' A
hcloud zone rrset change-ttl --ttl 3600 mr-bytez.de '*' AAAA
# ... weitere Records analog
```

**PTR-Record:** Muss im Hetzner Robot Web-Interface gesetzt werden (nicht ueber hcloud CLI).
→ Robot → Server → IPs → Reverse DNS

### Prioritaet 3: Aufraeumen (D4)

- [ ] Alte API-Tokens pruefen (`n8-vps_console_api_token.secret`, `n8-vps_dns_manage_token.secret`)
- [ ] Nicht mehr benoetigte Tokens loeschen
- [ ] DNS Backup-Strategie (regelmaessig JSON-Export)

---

## ⚠️ Wichtige Hinweise

1. **TTLs sind aktuell auf 300s** — nach Stabilisierung auf 3600s hochsetzen!
2. **`www` Record beibehalten** — auch wenn Wildcard greift, explizit ist sicherer
3. **Wildcard matcht keine Sub-Subdomains** — `*.mr-bytez.de` matcht `traefik.mr-bytez.de` aber NICHT `api.staging.mr-bytez.de`
4. **CAA Records vorhanden** — `issue` und `issuewild` fuer `letsencrypt.org` sind gesetzt
5. **Hetzner Console Migration** bereits abgeschlossen — alte DNS Console nicht mehr noetig
6. **DNS Backup** liegt unter `~/mr-bytez-dns-backup-2026-02-09.json`

---

## 🔗 Referenzen

- **Traefik-Handoff:** `.claude/context/handoffs/HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md`
- **Hetzner Console:** https://console.hetzner.com
- **Cloud API Docs:** https://docs.hetzner.cloud/reference/cloud
- **DNS Migration Guide:** https://docs.hetzner.com/networking/dns/migration-to-hetzner-console/process/
- **hcloud CLI GitHub:** https://github.com/hetznercloud/cli
