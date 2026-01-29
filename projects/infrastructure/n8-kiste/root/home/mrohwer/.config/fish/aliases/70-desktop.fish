# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Desktop Override                                    ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     .config/fish/conf.d/70-desktop.fish (Host-spezifisch)            ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Zweck:    Desktop-spezifische Aliases (MIT Flatpak)                        ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
#
# Hosts: n8-kiste, n8-station, n8-book, n8-archstick, n8-maxx, n8-broker
#
# Diese Datei überschreibt 60-pacman.fish Aliases für Desktop-Systeme
# und fügt Flatpak-Integration hinzu.

# ══════════════════════════════════════════════════════════════════════════════
# 🔄 UPDATES MIT FLATPAK
# ══════════════════════════════════════════════════════════════════════════════

# upa: Interaktives Voll-Update (Repos + AUR + Flatpak) – OHNE --noconfirm
#      Empfohlen für kontrollierte Läufe
alias upa='sudo pacman -Syu && yay -Syu && sudo flatpak update -y'

# upall: Schnelles Voll-Update (Repos + AUR + Flatpak) – MIT --noconfirm
#        Bequem, aber potenziell riskanter bei Konflikten
alias upall='sudo pacman -Syu --noconfirm && yay -Syu --noconfirm && flatpak update -y'

# ══════════════════════════════════════════════════════════════════════════════
# 📦 FLATPAK STANDALONE
# ══════════════════════════════════════════════════════════════════════════════

# upfl: Flatpak Updates non-interaktiv
alias upfl='flatpak update -y'

# upflc: Flatpak Aufräumen + Reparatur
alias upflc='flatpak uninstall --unused -y && flatpak repair -y'

# ══════════════════════════════════════════════════════════════════════════════
# 🧹 CLEANUP MIT FLATPAK
# ══════════════════════════════════════════════════════════════════════════════

# upclean: Cleanup gesamt (Repo/AUR/Flatpak)
# Hinweis: "pacman-contrib" für paccache benötigt
alias upclean='sudo paccache -rk2; and yay -Sc --aur; and sudo flatpak uninstall --system --unused -y; and flatpak uninstall --user --unused -y'

# ══════════════════════════════════════════════════════════════════════════════
# 🔍 CHECK MIT FLATPAK
# ══════════════════════════════════════════════════════════════════════════════

# upchk: Nur prüfen, was ansteht (kein Install) - MIT Flatpak
# Überschreibt die Basis-Version aus 60-pacman.fish
alias upchk='checkupdates; and yay -Qua; and flatpak remote-ls --updates'

# ══════════════════════════════════════════════════════════════════════════════
# 💤 POWER-MANAGEMENT (nur Desktop)
# ══════════════════════════════════════════════════════════════════════════════

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
function __lock_session --description "sperrt die Session, falls möglich"
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
    set_color cyan; echo -n "ℹ"; set_color normal
    echo " zzz: 🔒 Bildschirm sperren → Energiesparmodus"
    __lock_session
    if command -q systemctl
        command systemctl suspend 2>/dev/null; or command loginctl suspend 2>/dev/null; or begin
            echo "❌ Suspend abgelehnt – ggf. Polkit/Sudo nötig." >&2
            return 1
        end
    else if command -q loginctl
        command loginctl suspend 2>/dev/null; or begin
            echo "❌ Suspend abgelehnt – ggf. Polkit/Sudo nötig." >&2
            return 1
        end
    else
        echo "❌ Weder systemctl noch loginctl verfügbar." >&2
        return 1
    end
end

# zzzh: Lock + Hibernate (Swap/Resume nötig)
function zzzh --description "Lock + Hibernate"
    set_color cyan; echo -n "ℹ"; set_color normal
    echo " zzzh: 🔒 Bildschirm sperren → Ruhezustand"
    __lock_session
    if command -q systemctl
        command systemctl hibernate 2>/dev/null; or command loginctl hibernate 2>/dev/null; or begin
            echo "❌ Hibernate abgelehnt – Swap/Resume & Polkit prüfen." >&2
            return 1
        end
    else if command -q loginctl
        command loginctl hibernate 2>/dev/null; or begin
            echo "❌ Hibernate abgelehnt – Berechtigungen prüfen." >&2
            return 1
        end
    else
        echo "❌ Weder systemctl noch loginctl verfügbar." >&2
        return 1
    end
end

# zzzx: Lock + Hybrid-Sleep
function zzzx --description "Lock + Hybrid-Sleep"
    set_color cyan; echo -n "ℹ"; set_color normal
    echo " zzzx: 🔒 Bildschirm sperren → Hybrid-Sleep"
    __lock_session
    if command -q systemctl
        command systemctl hybrid-sleep 2>/dev/null; or begin
            echo "❌ Hybrid-Sleep abgelehnt – ggf. nicht unterstützt." >&2
            return 1
        end
    else
        echo "❌ systemctl nicht verfügbar." >&2
        return 1
    end
end
# ═══════════════════════════════════════════════════════════════════════════════
# 🧪 DESKTOP-TEST
# ═══════════════════════════════════════════════════════════════════════════════

function desktop-test --description "Test ob Desktop-Config geladen"
    set_color green
    echo "✔ Desktop-Config aktiv (Flatpak-Integration)!"
    set_color normal
    echo ""
    echo "Desktop-spezifische Aliases:"
    echo "  upa       → Update Repos + AUR + Flatpak (interaktiv)"
    echo "  upall     → Update Repos + AUR + Flatpak (noconfirm)"
    echo "  upfl      → Flatpak Update"
    echo "  upflc     → Flatpak Cleanup"
end
