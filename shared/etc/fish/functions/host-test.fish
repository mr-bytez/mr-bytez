# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Function – host-test                                          ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     shared/usr/local/share/fish/functions/host-test.fish             ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.2.0                                                             ║
# ║  Erstellt: 2026-01-28                                                        ║
# ║  Zweck:    Generische Host-Info Funktion für alle mr-bytez Hosts            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

function host-test --description "Zeigt umfassende Host-Informationen"

    # ══════════════════════════════════════════════════════════════════════════
    # 🎨 MOTD LOGO + GREETING
    # ══════════════════════════════════════════════════════════════════════════
    if test -f /etc/motd
        echo ""
        set_color cyan
        command cat /etc/motd
        set_color normal
    end

    # Fish Greeting Slogans
    echo ""
    set_color cyan;   echo -n "  🚀 "; set_color normal; echo "Escape the Cloud. Embrace the Arch."
    set_color yellow; echo -n "  ⚡ "; set_color normal; echo "Where Microsoft ends, MR-ByteZ begins."
    set_color red;    echo -n "  🚫 "; set_color normal; echo "No Apple. No Google. No Microsoft. No Bullshit."
    set_color green;  echo -n "  🐧 "; set_color normal; echo "Just Arch, Fish, and Freedom."
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 🖥️  SYSTEM INFO
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║  🖥️  SYSTEM INFO                                                      ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    set_color normal

    set -l hostname_str (hostname)
    set -l kernel_str (uname -r)
    set -l arch_str (uname -m)
    set -l uptime_str (uptime -p 2>/dev/null || uptime | string replace -r '.*up ' 'up ')
    set -l load_str (command cat /proc/loadavg | command awk '{print $1, $2, $3}')

    echo ""
    printf "  %-14s %s\n" "Hostname:" "$hostname_str"
    printf "  %-14s %s (%s)\n" "Kernel:" "$kernel_str" "$arch_str"
    printf "  %-14s %s\n" "Uptime:" "$uptime_str"
    printf "  %-14s %s\n" "Load:" "$load_str"
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 🌐 NETZWERK
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║  🌐 NETZWERK                                                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    # Physische Netzwerkkarten (keine docker/bridge)
    command ip -4 -o addr show 2>/dev/null | while read line
        set -l iface (echo $line | command awk '{print $2}')
        set -l ip_addr (echo $line | command awk '{print $4}')

        # Loopback und Docker-Bridges überspringen
        if test "$iface" != "lo"
            if not string match -q "docker*" $iface
                if not string match -q "br-*" $iface
                    if not string match -q "veth*" $iface
                        printf "  %-14s %s\n" "$iface:" "$ip_addr"
                    end
                end
            end
        end
    end

    # Externe IP
    printf "  %-14s " "Externe IP:"
    set -l ext_ip (command curl -s --connect-timeout 3 ifconfig.me 2>/dev/null)
    if test -n "$ext_ip"
        set_color yellow
        echo "$ext_ip"
        set_color normal
    else
        set_color red
        echo "nicht erreichbar"
        set_color normal
    end
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 💾 SPEICHER (RAM/SWAP)
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║  💾 SPEICHER (RAM/SWAP)                                               ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    # RAM - direkt aus /proc/meminfo lesen (zuverlässiger)
    set -l mem_total_kb (command grep '^MemTotal:' /proc/meminfo | command awk '{print $2}')
    set -l mem_avail_kb (command grep '^MemAvailable:' /proc/meminfo | command awk '{print $2}')
    set -l mem_used_kb (math "$mem_total_kb - $mem_avail_kb")
    set -l mem_percent (math --scale=0 "$mem_used_kb * 100 / $mem_total_kb")

    # In GB umrechnen
    set -l mem_total_gb (math --scale=1 "$mem_total_kb / 1024 / 1024")
    set -l mem_used_gb (math --scale=1 "$mem_used_kb / 1024 / 1024")
    set -l mem_avail_gb (math --scale=1 "$mem_avail_kb / 1024 / 1024")

    printf "  %-14s %sG / %sG (%s%% genutzt, %sG verfügbar)\n" "RAM:" "$mem_used_gb" "$mem_total_gb" "$mem_percent" "$mem_avail_gb"

    # SWAP
    set -l swap_total_kb (command grep '^SwapTotal:' /proc/meminfo | command awk '{print $2}')
    set -l swap_free_kb (command grep '^SwapFree:' /proc/meminfo | command awk '{print $2}')

    if test "$swap_total_kb" -gt 0
        set -l swap_used_kb (math "$swap_total_kb - $swap_free_kb")
        set -l swap_percent (math --scale=0 "$swap_used_kb * 100 / $swap_total_kb")
        set -l swap_total_gb (math --scale=1 "$swap_total_kb / 1024 / 1024")
        set -l swap_used_gb (math --scale=1 "$swap_used_kb / 1024 / 1024")
        printf "  %-14s %sG / %sG (%s%% genutzt)\n" "Swap:" "$swap_used_gb" "$swap_total_gb" "$swap_percent"
    else
        printf "  %-14s %s\n" "Swap:" "nicht konfiguriert"
    end
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 💿 FESTPLATTEN
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║  💿 FESTPLATTEN                                                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    # Physische Disks (keine loop, keine zram)
    echo "  Physische Laufwerke:"
    command lsblk -d -o NAME,SIZE,MODEL,TRAN 2>/dev/null | command grep -v "^NAME" | command grep -v "loop" | command grep -v "zram" | while read line
        echo "    $line"
    end
    echo ""

    # Partitionen mit Nutzung
    echo "  Partitionen:"
    printf "    %-24s %8s %8s %8s %6s  %s\n" "Device" "Size" "Used" "Avail" "Use%" "Mount"
    echo "    ────────────────────────────────────────────────────────────────────────"

    LANG=C command df -h -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null | command grep -v "^Filesystem" | while read line
        set -l dev (echo $line | command awk '{print $1}')
        set -l size (echo $line | command awk '{print $2}')
        set -l used (echo $line | command awk '{print $3}')
        set -l avail (echo $line | command awk '{print $4}')
        set -l pct (echo $line | command awk '{print $5}')
        set -l mount (echo $line | command awk '{print $6}')

        # Farbcodierung nach Nutzung
        set -l usage_num (string replace "%" "" $pct)
        if test -n "$usage_num" -a "$usage_num" != ""
            if string match -qr '^[0-9]+$' $usage_num
                if test $usage_num -ge 90
                    set_color red
                else if test $usage_num -ge 75
                    set_color yellow
                else
                    set_color green
                end
            end
        end
        printf "    %-24s %8s %8s %8s %6s  %s\n" "$dev" "$size" "$used" "$avail" "$pct" "$mount"
        set_color normal
    end
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 🐳 DOCKER
    # ══════════════════════════════════════════════════════════════════════════
    if command -q docker
        set_color --bold cyan
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║  🐳 DOCKER                                                            ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        set_color normal
        echo ""

        # Docker Version
        set -l docker_version (command docker --version 2>/dev/null | string replace "Docker version " "" | string split ",")[1]
        printf "  %-14s %s\n" "Version:" "$docker_version"

        # Container Count
        set -l running (command docker ps -q 2>/dev/null | wc -l)
        set -l total (command docker ps -aq 2>/dev/null | wc -l)
        printf "  %-14s %s running / %s total\n" "Container:" "$running" "$total"
        echo ""

        # Container Liste (wenn welche laufen)
        if test $running -gt 0
            echo "  Laufende Container:"
            printf "    %-22s %-20s %-14s %s\n" "NAME" "IMAGE" "STATUS" "PORTS"
            echo "    ────────────────────────────────────────────────────────────────────────"

            command docker ps --format "{{.Names}}|{{.Image}}|{{.Status}}|{{.Ports}}" 2>/dev/null | while read line
                set -l c_name (echo $line | command cut -d'|' -f1 | string sub -l 22)
                set -l c_image (echo $line | command cut -d'|' -f2 | string sub -l 20)
                set -l c_stat (echo $line | command cut -d'|' -f3 | string sub -l 14)
                set -l c_ports (echo $line | command cut -d'|' -f4 | string sub -l 30)

                set_color green
                printf "    %-22s " "$c_name"
                set_color normal
                printf "%-20s %-14s %s\n" "$c_image" "$c_stat" "$c_ports"
            end

            # Docker Netzwerke
            echo ""
            echo "  Docker Netzwerke:"
            printf "    %-22s %-12s %-18s %s\n" "NAME" "DRIVER" "SUBNET" "GATEWAY"
            echo "    ────────────────────────────────────────────────────────────────────────"

            command docker network ls --format "{{.Name}}" 2>/dev/null | while read netname
                set -l net_info (command docker network inspect $netname --format '{{.Driver}}|{{range .IPAM.Config}}{{.Subnet}}|{{.Gateway}}{{end}}' 2>/dev/null)
                set -l driver (echo $net_info | command cut -d'|' -f1)
                set -l subnet (echo $net_info | command cut -d'|' -f2)
                set -l gateway (echo $net_info | command cut -d'|' -f3)

                # Leere Werte durch "-" ersetzen
                test -z "$subnet"; and set subnet "-"
                test -z "$gateway"; and set gateway "-"

                printf "    %-22s %-12s %-18s %s\n" (string sub -l 22 $netname) "$driver" "$subnet" "$gateway"
            end

        else
            set_color yellow
            echo "  Keine Container laufen"
            set_color normal
        end
        echo ""
    end

    # ══════════════════════════════════════════════════════════════════════════
    # ⚠️  SYSTEMD FAILED UNITS
    # ══════════════════════════════════════════════════════════════════════════
    set -l failed_units (systemctl --failed --no-legend 2>/dev/null | wc -l)
    if test $failed_units -gt 0
        set_color --bold red
        echo "╔══════════════════════════════════════════════════════════════════════╗"
        echo "║  ⚠️  SYSTEMD FAILED UNITS                                             ║"
        echo "╚══════════════════════════════════════════════════════════════════════╝"
        set_color normal
        echo ""
        systemctl --failed --no-legend 2>/dev/null | while read line
            echo "  ❌ $line"
        end
        echo ""
    end

    # ══════════════════════════════════════════════════════════════════════════
    # 🐟 FISH CONFIG
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║  🐟 FISH CONFIG                                                       ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    set_color normal
    echo ""

    printf "  %-14s " "Shared:"
    if test -d /usr/local/share/fish/conf.d
        set_color green
        echo "✔ /usr/local/share/fish/"
        set_color normal
    else
        set_color red
        echo "✘ nicht gefunden"
        set_color normal
    end

    printf "  %-14s " "User:"
    if test -d ~/.config/fish
        set_color green
        echo "✔ ~/.config/fish/"
        set_color normal
    else
        set_color red
        echo "✘ nicht gefunden"
        set_color normal
    end

    if set -q N8_HOST
        printf "  %-14s %s (%s)\n" "N8_HOST:" "$N8_HOST" "$N8_ROLE"
    end
    echo ""

    # ══════════════════════════════════════════════════════════════════════════
    # 🚀 SLOGAN
    # ══════════════════════════════════════════════════════════════════════════
    set_color --bold cyan
    echo "═══════════════════════════════════════════════════════════════════════"
    set_color normal
    set_color cyan;   echo -n "  🚀 "; set_color normal; echo "Escape the Cloud. Embrace the Arch."
    set_color yellow; echo -n "  ⚡ "; set_color normal; echo "Where Microsoft ends, MR-ByteZ begins."
    set_color red;    echo -n "  🚫 "; set_color normal; echo "No Apple. No Google. No Microsoft. No Bullshit."
    set_color green;  echo -n "  🐧 "; set_color normal; echo "Just Arch, Fish, and Freedom."
    set_color --bold cyan
    echo "═══════════════════════════════════════════════════════════════════════"
    set_color normal
    echo ""

    set_color --bold green
    printf "  ✔ Host-Test abgeschlossen: %s @ %s\n" "$hostname_str" (date +"%Y-%m-%d %H:%M:%S")
    set_color normal
    echo ""
end
