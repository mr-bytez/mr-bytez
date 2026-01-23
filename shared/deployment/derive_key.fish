#!/usr/bin/env fish
# ============================================
# derive_key.fish - Key-Derivation Script
# Pfad: /mr-bytez/shared/deployment/derive_key.fish
# Autor: Michael Rohwer
# Erstellt: 2026-01-23
# Version: 1.1.0
# Zweck: PBKDF2 Key-Derivation aus Master-Password + Salt
# ============================================

# Argumente prüfen
if test (count $argv) -lt 1
    set_color red
    echo "❌ Fehler: Salt erforderlich!"
    set_color normal
    echo ""
    echo "Verwendung:"
    echo "  derive_key.fish [SALT]              # Nur Salt"
    echo "  derive_key.fish [SALT] --with-host  # Salt + Hostname"
    echo ""
    echo "Beispiele:"
    echo "  derive_key.fish secrets             # → PBKDF2(secrets + MasterPwd)"
    echo "  derive_key.fish secrets --with-host # → PBKDF2(secrets + n8-kiste + MasterPwd)"
    echo "  derive_key.fish codeberg            # → PBKDF2(codeberg + MasterPwd)"
    exit 1
end

# Parameter
set salt $argv[1]
set with_host false

# --with-host Flag prüfen
if test (count $argv) -ge 2
    if test "$argv[2]" = "--with-host"
        set with_host true
        set salt "$salt+"(hostname)
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
