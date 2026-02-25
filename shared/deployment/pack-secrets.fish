#!/usr/bin/env fish
# ============================================
# pack-secrets.fish - Secrets-Archiv packen
# Pfad: /mr-bytez/shared/deployment/pack-secrets.fish
# Autor: MR-ByteZ
# Erstellt: 2026-02-25
# Version: 1.0.0
# Zweck: mrohwer/ → mrohwer.tar → mrohwer.tar.age
# ============================================

# ── Konfiguration ────────────────────────────

set script_name (basename (status filename))
set secrets_dir /mr-bytez/.secrets
set source_dir mrohwer
set tar_file mrohwer.tar
set age_file mrohwer.tar.age

# ── Hilfsfunktionen ─────────────────────────

function _msg
    set_color cyan
    echo "→ $argv"
    set_color normal
end

function _success
    set_color green
    echo "✅ $argv"
    set_color normal
end

function _error
    set_color red
    echo "❌ $argv" >&2
    set_color normal
end

function _warn
    set_color yellow
    echo "⚠️  $argv"
    set_color normal
end

# ── Usage ────────────────────────────────────

function _usage
    echo ""
    echo "Verwendung: fish $script_name [OPTIONEN]"
    echo ""
    echo "Packt mrohwer/ in ein verschluesseltes Age-Archiv (mrohwer.tar.age)."
    echo ""
    echo "Optionen:"
    echo "  --secrets-dir PFAD   Secrets-Repo Verzeichnis (Standard: $secrets_dir)"
    echo "  --dry-run            Nur validieren, nicht packen"
    echo "  --help               Diese Hilfe anzeigen"
    echo ""
    echo "Workflow:"
    echo "  1. Validiert mrohwer/ Verzeichnis"
    echo "  2. Erstellt mrohwer.tar"
    echo "  3. Verschluesselt mit age (Passphrase-Eingabe)"
    echo "  4. Validiert Archiv"
    echo "  5. Raeumt tar-Zwischendatei auf"
    echo ""
    echo "Passphrase generieren:"
    echo "  fish derive_key.fish secrets --with-username"
    echo ""
end

# ── Argumente parsen ─────────────────────────

set dry_run false

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
        case --dry-run
            set dry_run true
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

# ── Voraussetzungen pruefen ──────────────────

echo ""
_msg "pack-secrets.fish v1.0.0"
echo ""

# Secrets-Verzeichnis pruefen
if not test -d "$secrets_dir"
    _error "Secrets-Verzeichnis nicht gefunden: $secrets_dir"
    exit 1
end

# In Secrets-Verzeichnis wechseln
cd "$secrets_dir"
_msg "Arbeitsverzeichnis: $secrets_dir"

# Source-Verzeichnis pruefen
if not test -d "$source_dir"
    _error "Quellverzeichnis nicht gefunden: $secrets_dir/$source_dir"
    echo "  Tipp: Erst Secrets in mrohwer/ einsortieren, dann packen."
    exit 1
end

# Inhalt pruefen — mindestens eine Datei muss existieren
set file_count (find "$source_dir" -type f 2>/dev/null | wc -l | string trim)
if test "$file_count" -eq 0
    _error "Quellverzeichnis ist leer: $secrets_dir/$source_dir"
    exit 1
end

_success "Quellverzeichnis: $source_dir/ ($file_count Dateien)"

# age verfuegbar?
if not command -q age
    _error "age nicht installiert! (pacman -S age)"
    exit 1
end

# ── Bestehendes Archiv pruefen ───────────────

if test -f "$age_file"
    _warn "Bestehendes Archiv gefunden: $age_file"
    set old_size (command du -h "$age_file" | cut -f1)
    echo "  Groesse: $old_size"
    echo ""

    read -P "Ueberschreiben? [j/N] " confirm
    if test "$confirm" != j; and test "$confirm" != J
        _msg "Abgebrochen."
        exit 0
    end
    echo ""
end

# ── Dry-Run Modus ────────────────────────────

if test "$dry_run" = true
    _msg "Dry-Run — Verzeichnisstruktur:"
    echo ""
    find "$source_dir" -type f | sort | while read -l f
        echo "  $f"
    end
    echo ""
    _success "Validierung OK — $file_count Dateien wuerden gepackt"
    exit 0
end

# ── Schritt 1: tar erstellen ─────────────────

_msg "Erstelle Archiv: $tar_file"

# Alte Zwischendateien aufraeumen
if test -f "$tar_file"
    rm "$tar_file"
end

tar -cf "$tar_file" "$source_dir"
if test $status -ne 0
    _error "tar fehlgeschlagen!"
    exit 1
end

set tar_size (command du -h "$tar_file" | cut -f1)
_success "tar erstellt ($tar_size)"

# ── Schritt 2: tar validieren ────────────────

_msg "Validiere Archiv..."

set tar_count (tar -tf "$tar_file" | command grep -c -v '/$')
if test "$tar_count" -ne "$file_count"
    _error "Archiv-Validierung fehlgeschlagen! Erwartet: $file_count Dateien, Gefunden: $tar_count"
    rm "$tar_file"
    exit 1
end

_success "Archiv validiert ($tar_count Dateien)"

# ── Schritt 3: Age-Verschluesselung ─────────

echo ""
_msg "Verschluessele mit age (Passphrase-Modus)..."
echo "  Tipp: Passphrase generieren mit: fish derive_key.fish secrets --with-username"
echo ""

# Alte .age-Datei entfernen falls vorhanden
if test -f "$age_file"
    rm "$age_file"
end

age -p -o "$age_file" "$tar_file"
if test $status -ne 0
    _error "age-Verschluesselung fehlgeschlagen!"
    rm -f "$tar_file"
    exit 1
end

if not test -f "$age_file"
    _error "Age-Datei wurde nicht erstellt!"
    rm -f "$tar_file"
    exit 1
end

set age_size (command du -h "$age_file" | cut -f1)
_success "Verschluesselt: $age_file ($age_size)"

# ── Schritt 4: Aufraumen ────────────────────

_msg "Raeume tar-Zwischendatei auf..."
rm "$tar_file"
_success "Aufgeraeumt"

# ── Zusammenfassung ──────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
_success "Archiv erfolgreich erstellt!"
echo ""
echo "  Datei:    $secrets_dir/$age_file"
echo "  Groesse:  $age_size"
echo "  Dateien:  $file_count"
echo ""
echo "  Naechste Schritte:"
echo "    cd $secrets_dir"
echo "    git add $age_file"
echo "    git commit -m '[Secrets] Archiv aktualisiert'"
echo "    git push origin main; git push codeberg main"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
