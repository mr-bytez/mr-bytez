#!/bin/bash

# Hardware Info Script (hwi)
# Version: 3.1.1
# Beschreibung: Multi-Distro Hardware-Audit mit flexiblem Output
# Speicherort: /mr-bytez/shared/usr/local/bin/hwi/hwi.sh
# Symlink: /usr/local/bin/hwi -> /opt/mr-bytez/current/shared/usr/local/bin/hwi/hwi.sh
# Output:
#   - Standard: ~/hostname_hardware.md
#   - Mit -o: /custom/path/hostname_hardware.md
#   - Mit mrbz: /mr-bytez/projects/infrastructure/hostname/HARDWARE.md
# Autor: MR-ByteZ
# Datum: 2026-02-17

set -euo pipefail

# ═══════════════════════════════════════════════════════
# KONFIGURATION
# ═══════════════════════════════════════════════════════

SCRIPT_VERSION="3.1.1"
REAL_USER=${SUDO_USER:-$(whoami)}
REAL_HOME=$(eval echo ~${REAL_USER})
DATE_ONLY=$(date +%Y%m%d)
HOSTNAME=$(hostname)

# Output-Modus (wird durch Parameter gesetzt)
OUTPUT_MODE="standard"  # standard | custom | mrbz
CUSTOM_OUTPUT_DIR=""

# Farben für Terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# ═══════════════════════════════════════════════════════
# PARAMETER-HANDLING
# ═══════════════════════════════════════════════════════

parse_arguments() {
    if [[ $# -eq 0 ]]; then
        OUTPUT_MODE="standard"
        return
    fi

    case "$1" in
        mrbz)
            OUTPUT_MODE="mrbz"
            ;;
        -o|--output)
            if [[ $# -lt 2 ]]; then
                echo -e "${RED}❌ Fehler: -o benötigt einen Pfad${NC}"
                echo -e "${CYAN}Beispiel: hwi -o /opt/hardware${NC}"
                exit 1
            fi
            OUTPUT_MODE="custom"
            CUSTOM_OUTPUT_DIR="$2"
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unbekannter Parameter: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

show_help() {
    echo ""
    echo -e "${BOLD}${CYAN}Hardware Info Script (hwi) v${SCRIPT_VERSION}${NC}"
    echo ""
    echo -e "${BOLD}VERWENDUNG:${NC}"
    echo -e "  ${GREEN}hwi${NC}              Standard-Output: ${WHITE}~/hostname_hardware.md${NC}"
    echo -e "  ${GREEN}hwi -o /pfad${NC}     Custom-Output:   ${WHITE}/pfad/hostname_hardware.md${NC}"
    echo -e "  ${GREEN}hwi mrbz${NC}         mr-bytez Repo:   ${WHITE}/mr-bytez/projects/infrastructure/hostname/HARDWARE.md${NC}"
    echo ""
    echo -e "${BOLD}OPTIONEN:${NC}"
    echo -e "  ${CYAN}-o, --output <pfad>${NC}  Eigener Ausgabe-Ordner"
    echo -e "  ${CYAN}-h, --help${NC}          Diese Hilfe"
    echo ""
    echo -e "${BOLD}BEISPIELE:${NC}"
    echo -e "  ${DIM}hwi${NC}                  → ~/n8-station_hardware.md"
    echo -e "  ${DIM}hwi -o /backup${NC}       → /backup/n8-station_hardware.md"
    echo -e "  ${DIM}hwi mrbz${NC}             → /mr-bytez/projects/infrastructure/n8-station/HARDWARE.md"
    echo ""
}

get_output_path() {
    local filename="${HOSTNAME}_hardware.md"

    case "$OUTPUT_MODE" in
        standard)
            echo "${REAL_HOME}/${filename}"
            ;;
        custom)
            # Ordner erstellen falls nicht vorhanden
            if [[ ! -d "$CUSTOM_OUTPUT_DIR" ]]; then
                mkdir -p "$CUSTOM_OUTPUT_DIR"
                chown ${REAL_USER}:${REAL_USER} "$CUSTOM_OUTPUT_DIR"
            fi
            echo "${CUSTOM_OUTPUT_DIR}/${filename}"
            ;;
        mrbz)
            local mrbz_base="/mr-bytez/projects/infrastructure/${HOSTNAME}"

            # Prüfen ob mr-bytez existiert
            if [[ ! -d "/mr-bytez" ]]; then
                echo -e "${RED}❌ Fehler: /mr-bytez nicht gefunden${NC}" >&2
                echo -e "${YELLOW}Hinweis: mr-bytez Repository muss existieren${NC}" >&2
                exit 1
            fi

            # Ordner erstellen falls nicht vorhanden
            if [[ ! -d "$mrbz_base" ]]; then
                mkdir -p "$mrbz_base"
                chown ${REAL_USER}:${REAL_USER} "$mrbz_base"
            fi

            echo "${mrbz_base}/HARDWARE.md"
            ;;
    esac
}

# ═══════════════════════════════════════════════════════
# DISTRO & PACKAGE MANAGER
# ═══════════════════════════════════════════════════════

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        set +u
        source /etc/os-release
        echo "$ID"
        set -u
    else
        echo "unknown"
    fi
}

get_install_command() {
    local distro=$(detect_distro)

    case "$distro" in
        arch|manjaro|endeavouros)
            echo "sudo pacman -S lshw dmidecode smartmontools pciutils bc"
            ;;
        ubuntu|debian|linuxmint|pop)
            echo "sudo apt install lshw dmidecode smartmontools pciutils bc"
            ;;
        *)
            echo "Unbekannte Distribution - manuelle Installation erforderlich"
            ;;
    esac
}

# ═══════════════════════════════════════════════════════
# TOOL-CHECKS
# ═══════════════════════════════════════════════════════

