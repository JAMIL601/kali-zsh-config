# 🚀 Installation Guide

This guide explains how to install, verify, update, and uninstall **Kali Zsh Config** on a fresh Linux system.

> **Target Distribution:** Kali Linux is the primary target. Other Debian-based distributions (Debian, Ubuntu, Linux Mint, Parrot OS) should also work with minor dependency differences.

---

## 1. Install Git

On Kali Linux or any Debian-based system, update your package index and install Git:

```bash
sudo apt update
sudo apt install git -y
```

**Verify installation:**
```bash
git --version
```

---

## 2. Clone the Repository

Clone the project from GitHub and enter the directory:

```bash
git clone [https://github.com/Jamil601/kali-zsh-config.git](https://github.com/Jamil601/kali-zsh-config.git)
cd kali-zsh-config
```

---

## 3. Check the Configuration (Syntax Test)

Before installing, you can perform a dry-run syntax check on all Zsh configuration files and widgets:

**Check main config files:**
```bash
zsh -n config/zshrc
zsh -n config/options.zsh
zsh -n config/aliases.zsh
zsh -n config/completion.zsh
```

**Check custom widgets:**
```bash
zsh -n widgets/filesystem-preview.zsh
zsh -n widgets/tool-completion.zsh
```
*(No output normally means all syntax checks passed successfully.)*

---

## 4. Run the Installer

Make the installer script executable and run it:

```bash
chmod +x install.sh
./install.sh
```
The installer prepares the required environment, installs necessary dependencies, and sets up the configuration modules.

---

## 5. Restart Zsh

After the installation completes, reload your shell environment:

```bash
exec zsh
```
*(Alternatively, you can close and reopen your terminal.)*

---

## 6. Verify Installation

Check if Zsh and core tools are working correctly:

```bash
zsh --version
fzf --version
ls ~/kali-zsh-config
```

**Test Completion & Widgets:**
* Test normal completion by typing `cd /etc/` and pressing `Tab`.
* Test the interactive filesystem preview widget using `Ctrl + Space` (or your configured shortcut).

---

## 🔄 Updating

To pull the latest updates for the configuration, navigate to the repo directory:

```bash
cd ~/kali-zsh-config
```

You can update via Git:
```bash
git pull
```

Or run the project's update script:
```bash
chmod +x update.sh
./update.sh
```

After updating, restart Zsh:
```bash
exec zsh
```

---

## 🗑️ Uninstalling

To safely remove the configuration using the project's uninstall script:

```bash
cd ~/kali-zsh-config
chmod +x uninstall.sh
./uninstall.sh
```

Then restart your shell:
```bash
exec zsh
```

---

## 🛡️ Backup & Restore

Before making major modifications, always keep a backup of your existing `.zshrc` file:

```bash
# Create backup
cp ~/.zshrc ~/.zshrc.backup

# Restore backup (if needed)
cp ~/.zshrc.backup ~/.zshrc
exec zsh
```

---

## 🧹 Troubleshooting

If something does not work as expected, check the configuration syntax:

```bash
# Check main config
zsh -n ~/.zshrc

# Check individual modules
zsh -n config/zshrc
zsh -n widgets/filesystem-preview.zsh
zsh -n widgets/tool-completion.zsh
```

For more detailed troubleshooting steps, refer to **`docs/troubleshooting.md`**.

