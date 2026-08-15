:::writing{variant="document" id="58321" title="update.sh"}
#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Kali Zsh Config - Automatic Updater
#
# This script:
#
#   1. Checks the local repository.
#   2. Checks the GitHub remote.
#   3. Connects to GitHub and fetches the latest version.
#   4. Compares the local repository with GitHub.
#   5. Shows which files will be updated.
#   6. Replaces the local repository with the official
#      GitHub version.
#   7. Automatically replaces update.sh itself if GitHub
#      contains a newer version.
#   8. Restarts using the newly downloaded update.sh.
#   9. Runs install.sh automatically.
#  10. Verifies the Zsh configuration and important files.
#  11. Tells the user to run "exec zsh" when activation
#      of the new configuration is required.
#
# Official repository:
#   https://github.com/JAMIL601/kali-zsh-config.git
#
# IMPORTANT:
#   Local changes inside this repository are replaced by
#   the official GitHub version during an update.
#
# ==========================================================


# ----------------------------------------------------------
# Configuration
# ----------------------------------------------------------

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REMOTE_URL="https://github.com/JAMIL601/kali-zsh-config.git"
REMOTE_NAME="origin"
BRANCH="main"

INSTALLER="$REPO_DIR/install.sh"
ZSHRC="$HOME/.zshrc"

# Prevent an infinite restart loop when update.sh updates itself.
UPDATE_RESTARTED="${KALI_ZSH_UPDATE_RESTARTED:-0}"


# ----------------------------------------------------------
# Colors
# ----------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'


# ----------------------------------------------------------
# Messages
# ----------------------------------------------------------

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
# Basic safety checks
# ----------------------------------------------------------

if [[ "${EUID}" -eq 0 ]]; then
    error "Do not run update.sh as root."
    error "Run it as your normal Kali user."
    exit 1
fi


if [[ ! -d "$REPO_DIR/.git" ]]; then
    error "This directory is not a Git repository:"
    error "$REPO_DIR"
    exit 1
fi


if ! command -v git >/dev/null 2>&1; then
    error "Git is not installed."
    error "Git is required to update this project."
    exit 1
fi


# ----------------------------------------------------------
# Header
# ----------------------------------------------------------

echo
echo "=========================================================="
echo " Kali Zsh Config - Automatic Updater"
echo "=========================================================="
echo

info "Local repository:"
printf "    %s\n" "$REPO_DIR"

info "GitHub repository:"
printf "    %s\n" "$REMOTE_URL"

echo


# ----------------------------------------------------------
# Configure GitHub remote
# ----------------------------------------------------------

echo "=========================================================="
echo " Checking GitHub connection"
echo "=========================================================="
echo

CURRENT_REMOTE="$(
    git -C "$REPO_DIR" remote get-url "$REMOTE_NAME" 2>/dev/null || true
)"

if [[ -z "$CURRENT_REMOTE" ]]; then

    info "GitHub remote is not configured."
    info "Adding official GitHub repository..."

    git -C "$REPO_DIR" remote add "$REMOTE_NAME" "$REMOTE_URL"

elif [[ "$CURRENT_REMOTE" != "$REMOTE_URL" ]]; then

    warning "The current GitHub remote is different."
    printf "    Current : %s\n" "$CURRENT_REMOTE"
    printf "    Expected: %s\n" "$REMOTE_URL"

    info "Changing origin to the official repository..."

    git -C "$REPO_DIR" remote set-url "$REMOTE_NAME" "$REMOTE_URL"

else

    success "GitHub remote is correct."

fi


# ----------------------------------------------------------
# Fetch latest GitHub version
# ----------------------------------------------------------

info "Connecting to GitHub..."

if ! git -C "$REPO_DIR" fetch "$REMOTE_NAME" "$BRANCH"; then
    error "Could not connect to GitHub or fetch the latest version."
    error "Check your internet connection and try again."
    exit 1
fi

success "GitHub connection successful."

echo


# ----------------------------------------------------------
# Verify remote branch
# ----------------------------------------------------------

if ! git -C "$REPO_DIR" rev-parse --verify \
    "$REMOTE_NAME/$BRANCH" >/dev/null 2>&1; then

    error "GitHub branch was not found:"
    error "$REMOTE_NAME/$BRANCH"
    exit 1