check_required_tools() {
    local missing_tools=()
    local required_tools=("dmidecode" "lscpu" "lspci" "smartctl" "bc")

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Fehlende Tools: ${missing_tools[*]}${NC}"
        echo -e "${CYAN}Installation: $(get_install_command)${NC}"
        exit 1
    fi
}

# ═══════════════════════════════════════════════════════
# HELPER
# ═══════════════════════════════════════════════════════

normalize_vendor() {
    case "$1" in
        "GenuineIntel") echo "Intel" ;;
        "AuthenticAMD") echo "AMD" ;;
        *) echo "$1" ;;
    esac
}

format_bytes_to_size() {
    local bytes=$1

    if [[ $bytes -lt 1099511627776 ]]; then
        # < 1 TB → GB
        LC_ALL=C printf "%.0f GB" $(echo "scale=2; $bytes / 1073741824" | LC_ALL=C bc)
    else
        # >= 1 TB → TB
        LC_ALL=C printf "%.2f TB" $(echo "scale=2; $bytes / 1099511627776" | LC_ALL=C bc)
    fi
}

# ═══════════════════════════════════════════════════════
# HARDWARE-AUSLESEN
# ═══════════════════════════════════════════════════════

get_distribution_info() {
    local distro_name="Unknown"
    local kernel_version=$(uname -r)

    if [[ -f /etc/os-release ]]; then
        set +u
        source /etc/os-release
        distro_name="${NAME:-Unknown}"
        set -u
    fi

    echo "${distro_name}|${kernel_version}"
}

get_mainboard_info() {
    local mb_vendor=$(dmidecode -t baseboard 2>/dev/null | command grep "Manufacturer:" | cut -d: -f2 | xargs || echo "Unknown")
    local mb_product=$(dmidecode -t baseboard 2>/dev/null | command grep "Product Name:" | cut -d: -f2 | xargs || echo "Unknown")
    local chipset=$(LC_ALL=C lspci 2>/dev/null | command grep -i "Host bridge" | cut -d: -f3 | xargs || echo "Unknown")

    echo "${mb_vendor}|${mb_product}|${chipset}"
}

get_bios_info() {
    local bios_vendor=$(dmidecode -t bios 2>/dev/null | command grep "Vendor:" | cut -d: -f2 | xargs || echo "Unknown")
    local bios_version=$(dmidecode -t bios 2>/dev/null | command grep "Version:" | cut -d: -f2 | xargs || echo "Unknown")
    local bios_date=$(dmidecode -t bios 2>/dev/null | command grep "Release Date:" | cut -d: -f2 | xargs || echo "Unknown")

    echo "${bios_vendor}|${bios_version}|${bios_date}"
}

get_cpu_info() {
    local cpu_vendor=$(LC_ALL=C lscpu | command grep "Vendor ID:" | cut -d: -f2 | xargs || echo "Unknown")
    local cpu_model=$(LC_ALL=C lscpu | command grep "Model name:" | cut -d: -f2 | xargs || echo "Unknown")
    local cpu_cores=$(LC_ALL=C lscpu | command grep "^CPU(s):" | cut -d: -f2 | xargs || echo "0")

    # Base-Takt aus Model Name extrahieren (z.B. "@ 3.10GHz")
    local cpu_base_ghz=$(echo "$cpu_model" | command grep -oP '@\s*\K[0-9.]+(?=GHz)' || echo "N/A")

    # Turbo aus CPU max MHz
    local cpu_max_mhz=$(LC_ALL=C lscpu | command grep "CPU max MHz:" | awk '{print $4}' || echo "0")
    local cpu_turbo_ghz="N/A"

    if [[ "$cpu_max_mhz" != "0" ]] && [[ -n "$cpu_max_mhz" ]]; then
        cpu_turbo_ghz=$(echo "scale=1; ${cpu_max_mhz} / 1000" | bc)
    fi

    # Vendor normalisieren
    cpu_vendor=$(normalize_vendor "$cpu_vendor")

    # CPU Kurzform für Dateinamen
    local cpu_short="Unknown"
    if [[ $cpu_vendor == "Intel" ]]; then
        cpu_short="Intel-$(echo "$cpu_model" | command grep -oE 'i[0-9]-[0-9]+[A-Z]*' | head -n1)"
        if [[ "$cpu_short" == "Intel-" ]]; then
            cpu_short="Intel-$(echo "$cpu_model" | command grep -oE '[0-9]{4,5}[A-Z]*' | head -n1)"
        fi
    elif [[ $cpu_vendor == "AMD" ]]; then
        cpu_short="AMD-$(echo "$cpu_model" | command grep -oE '[0-9]{4}[A-Z]*' | head -n1)"
    fi

    echo "${cpu_vendor}|${cpu_model}|${cpu_short}|${cpu_cores}|${cpu_base_ghz}|${cpu_turbo_ghz}"
}

get_primary_gpu() {
    local gpu_vendor="Unknown"
    local gpu_model="Unknown"
    local gpu_vram="Unknown"
    local gpu_clock="Unknown"
    local gpu_short="Unknown"

    if command -v nvidia-smi &> /dev/null; then
        local nvidia_output=$(nvidia-smi --query-gpu=name,memory.total,clocks.max.gr --format=csv,noheader 2>/dev/null | head -n1)
        if [[ -n "$nvidia_output" ]]; then
            gpu_model=$(echo "$nvidia_output" | cut -d',' -f1 | xargs)
            gpu_vram=$(echo "$nvidia_output" | cut -d',' -f2 | xargs)
            gpu_clock=$(echo "$nvidia_output" | cut -d',' -f3 | xargs)
            gpu_vendor="NVIDIA"
            gpu_short="NVIDIA-$(echo "$gpu_model" | command grep -oE '(RTX|GTX)[[:space:]]*[0-9]+[[:space:]]*[A-Z]*' | tr -d ' ')"
        fi
    fi

    if [[ "$gpu_vendor" == "Unknown" ]]; then
        local gpu_line=$(LC_ALL=C lspci 2>/dev/null | command grep -i "VGA compatible controller" | head -n1)
        if [[ -n "$gpu_line" ]]; then
            if [[ $gpu_line == *"AMD"* ]] || [[ $gpu_line == *"ATI"* ]]; then
                gpu_vendor="AMD"
            elif [[ $gpu_line == *"NVIDIA"* ]]; then
                gpu_vendor="NVIDIA"
            elif [[ $gpu_line == *"Intel"* ]]; then
                gpu_vendor="Intel"
            fi

            gpu_model=$(echo "$gpu_line" | cut -d: -f3 | sed 's/\[.*\]//g' | xargs)
            gpu_vram="N/A"
            gpu_clock="N/A"
        fi
    fi

    echo "${gpu_vendor}|${gpu_model}|${gpu_vram}|${gpu_clock}|${gpu_short}"
}

