#!/usr/bin/env bash

# ==========================================================
# Kali Zsh Configuration
# Package Setup
#
# Installs packages required by the configuration.
# Safe to run multiple times.
# ==========================================================

set -e

echo "[+] Updating package information..."
sudo apt-get update

echo "[+] Installing required packages..."

sudo apt-get install -y \
    zsh \
    fzf \
    eza \
    bat \
    file \
    tree \
    git \
    curl \
    wget \
    procps \
    coreutils \
    util-linux

echo
echo "[+] Required packages installed successfully."
