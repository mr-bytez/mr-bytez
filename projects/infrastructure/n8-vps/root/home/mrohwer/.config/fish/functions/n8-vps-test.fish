function n8vps-test --description "Test n8-vps Host-Config"
    set -l G (set_color green)
    set -l Y (set_color yellow)
    set -l N (set_color normal)
    echo $G"✔ n8-vps Host-Config aktiv!"$N
    echo ""
    echo $Y"Server-Aliases:"$N
    echo "  upa       → sudo pacman -Syu && yay -Syu"
    echo "  dps       → docker ps (formatiert)"
    echo "  cdstacks  → cd /srv/stacks"
    echo ""
    echo $Y"Variablen:"$N
    echo "  N8_HOST_TEST = $N8_HOST_TEST"
end
