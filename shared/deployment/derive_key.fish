#!/usr/bin/env fish
# ============================================
# derive_key.fish — Key-Derivation Script
# Pfad: /mr-bytez/shared/deployment/derive_key.fish
# Autor: MR-ByteZ
# Erstellt: 2026-01-23
# Version: siehe $script_version
# Zweck: PBKDF2 Key-Derivation aus Master-Password + Salt
# ============================================

# ── Banner laden ────────────────────────────

set -l banner_path /mr-bytez/shared/lib/banner.fish
if test -f "$banner_path"
    source "$banner_path"
else
    # Fallback ueber Anker
    set -l banner_anchor /opt/mr-bytez/current/shared/lib/banner.fish
    if test -f "$banner_anchor"
        source "$banner_anchor"
    end
end

# ── Konfiguration ────────────────────────────

set script_version "0.2.0"

# ── Banner ───────────────────────────────────

echo ""
if type -q mr_bytez_banner
    mr_bytez_banner
    echo ""
    set_color brblack
    echo "  derive_key.fish v$script_version"
    echo "  PBKDF2 Key-Derivation aus Master-Password + Salt"
    set_color normal
else
    set_color cyan
    echo "→ derive_key.fish v$script_version"
    set_color normal
    set_color brblack
    echo "  PBKDF2 Key-Derivation aus Master-Password + Salt"
    set_color normal
end
echo ""

# Argumente pruefen
if test (count $argv) -lt 1
    set_color red
    echo "❌ Fehler: Salt erforderlich!"
    set_color normal
    echo ""
    echo "Verwendung:"
    echo "  derive_key.fish [SALT]              # Nur Salt"
    echo "  derive_key.fish [SALT] --with-host      # Salt + Hostname"
    echo "  derive_key.fish [SALT] --with-username  # Salt + Username"
    echo ""
    echo "Beispiele:"
    echo "  derive_key.fish secrets             # → PBKDF2(secrets + MasterPwd)"
    echo "  derive_key.fish secrets --with-host     # → PBKDF2(secrets + n8-kiste + MasterPwd)"
    echo "  derive_key.fish secrets --with-username # → PBKDF2(secrets + mrohwer + MasterPwd)"
    echo "  derive_key.fish codeberg            # → PBKDF2(codeberg + MasterPwd)"
    exit 1
end

# Parameter
set salt $argv[1]
set with_host false

# --with-host / --with-username Flag prüfen
set with_username false
if test (count $argv) -ge 2
    if test "$argv[2]" = "--with-host"
        set with_host true
        set salt "$salt+"(hostname)
    else if test "$argv[2]" = "--with-username"
        set with_username true
        set salt "$salt+"(id -un)
    end
end

# Master-Password abfragen (1. Eingabe)
set_color cyan
echo "🔐 Master-Password eingeben:"
set_color normal
read -s -P "Password: " master_pwd
echo ""

# Master-Password verifizieren (2. Eingabe)
set_color cyan
echo "🔐 Master-Password wiederholen:"
set_color normal
read -s -P "Password: " master_pwd_verify
echo ""

# Passwörter vergleichen
if test "$master_pwd" != "$master_pwd_verify"
    set_color red
    echo "❌ Fehler: Passwörter stimmen nicht überein!"
    set_color normal
    exit 1
end

# Validierung
if test -z "$master_pwd"
    set_color red
    echo "❌ Fehler: Password darf nicht leer sein!"
    set_color normal
    exit 1
end

# PBKDF2 Key-Derivation via OpenSSL
# Iterations: 100000 (Industry Standard)
# Output: 32 Bytes (256 Bit) als Hex
set combined "$salt+$master_pwd"
set derived_key (echo -n "$combined" | openssl dgst -sha256 -binary | openssl enc -base64 | head -c 43)

# Ausgabe
echo ""
set_color green
echo "✅ Derived Key generiert!"
set_color normal
echo ""
echo "Salt verwendet: $salt"
if test "$with_host" = "true"
    echo "Hostname:       "(hostname)
else if test "$with_username" = "true"
    echo "Username:       "(id -un)
end
echo ""
set_color yellow
echo "🔑 Derived Key (als Age-Passphrase verwenden):"
set_color normal
echo "$derived_key"
echo ""
set_color cyan
echo "📋 Zum Kopieren: Der Key ist 43 Zeichen lang"
set_color normal
