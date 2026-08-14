# ==========================================================
# Tool Completion Enhancements
# ==========================================================
#
# Purpose:
#   Small, safe enhancements for command/tool completion.
#
# Design:
#   - Does NOT replace normal Zsh completion
#   - Does NOT override Tab
#   - Does NOT create a second completion widget
#   - Works alongside fzf-tab
#   - Safe to disable independently
#
# ==========================================================


# ----------------------------------------------------------
# Completion styles for command arguments
# ----------------------------------------------------------

# Keep completion results readable.
zstyle ':completion:*' menu select

# Use case-insensitive matching.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Show useful descriptions when available.
zstyle ':completion:*' verbose true
zstyle ':completion:*' auto-description 'specify: %d'

# Keep completion groups visually separated.
zstyle ':completion:*' group-name ''


# ----------------------------------------------------------
# Command completion
# ----------------------------------------------------------

# Ask Zsh to rehash commands when necessary.
# This helps when a new executable is installed while
# the shell is already running.
zstyle ':completion:*' rehash true


# ----------------------------------------------------------
# Option completion
# ----------------------------------------------------------

# When a command has Zsh completion metadata, allow its
# command-line options to be completed normally.
#
# IMPORTANT:
# We intentionally do NOT create our own list of options.
# This prevents fake/outdated options from being suggested.
zstyle ':completion:*' completer _expand _complete


# ----------------------------------------------------------
# File completion
# ----------------------------------------------------------

# Keep filesystem completion enabled for commands that
# accept paths such as:
#
#   cp
#   mv
#   rm
#   ln
#   cat
#   less
#   nano
#   vim
#   ssh
#   scp
#
# Zsh decides what is valid for each command.
zstyle ':completion:*' file-sort name


# ----------------------------------------------------------
# Directory completion
# ----------------------------------------------------------

# Prefer directory completion when the command expects
# a directory.
zstyle ':completion:*' list-dirs-first true


# ----------------------------------------------------------
# Process completion
# ----------------------------------------------------------

# Useful for commands such as kill.
zstyle ':completion:*:*:kill:*' command \
    'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# ----------------------------------------------------------
# SSH host completion
# ----------------------------------------------------------

# Zsh can normally complete hosts from SSH configuration
# and known-host information.
#
# We do not manually parse ~/.ssh here because Zsh already
# provides SSH completion where supported.


# ----------------------------------------------------------
# Command cache refresh helper
# ----------------------------------------------------------

_tool_completion_refresh() {
    rehash
    zle -M "Command completion cache refreshed"
}

zle -N _tool_completion_refresh


# ----------------------------------------------------------
# Optional shortcut
# Ctrl + Alt + R = refresh command completion cache
# ----------------------------------------------------------

bindkey '^[^R' _tool_completion_refresh


# ----------------------------------------------------------
# Safety check
# ----------------------------------------------------------

# Nothing in this file replaces:
#
#   Tab
#   self-insert
#   accept-line
#   fzf-tab widgets
#   autosuggestions
#
# The module only configures completion styles and provides
# an optional manual refresh shortcut.