fi


# ----------------------------------------------------------
# Compare local repository with GitHub
# ----------------------------------------------------------

echo "=========================================================="
echo " Comparing local repository with GitHub"
echo "=========================================================="
echo

LOCAL_COMMIT="$(git -C "$REPO_DIR" rev-parse HEAD)"
REMOTE_COMMIT="$(git -C "$REPO_DIR" rev-parse "$REMOTE_NAME/$BRANCH")"

LOCAL_SHORT="$(git -C "$REPO_DIR" rev-parse --short HEAD)"
REMOTE_SHORT="$(git -C "$REPO_DIR" rev-parse --short "$REMOTE_NAME/$BRANCH")"

LOCAL_MESSAGE="$(
    git -C "$REPO_DIR" log -1 --pretty=format:'%s'
)"

REMOTE_MESSAGE="$(
    git -C "$REPO_DIR" log -1 "$REMOTE_NAME/$BRANCH" --pretty=format:'%s'
)"

printf "Local version:\n"
printf "    %s - %s\n\n" "$LOCAL_SHORT" "$LOCAL_MESSAGE"

printf "GitHub version:\n"
printf "    %s - %s\n\n" "$REMOTE_SHORT" "$REMOTE_MESSAGE"


# ----------------------------------------------------------
# Check whether repository is already up to date
# ----------------------------------------------------------

if [[ "$LOCAL_COMMIT" == "$REMOTE_COMMIT" ]]; then

    success "Local repository and GitHub are already identical."

    echo
    info "No repository files need to be downloaded."

else

    warning "A newer GitHub version is available."

    echo
    info "Files that differ between local and GitHub:"

    git --no-pager -C "$REPO_DIR" diff \
        --name-status \
        "$LOCAL_COMMIT" \
        "$REMOTE_COMMIT" || true

    echo

    # ------------------------------------------------------
    # Show local modifications
    # ------------------------------------------------------

    LOCAL_CHANGES="$(
        git -C "$REPO_DIR" status --porcelain
    )"

    if [[ -n "$LOCAL_CHANGES" ]]; then

        warning "Local repository changes were detected."
        echo
        printf "%s\n" "$LOCAL_CHANGES"
        echo

        warning "These local repository changes will be replaced"
        warning "by the official GitHub version."

    else

        info "No uncommitted local changes were found."

    fi

    echo

    # ------------------------------------------------------
    # Replace local repository with GitHub version
    # ------------------------------------------------------

    echo "=========================================================="
    echo " Updating repository from GitHub"
    echo "=========================================================="
    echo

    info "Resetting local repository to GitHub version..."

    git -C "$REPO_DIR" reset --hard "$REMOTE_NAME/$BRANCH"

    info "Removing old untracked repository files..."

    git -C "$REPO_DIR" clean -fd

    success "Local repository now matches GitHub."

    echo


    # ------------------------------------------------------
    # IMPORTANT:
    # update.sh may have just replaced itself.
    #
    # Restart using the NEW GitHub version.
    # ------------------------------------------------------

    NEW_COMMIT="$(
        git -C "$REPO_DIR" rev-parse HEAD
    )"

    if [[ "$NEW_COMMIT" != "$LOCAL_COMMIT" ]]; then

        echo "=========================================================="
        echo " Restarting with the updated updater"
        echo "=========================================================="
        echo

        if [[ ! -f "$REPO_DIR/update.sh" ]]; then
            error "Updated update.sh was not found."
            exit 1
        fi

        chmod +x "$REPO_DIR/update.sh"

        success "The GitHub version of update.sh is now installed."
        info "Restarting updater using the new version..."

        export KALI_ZSH_UPDATE_RESTARTED=1

        exec "$REPO_DIR/update.sh"

    fi

fi


# ----------------------------------------------------------
# Make sure the current updater is executable
# ----------------------------------------------------------

if [[ ! -x "$REPO_DIR/update.sh" ]]; then
    info "Making update.sh executable..."
    chmod +x "$REPO_DIR/update.sh"
fi


# ----------------------------------------------------------
# Run install.sh
# ----------------------------------------------------------

echo
echo "=========================================================="
echo " Installing / Updating Kali Zsh Config"
echo "=========================================================="
echo

