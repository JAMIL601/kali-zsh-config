#!/usr/bin/env bash

set -uo pipefail

# ==========================================================
# Kali Zsh Config
# Main Installer
# ==========================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$REPO_DIR/config/zshrc"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup"

PLUGIN_DIR="$HOME/plugins"

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

die() {
    error "$1"
    exit 1
}

# ----------------------------------------------------------
# Detect operating system
# ----------------------------------------------------------

OS_ID="unknown"

if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    OS_ID="${ID:-unknown}"
fi

if [[ -n "${TERMUX_VERSION:-}" ]] || [[ "${PREFIX:-}" == *"com.termux"* ]]; then
    OS_ID="termux"
fi

# ----------------------------------------------------------
# Basic checks
# ----------------------------------------------------------

if [[ "${EUID}" -eq 0 ]]; then
    error "Do not run this installer as root."
    error "Run it as your normal user."
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    die "Configuration file not found: $CONFIG_FILE"
fi

# ----------------------------------------------------------
# Package manager helpers
# ----------------------------------------------------------

APT_UPDATED=0

run_privileged() {
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
        return $?
    fi

    error "sudo is required to install system packages."
    error "Please install sudo or install the required packages manually."
    return 1
}

apt_update_once() {
    if [[ "$APT_UPDATED" -eq 1 ]]; then
        return 0
    fi

    info "Updating package lists..."
    
    if ! run_privileged apt-get update; then
        error "apt package list update failed."
        return 1
    fi

    APT_UPDATED=1
    return 0
}

install_apt_package() {
    local package="$1"

    if ! apt_update_once; then
        return 1
    fi

    info "Installing package: $package"

    if ! run_privileged apt-get install -y "$package"; then
        error "Failed to install package: $package"
        return 1
    fi

    return 0
}

install_termux_package() {
    local package="$1"

    if ! command -v pkg >/dev/null 2>&1; then
        error "Termux package manager 'pkg' was not found."
        return 1
    fi

    info "Installing Termux package: $package"

    if ! pkg install -y "$package"; then
        error "Failed to install Termux package: $package"
        return 1
    fi

    return 0
}

install_package() {
    local package="$1"

    case "$OS_ID" in
        termux)
            install_termux_package "$package"
            ;;

        kali|debian|ubuntu|linuxmint|parrot|pop|elementary)
            install_apt_package "$package"
            ;;

        *)
            error "Unsupported or unknown Linux distribution: $OS_ID"
            error "Please install '$package' manually and run the installer again."
            return 1
            ;;
    esac
}

# ----------------------------------------------------------
# Dependency management
# ----------------------------------------------------------

ensure_command() {
    local command_name="$1"
    local package_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        success "$command_name is already installed."
        return 0
    fi

    warning "$command_name is not installed."
    info "Attempting automatic installation..."

    if install_package "$package_name"; then
        if command -v "$command_name" >/dev/null 2>&1; then
            success "$command_name installed successfully."
            return 0
        fi
    fi

    error "Unable to install required dependency: $command_name"
    return 1
}

# ----------------------------------------------------------
# Repository information
# ----------------------------------------------------------

echo
info "Kali Zsh Config installer"
info "Repository:"
printf "    %s\n" "$REPO_DIR"
echo

info "Detected system: $OS_ID"

# ----------------------------------------------------------
# Required dependencies
# ----------------------------------------------------------

info "Checking required dependencies..."

if ! ensure_command zsh zsh; then
    die "Zsh is required. Installation stopped."
fi

if ! ensure_command git git; then
    die "Git is required. Installation stopped."
fi

if ! ensure_command fzf fzf; then
    die "fzf is required. Installation stopped."
fi

success "Required dependencies are available."

# ----------------------------------------------------------
# Prepare cache directory
# ----------------------------------------------------------

info "Checking Zsh cache directory..."

mkdir -p "$HOME/.cache"

if [[ ! -d "$HOME/.cache" ]]; then
    die "Unable to create Zsh cache directory."
fi

success "Zsh cache directory is ready."

# ----------------------------------------------------------
# Run directory setup
# ----------------------------------------------------------

if [[ -f "$REPO_DIR/setup/directories.sh" ]]; then
    info "Running directory setup..."

    if ! bash "$REPO_DIR/setup/directories.sh"; then
        die "Directory setup failed."
    fi

    success "Directory setup completed."
else
    warning "setup/directories.sh not found. Skipping directory setup."
fi

# ----------------------------------------------------------
# Run package setup
# ----------------------------------------------------------
#
# Required system dependencies have already been handled above.
# packages.sh is therefore optional and should not be able to
# destroy the installation flow.
#

if [[ -f "$REPO_DIR/setup/packages.sh" ]]; then
    info "Running additional package setup..."

    if ! bash "$REPO_DIR/setup/packages.sh"; then
        warning "Additional package setup returned an error."
        warning "Continuing because required dependencies are already installed."
    else
        success "Additional package setup completed."
    fi
fi

# ----------------------------------------------------------
# Run plugin setup
# ----------------------------------------------------------

