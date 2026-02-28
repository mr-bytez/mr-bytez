#!/usr/bin/env fish
# ============================================
# unpack-secrets.fish — Secrets-Archiv entpacken
# Pfad: /mr-bytez/shared/deployment/unpack-secrets.fish
# Autor: MR-ByteZ
# Erstellt: 2026-02-25
# Version: siehe $script_version
# Zweck: mrohwer.tar.age → mrohwer.tar → mrohwer/
# ============================================

# ── Format-Library laden ───────────────────

set -l format_path /mr-bytez/shared/lib/format.fish
if test -f "$format_path"
    source "$format_path"
else
    # Fallback ueber Anker
    set -l format_anchor /opt/mr-bytez/current/shared/lib/format.fish
    if test -f "$format_anchor"
        source "$format_anchor"
    end
end

# ── Konfiguration ────────────────────────────

set script_name (basename (status filename))
set script_version "0.2.0"
set secrets_dir /mr-bytez/.secrets
set source_dir mrohwer
set tar_file mrohwer.tar
set age_file mrohwer.tar.age

# ── Hilfsfunktionen (aus format.fish, Fallback falls nicht verfuegbar) ─────

if not type -q _msg
    function _msg; set_color cyan; echo "→ $argv"; set_color normal; end
    function _success; set_color green; echo "✅ $argv"; set_color normal; end
    function _error; set_color red; echo "❌ $argv" >&2; set_color normal; end
    function _warn; set_color yellow; echo "⚠️  $argv"; set_color normal; end
end

# ── Usage ────────────────────────────────────

function _usage
    echo ""
    echo "Verwendung: fish $script_name [OPTIONEN]"
    echo ""
    echo "Entpackt das verschluesselte Age-Archiv (mrohwer.tar.age) nach mrohwer/."
    echo ""
    echo "Optionen:"
    echo "  --secrets-dir PFAD   Secrets-Repo Verzeichnis (Standard: $secrets_dir)"
    echo "  --keep-tar           tar-Zwischendatei nicht loeschen"
    echo "  --help               Diese Hilfe anzeigen"
    echo ""
    echo "Workflow:"
    echo "  1. Entschluesselt mrohwer.tar.age → mrohwer.tar"
    echo "  2. Entpackt mrohwer.tar → mrohwer.tmp/"
    echo "  3. Validiert entpackte Dateien"
    echo "  4. Erst bei Erfolg: altes mrohwer/ ersetzen"
    echo "  5. Raeumt tar-Zwischendatei auf"
    echo ""
    echo "Passphrase generieren:"
    echo "  fish derive_key.fish secrets --with-username"
    echo ""
end

# ── Argumente parsen ─────────────────────────

set keep_tar false

set i 1
while test $i -le (count $argv)
    switch $argv[$i]
        case --secrets-dir
            set i (math $i + 1)
            if test $i -le (count $argv)
                set secrets_dir $argv[$i]
            else
                _error "Fehler: --secrets-dir benoetigt einen Pfad"
                exit 1
            end
        case --keep-tar
            set keep_tar true
        case --help -h
            _usage
            exit 0
        case '*'
            _error "Unbekannte Option: $argv[$i]"
            _usage
            exit 1
    end
    set i (math $i + 1)
end

# ── Banner ───────────────────────────────────

echo ""
if type -q mr_bytez_banner
    mr_bytez_banner
    echo ""
    set_color brblack
    echo "  unpack-secrets.fish v$script_version"
    echo "  Verschluesseltes Age-Archiv entpacken"
    set_color normal
else
    _msg "unpack-secrets.fish v$script_version"
    set_color brblack
    echo "  Verschluesseltes Age-Archiv entpacken"
    set_color normal
end
echo ""

# ── Voraussetzungen pruefen ──────────────────

# Secrets-Verzeichnis pruefen
if not test -d "$secrets_dir"
    _error "Secrets-Verzeichnis nicht gefunden: $secrets_dir"
    exit 1
end

# In Secrets-Verzeichnis wechseln
cd "$secrets_dir"
_msg "Arbeitsverzeichnis: $secrets_dir"

# Age-Datei pruefen
if not test -f "$age_file"
    _error "Archiv nicht gefunden: $secrets_dir/$age_file"
    echo "  Tipp: Erst mit pack-secrets.fish ein Archiv erstellen."
    exit 1
end

set age_size (command du -h "$age_file" | cut -f1)
_success "Archiv gefunden: $age_file ($age_size)"

