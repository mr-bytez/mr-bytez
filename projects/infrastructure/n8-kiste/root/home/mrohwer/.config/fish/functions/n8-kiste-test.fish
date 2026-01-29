function n8kiste-test --description "Test n8-kiste Host-Config"
    set -l G (set_color green)
    set -l Y (set_color yellow)
    set -l N (set_color normal)
    echo $G"✔ n8-kiste Host-Config aktiv!"$N
    echo ""
    echo $Y"Desktop-Aliases:"$N
    echo "  upa       → pacman + yay + flatpak"
    echo "  upfl      → flatpak update"
    echo "  ssh-vps   → ssh mrohwer@136.243.101.223 -p 61020"
    echo "  cdcloud   → cd ~/nextcloud"
    echo ""
    echo $Y"Display (4K):"$N
    echo "  GDK_SCALE        = $GDK_SCALE"
    echo "  QT_SCALE_FACTOR  = $QT_SCALE_FACTOR"
    echo "  N8_HOST_TEST     = $N8_HOST_TEST"
end
