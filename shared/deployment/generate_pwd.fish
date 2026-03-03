#!/usr/bin/env fish
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ — generate_pwd.fish                                             ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     shared/deployment/generate_pwd.fish                             ║
# ║  Autor:    MR-ByteZ                                                        ║
# ║  Version:  0.1.0                                                           ║
# ║  Erstellt: 2025-01-20                                                      ║
# ║  Aktualisiert: 2026-03-03                                                  ║
# ║  Zweck:    Interaktives Passwort-Generator Tool fuer Secrets               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

function generate_pwd --description "🔐 Generiere sichere Passwörter in ~/.secrets"
    # Header
    set_color --bold cyan
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║       🔐  Passwort Generator für ~/.secrets  🔐         ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    # Basis-Verzeichnis prüfen
    if not test -d ~/.secrets
        set_color red
        echo "❌ Fehler: ~/.secrets existiert nicht!"
        set_color yellow
        echo "   Soll es angelegt werden? (j/n): "
        set_color normal
        read -P "" create_base
        if test "$create_base" = "j"
            mkdir -m 700 -p ~/.secrets
            set_color green
            echo "✅ ~/.secrets wurde erstellt"
            set_color normal
        else
            return 1
        end
    end

    # Ordner auflisten
    set_color cyan; echo "📁 Verfügbare Ordner in ~/.secrets:"; set_color normal
    echo ""
    
    set folders (find ~/.secrets -mindepth 1 -type d | sort)
    set folder_count (count $folders)
    
    if test $folder_count -eq 0
        set_color yellow
        echo "   Keine Unterordner vorhanden"
        set_color normal
    else
        for i in (seq $folder_count)
            set folder_path $folders[$i]
            set folder_name (string replace ~/.secrets/ "" $folder_path)
            set_color green
            echo "   [$i] $folder_name"
            set_color normal
        end
    end
    
    echo ""
    set_color yellow
    echo "   [n] Neuen Ordner anlegen"
    set_color normal
    echo ""

    # Ordner auswählen
    set_color cyan
    read -P "🎯 Wähle einen Ordner (Nummer oder 'n'): " choice
    set_color normal

    if test "$choice" = "n"
        # Neuen Ordner anlegen
        set_color cyan
        read -P "📂 Pfad innerhalb von ~/.secrets (z.B. cloud/hetzner): " new_folder
        set_color normal
        
        set target_dir ~/.secrets/$new_folder
        
        if not test -d $target_dir
            mkdir -m 700 -p $target_dir
            # Alle Parent-Ordner einzeln auf 700 setzen
            set parts (string split / $new_folder)
            set current ""
            for part in $parts
                set current "$current$part"
                chmod 700 ~/.secrets/$current
                set current "$current/"
            end
            set_color green
            echo "✅ Ordner erstellt: $new_folder"
            set_color normal
        else
            set_color yellow
            echo "⚠️  Ordner existiert bereits: $new_folder"
            set_color normal
        end
    else if test "$choice" -ge 1 -a "$choice" -le $folder_count 2>/dev/null
        # Bestehenden Ordner wählen
        set target_dir $folders[$choice]
        set folder_name (string replace ~/.secrets/ "" $target_dir)
        set_color green
        echo "✅ Gewählt: $folder_name"
        set_color normal
    else
        set_color red
        echo "❌ Ungültige Auswahl!"
        set_color normal
        return 1
    end

    echo ""

    # Dateinamen abfragen
    set_color cyan
    read -P "📄 Dateiname für das Secret: " filename
    set_color normal

    if test -z "$filename"
        set_color red
        echo "❌ Kein Dateiname angegeben!"
        set_color normal
        return 1
    end

    set secret_file $target_dir/$filename

    # Prüfen ob Datei existiert
    if test -f $secret_file
        set_color yellow
        echo "⚠️  Datei existiert bereits: $secret_file"
        read -P "   Überschreiben? (j/n): " overwrite
        set_color normal
        if test "$overwrite" != "j"
            set_color cyan
            echo "ℹ️  Abgebrochen"
            set_color normal
            return 0
        end
    end

    # Passwort generieren
    set_color green
    echo "🔐 Generiere sicheres Passwort..."
    set_color normal
    
    tr -dc 'a-zA-Z0-9!$%()=?+#\-.:~*@\[\]_' < /dev/urandom | head -c 50 > $secret_file
    chmod 600 $secret_file

    # Erfolg
    echo ""
    set_color --bold green
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    ✅ Erfolgreich! ✅                      ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""
    set_color cyan
    echo "📍 Speicherort:"
    set_color normal
    echo "   $secret_file"
    echo ""
    set_color cyan
    echo "🔑 Passwort:"
    set_color yellow
    echo "   "(cat $secret_file)
    set_color normal
    echo ""
    set_color cyan
    echo "🔒 Permissions: 600 (read/write nur Owner)"
    set_color normal
    echo ""
end
# Script ausführen
generate_pwd