get_all_gpus_info() {
    # Gibt Array zurück: vendor|model|vram|clock für jede GPU
    if command -v nvidia-smi &> /dev/null; then
        nvidia-smi --query-gpu=name,memory.total,clocks.max.gr --format=csv,noheader 2>/dev/null | while IFS=',' read -r name vram clock; do
            echo "NVIDIA|$(echo $name | xargs)|$(echo $vram | xargs)|$(echo $clock | xargs)"
        done
    else
        LC_ALL=C lspci 2>/dev/null | command grep -i "VGA compatible controller" | while read line; do
            local vendor="Unknown"
            if [[ $line == *"AMD"* ]] || [[ $line == *"ATI"* ]]; then
                vendor="AMD"
            elif [[ $line == *"NVIDIA"* ]]; then
                vendor="NVIDIA"
            elif [[ $line == *"Intel"* ]]; then
                vendor="Intel"
            fi
            local model=$(echo "$line" | cut -d: -f3 | sed 's/\[.*\]//g' | xargs)
            echo "${vendor}|${model}|N/A|N/A"
        done
    fi
}

get_ram_info() {
    # RAM Detection mit Fallback auf decode-dimms bei "Unknown"

    # Versuch 1: dmidecode (schnell)
    local ram_data=$(dmidecode -t memory 2>/dev/null)

    # Total Size
    local total_mb=$(echo "$ram_data" | command grep "^\s*Size:" | command grep -E "[0-9]+ [GM]i?B" | \
        awk '{
            if ($3 ~ /GiB?/) sum += $2 * 1024;
            else if ($3 ~ /MiB?/) sum += $2;
        } END {print sum}')
    local total_gb=$(awk "BEGIN {printf \"%.0f\", $total_mb / 1024}")

    # Module Count
    local module_count=$(echo "$ram_data" | command grep "^\s*Size:" | command grep -E "[0-9]+ [GM]i?B" | wc -l)

    # Type (DDR3/DDR4/DDR5)
    local ram_type=$(echo "$ram_data" | command grep "^\s*Type:" | command grep -v "Error\|Unknown\|Other" | head -n1 | awk '{print $2}')

    # Speed
    local ram_speed=$(echo "$ram_data" | command grep "^\s*Speed:" | command grep -E "[0-9]+" | head -n1 | awk '{print $2, $3}')

    # Manufacturer (dmidecode)
    local manufacturer=$(echo "$ram_data" | command grep "^\s*Manufacturer:" | command grep -v "NO DIMM" | head -n1 | awk '{print $2}')

    # Timings (via decode-dimms)
    local timings="N/A"

    # Fallback auf decode-dimms falls "Unknown" ODER für Timings
    if [[ "$manufacturer" == "Unknown" ]] || [[ -z "$manufacturer" ]]; then
        if command -v decode-dimms &>/dev/null; then
            modprobe eeprom 2>/dev/null
            local dimms_data=$(decode-dimms 2>/dev/null)
            manufacturer=$(echo "$dimms_data" | command grep "^Module Manufacturer" | head -n1 | awk -F'  +' '{print $2}')
            local part_number=$(echo "$dimms_data" | command grep "^Part Number" | head -n1 | awk -F'  +' '{print $2}')
            local speed_numeric=$(echo "$ram_speed" | awk '{print $1}')
            timings=$(echo "$dimms_data" | command grep "^AA-RCD-RP-RAS (cycles)" | head -n1 | awk '{print $NF}')
            [[ -z "$manufacturer" ]] && manufacturer="Generic"
            if [[ -n "$part_number" ]] && [[ "$part_number" != "Unknown" ]]; then
                manufacturer="$manufacturer ($part_number)"
            fi
        else
            manufacturer="Generic (dmidecode Unknown)"
        fi
    else
        # Auch bei bekanntem Manufacturer Timings holen
        if command -v decode-dimms &>/dev/null; then
            modprobe eeprom 2>/dev/null
            local dimms_data=$(decode-dimms 2>/dev/null)
            local speed_numeric=$(echo "$ram_speed" | awk '{print $1}')
            timings=$(echo "$dimms_data" | command grep "AA-RCD-RP-RAS.*DDR4-${speed_numeric}" | awk '{print $NF}')
        fi
    fi

    [[ -z "$timings" ]] && timings="N/A"

    # Output: total_gb|module_count|manufacturer|ram_speed|ram_type|timings (ALTE Reihenfolge!)
    echo "${total_gb}|${module_count}|${manufacturer}|${ram_speed}|${ram_type}|${timings}"
}

get_storage_overview() {
    local nvme_count=0
    local nvme_bytes=0
    local ssd_count=0
    local ssd_bytes=0
    local hdd_count=0
    local hdd_bytes=0

    for disk in $(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep "nvme" | awk '{print $1}'); do
        nvme_count=$((nvme_count + 1))
        local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',' || echo "0")
        nvme_bytes=$((nvme_bytes + size))
    done

    for disk in $(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "nvme" | command grep -v "zram" | awk '{print $1}'); do
        local rotational=$(cat /sys/block/$disk/queue/rotational 2>/dev/null || echo "1")
        local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',' || echo "0")

        if [[ $rotational -eq 0 ]]; then
            ssd_count=$((ssd_count + 1))
            ssd_bytes=$((ssd_bytes + size))
        else
            hdd_count=$((hdd_count + 1))
            hdd_bytes=$((hdd_bytes + size))
        fi
    done

    local nvme_size=$(format_bytes_to_size $nvme_bytes)
    local ssd_size=$(format_bytes_to_size $ssd_bytes)
    local hdd_size=$(format_bytes_to_size $hdd_bytes)

    echo "${nvme_count}|${nvme_size}|${ssd_count}|${ssd_size}|${hdd_count}|${hdd_size}"
}

get_disk_smart_info() {
    local device=$1
    local smart_output=$(smartctl -a /dev/$device 2>/dev/null || echo "")

    if [[ -z "$smart_output" ]]; then
        echo "Unknown|Unknown|Unknown|0|0|0|0|0|0|100"
        return
    fi

    # Vendor
    local vendor=$(echo "$smart_output" | command grep "Vendor:" | cut -d: -f2 | xargs || echo "")

    # Model Number
    local model=$(echo "$smart_output" | command grep "Model Number:" | cut -d: -f2 | xargs || echo "")
    if [[ -z "$model" ]]; then
        model=$(echo "$smart_output" | command grep "Device Model:" | cut -d: -f2 | xargs || echo "Unknown")
    fi

    # Firmware
    local firmware=$(echo "$smart_output" | command grep "Firmware Version:" | cut -d: -f2 | xargs || echo "Unknown")

    # Power-On Hours
    local power_hours=$(echo "$smart_output" | command grep "Power_On_Hours" | awk '{print $10}' | tr -d '.' | tr -d ',' || echo "0")
    if [[ "$power_hours" == "0" ]] || [[ -z "$power_hours" ]]; then
        power_hours=$(echo "$smart_output" | command grep "Power On Hours:" | awk '{print $4}' | tr -d '.' | tr -d ',' || echo "0")
    fi

    # Temperature
    local temp=$(echo "$smart_output" | command grep "Temperature:" | awk '{print $2}' || echo "0")
    if [[ "$temp" == "0" ]] || [[ -z "$temp" ]]; then
        temp=$(echo "$smart_output" | command grep "Temperature_Celsius" | awk '{print $10}' || echo "0")
    fi

    # Data Written - UNTERSCHEIDUNG NVMe vs SATA
    local data_written_bytes=0
    local data_units=$(echo "$smart_output" | command grep "Data Units Written:" | awk '{print $4}' | tr -d '.' | tr -d ',' || echo "0")
    if [[ "$data_units" != "0" ]] && [[ -n "$data_units" ]]; then
        # NVMe: 1 Data Unit = 512 KB
        data_written_bytes=$((data_units * 524288))
    else
        # SATA: Total_LBAs_Written (512 Byte Sektoren)
        local lbas_written=$(echo "$smart_output" | command grep "Total_LBAs_Written" | awk '{print $10}' | tr -d '.' | tr -d ',' || echo "0")
        if [[ "$lbas_written" != "0" ]] && [[ -n "$lbas_written" ]]; then
            data_written_bytes=$((lbas_written * 512))
        fi
    fi

    # NVMe-spezifische Werte
    local media_errors=0
    local critical_warning=0
    if [[ $device == nvme* ]]; then
        media_errors=$(echo "$smart_output" | command grep "Media and Data Integrity Errors:" | awk '{print $6}' || echo "0")
        critical_warning=$(echo "$smart_output" | command grep "Critical Warning:" | awk '{print $3}' || echo "0x00")
        # Wenn Critical Warning != 0x00 → Problem!
        [[ "$critical_warning" != "0x00" ]] && critical_warning=1 || critical_warning=0
    fi

    # SSD/HDD-spezifische Werte
    local reallocated=0
    local pending=0
    local crc_errors=0
    local program_fail=0

    if [[ $device != nvme* ]]; then
        reallocated=$(echo "$smart_output" | command grep "Reallocated_Sector_Ct" | awk '{print $10}' || echo "0")
        pending=$(echo "$smart_output" | command grep "Current_Pending_Sector" | awk '{print $10}' || echo "0")
        crc_errors=$(echo "$smart_output" | command grep "UDMA_CRC_Error_Count" | awk '{print $10}' || echo "0")
        program_fail=$(echo "$smart_output" | command grep "Program_Fail_Count" | awk '{print $10}' || echo "0")
    fi

    # Health % (NVMe: Percentage Used invertieren)
    local health=100
    local health_attr=$(echo "$smart_output" | command grep "Percentage Used:" | awk '{print $3}' | tr -d '%' || echo "")
    if [[ -n "$health_attr" ]]; then
        health=$((100 - health_attr))
    fi

    # Vendor aus Model extrahieren wenn leer
    if [[ -z "$vendor" ]] || [[ "$vendor" == "Unknown" ]]; then
        vendor=$(echo "$model" | awk '{print $1}')
    fi

    # Output: vendor|model|firmware|hours|written|temp|realloc|pending|media_err|crc|program_fail|critical_warn|health
    echo "${vendor}|${model}|${firmware}|${power_hours}|${data_written_bytes}|${temp}|${reallocated}|${pending}|${media_errors}|${crc_errors}|${program_fail}|${health}"
}

# ═══════════════════════════════════════════════════════
# OUTPUT - TERMINAL (mit Farben)
# ═══════════════════════════════════════════════════════

