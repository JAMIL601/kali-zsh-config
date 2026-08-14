# ==========================================================
# Aliases
# ==========================================================

alias history="history 0"

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if command -v dircolors >/dev/null 2>&1; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi
