function n8archstick-test --description "Test n8-archstick Host-Config"
    set -l G (set_color green)
    set -l Y (set_color yellow)
    set -l N (set_color normal)
    echo $G"✔ n8-archstick Host-Config aktiv!"$N
    echo ""
    echo $Y"Portable-Aliases:"$N
    echo "  upa           → pacman + yay + flatpak"
    echo "  portable-sync → rsync ~/portable/ /mnt/backup/"
    echo "  ssh-vps       → ssh mrohwer@136.243.101.223 -p 61020"
    echo ""
    echo $Y"Display (variabel):"$N
    echo "  Keine feste Skalierung"
    echo "  N8_HOST_TEST = $N8_HOST_TEST"
end