print_terminal_output() {
    local output_file="$1"

    echo ""
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${BLUE}  HARDWARE AUDIT ERGEBNIS ${DIM}(v${SCRIPT_VERSION})${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════${NC}\n"

    # Header
    IFS='|' read -r distro_name kernel_version <<< "$(get_distribution_info)"

    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  HARDWARE AUDIT - ${WHITE}${HOSTNAME}${NC}"
    echo -e "${DIM}  Datum: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${DIM}  Distribution: ${distro_name}${NC}"
    echo -e "${DIM}  Kernel: ${kernel_version}${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════${NC}\n"

    # Mainboard
    IFS='|' read -r mb_vendor mb_product chipset <<< "$(get_mainboard_info)"
    IFS='|' read -r bios_vendor bios_version bios_date <<< "$(get_bios_info)"

    echo -e "${BOLD}${MAGENTA}📋 MAINBOARD & CHIPSATZ${NC}"
    echo -e "${DIM}├─ Hersteller:${NC} ${WHITE}${mb_vendor}${NC}"
    echo -e "${DIM}├─ Model:${NC} ${WHITE}${mb_product}${NC}"
    echo -e "${DIM}├─ Chipsatz:${NC} ${WHITE}${chipset}${NC}"
    echo -e "${DIM}└─ BIOS:${NC} ${WHITE}${bios_vendor} ${bios_version}${NC} ${DIM}(${bios_date})${NC}\n"

    # CPU
    IFS='|' read -r cpu_vendor cpu_model cpu_short cpu_cores cpu_base cpu_turbo <<< "$(get_cpu_info)"

    echo -e "${BOLD}${MAGENTA}💻 CPU${NC}"
    echo -e "${DIM}├─ Hersteller:${NC} ${WHITE}${cpu_vendor}${NC}"
    echo -e "${DIM}├─ Model:${NC} ${WHITE}${cpu_model}${NC}"
    echo -e "${DIM}├─ Kerne:${NC} ${WHITE}${cpu_cores}${NC}"
    echo -e "${DIM}└─ Takt:${NC} ${WHITE}${cpu_base} GHz${NC} ${DIM}(Turbo: ${WHITE}${cpu_turbo} GHz${DIM})${NC}\n"

    # GPU (alle)
    echo -e "${BOLD}${MAGENTA}🎮 GPU${NC}"
    local gpu_num=0
    while IFS='|' read -r vendor model vram clock; do
        gpu_num=$((gpu_num + 1))
        echo -e "${DIM}GPU ${gpu_num}:${NC}"
        echo -e "${DIM}├─ Hersteller:${NC} ${WHITE}${vendor}${NC}"
        echo -e "${DIM}├─ Model:${NC} ${WHITE}${model}${NC}"
        echo -e "${DIM}├─ VRAM:${NC} ${WHITE}${vram}${NC}"
        echo -e "${DIM}└─ Max Takt:${NC} ${WHITE}${clock}${NC}"
    done < <(get_all_gpus_info)
    echo ""

    # RAM
    IFS='|' read -r ram_total_gb ram_modules ram_manufacturer ram_speed ram_type timings <<< "$(get_ram_info)"
    echo -e "${BOLD}${MAGENTA}🧠 RAM${NC}"
    echo -e "${DIM}├─ Total:${NC} ${WHITE}${ram_total_gb} GB${NC}"
    echo -e "${DIM}├─ Hersteller:${NC} ${WHITE}${ram_manufacturer}${NC} ${DIM}(${ram_modules}x Module)${NC}"
    echo -e "${DIM}├─ Typ:${NC} ${WHITE}${ram_type}${NC}"
    echo -e "${DIM}├─ Speed:${NC} ${WHITE}${ram_speed}${NC}"
    echo -e "${DIM}└─ Timings:${NC} ${WHITE}${timings}${NC}\n"

    # Storage Overview
    IFS='|' read -r nvme_count nvme_size ssd_count ssd_size hdd_count hdd_size <<< "$(get_storage_overview)"

    echo -e "${BOLD}${MAGENTA}💾 STORAGE ÜBERSICHT${NC}"
    [[ $nvme_count -gt 0 ]] && echo -e "${DIM}├─ NVMe:${NC} ${WHITE}${nvme_size}${NC} ${DIM}(${nvme_count} Geräte)${NC}"
    [[ $ssd_count -gt 0 ]] && echo -e "${DIM}├─ SSD:${NC} ${WHITE}${ssd_size}${NC} ${DIM}(${ssd_count} Geräte)${NC}"
    [[ $hdd_count -gt 0 ]] && echo -e "${DIM}└─ HDD:${NC} ${WHITE}${hdd_size}${NC} ${DIM}(${hdd_count} Geräte)${NC}"
    echo ""

    # Storage Details
    echo -e "${BOLD}${MAGENTA}🏥 STORAGE HEALTH & DETAILS${NC}\n"

    # NVMe
    local nvme_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep "nvme" | awk '{print $1}')
    if [[ -n "$nvme_list" ]]; then
        echo -e "${CYAN}━━━ NVMe Devices ━━━${NC}"
        printf "${DIM}%-9s %-24s %-11s %-9s %-10s %-10s %-7s %-7s %-5s %-7s${NC}\n" \
            "Device" "Model" "Firmware" "Größe" "Hours" "Written" "Temp" "Media" "Crit" "Health"
        echo -e "${DIM}$(printf '%.0s─' {1..105})${NC}"

        for disk in $nvme_list; do
            IFS='|' read -r vendor model firmware hours written_bytes temp realloc pending media_err crc prog_fail health \
                <<< "$(get_disk_smart_info "$disk")"

            local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
            local size_human=$(format_bytes_to_size "$size")
            local written_human=$(format_bytes_to_size "$written_bytes")

            # Hours Farbe
            local hours_color="${GREEN}"
            [[ $hours -gt 40000 ]] && hours_color="${YELLOW}"
            [[ $hours -gt 70000 ]] && hours_color="${MAGENTA}"
            [[ $hours -gt 90000 ]] && hours_color="${RED}"

            # Temp Farbe
            local temp_color="${GREEN}"
            [[ $temp -gt 50 ]] && temp_color="${YELLOW}"
            [[ $temp -gt 70 ]] && temp_color="${RED}"

            # Health Farbe
            local health_color="${GREEN}"
            [[ $health -lt 90 ]] && health_color="${YELLOW}"
            [[ $health -lt 80 ]] && health_color="${RED}"

            # Media Errors Farbe
            local media_color="${GREEN}"
            [[ $media_err -gt 0 ]] && media_color="${RED}"

            # Critical Warning Farbe (prog_fail wird wiederverwendet)
            local crit_color="${GREEN}"
            [[ $prog_fail -gt 0 ]] && crit_color="${RED}"

            printf "%-9s ${WHITE}%-24s${NC} ${DIM}%-11s${NC} %-9s ${hours_color}%-10s${NC} %-10s ${temp_color}%-7s${NC} ${media_color}%-7s${NC} ${crit_color}%-5s${NC} ${health_color}%-7s${NC}\n" \
                "$disk" "${model:0:24}" "$firmware" "$size_human" "${hours}h" "$written_human" "${temp}°C" "$media_err" "$prog_fail" "${health}%"
        done
        echo ""
    fi

    # SSD
    local ssd_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "nvme" | command grep -v "zram" | awk '{print $1}' | while read d; do [[ $(cat /sys/block/$d/queue/rotational 2>/dev/null || echo "1") -eq 0 ]] && echo $d; done)
    if [[ -n "$ssd_list" ]]; then
        echo -e "${CYAN}━━━ SSD Devices ━━━${NC}"
        printf "${DIM}%-9s %-24s %-11s %-9s %-10s %-10s %-7s %-7s %-7s %-7s${NC}\n" \
            "Device" "Model" "Firmware" "Größe" "Hours" "Written" "Temp" "Realloc" "ProgF" "Health"
        echo -e "${DIM}$(printf '%.0s─' {1..110})${NC}"

        for disk in $ssd_list; do
            IFS='|' read -r vendor model firmware hours written_bytes temp realloc pending media_err crc prog_fail health \
                <<< "$(get_disk_smart_info "$disk")"

            local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
            local size_human=$(format_bytes_to_size "$size")
            local written_human=$(format_bytes_to_size "$written_bytes")

            # Hours Farbe
            local hours_color="${GREEN}"
            [[ $hours -gt 20000 ]] && hours_color="${YELLOW}"
            [[ $hours -gt 40000 ]] && hours_color="${MAGENTA}"
            [[ $hours -gt 60000 ]] && hours_color="${RED}"

            # Temp Farbe
            local temp_color="${GREEN}"
            [[ $temp -gt 50 ]] && temp_color="${YELLOW}"
            [[ $temp -gt 70 ]] && temp_color="${RED}"

            # Reallocated Farbe
            local realloc_color="${GREEN}"
            [[ $realloc -gt 0 ]] && realloc_color="${RED}"

            # Program Fail Farbe
            local prog_color="${GREEN}"
            [[ $prog_fail -gt 0 ]] && prog_color="${YELLOW}"
            [[ $prog_fail -gt 100 ]] && prog_color="${RED}"

            # Health Farbe
            local health_color="${GREEN}"
            [[ $health -lt 90 ]] && health_color="${YELLOW}"
            [[ $health -lt 80 ]] && health_color="${RED}"

            printf "%-9s ${WHITE}%-24s${NC} ${DIM}%-11s${NC} %-9s ${hours_color}%-10s${NC} %-10s ${temp_color}%-7s${NC} ${realloc_color}%-7s${NC} ${prog_color}%-7s${NC} ${health_color}%-7s${NC}\n" \
                "$disk" "${model:0:24}" "$firmware" "$size_human" "${hours}h" "$written_human" "${temp}°C" "$realloc" "$prog_fail" "${health}%"
        done
        echo ""
    fi

    # HDD
    local hdd_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "nvme" | command grep -v "zram" | awk '{print $1}' | while read d; do [[ $(cat /sys/block/$d/queue/rotational 2>/dev/null || echo "0") -eq 1 ]] && echo $d; done)
    if [[ -n "$hdd_list" ]]; then
        echo -e "${CYAN}━━━ HDD Devices ━━━${NC}"
        printf "${DIM}%-9s %-24s %-11s %-9s %-10s %-7s %-8s %-8s %-8s %-7s${NC}\n" \
            "Device" "Model" "Firmware" "Größe" "Hours" "Temp" "Realloc" "Pending" "CRC" "Health"
        echo -e "${DIM}$(printf '%.0s─' {1..105})${NC}"

        for disk in $hdd_list; do
            IFS='|' read -r vendor model firmware hours written_bytes temp realloc pending media_err crc prog_fail health \
                <<< "$(get_disk_smart_info "$disk")"

            local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
            local size_human=$(format_bytes_to_size "$size")

            # Hours Farbe
            local hours_color="${GREEN}"
            [[ $hours -gt 40000 ]] && hours_color="${YELLOW}"
            [[ $hours -gt 70000 ]] && hours_color="${MAGENTA}"
            [[ $hours -gt 90000 ]] && hours_color="${RED}"

            # Temp Farbe
            local temp_color="${GREEN}"
            [[ $temp -gt 45 ]] && temp_color="${YELLOW}"
            [[ $temp -gt 55 ]] && temp_color="${RED}"

            # Reallocated Farbe
            local realloc_color="${GREEN}"
            [[ $realloc -gt 0 ]] && realloc_color="${YELLOW}"
            [[ $realloc -gt 10 ]] && realloc_color="${RED}"

            # Pending Farbe
            local pending_color="${GREEN}"
            [[ $pending -gt 0 ]] && pending_color="${RED}"

            # CRC Farbe
            local crc_color="${GREEN}"
            [[ $crc -gt 0 ]] && crc_color="${YELLOW}"
            [[ $crc -gt 100 ]] && crc_color="${RED}"

            # Health Farbe
            local health_color="${GREEN}"
            [[ $health -lt 90 ]] && health_color="${YELLOW}"
            [[ $health -lt 80 ]] && health_color="${RED}"

            printf "%-9s ${WHITE}%-24s${NC} ${DIM}%-11s${NC} %-9s ${hours_color}%-10s${NC} ${temp_color}%-7s${NC} ${realloc_color}%-8s${NC} ${pending_color}%-8s${NC} ${crc_color}%-8s${NC} ${health_color}%-7s${NC}\n" \
                "$disk" "${model:0:24}" "$firmware" "$size_human" "${hours}h" "${temp}°C" "$realloc" "$pending" "$crc" "${health}%"
        done
        echo ""
    fi

    # Warnungen
    echo -e "${BOLD}${YELLOW}⚠  WARNUNGEN${NC}"

    local warnings_found=0
    for disk in $(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "zram" | awk '{print $1}'); do
        IFS='|' read -r vendor model firmware hours written health <<< "$(get_disk_smart_info "$disk")"

        if [[ $hours -gt 40000 ]]; then
            local years=$(echo "scale=1; $hours / 8760" | bc)
            echo -e "${YELLOW}├─ ${disk}: ${hours}h Power-On (${years}+ Jahre) - Backup empfohlen${NC}"
            warnings_found=1
        fi

        if [[ $health -lt 80 ]]; then
            echo -e "${RED}├─ ${disk}: Health ${health}% - DISK-TAUSCH PLANEN!${NC}"
            warnings_found=1
        fi
    done

    [[ $warnings_found -eq 0 ]] && echo -e "${GREEN}└─ Keine Warnungen${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════
