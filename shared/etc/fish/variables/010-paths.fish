# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Variables — User Paths                                      ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/variables/010-paths.fish                      ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.3.1                                                         ║
# ║  Erstellt:    2026-02-10                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       User-PATH Erweiterungen fuer alle Hosts                      ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ── ~/.local/bin (User-Tools: Claude Code, pip, etc.) ──────────────────────
if test -d $HOME/.local/bin
    if not contains $HOME/.local/bin $fish_user_paths
        set -Ua fish_user_paths $HOME/.local/bin
    end
end
