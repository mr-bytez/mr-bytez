# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Fish Function                              │
# └─────────────────────────────────────────────────────────┘
# Datei:       fish_prompt.fish
# Pfad:        shared/etc/fish/functions/fish_prompt.fish
# Autor:       MR-ByteZ
# Version:     0.3.1
# Erstellt:    2026-01-25
# Aktualisiert:2026-02-28
# Zweck:       Powerline Prompt mit Git/Docker Status
# Abh.:        005-theme.fish (Farben, Icons, Separatoren)

function fish_prompt
    # Host-Farben holen [BG, TEXT]
    set -l host_colors (__mr_host_color)
    set -l host_bg $host_colors[1]
    set -l host_text $host_colors[2]
    set -g __mr_last_status $status
    set -l last_status $__mr_last_status

    # ============================================
    # VARIABLEN AUS THEME
    # ============================================

    set -l sep $MR_SEP_LEFT

    # Smart PWD (erste + letzte voll, Mitte gekürzt)
    set -l path_display
    if type -q __mr_smart_pwd
        set path_display (__mr_smart_pwd)
    else
        set path_display (prompt_pwd)
    end

    # ============================================
    # LEERZEICHEN VOR ERSTEM BLOCK
    # ============================================
    echo
    echo -n ' '

    # ============================================
    # BLOCK 1: User@Host (unterschiedliche Farben)
    # ============================================

    # User-Farbe je nach Typ (root/sudo/normal)
    if test (id -u) -eq 0
        set_color --bold -b $host_bg $MR_COLOR_TEXT_USER_ROOT
    else if groups 2>/dev/null | string match -q '*wheel*'
        set_color --bold -b $host_bg $MR_COLOR_TEXT_USER_SUDO
    else
        set_color --bold -b $host_bg $MR_COLOR_TEXT_USER_NORMAL
    end
    echo -n " $USER"
    set_color --bold -b $host_bg $host_text
    echo -n "@"(hostname -s)" "
    set_color -b $MR_COLOR_BG_PATH $host_bg
    echo -n $sep

    # ============================================
    # BLOCK 2: Pfad
    # ============================================

    set_color --bold -b $MR_COLOR_BG_PATH $MR_COLOR_TEXT_PATH
    echo -n " $MR_ICON_FOLDER $path_display "

    # ============================================
    # BLOCK 3: Git Status (optional)
    # ============================================

    if type -q __mr_git_status
        set -l git_info (__mr_git_status)
        if test -n "$git_info"
            set -l git_bg $MR_COLOR_BG_GIT_CLEAN
            if string match -q '*✗*' "$git_info"; or string match -q '*+*' "$git_info"
                set git_bg $MR_COLOR_BG_GIT_DIRTY
            end
            set_color -b $git_bg $MR_COLOR_BG_PATH
            echo -n $sep
            set_color --bold -b $git_bg $MR_COLOR_TEXT_GIT
            echo -n " $MR_ICON_GIT $git_info "
            set -g __mr_last_bg $git_bg
        else
            set -g __mr_last_bg $MR_COLOR_BG_PATH
        end
    else
        set -g __mr_last_bg $MR_COLOR_BG_PATH
    end

    # ============================================
    # BLOCK 4: Docker Status (optional)
    # ============================================

    if type -q __mr_docker_status
        set -l docker_info (__mr_docker_status)
        if test -n "$docker_info"
            set_color -b $MR_COLOR_BG_DOCKER $__mr_last_bg
            echo -n $sep
            set_color --bold -b $MR_COLOR_BG_DOCKER $MR_COLOR_TEXT_DOCKER
            echo -n " $MR_ICON_DOCKER $docker_info "
            set -g __mr_last_bg $MR_COLOR_BG_DOCKER
        end
    end

    # ============================================
    # ABSCHLUSS
    # ============================================

    set_color normal
    set_color $__mr_last_bg
    echo -n $sep
    set_color normal
    echo

    # ============================================
    # VI-MODE INDICATOR
    # ============================================
    #
    #switch $fish_bind_mode
    #    case default
    #        set_color $MR_VI_NORMAL
    #        echo -n "$MR_ICON_VI "
    #    case insert
    #        set_color $MR_VI_INSERT
    #        echo -n "$MR_ICON_VI "
    #    case replace_one replace
    #        set_color $MR_VI_REPLACE
    #        echo -n "$MR_ICON_VI "
    #    case visual
    #        set_color $MR_VI_VISUAL
    #        echo -n "$MR_ICON_VI "
    #end

    # ============================================
    # COMMAND PROMPT
    # ============================================

    # Prefix je nach User-Typ (root/sudo/normal) - gleiche Farben wie Username
    if test (id -u) -eq 0
        set_color --bold $MR_COLOR_TEXT_USER_ROOT
        echo -n "$MR_PROMPT_PREFIX_ROOT "
    else if groups 2>/dev/null | string match -q '*wheel*'
        set_color --bold $MR_COLOR_TEXT_USER_SUDO
        echo -n "$MR_PROMPT_PREFIX_SUDO "
    else
        set_color --bold $MR_COLOR_TEXT_USER_NORMAL
        echo -n "$MR_PROMPT_PREFIX_USER "
    end

    # Prompt-Symbol (Farbe je nach Status)
    if test $last_status -eq 0
        set_color --bold $MR_COLOR_PROMPT_SUCCESS
    else
        set_color $MR_COLOR_PROMPT_ERROR
    end
    echo -n "$MR_ICON_PROMPT "
    set_color normal
end
