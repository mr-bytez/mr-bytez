# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Variables - User Paths                                        ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/etc/fish/variables/10-paths.fish    ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-02-10                                                        ║
# ║  Zweck:    User-PATH Erweiterungen für alle Hosts                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ── ~/.local/bin (User-Tools: Claude Code, pip, etc.) ──────────────────────
if test -d $HOME/.local/bin
    if not contains $HOME/.local/bin $fish_user_paths
        set -Ua fish_user_paths $HOME/.local/bin
    end
end
