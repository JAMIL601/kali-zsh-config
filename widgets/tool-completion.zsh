# ==========================================================
# Kali Zsh Config
# Tool Completion Enhancements
# ==========================================================
#
# Safe command-completion helper.
#
# This module does NOT replace:
#   - TAB
#   - self-insert
#   - accept-line
#   - fzf-tab
#   - zsh-autosuggestions
#
# ==========================================================


# ----------------------------------------------------------
# Interactive shell safety
# ----------------------------------------------------------

if [[ ! -o interactive ]]; then
    return
fi


# ----------------------------------------------------------
# Command cache refresh
# ----------------------------------------------------------

_tool_completion_refresh() {
    rehash
    zle -M 'Command completion cache refreshed'
}


# Register the ZLE widget only when ZLE is available.

if (( $+widgets[zle-line-init] || $+widgets[accept-line] )); then
    zle -N _tool_completion_refresh
fi


# ----------------------------------------------------------
# Optional shortcut
# ----------------------------------------------------------
#
# Ctrl + Alt + R
#
# Refreshes Zsh's command cache.
#

bindkey '^[^R' _tool_completion_refresh


# ==========================================================
# END OF TOOL COMPLETION MODULE
# ==========================================================
