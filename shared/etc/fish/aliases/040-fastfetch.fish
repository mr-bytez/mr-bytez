# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  MR-ByteZ Fish Aliases — Fastfetch                                          ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Pfad:        shared/etc/fish/aliases/040-fastfetch.fish                    ║
# ║  Autor:       MR-ByteZ                                                      ║
# ║  Version:     0.3.1                                                         ║
# ║  Erstellt:    2026-01-25                                                    ║
# ║  Aktualisiert:2026-02-28                                                    ║
# ║  Zweck:       Schnelle Systemuebersicht mit fastfetch                      ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# 🧾 HELPER
# ══════════════════════════════════════════════════════════════════════════════

# Prüft ob Preset existiert
function __ff_preset_exists --description "Prüft ob fastfetch Preset existiert"
    set -l name $argv[1]
    fastfetch --list-presets 2>/dev/null | grep -qx -- "$name"
end

# ══════════════════════════════════════════════════════════════════════════════
# 📊 STANDARD
# ══════════════════════════════════════════════════════════════════════════════

# ff: Fastfetch Standard
function ff --description "Fastfetch Standard"
    fastfetch
end

# fetch: Alias für fastfetch
function fetch --description "Systemübersicht (fastfetch)"
    fastfetch $argv
end

# ══════════════════════════════════════════════════════════════════════════════
# 🎯 PRESETS
# ══════════════════════════════════════════════════════════════════════════════

# ffm: Fastfetch minimal: Host/OS/Kernel/Uptime
function ffm --description "Fastfetch minimal: Host/OS/Kernel/Uptime"
    if __ff_preset_exists minimal
        fastfetch -c minimal.jsonc
    else
        fastfetch -s Title:OS:Kernel:Uptime
    end
end

# ffs: Fastfetch Systemübersicht: OS/Kernel/CPU/GPU/Memory/Disk
function ffs --description "Fastfetch Systemübersicht: OS/Kernel/CPU/GPU/Memory/Disk"
    if __ff_preset_exists sysinfo
        fastfetch -c sysinfo.jsonc
    else
        fastfetch -s Title:OS:Kernel:CPU:GPU:Memory:Disk
    end
end

# ffg: Fastfetch Grafik: GPU/Display
function ffg --description "Fastfetch Grafik: GPU/Display"
    if __ff_preset_exists gpu
        fastfetch -c gpu.jsonc
    else
        fastfetch -s Title:GPU:Display
    end
end

# ffn: Fastfetch Netzwerk: Host/IP
function ffn --description "Fastfetch Netzwerk: Host/IP"
    if __ff_preset_exists network
        fastfetch -c network.jsonc
    else
        fastfetch -s Title:Hostname:LocalIP
    end
end
