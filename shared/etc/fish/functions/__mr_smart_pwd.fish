# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Function                              │
# └─────────────────────────────────────────────────────────┘
# Datei:       __mr_smart_pwd.fish
# Pfad:        shared/etc/fish/functions/__mr_smart_pwd.fish
# Autor:       MR-ByteZ
# Version:     0.3.1
# Erstellt:    2026-01-25
# Aktualisiert:2026-02-28
# Zweck:       Intelligente Pfadkuerzung fuer Prompt
# Abh.:        Keine

function __mr_smart_pwd
    # Theme-Variablen (Defaults)
    set -l first_full 1
    set -l last_full 2
    set -l mid_length 3

    # Theme-Overrides
    if set -q MR_PWD_FIRST_FULL
        set first_full $MR_PWD_FIRST_FULL
    end
    if set -q MR_PWD_LAST_FULL
        set last_full $MR_PWD_LAST_FULL
    end
    if set -q MR_PWD_MID_LENGTH
        set mid_length $MR_PWD_MID_LENGTH
    end

    # Home ersetzen
    set -l current_path (pwd | string replace $HOME '~')

    # In Teile splitten und leere filtern
    set -l all_parts (string split '/' $current_path)
    set -l parts
    for p in $all_parts
        if test -n "$p"
            set -a parts $p
        end
    end

    set -l count (count $parts)

    # Kurze Pfade: nicht kürzen
    set -l min_parts (math "$first_full + $last_full + 1")
    if test $count -le $min_parts
        echo $current_path
        return
    end

    # Ergebnis zusammenbauen
    set -l result
    for i in (seq 1 $count)
        set -l part $parts[$i]

        # Position von Anfang und Ende
        set -l from_start $i
        set -l from_end (math "$count - $i + 1")

        if test $from_start -le $first_full
            # Erste N: voll
            set -a result $part
        else if test $from_end -le $last_full
            # Letzte N: voll
            set -a result $part
        else
            # Mitte: kürzen
            set -a result (string sub -l $mid_length $part)
        end
    end

    # Zusammenfügen
    if string match -q '~*' $current_path
        echo (string join '/' $result)
    else
        echo "/"(string join '/' $result)
    end
end
