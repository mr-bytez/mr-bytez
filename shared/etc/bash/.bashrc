# ┌─────────────────────────────────────────────────────────┐
# │  MR-ByteZ — Minimale Bash-Config                      │
# │  Datei:    .bashrc                                     │
# │  Pfad:     shared/etc/bash/.bashrc                     │
# │  Zweck:    Fallback fuer Hosts ohne Fish als Default   │
# │  Version:  0.1.0                                       │
# │  Autor:    MR-ByteZ                                    │
# │  Erstellt: 2026-03-01                                  │
# └─────────────────────────────────────────────────────────┘
#
# Diese .bashrc ist ein minimaler Fallback fuer Hosts, bei denen
# Fish nicht als Default-Login-Shell gesetzt ist. Sie leitet
# interaktive Sessions automatisch an Fish weiter.
#
# Deployment: cp shared/etc/bash/.bashrc ~/.bashrc

# --- Interaktive Shell? ---
# Nicht-interaktive Shells (z.B. scp, rsync) nicht umleiten!
[[ $- != *i* ]] && return

# --- Fish starten (falls vorhanden) ---
if command -v fish &>/dev/null; then
    exec fish
fi

# --- Fallback: Minimales Bash-Setup ---
# Falls Fish nicht installiert ist

# Prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Basis-Aliases
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# History
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth
shopt -s histappend

# Hinweis
echo "WARNUNG: Fish nicht gefunden — Bash-Fallback aktiv."
echo "Installieren: sudo pacman -S fish"
