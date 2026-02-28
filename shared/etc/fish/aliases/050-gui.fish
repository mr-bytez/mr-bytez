# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ Fish Config                                  │
# │  Datei:    050-gui.fish                                 │
# │  Pfad:     shared/etc/fish/aliases/050-gui.fish         │
# │  Zweck:    GUI-spezifische Aliases und Funktionen       │
# │  Version:  0.1.0                                        │
# │  Autor:    MR-ByteZ                                     │
# │  Erstellt: 2026-02-28                                   │
# └─────────────────────────────────────────────────────────┘
#
# Self-Check: Nur laden wenn GUI vorhanden
# Hosts: n8-kiste, n8-station, n8-book, n8-bookchen, n8-broker, n8-maxx, n8-archstick
# Nicht: n8-vps (headless)

test "$MR_HAS_GUI" != "true"; and return

# ══════════════════════════════════════════════════════════
# Updates mit Flatpak (ueberschreibt upa aus 035-pacman.fish)
# ══════════════════════════════════════════════════════════

# upa: Interaktives Voll-Update (Repos + AUR + Flatpak) — OHNE --noconfirm
alias upa='sudo pacman -Syu; and yay -Syu; and sudo flatpak update -y'

# upall: Schnelles Voll-Update (Repos + AUR + Flatpak) — MIT --noconfirm
alias upall='sudo pacman -Syu --noconfirm; and yay -Syu --noconfirm; and flatpak update -y'

# ══════════════════════════════════════════════════════════
# Flatpak Standalone
# ══════════════════════════════════════════════════════════

# upfl: Flatpak Updates non-interaktiv
alias upfl='flatpak update -y'

# upflc: Flatpak Aufraeumen + Reparatur
alias upflc='flatpak uninstall --unused -y; and flatpak repair -y'

# flathub: Flathub-Remote hinzufuegen
alias flathub='flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'

# ══════════════════════════════════════════════════════════
# Cleanup mit Flatpak
# ══════════════════════════════════════════════════════════

# upclean: Cleanup gesamt (Repo/AUR/Flatpak)
# Hinweis: "pacman-contrib" fuer paccache benoetigt
alias upclean='sudo paccache -rk2; and yay -Sc --aur; and sudo flatpak uninstall --system --unused -y; and flatpak uninstall --user --unused -y'

# ══════════════════════════════════════════════════════════
# Check mit Flatpak
# ══════════════════════════════════════════════════════════

# upchk: Nur pruefen, was ansteht (kein Install) — MIT Flatpak
# Ueberschreibt die Basis-Version aus 035-pacman.fish
alias upchk='checkupdates; and yay -Qua; and flatpak remote-ls --updates'

# ══════════════════════════════════════════════════════════
# Power-Management (nur Desktop)
# ══════════════════════════════════════════════════════════

# Interner Helper: aktuelle logind-Session ermitteln
function __current_session_id --description "liefert loginctl-Session-ID oder leer"
    set -l me (whoami)
    set -l tty (tty | string replace -r '^/dev/' '')
    # 1) per TTY versuchen
    set -l sid (command loginctl 2>/dev/null | awk -v t="$tty" '$2==t{print $1;exit}')
    if test -n "$sid"
        echo $sid; return 0
    end
    # 2) erste Session des Users
    set sid (command loginctl 2>/dev/null | awk -v u="$me" '$3==u{print $1;exit}')
    if test -n "$sid"
        echo $sid; return 0
    end
    return 1
end

# Interner Helper: Session sperren
function __lock_session --description "sperrt die Session, falls moeglich"
    set -l sid (__current_session_id)
    if test -n "$sid"; and command -q loginctl
        command loginctl lock-session $sid 2>/dev/null
        return 0
    end
    # KDE/Plasma Fallback
    if command -q qdbus
        command qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock 2>/dev/null
    end
end

# zzz: Lock + Suspend-to-RAM
function zzz --description "Lock + Suspend-to-RAM"
    set_color cyan; echo -n "i"; set_color normal
    echo " zzz: Bildschirm sperren + Energiesparmodus"
    __lock_session
    if command -q systemctl
        command systemctl suspend 2>/dev/null; or command loginctl suspend 2>/dev/null; or begin
            echo "Suspend abgelehnt — ggf. Polkit/Sudo noetig." >&2
            return 1
        end
    else if command -q loginctl
        command loginctl suspend 2>/dev/null; or begin
            echo "Suspend abgelehnt — ggf. Polkit/Sudo noetig." >&2
            return 1
        end
    else
        echo "Weder systemctl noch loginctl verfuegbar." >&2
        return 1
    end
end

# zzzh: Lock + Hibernate (Swap/Resume noetig)
function zzzh --description "Lock + Hibernate"
    set_color cyan; echo -n "i"; set_color normal
    echo " zzzh: Bildschirm sperren + Ruhezustand"
    __lock_session
    if command -q systemctl
        command systemctl hibernate 2>/dev/null; or command loginctl hibernate 2>/dev/null; or begin
            echo "Hibernate abgelehnt — Swap/Resume & Polkit pruefen." >&2
            return 1
        end
    else if command -q loginctl
        command loginctl hibernate 2>/dev/null; or begin
            echo "Hibernate abgelehnt — Berechtigungen pruefen." >&2
            return 1
        end
    else
        echo "Weder systemctl noch loginctl verfuegbar." >&2
        return 1
    end
end

# zzzx: Lock + Hybrid-Sleep
function zzzx --description "Lock + Hybrid-Sleep"
    set_color cyan; echo -n "i"; set_color normal
    echo " zzzx: Bildschirm sperren + Hybrid-Sleep"
    __lock_session
    if command -q systemctl
        command systemctl hybrid-sleep 2>/dev/null; or begin
            echo "Hybrid-Sleep abgelehnt — ggf. nicht unterstuetzt." >&2
            return 1
        end
    else
        echo "systemctl nicht verfuegbar." >&2
        return 1
    end
end

# ══════════════════════════════════════════════════════════
# Desktop-Test
# ══════════════════════════════════════════════════════════

function desktop-test --description "Test ob Desktop-Config geladen"
    set_color green
    echo "Desktop-Config aktiv (Flatpak-Integration)!"
    set_color normal
    echo ""
    echo "Desktop-spezifische Aliases:"
    echo "  upa       → Update Repos + AUR + Flatpak (interaktiv)"
    echo "  upall     → Update Repos + AUR + Flatpak (noconfirm)"
    echo "  upfl      → Flatpak Update"
    echo "  upflc     → Flatpak Cleanup"
    echo "  upclean   → Cleanup gesamt"
    echo "  upchk     → Update-Check mit Flatpak"
    echo "  flathub   → Flathub-Remote hinzufuegen"
    echo "  zzz       → Lock + Suspend"
    echo "  zzzh      → Lock + Hibernate"
    echo "  zzzx      → Lock + Hybrid-Sleep"
end