# OUTPUT - DATEI (Plain Text, keine Farben)
# ═══════════════════════════════════════════════════════

generate_markdown_output() {
    local output_file="$1"

    > "$output_file"

    {
        IFS='|' read -r distro_name kernel_version <<< "$(get_distribution_info)"

        echo "═══════════════════════════════════════════════════════"
        echo "  HARDWARE AUDIT - ${HOSTNAME}"
        echo "  Datum: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "  Distribution: ${distro_name}"
        echo "  Kernel: ${kernel_version}"
        echo "═══════════════════════════════════════════════════════"
        echo ""

        IFS='|' read -r mb_vendor mb_product chipset <<< "$(get_mainboard_info)"
        IFS='|' read -r bios_vendor bios_version bios_date <<< "$(get_bios_info)"

        echo "📋 MAINBOARD & CHIPSATZ"
        echo "├─ Hersteller: ${mb_vendor}"
        echo "├─ Model: ${mb_product}"
        echo "├─ Chipsatz: ${chipset}"
        echo "└─ BIOS: ${bios_vendor} ${bios_version} (${bios_date})"
        echo ""

        IFS='|' read -r cpu_vendor cpu_model cpu_short cpu_cores cpu_base cpu_turbo <<< "$(get_cpu_info)"

        echo "💻 CPU"
        echo "├─ Hersteller: ${cpu_vendor}"
        echo "├─ Model: ${cpu_model}"
        echo "├─ Kerne: ${cpu_cores}"
        echo "└─ Takt: ${cpu_base} GHz (Turbo: ${cpu_turbo} GHz)"
        echo ""

        echo "🎮 GPU"
        local gpu_num=0
        while IFS='|' read -r vendor model vram clock; do
            gpu_num=$((gpu_num + 1))
            echo "GPU ${gpu_num}:"
            echo "├─ Hersteller: ${vendor}"
            echo "├─ Model: ${model}"
            echo "├─ VRAM: ${vram}"
            echo "└─ Max Takt: ${clock}"
        done < <(get_all_gpus_info)
        echo ""

        IFS='|' read -r ram_total_gb ram_modules ram_manufacturer ram_speed ram_type <<< "$(get_ram_info)"

        echo "🧠 RAM"
        echo "├─ Total: ${ram_total_gb} GB"
        echo "├─ Hersteller: ${ram_manufacturer} (${ram_modules}x Module)"
        echo "├─ Typ: ${ram_type}"
        echo "└─ Speed: ${ram_speed}"
        echo ""

        IFS='|' read -r nvme_count nvme_size ssd_count ssd_size hdd_count hdd_size <<< "$(get_storage_overview)"

        echo "💾 STORAGE ÜBERSICHT"
        [[ $nvme_count -gt 0 ]] && echo "├─ NVMe: ${nvme_size} (${nvme_count} Geräte)"
        [[ $ssd_count -gt 0 ]] && echo "├─ SSD: ${ssd_size} (${ssd_count} Geräte)"
        [[ $hdd_count -gt 0 ]] && echo "└─ HDD: ${hdd_size} (${hdd_count} Geräte)"
        echo ""

        echo "🏥 STORAGE HEALTH & DETAILS"
        echo ""

        local nvme_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep "nvme" | awk '{print $1}')
        if [[ -n "$nvme_list" ]]; then
            echo "━━━ NVMe Devices ━━━"
            printf "%-8s %-25s %-12s %-10s %-10s %-10s %-7s\n" "Device" "Model" "Firmware" "Größe" "Hours" "Written" "Health"
            printf "%.0s─" {1..90}
            echo ""

            for disk in $nvme_list; do
                IFS='|' read -r vendor model firmware hours written_bytes health <<< "$(get_disk_smart_info "$disk")"
                local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
                local size_human=$(format_bytes_to_size "$size")
                local written_human=$(format_bytes_to_size "$written_bytes")

                printf "%-8s %-25s %-12s %-10s %-10s %-10s %3s%%\n" \
                    "$disk" "${model:0:25}" "$firmware" "$size_human" "${hours}h" "$written_human" "$health"
            done
            echo ""
        fi

        local ssd_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "nvme" | command grep -v "zram" | awk '{print $1}' | while read d; do [[ $(cat /sys/block/$d/queue/rotational 2>/dev/null || echo "1") -eq 0 ]] && echo $d; done)
        if [[ -n "$ssd_list" ]]; then
            echo "━━━ SSD Devices ━━━"
            printf "%-8s %-25s %-12s %-10s %-10s %-10s %-7s\n" "Device" "Model" "Firmware" "Größe" "Hours" "Written" "Health"
            printf "%.0s─" {1..90}
            echo ""

            for disk in $ssd_list; do
                IFS='|' read -r vendor model firmware hours written_bytes health <<< "$(get_disk_smart_info "$disk")"
                local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
                local size_human=$(format_bytes_to_size "$size")
                local written_human=$(format_bytes_to_size "$written_bytes")

                printf "%-8s %-25s %-12s %-10s %-10s %-10s %3s%%\n" \
                    "$disk" "${model:0:25}" "$firmware" "$size_human" "${hours}h" "$written_human" "$health"
            done
            echo ""
        fi

        local hdd_list=$(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "nvme" | command grep -v "zram" | awk '{print $1}' | while read d; do [[ $(cat /sys/block/$d/queue/rotational 2>/dev/null || echo "0") -eq 1 ]] && echo $d; done)
        if [[ -n "$hdd_list" ]]; then
            echo "━━━ HDD Devices ━━━"
            printf "%-8s %-25s %-12s %-10s %-10s %-7s\n" "Device" "Model" "Firmware" "Größe" "Hours" "Health"
            printf "%.0s─" {1..80}
            echo ""

            for disk in $hdd_list; do
                IFS='|' read -r vendor model firmware hours written health <<< "$(get_disk_smart_info "$disk")"
                local size=$(LC_ALL=C lsblk -b -d -o SIZE /dev/$disk 2>/dev/null | tail -n1 | tr -d '.' | tr -d ',')
                local size_human=$(format_bytes_to_size "$size")

                printf "%-8s %-25s %-12s %-10s %-10s %3s%%\n" \
                    "$disk" "${model:0:25}" "$firmware" "$size_human" "${hours}h" "$health"
            done
            echo ""
        fi

        echo "⚠  WARNUNGEN"

        local warnings_found=0
        for disk in $(LC_ALL=C lsblk -d -o NAME,TYPE 2>/dev/null | command grep "disk" | command grep -v "zram" | awk '{print $1}'); do
            IFS='|' read -r vendor model firmware hours written health <<< "$(get_disk_smart_info "$disk")"

            if [[ $hours -gt 40000 ]]; then
                local years=$(echo "scale=1; $hours / 8760" | bc)
                echo "├─ ${disk}: ${hours}h Power-On (${years}+ Jahre) - Backup empfohlen"
                warnings_found=1
            fi

            if [[ $health -lt 80 ]]; then
                echo "├─ ${disk}: Health ${health}% - DISK-TAUSCH PLANEN!"
                warnings_found=1
            fi
        done

        [[ $warnings_found -eq 0 ]] && echo "└─ Keine Warnungen"
        echo ""

    } >> "$output_file"
}