if [[ ! -f "$INSTALLER" ]]; then
    error "install.sh was not found:"
    error "$INSTALLER"
    exit 1
fi

chmod +x "$INSTALLER"

info "Running install.sh..."
echo

"$INSTALLER"


# ----------------------------------------------------------
# Final verification
# ----------------------------------------------------------

echo
echo "=========================================================="
echo " Final Configuration Checks"
echo "=========================================================="
echo


# ----------------------------------------------------------
# Check Zsh
# ----------------------------------------------------------

if command -v zsh >/dev/null 2>&1; then

    success "Zsh is installed."

else

    error "Zsh is not available after installation."
    exit 1

fi


# ----------------------------------------------------------
# Check Git
# ----------------------------------------------------------

if command -v git >/dev/null 2>&1; then

    success "Git is installed."

else

    error "Git is not available."
    exit 1

fi


# ----------------------------------------------------------
# Check fzf
# ----------------------------------------------------------

if command -v fzf >/dev/null 2>&1; then

    success "fzf is installed."

else

    warning "fzf was not found."

fi


# ----------------------------------------------------------
# Check main repository configuration
# ----------------------------------------------------------

if [[ ! -f "$REPO_DIR/config/zshrc" ]]; then

    error "config/zshrc was not found."
    exit 1

fi

if zsh -n "$REPO_DIR/config/zshrc"; then

    success "config/zshrc syntax check passed."

else

    error "config/zshrc syntax check failed."
    exit 1

fi


# ----------------------------------------------------------
# Check config modules
# ----------------------------------------------------------

for config_file in "$REPO_DIR/config"/*.zsh; do

    [[ -f "$config_file" ]] || continue

    if zsh -n "$config_file"; then

        success "Syntax OK: $(basename "$config_file")"

    else

        error "Syntax check failed:"
        error "$config_file"
        exit 1

    fi

done


# ----------------------------------------------------------
# Check widgets
# ----------------------------------------------------------

if [[ -d "$REPO_DIR/widgets" ]]; then

    for widget in "$REPO_DIR/widgets"/*.zsh; do

        [[ -f "$widget" ]] || continue

        if zsh -n "$widget"; then

            success "Syntax OK: widgets/$(basename "$widget")"

        else

            error "Widget syntax check failed:"
            error "$widget"
            exit 1

        fi

    done

fi


# ----------------------------------------------------------
# Check ~/.zshrc
# ----------------------------------------------------------

if [[ ! -f "$ZSHRC" ]]; then

    error "~/.zshrc was not found after installation."
    exit 1

fi

if zsh -n "$ZSHRC"; then

    success "~/.zshrc syntax check passed."

else

    error "~/.zshrc syntax check failed."
    exit 1

fi


# ----------------------------------------------------------
# Check important plugins
# ----------------------------------------------------------

PLUGIN_DIR="$HOME/plugins"

if [[ -f "$PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" ]]; then

    success "fzf-tab plugin found."

else

    warning "fzf-tab plugin was not found."

fi


if [[ -f "$PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then

    success "zsh-autosuggestions plugin found."

else

    warning "zsh-autosuggestions plugin was not found."

fi


if [[ -f "$PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then

    success "zsh-syntax-highlighting plugin found."

else

    warning "zsh-syntax-highlighting plugin was not found."

fi


# ----------------------------------------------------------
# Final status
# ----------------------------------------------------------

echo
echo "=========================================================="
success "Kali Zsh Config update completed successfully."
echo "=========================================================="
echo

printf "${CYAN}Repository:${RESET}\n"
printf "    %s\n\n" "$REPO_DIR"

printf "${CYAN}GitHub version:${RESET}\n"
printf "    %s\n" "$(git -C "$REPO_DIR" rev-parse --short HEAD)"

printf "${CYAN}Configuration:${RESET}\n"
printf "    %s\n\n" "$ZSHRC"

printf "${GREEN}All available checks completed successfully.${RESET}\n"
echo

printf "${YELLOW}To activate the updated Zsh configuration in this terminal, run:${RESET}\n"
printf "    exec zsh\n"
echo

printf "${CYAN}A new terminal session will also load the updated configuration.${RESET}\n"
echo

echo "=========================================================="
echo " Update complete"
echo "=========================================================="
echo
:::
