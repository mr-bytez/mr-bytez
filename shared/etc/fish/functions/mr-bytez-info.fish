function mr-bytez-info --description "mr-bytez Fish-Config Info und Diagnose"
    # ═══════════════════════════════════════════════════════════════
    # mr-bytez-info - Zentrale Diagnose für Fish-Config
    # Version: 1.0
    # ═══════════════════════════════════════════════════════════════
    
    argparse "v/verbose" "a/aliases" "f/functions" "V/vars" "c/check" "s/structure" "h/help" -- $argv
    or return 1
    
    # Farben
    set -l C (set_color cyan)
    set -l G (set_color green)
    set -l Y (set_color yellow)
    set -l R (set_color red)
    set -l M (set_color magenta)
    set -l B (set_color blue)
    set -l D (set_color brblack)
    set -l N (set_color normal)
    set -l BOLD (set_color --bold)
    
    # Host und Pfade
    set -l host (hostname)
    set -l shared_base /mr-bytez/shared/etc/fish
    set -l host_base /mr-bytez/projects/infrastructure/$host/root/home/mrohwer/.config/fish
    
    # ─────────────────────────────────────────────────────────────────
    # HILFE
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_help
        echo ""
        echo "$BOLD$C""MR-BYTEZ-INFO$N - Fish-Config Diagnose und Übersicht"
        echo ""
        echo "$Y""SYNOPSIS$N"
        echo "    mr-bytez-info [OPTIONEN]"
        echo ""
        echo "$Y""BESCHREIBUNG$N"
        echo "    Zeigt alle geladenen Variablen, Aliases und Funktionen"
        echo "    für den aktuellen Host an. Prüft Struktur und Symlinks."
        echo ""
        echo "$Y""OPTIONEN$N"
        echo "    $G-h, --help$N       Diese Hilfe anzeigen"
        echo "    $G-v, --verbose$N    Ausführlich mit Beispielen"
        echo "    $G-a, --aliases$N    Nur Aliases anzeigen"
        echo "    $G-f, --functions$N  Nur Funktionen anzeigen"
        echo "    $G-V, --vars$N       Nur Variablen anzeigen"
        echo "    $G-c, --check$N      Symlink-Prüfung"
        echo "    $G-s, --structure$N  Struktur-Prüfung"
        echo ""
        echo "$Y""BEISPIELE$N"
        echo "    mr-bytez-info          # Komplette Übersicht"
        echo "    mr-bytez-info -v       # Mit Beispielen"
        echo "    mr-bytez-info -a -v    # Aliases mit Beispielen"
        echo "    mr-bytez-info --check  # Symlinks prüfen"
        echo ""
        echo "$Y""DATEIEN$N"
        echo "    Shared:  $shared_base/"
        echo "    Host:    $host_base/"
        echo ""
        return 0
    end
    
    # ─────────────────────────────────────────────────────────────────
    # HEADER
    # ─────────────────────────────────────────────────────────────────
    if not set -q _flag_aliases; and not set -q _flag_functions; and not set -q _flag_vars; and not set -q _flag_check; and not set -q _flag_structure
        echo ""
        echo "$BOLD$C""═══════════════════════════════════════════════════════════════$N"
        echo "$BOLD$C""  mr-bytez Fish-Config · Host: $Y$host$N"
        echo "$BOLD$C""═══════════════════════════════════════════════════════════════$N"
        echo ""
    end
    
    # ─────────────────────────────────────────────────────────────────
    # STRUKTUR-PRÜFUNG
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_structure; or not set -q _flag_aliases; and not set -q _flag_functions; and not set -q _flag_vars; and not set -q _flag_check
        if set -q _flag_structure
            echo ""
            echo "$BOLD$C""═══ STRUKTUR-PRÜFUNG ═══$N"
        else
            echo "$Y""📁 Struktur$N"
        end
        echo ""
        
        # Shared Pfade
        echo "  $B""Shared:$N"
        for dir in aliases variables functions completions conf.d themes
            if test -d $shared_base/$dir
                set count (count $shared_base/$dir/*.fish 2>/dev/null)
                echo "    $G✔$N $dir/ ($count Dateien)"
            else
                echo "    $R✘$N $dir/ (fehlt)"
            end
        end
        echo ""
        
        # Host Pfade
        echo "  $B""Host ($host):$N"
        if test -d $host_base
            for dir in aliases variables functions completions conf.d themes
                if test -d $host_base/$dir
                    set count (count $host_base/$dir/*.fish 2>/dev/null)
                    echo "    $G✔$N $dir/ ($count Dateien)"
                else
                    echo "    $D─$N $dir/ (leer)"
                end
            end
        else
            echo "    $R✘$N Host-Verzeichnis nicht gefunden!"
        end
        echo ""
    end
    
    # ─────────────────────────────────────────────────────────────────
    # SYMLINK-PRÜFUNG
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_check
        echo ""
        echo "$BOLD$C""═══ SYMLINK-PRÜFUNG ═══$N"
        echo ""
        
        # Wichtige Symlinks prüfen
        set -l links \
            "/etc/fish:$shared_base" \
            "$HOME/.config/fish/conf.d:$host_base/conf.d"
        
        for link_pair in $links
            set -l link (string split ":" $link_pair)[1]
            set -l target (string split ":" $link_pair)[2]
            
            if test -L $link
                set -l actual (readlink -f $link)
                if test "$actual" = "$target"
                    echo "  $G✔$N $link"
                    echo "    $D→ $target$N"
                else
                    echo "  $Y⚠$N $link"
                    echo "    $D→ $actual (erwartet: $target)$N"
                end
            else if test -d $link
                echo "  $Y⚠$N $link (Verzeichnis, kein Symlink)"
            else
                echo "  $R✘$N $link (fehlt)"
            end
        end
        
        echo ""
        
        # Loader prüfen
        echo "  $B""Loader:$N"
        if test -f $shared_base/conf.d/00-loader.fish
            echo "    $G✔$N 00-loader.fish vorhanden"
        else
            echo "    $R✘$N 00-loader.fish FEHLT!"
        end
        echo ""
        return 0
    end
    
    # ─────────────────────────────────────────────────────────────────
    # VARIABLEN
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_vars; or not set -q _flag_aliases; and not set -q _flag_functions; and not set -q _flag_check; and not set -q _flag_structure
        if set -q _flag_vars
            echo ""
            echo "$BOLD$C""═══ VARIABLEN ═══$N"
        else
            echo "$Y""📊 Variablen$N"
        end
        echo ""
        
        # Display Variablen
        echo "  $B""Display:$N"
        if set -q GDK_SCALE
            echo "    GDK_SCALE        = $G$GDK_SCALE$N"
        else
            echo "    GDK_SCALE        = $D(nicht gesetzt)$N"
        end
        if set -q QT_SCALE_FACTOR
            echo "    QT_SCALE_FACTOR  = $G$QT_SCALE_FACTOR$N"
        else
            echo "    QT_SCALE_FACTOR  = $D(nicht gesetzt)$N"
        end
        echo ""
        
        # mr-bytez Variablen
        echo "  $B""mr-bytez:$N"
        if set -q N8_HOST_TEST
            echo "    N8_HOST_TEST     = $G$N8_HOST_TEST$N"
        end
        if set -q FISH_LOADER_DEBUG
            echo "    FISH_LOADER_DEBUG = $G$FISH_LOADER_DEBUG$N"
        end
        echo ""
        
        if set -q _flag_verbose
            echo "  $D""Tipp: Display-Variablen aus variables/10-display.fish$N"
            echo ""
        end
    end
    
    # ─────────────────────────────────────────────────────────────────
    # ALIASES
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_aliases; or not set -q _flag_functions; and not set -q _flag_vars; and not set -q _flag_check; and not set -q _flag_structure
        if set -q _flag_aliases
            echo ""
            echo "$BOLD$C""═══ ALIASES ═══$N"
        else
            echo "$Y""⚡ Aliases$N"
        end
        echo ""
        
        # Shared Aliases (10-69)
        echo "  $B""Shared (alle Hosts):$N"
        echo "    $M""Navigation:$N"
        echo "      ..        $D→$N cd .."
        echo "      ...       $D→$N cd ../.."
        echo "      cdr       $D→$N cd /"
        echo "      cdhome    $D→$N cd ~"
        if set -q _flag_verbose
            echo "      $D# Schnelle Verzeichniswechsel$N"
        end
        echo ""
        
        echo "    $M""Eza (ls):$N"
        echo "      l         $D→$N eza -la"
        echo "      ll        $D→$N eza -l"
        echo "      la        $D→$N eza -a"
        echo "      lt        $D→$N eza --tree"
        if set -q _flag_verbose
            echo "      $D# Moderne ls-Alternative mit Icons$N"
        end
        echo ""
        
        echo "    $M""Docker:$N"
        echo "      dcu       $D→$N docker compose up -d"
        echo "      dcd       $D→$N docker compose down"
        echo "      dcr       $D→$N docker compose restart"
        echo "      dcp       $D→$N docker compose pull"
        echo "      dcl       $D→$N docker compose logs -f"
        if set -q _flag_verbose
            echo "      $D# Docker Compose Shortcuts$N"
            echo "      $D# Beispiel: cd /srv/stacks/traefik && dcu$N"
        end
        echo ""
        
        echo "    $M""Git:$N"
        echo "      gs        $D→$N git status"
        echo "      ga        $D→$N git add"
        echo "      gc        $D→$N git commit"
        echo "      gp        $D→$N git push"
        echo "      gl        $D→$N git pull"
        echo "      gd        $D→$N git diff"
        if set -q _flag_verbose
            echo "      $D# Git Workflow Shortcuts$N"
            echo "      $D# Beispiel: ga . && gc -m \"message\" && gp$N"
        end
        echo ""
        
        echo "    $M""Systemd:$N"
        echo "      scs       $D→$N systemctl status"
        echo "      scr       $D→$N systemctl restart"
        echo "      sce       $D→$N systemctl enable"
        echo "      jf        $D→$N journalctl -f"
        echo ""
        
        echo "    $M""Pacman:$N"
        echo "      pacs      $D→$N pacman -S"
        echo "      pacr      $D→$N pacman -R"
        echo "      pacq      $D→$N pacman -Q"
        echo "      yays      $D→$N yay -S"
        echo ""
        
        # Host-spezifische Aliases (70-89)
        echo "  $B""Host ($host):$N"
        
        # Kategorie-Aliases (70-79)
        switch $host
            case "n8-vps"
                echo "    $M""Server:$N"
                echo "      upa       $D→$N sudo pacman -Syu && yay -Syu"
                echo "      dps       $D→$N docker ps (formatiert)"
                echo "      dlogs     $D→$N docker logs -f"
                if set -q _flag_verbose
                    echo "      $D# Server ohne Flatpak$N"
                end
            case "*"
                echo "    $M""Desktop:$N"
                echo "      upa       $D→$N pacman + yay + flatpak update"
                echo "      upfl      $D→$N flatpak update"
                echo "      flathub   $D→$N flatpak remote-add"
                if set -q _flag_verbose
                    echo "      $D# Desktop mit Flatpak-Integration$N"
                end
        end
        echo ""
        
        # Host-spezifische (80-89)
        echo "    $M""$host-spezifisch:$N"
        switch $host
            case "n8-kiste"
                echo "      cdcloud   $D→$N cd ~/nextcloud"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
            case "n8-vps"
                echo "      cdstacks  $D→$N cd /srv/stacks"
                echo "      tlog      $D→$N tail traefik logs"
            case "n8-station"
                echo "      cdcloud   $D→$N cd /mnt/cloud"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
                echo "      ssh-kiste $D→$N ssh mrohwer@10.10.10.1"
            case "n8-maxx"
                echo "      steam     $D→$N flatpak run Steam"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
                echo "      ssh-kiste $D→$N ssh mrohwer@10.10.10.1"
            case "n8-book" "n8-bookchen"
                echo "      bat       $D→$N Akku-Status anzeigen"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
                echo "      ssh-kiste $D→$N ssh mrohwer@10.10.10.1"
            case "n8-broker"
                echo "      trading   $D→$N cd ~/Trading"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
                echo "      ssh-kiste $D→$N ssh mrohwer@10.10.10.1"
            case "n8-archstick"
                echo "      portable-sync $D→$N rsync ~/portable/ backup"
                echo "      ssh-vps   $D→$N ssh mrohwer@136.243.101.223 -p 61020"
                echo "      ssh-kiste $D→$N ssh mrohwer@10.10.10.1"
        end
        echo ""
    end
    
    # ─────────────────────────────────────────────────────────────────
    # FUNKTIONEN
    # ─────────────────────────────────────────────────────────────────
    if set -q _flag_functions; or not set -q _flag_aliases; and not set -q _flag_vars; and not set -q _flag_check; and not set -q _flag_structure
        if set -q _flag_functions
            echo ""
            echo "$BOLD$C""═══ FUNKTIONEN ═══$N"
        else
            echo "$Y""🔧 Funktionen$N"
        end
        echo ""
        
        echo "  $B""Shared:$N"
        echo "    mr-bytez-info   $D→$N Diese Hilfe/Diagnose"
        if set -q _flag_verbose
            echo "      $D# Optionen: -v -a -f -V --check --structure$N"
        end
        echo ""
        
        echo "  $B""Host ($host):$N"
        set -l test_func $host"-test"
        set -l test_func_clean (string replace -a "-" "" $test_func)
        echo "    $test_func_clean   $D→$N Host-Config Test"
        if set -q _flag_verbose
            echo "      $D# Zeigt host-spezifische Config-Zusammenfassung$N"
        end
        echo ""
    end
    
    # ─────────────────────────────────────────────────────────────────
    # FOOTER
    # ─────────────────────────────────────────────────────────────────
    if not set -q _flag_aliases; and not set -q _flag_functions; and not set -q _flag_vars; and not set -q _flag_check; and not set -q _flag_structure
        echo "$D""───────────────────────────────────────────────────────────────$N"
        echo "$D""  mr-bytez-info -h für Hilfe · mr-bytez-info -v für Details$N"
        echo ""
    end
end
