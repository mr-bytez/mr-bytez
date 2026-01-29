function n8book-test --description "Test n8-book Host-Config"
    set -l G (set_color green)
    set -l Y (set_color yellow)
    set -l N (set_color normal)
    echo $G"✔ n8-book Host-Config aktiv!"$N
    echo ""
    echo $Y"Laptop-Aliases:"$N
    echo "  upa     → pacman + yay + flatpak"
    echo "  bat     → Akku-Status"
    echo "  ssh-vps → ssh mrohwer@136.243.101.223 -p 61020"
    echo ""
    echo $Y"Display (1920p):"$N
    echo "  GDK_SCALE        = $GDK_SCALE"
    echo "  QT_SCALE_FACTOR  = $QT_SCALE_FACTOR"
    echo "  N8_HOST_TEST     = $N8_HOST_TEST"
end
