# ============================================
# __mr_git_status.fish - Git Status Helper
# Pfad: shared/etc/fish/functions/
# Author: Michael Rohwer
# Created: 2026-01-23
# Version: 1.0.0
# Purpose: Gibt Git-Branch + Status-Symbole zurück
# ============================================

function __mr_git_status
    # Prüfe ob wir in einem Git-Repo sind
    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        return
    end
    
    # Branch-Name holen
    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        # Detached HEAD - zeige kurzen Hash
        set branch (command git rev-parse --short HEAD 2>/dev/null)
        if test -z "$branch"
            return
        end
        set branch "($branch)"
    end
    
    # Status-Symbole sammeln
    set -l symbols ''
    
    # Uncommitted changes (modified/deleted)
    if not command git diff --quiet 2>/dev/null
        set symbols "$symbols*"
    end
    
    # Staged changes
    if not command git diff --cached --quiet 2>/dev/null
        set symbols "$symbols+"
    end
    
    # Untracked files
    if test -n "(command git ls-files --others --exclude-standard 2>/dev/null)"
        set symbols "$symbols?"
    end
    
    # Ahead/Behind upstream
    set -l upstream (command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
    if test -n "$upstream"
        set -l ahead (command git rev-list --count '@{upstream}..HEAD' 2>/dev/null)
        set -l behind (command git rev-list --count 'HEAD..@{upstream}' 2>/dev/null)
        
        if test "$ahead" -gt 0 2>/dev/null
            set symbols "$symbols↑$ahead"
        end
        if test "$behind" -gt 0 2>/dev/null
            set symbols "$symbols↓$behind"
        end
    end
    
    # Merge conflict
    if test -f (command git rev-parse --git-dir 2>/dev/null)/MERGE_HEAD
        set symbols "$symbols⚡"
    end
    
    # Ausgabe: "branch symbols" oder nur "branch"
    if test -n "$symbols"
        echo "$branch $symbols"
    else
        echo "$branch"
    end
end