if [[ -f "$REPO_DIR/setup/plugins.sh" ]]; then
    info "Running plugin setup..."

    if ! bash "$REPO_DIR/setup/plugins.sh"; then
        die "Plugin setup failed."
    fi

    success "Plugin setup completed."
else
    warning "setup/plugins.sh not found."
    warning "Skipping plugin setup."
fi

# ----------------------------------------------------------
# Verify fzf-tab
# ----------------------------------------------------------

FZF_TAB="$PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"

if [[ -f "$FZF_TAB" ]]; then
    success "fzf-tab is available."
else
    warning "fzf-tab plugin was not found at:"
    printf "    %s\n" "$FZF_TAB"
    warning "The configuration may not provide fzf-tab completion."
fi

# ----------------------------------------------------------
# Backup existing .zshrc
# ----------------------------------------------------------

if [[ -f "$ZSHRC" ]]; then

    if [[ ! -f "$BACKUP" ]]; then
        info "Backing up existing ~/.zshrc..."

        if ! cp -p "$ZSHRC" "$BACKUP"; then
            die "Unable to create ~/.zshrc backup."
        fi

        success "Backup created:"
        printf "    %s\n" "$BACKUP"
    else
        warning "Existing backup preserved:"
        printf "    %s\n" "$BACKUP"
        warning "The installer will not overwrite your existing backup."
    fi

else
    info "No existing ~/.zshrc found."
fi

# ----------------------------------------------------------
# Validate repository configuration
# ----------------------------------------------------------

info "Checking Zsh configuration..."

ZSH_FILES=(
    "$REPO_DIR/config/zshrc"
    "$REPO_DIR/config/options.zsh"
    "$REPO_DIR/config/aliases.zsh"
    "$REPO_DIR/config/completion.zsh"
    "$REPO_DIR/widgets/filesystem-preview.zsh"
    "$REPO_DIR/widgets/tool-completion.zsh"
)

for file in "${ZSH_FILES[@]}"; do

    if [[ ! -f "$file" ]]; then
        warning "Optional configuration file not found:"
        printf "    %s\n" "$file"
        continue
    fi

    if ! zsh -n "$file" >/dev/null 2>&1; then
        error "Zsh syntax error:"
        printf "    %s\n" "$file"

        if [[ -f "$BACKUP" ]]; then
            warning "Your existing ~/.zshrc was not replaced."
        fi

        exit 1
    fi

    success "Syntax OK: $(basename "$file")"
done

# ----------------------------------------------------------
# Create user .zshrc
# ----------------------------------------------------------

info "Installing repository Zsh configuration..."

TEMP_ZSHRC="$(mktemp)"

cleanup() {
    rm -f "$TEMP_ZSHRC"
}

trap cleanup EXIT

cat > "$TEMP_ZSHRC" <<EOF
# ==========================================================
# Kali Zsh Config
# Generated by install.sh
# ==========================================================

export KALI_ZSH_CONFIG_DIR="$REPO_DIR"

if [[ -f "\$KALI_ZSH_CONFIG_DIR/config/zshrc" ]]; then
    source "\$KALI_ZSH_CONFIG_DIR/config/zshrc"
else
    print -u2 "Kali Zsh Config: configuration repository not found:"
    print -u2 "  \$KALI_ZSH_CONFIG_DIR"
fi
EOF

# ----------------------------------------------------------
# Validate generated .zshrc
# ----------------------------------------------------------

if ! zsh -n "$TEMP_ZSHRC" >/dev/null 2>&1; then
    error "Generated ~/.zshrc failed syntax validation."
    error "Your existing ~/.zshrc has not been replaced."
    exit 1
fi

# ----------------------------------------------------------
# Install generated .zshrc
# ----------------------------------------------------------

if ! cp "$TEMP_ZSHRC" "$ZSHRC"; then
    error "Unable to install generated ~/.zshrc."

    if [[ -f "$BACKUP" ]]; then
        warning "Restoring previous ~/.zshrc..."
        cp "$BACKUP" "$ZSHRC" || true
    fi

    exit 1
fi

# ----------------------------------------------------------
# Final validation
# ----------------------------------------------------------

if ! zsh -n "$ZSHRC" >/dev/null 2>&1; then
    error "Installed ~/.zshrc failed syntax validation."

    if [[ -f "$BACKUP" ]]; then
        warning "Restoring previous ~/.zshrc..."

        if cp "$BACKUP" "$ZSHRC"; then
            success "Previous ~/.zshrc restored."
        else
            error "Automatic restore failed."
        fi
    fi

    exit 1
fi

# ----------------------------------------------------------
# Installation complete
# ----------------------------------------------------------

echo
success "Installation completed successfully!"
echo

printf "${CYAN}Repository:${RESET}\n"
printf "  %s\n\n" "$REPO_DIR"

printf "${CYAN}Configuration:${RESET}\n"
printf "  %s\n\n" "$ZSHRC"

if [[ -f "$BACKUP" ]]; then
    printf "${CYAN}Backup:${RESET}\n"
    printf "  %s\n\n" "$BACKUP"
fi

printf "${GREEN}Start a fresh Zsh session with:${RESET}\n"
printf "  exec zsh\n"
echo

printf "${YELLOW}Note:${RESET} The installer does not automatically restart your shell.\n"
echo
