# ==========================================================
# Kali Zsh Config
# Tool Completion Enhancements
# ==========================================================
#
# Purpose:
#   - Improve command completion behavior
#   - Refresh Zsh command cache when requested
#   - Keep normal TAB completion untouched
#   - Keep fzf-tab untouched
#   - Keep autosuggestions untouched
#
# This module does NOT replace:
#   - TAB
#   - self-insert
#   - accept-line
#   - fzf-tab widgets
#   - zsh-autosuggestions
#
# ==========================================================


# ----------------------------------------------------------
# Safety
# ----------------------------------------------------------

# This file is intended for interactive Zsh.
# Do nothing if Zsh is not running interactively.

[[ -o interactive ]] || return


# ----------------------------------------------------------
# Command completion refresh helper
# ----------------------------------------------------------

_tool_completion_refresh() {
    rehash

    zle -M "Command completion cache refreshed"

    zle redisplay
}

zle -N _tool_completion_refresh


# ----------------------------------------------------------
# Optional keyboard shortcut
# ----------------------------------------------------------
#
# Ctrl + Alt + R
# Refresh the command completion cache.
#
# This does NOT replace TAB.
# It does NOT replace self-insert.
# It does NOT replace accept-line.
#

bindkey '^[^R' _tool_completion_refresh


# ----------------------------------------------------------
# Completion refresh after command execution
# ----------------------------------------------------------
#
# Zsh normally updates its command hash when necessary.
# We intentionally do not force rehash after every command,
# because doing so would create unnecessary overhead.
#
# The manual shortcut above is provided when a newly installed
# command is not immediately visible to completion.
#


# ----------------------------------------------------------
# Safety check
# ----------------------------------------------------------
#
# Nothing in this file replaces:
#
#   TAB
#   self-insert
#   accept-line
#   fzf-tab widgets
#   zsh-autosuggestions
#
# The module only provides a safe command-cache refresh helper.
#
# ==========================================================
