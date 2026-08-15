#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Kali Zsh Config - Safe Uninstaller
#
# Restores the user's previous ~/.zshrc
# Removes Kali Zsh Config plugins and cache
# Removes the cloned kali-zsh-config repository
#
# System packages are NOT removed.
# ==========================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup"

PLUGIN_DIR="$HOME/plugins"

FZF_TAB_DIR="$PLUGIN_DIR/fzf-tab"
AUTOSUGGESTIONS_DIR="$PLUGIN_DIR/zsh-autosuggestions"
SYNTAX_HIGHLIGHTING_DIR="$PLUGIN_DIR/zsh-syntax-highlighting"

BACKUP_BEFORE_UNINSTALL="$HOME/.zshrc.before-kali-zsh-uninstall"

# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

info() {
    printf "${CYAN}[+]${RESET} %s\n" "$1"
}

success() {
    printf "${GREEN}[+]${RESET} %s\n" "$1"
}

warning() {
    printf "${YELLOW}[!]${RESET} %s\n" "$1"
}

error() {
    printf "${RED}[!]${RESET} %s\n" "$1" >&2
}

# ----------------------------------------------------------
# Basic checks
# ----------------------------------------------------------

if [[ "${EUID}" -eq 0 ]]; then
    error "Do not run this uninstaller as root."
    error "Run it as your normal Kali user."
    exit 1
fi

echo
echo "=========================================================="
echo " Kali Zsh Config - Uninstaller"
echo "=========================================================="
echo

warning "This will remove the Kali Zsh Config installation."
warning "Your previous ~/.zshrc will be restored if a backup exists."
echo

read -r -p "Continue with uninstall? [y/N]: " ANSWER

case "$ANSWER" in
    y|Y|yes|YES)
        ;;
    *)
        echo
        info "Uninstall cancelled."
        exit 0
        ;;
esac

echo

# ----------------------------------------------------------
# Backup current ~/.zshrc
# ----------------------------------------------------------

if [[ -f "$ZSHRC" ]]; then
    info "Backing up current ~/.zshrc before uninstall..."

    cp -p "$ZSHRC" "$BACKUP_BEFORE_UNINSTALL"

    success "Current configuration backed up:"
    printf "    %s\n" "$BACKUP_BEFORE_UNINSTALL"
else
    info "No current ~/.zshrc found."
fi

# ----------------------------------------------------------
# Restore previous ~/.zshrc
# ----------------------------------------------------------

if [[ -f "$BACKUP" ]]; then

    info "Restoring previous ~/.zshrc..."

    cp -p "$BACKUP" "$ZSHRC"

    success "Previous ~/.zshrc restored."

else

    warning "No ~/.zshrc.backup was found."

    if [[ -f "$ZSHRC" ]]; then
        warning "The current ~/.zshrc will be removed because no previous backup exists."

        rm -f "$ZSHRC"

        success "~/.zshrc removed."
    fi
fi

# ----------------------------------------------------------
# Remove plugin installations
# ----------------------------------------------------------

info "Removing Kali Zsh Config plugins..."

if [[ -d "$FZF_TAB_DIR" ]]; then
    rm -rf "$FZF_TAB_DIR"
    success "Removed fzf-tab."
else
    info "fzf-tab was not installed by this configuration."
fi

if [[ -d "$AUTOSUGGESTIONS_DIR" ]]; then
    rm -rf "$AUTOSUGGESTIONS_DIR"
    success "Removed zsh-autosuggestions."
else
    info "zsh-autosuggestions plugin directory not found."
fi

if [[ -d "$SYNTAX_HIGHLIGHTING_DIR" ]]; then
    rm -rf "$SYNTAX_HIGHLIGHTING_DIR"
    success "Removed zsh-syntax-highlighting."
else
    info "zsh-syntax-highlighting plugin directory not found."
fi

# ----------------------------------------------------------
# Remove Zsh cache created by the configuration
# ----------------------------------------------------------

info "Cleaning Zsh completion cache..."

rm -f "$HOME/.cache/zcompdump"*
rm -f "$HOME/.zcompdump"*

success "Zsh completion cache cleaned."

# ----------------------------------------------------------
# Remove repository
# ----------------------------------------------------------

if [[ -d "$REPO_DIR" ]]; then

    echo
    info "Removing Kali Zsh Config repository..."

    # The script must finish its work after the repository
    # is removed, so execute the removal at the end.
    REPO_TO_REMOVE="$REPO_DIR"

else
    REPO_TO_REMOVE=""
fi

# ----------------------------------------------------------
# Final configuration check
# ----------------------------------------------------------

echo
info "Checking restored Zsh configuration..."

if [[ -f "$ZSHRC" ]]; then

    if command -v zsh >/dev/null 2>&1; then

        if zsh -n "$ZSHRC" >/dev/null 2>&1; then
            success "Restored ~/.zshrc passed Zsh syntax check."
        else
            warning "Restored ~/.zshrc has a Zsh syntax error."
            warning "Your backup may contain an existing syntax problem."
        fi

    else
        warning "Zsh is not installed, so syntax validation was skipped."
    fi

else
    info "No ~/.zshrc remains."
fi

# ----------------------------------------------------------
# Remove repository last
# ----------------------------------------------------------

if [[ -n "$REPO_TO_REMOVE" ]]; then

    CURRENT_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"

    if [[ -n "$CURRENT_SCRIPT" && -f "$CURRENT_SCRIPT" ]]; then

        info "Removing repository:"
        printf "    %s\n" "$REPO_TO_REMOVE"

        # Run the deletion after this script exits.
        # This prevents the currently running script from
        # disappearing before it has finished.
        (
            sleep 1
            rm -rf -- "$REPO_TO_REMOVE"
        ) >/dev/null 2>&1 &

    fi
fi

# ----------------------------------------------------------
# Final message
# ----------------------------------------------------------

echo
echo "=========================================================="
success "Kali Zsh Config has been uninstalled."
echo "=========================================================="
echo

if [[ -f "$ZSHRC" ]]; then
    printf "${GREEN}Restored configuration:${RESET}\n"
    printf "    %s\n\n" "$ZSHRC"
fi

if [[ -f "$BACKUP_BEFORE_UNINSTALL" ]]; then
    printf "${CYAN}Safety backup created:${RESET}\n"
    printf "    %s\n\n" "$BACKUP_BEFORE_UNINSTALL"
fi

printf "${CYAN}System packages:${RESET}\n"
printf "    Not removed. Your system packages were left untouched.\n\n"

printf "${CYAN}Repository:${RESET}\n"
printf "    Scheduled for removal.\n\n"

printf "${GREEN}Your previous Zsh configuration has been restored.${RESET}\n"
printf "Open a new terminal session, or run:\n\n"
printf "    exec zsh\n\n"

echo "=========================================================="
echo " Uninstall complete."
echo "=========================================================="
echo