# age verfuegbar?
if not command -q age
    _error "age nicht installiert! (pacman -S age)"
    exit 1
end

# ── Bestehendes mrohwer/ pruefen ─────────────

set has_existing false
if test -d "$source_dir"
    set existing_count (find "$source_dir" -type f 2>/dev/null | wc -l | string trim)
    if test "$existing_count" -gt 0
        set has_existing true
        _warn "Bestehendes Verzeichnis gefunden: $source_dir/ ($existing_count Dateien)"
        echo ""
        read -P "Ueberschreiben? [j/N] " confirm
        if test "$confirm" != j; and test "$confirm" != J
            _msg "Abgebrochen."
            exit 0
        end
        echo ""
    end
end

# ── Schritt 1: Age-Entschluesselung ─────────
# WICHTIG: Erst entschluesseln + entpacken in temp, DANN altes Verzeichnis ersetzen
# So gehen bei falscher Passphrase keine Daten verloren!

_msg "Entschluessele Archiv..."
echo "  Tipp: Passphrase generieren mit: fish derive_key.fish secrets --with-username"
echo ""

# Alte Zwischendateien aufraeumen
if test -f "$tar_file"
    rm "$tar_file"
end

age -d -o "$tar_file" "$age_file"
if test $status -ne 0
    _error "Entschluesselung fehlgeschlagen! Falsche Passphrase?"
    rm -f "$tar_file"
    exit 1
end

if not test -f "$tar_file"
    _error "tar-Datei wurde nicht erstellt!"
    exit 1
end

set tar_size (command du -h "$tar_file" | cut -f1)
_success "Entschluesselt: $tar_file ($tar_size)"

# ── Schritt 2: In temp-Verzeichnis entpacken ──

set temp_dir "$source_dir.tmp"

# Altes temp aufraeumen falls vorhanden
if test -d "$temp_dir"
    rm -rf "$temp_dir"
end

_msg "Entpacke Archiv in temporaeres Verzeichnis..."

# tar entpackt nach mrohwer/ — wir entpacken in temp und benennen um
mkdir -p "$temp_dir"
tar -xf "$tar_file" -C "$temp_dir" --strip-components=1
if test $status -ne 0
    _error "tar entpacken fehlgeschlagen!"
    rm -rf "$temp_dir"
    rm -f "$tar_file"
    exit 1
end

set file_count (find "$temp_dir" -type f 2>/dev/null | wc -l | string trim)
if test "$file_count" -eq 0
    _error "Temporaeres Verzeichnis ist leer!"
    rm -rf "$temp_dir"
    rm -f "$tar_file"
    exit 1
end

_success "Entpackt: $temp_dir/ ($file_count Dateien)"

# ── Schritt 3: Validierung ──────────────────

_msg "Validiere entpackte Dateien..."

# tar-Inhalt gegen entpackte Dateien pruefen
set tar_count (tar -tf "$tar_file" | command grep -c -v '/$')
if test "$tar_count" -ne "$file_count"
    _error "Validierung fehlgeschlagen! Archiv: $tar_count Dateien, Entpackt: $file_count"
    rm -rf "$temp_dir"
    rm -f "$tar_file"
    exit 1
end

_success "Validierung OK ($file_count Dateien)"

# ── Schritt 4: Altes Verzeichnis ersetzen ────
# Erst JETZT (nach erfolgreicher Validierung) das alte Verzeichnis loeschen

if test "$has_existing" = true
    _msg "Ersetze bestehendes $source_dir/ durch neue Version..."
    rm -rf "$source_dir"
end

mv "$temp_dir" "$source_dir"
if test $status -ne 0
    _error "Konnte $temp_dir nicht nach $source_dir verschieben!"
    exit 1
end

_success "Verzeichnis $source_dir/ aktualisiert"

# ── Schritt 5: Aufraumen ────────────────────

if test "$keep_tar" = true
    _msg "tar-Zwischendatei behalten: $tar_file ($tar_size)"
else
    _msg "Raeume tar-Zwischendatei auf..."
    rm "$tar_file"
    _success "Aufgeraeumt"
end

# ── Zusammenfassung ──────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
_success "Archiv erfolgreich entpackt!"
echo ""
echo "  Verzeichnis:  $secrets_dir/$source_dir/"
echo "  Dateien:      $file_count"
echo ""
echo "  Naechste Schritte:"
echo "    fish /mr-bytez/.secrets/deploy.fish"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
