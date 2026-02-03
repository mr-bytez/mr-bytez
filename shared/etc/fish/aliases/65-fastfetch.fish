# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  mr-bytez Fish Aliases – Fastfetch                                          ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:     /mr-bytez/shared/usr/local/share/fish/aliases/65-fastfetch.fish  ║
# ║  Autor:    Michael Rohwer                                                    ║
# ║  Version:  1.0.0                                                             ║
# ║  Erstellt: 2026-01-25                                                        ║
# ║  Zweck:    Schnelle Systemübersicht mit fastfetch                           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 🧾 HELPER
# ══════════════════════════════════════════════════════════════════════════════

# Prüft ob Preset existiert
function __ff_preset_exists --description "Prüft ob fastfetch Preset existiert"
    set -l name $argv[1]
    command fastfetch --list-presets 2>/dev/null | command grep -qx -- "$name"
end

# ══════════════════════════════════════════════════════════════════════════════
# 📊 STANDARD
# ══════════════════════════════════════════════════════════════════════════════

# ff: Fastfetch Standard
function ff --description "Fastfetch Standard"
    command fastfetch
end

# fetch: Alias für fastfetch
function fetch --description "Systemübersicht (fastfetch)"
    command fastfetch $argv
end

# ══════════════════════════════════════════════════════════════════════════════
# 🎯 PRESETS
# ══════════════════════════════════════════════════════════════════════════════

# ffm: Fastfetch minimal: Host/OS/Kernel/Uptime
function ffm --description "Fastfetch minimal: Host/OS/Kernel/Uptime"
    if __ff_preset_exists minimal
        command fastfetch -c minimal.jsonc
    else
        command fastfetch -s Title:OS:Kernel:Uptime
    end
end

# ffs: Fastfetch Systemübersicht: OS/Kernel/CPU/GPU/Memory/Disk
function ffs --description "Fastfetch Systemübersicht: OS/Kernel/CPU/GPU/Memory/Disk"
    if __ff_preset_exists sysinfo
        command fastfetch -c sysinfo.jsonc
    else
        command fastfetch -s Title:OS:Kernel:CPU:GPU:Memory:Disk
    end
end

# ffg: Fastfetch Grafik: GPU/Display
function ffg --description "Fastfetch Grafik: GPU/Display"
    if __ff_preset_exists gpu
        command fastfetch -c gpu.jsonc
    else
        command fastfetch -s Title:GPU:Display
    end
end

# ffn: Fastfetch Netzwerk: Host/IP
function ffn --description "Fastfetch Netzwerk: Host/IP"
    if __ff_preset_exists network
        command fastfetch -c network.jsonc
    else
        command fastfetch -s Title:Hostname:LocalIP
    end
end
