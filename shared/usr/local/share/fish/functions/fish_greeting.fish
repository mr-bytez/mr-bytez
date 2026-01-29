# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Greeting                                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     .../fish/functions/fish_greeting.fish                            ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.1.0                                                             ║
# ║  Erstellt: 2026-01-26                                                        ║
# ║  Zweck:    Fastfetch + MOTD + Slogan                                        ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

function fish_greeting
    if status is-interactive
        # 1. Fastfetch
        if type -q fastfetch
            fastfetch && echo ""
        end
        
        # 2. MOTD
        if test -f /etc/motd
            echo ""
            cat /etc/motd
        end
        
        # 3. Slogan
        echo ""
        set_color cyan;   echo -n "🚀 "; set_color normal; echo "Escape the Cloud. Embrace the Arch."
        set_color yellow; echo -n "⚡ "; set_color normal; echo "Where Microsoft ends, MR-ByteZ begins."
        set_color red;    echo -n "🚫 "; set_color normal; echo "No Apple. No Google. No Microsoft. No Bullshit."
        set_color green;  echo -n "🐧 "; set_color normal; echo "Just Arch, Fish, and Freedom."
        echo ""
    end
end