print_welcome_header() {
    clear
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                       ║${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}${BLUE}🖥  HARDWARE INFO SCRIPT (hwi)${NC}  ${CYAN}v${SCRIPT_VERSION}${NC}                ${CYAN}║${NC}"
    echo -e "${CYAN}║                                                       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}${MAGENTA}📊 System:${NC}"
    echo -e "   ${CYAN}•${NC} ${DIM}Host:${NC}  ${WHITE}${HOSTNAME}${NC}"
    echo -e "   ${CYAN}•${NC} ${DIM}Datum:${NC} ${WHITE}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "   ${CYAN}•${NC} ${DIM}User:${NC}  ${WHITE}${REAL_USER}${NC}"
    echo ""
    echo -e "${BOLD}${YELLOW}✨ Features v${SCRIPT_VERSION}:${NC}"
    echo -e "   ${CYAN}➜${NC} Multi-Distro (Arch/Debian/Ubuntu/Mint)"
    echo -e "   ${CYAN}➜${NC} Flexible Output-Modi (Standard/Custom/mr-bytez)"
    echo -e "   ${CYAN}➜${NC} Erweiterte SMART-Daten (Hours/Written/Health%)"
    echo -e "   ${CYAN}➜${NC} Storage-Typen getrennt (NVMe/SSD/HDD)"
    echo -e "   ${CYAN}➜${NC} Alle GPUs mit Taktraten"
    echo ""
    echo -e "${BOLD}${GREEN}💾 Output-Modi:${NC}"
    case "$OUTPUT_MODE" in
        standard)
            echo -e "   ${WHITE}Standard:${NC} ~/hostname_hardware.md"
            ;;
        custom)
            echo -e "   ${WHITE}Custom:${NC} ${CUSTOM_OUTPUT_DIR}/hostname_hardware.md"
            ;;
        mrbz)
            echo -e "   ${WHITE}mr-bytez:${NC} /mr-bytez/projects/infrastructure/hostname/HARDWARE.md"
            ;;
    esac
    echo ""
}

# ═══════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════

main() {
    parse_arguments "$@"

    print_welcome_header

    if [[ $EUID -ne 0 ]]; then
        echo -e "${YELLOW}🔐 Root-Rechte erforderlich${NC}"
        echo -e "${CYAN}   Bitte sudo-Passwort eingeben:${NC}\n"
        exec sudo -E "$0" "$@"
    fi

    echo -e "${GREEN}✓ Root-Rechte erhalten${NC}\n"

    check_required_tools

    echo -e "${CYAN}🔍 Sammle Hardware-Informationen...${NC}"
    echo -e "${DIM}   (dauert ~5-10 Sekunden)${NC}\n"

    local output_file=$(get_output_path)

    chown ${REAL_USER}:${REAL_USER} "$output_file" 2>/dev/null || true

    generate_markdown_output "$output_file"

    sleep 2

    print_terminal_output "$output_file"

    echo -e "${GREEN}✅ Hardware-Audit abgeschlossen!${NC}"
    echo -e "${CYAN}📄 Gespeichert:${NC} ${WHITE}${output_file}${NC}\n"
}

main "$@"
