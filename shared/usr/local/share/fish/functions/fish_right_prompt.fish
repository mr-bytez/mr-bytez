# ============================================
# mr-bytez Fish Right Prompt
# Version: 2.1.0
# Deployment: shared/usr/local/share/fish/functions/
# Benötigt: 00-theme.fish für Farben, Icons, Separatoren
# ============================================

function fish_right_prompt
    set -l sep $MR_SEP_RIGHT
    
    # ============================================
    # CMD DURATION (wenn > 1 Sekunde)
    # ============================================
    
    if test $CMD_DURATION
        if test $CMD_DURATION -gt 1000
            set -l duration_sec (math "$CMD_DURATION / 1000")
            
            # Fehler? Rot + Symbol
            if test $__mr_last_status -ne 0
                set_color $MR_BG_ERROR
                echo -n $sep
                set_color --bold -b $MR_BG_ERROR $MR_TEXT_PRIMARY
                echo -n " $MR_ICON_ERROR $MR_ICON_TIMER "$duration_sec"s "
            else
                # Erfolg? Grün + Haken
                set_color $MR_BG_SUCCESS
                echo -n $sep
                set_color --bold -b $MR_BG_SUCCESS $MR_TEXT_SUCCESS
                echo -n " $MR_ICON_SUCCESS $MR_ICON_TIMER "$duration_sec"s "
            end        
        end
    end
    
    # ============================================
    # ZEIT (bold!)
    # ============================================
    
    set_color $MR_BG_TIME
    echo -n $sep
    set_color --bold -b $MR_BG_TIME $MR_TEXT_PRIMARY
    echo -n ' '(date '+%H:%M:%S')' '
    
    set_color normal
end
