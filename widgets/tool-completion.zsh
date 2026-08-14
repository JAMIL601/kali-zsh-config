# ==========================================================
# Kali Zsh Config
# Tool Completion Enhancements
# ==========================================================
#
# Purpose:
#   - Provide a safe command-cache refresh helper
#   - Keep normal Zsh completion untouched
#   - Keep TAB untouched
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
# Interactive shell safety
# ----------------------------------------------------------

[[ -o interactive ]] || return


# ----------------------------------------------------------
# Command completion cache refresh
# ----------------------------------------------------------

_tool_completion_refresh() {
    rehash
    zle -M "Command completion cache refreshed"
    zle redisplay
}

zle -N _tool_completion_refresh


# ----------------------------------------------------------
# Optional shortcut
# ----------------------------------------------------------
#
# Ctrl + Alt + R
# Refresh the Zsh command cache.
#
# This does NOT replace TAB or any normal editing widget.
#

bindkey '^[^R' _tool_completion_refresh


# ----------------------------------------------------------
# Notes
# ----------------------------------------------------------
#
# Zsh normally detects commands through its command hash.
# Therefore we do not run "rehash" after every command.
#
# Use Ctrl + Alt + R when:
#
#   - A newly installed command is not completing yet
#   - A command was removed or replaced
#   - PATH was changed during the current shell session
#
# ==========================================================
# END
# ==========================================================
