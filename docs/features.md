# ✨ Features

**Kali Zsh Config** provides a cleaner, more organized, and highly practical Zsh environment while keeping the standard Zsh workflow completely intact.

The main features are broadly divided into completion, filesystem interaction, shell customization, and maintenance.

---

## ✨ Zsh Improvements

The configuration enhances your overall terminal environment with:

* **Useful shell options:** Optimized for daily productivity.
* **Improved command history:** Better history persistence and search behavior.
* **Custom command aliases:** Quick shortcuts for common Linux commands.
* **Case-insensitive matching:** Find files and directories without worrying about upper/lowercase letters.
* **Interactive completion menus:** Easily navigate completion items.
* **Zsh autosuggestions:** Command recommendations based on your command history.
* **Syntax highlighting:** Visually distinguish commands, flags, paths, and syntax errors.
* **Kali-style prompt integration:** Maintains a familiar, lightweight Kali prompt interface.

> **Note:** Because the configuration is modular, all of these features can be edited or maintained independently.

---

## ⌨️ Enhanced Completion

The project uses Zsh's native completion system as its foundation, offering:

* File and directory completion
* Command completion
* Argument completion (where supported)
* Case-insensitive matching
* Interactive completion menus & descriptions
* Automatic command rehashing

*(Normal `Tab` completion remains fully available at all times.)*

---

## 🔎 fzf-tab Integration

`fzf-tab` replaces Zsh's default completion menu with an interactive `fzf` fuzzy-selection interface.

Instead of navigating a long completion list manually, you can interactively filter and select:
* Files and directories
* Command flags and candidates
* Historical paths

*(The project keeps `fzf-tab` separate from the custom filesystem preview widget to prevent unnecessary conflicts between systems.)*

---

## 📁 Filesystem Preview & File Information

The custom filesystem preview widget (`Ctrl + Space`) acts as an interactive filesystem browser when entering commands that take file/folder arguments.

### 📋 Supported Metadata Preview
Depending on the selected object, the preview window dynamically identifies and displays:
* **Object types:** Regular files, Directories, Symbolic links, etc.
* **Permissions & Ownership:** File permissions, Owner, and Group.
* **File properties:** File size, Modification time, and File type.
* **Symlinks:** Shows the target path a symbolic link points to.

---

## 📄 Text File Preview

When a selected file is detected as plain text, the widget displays a limited, clean preview of its contents.

**Supported Text Formats Include:**
```text
.txt   .conf   .cfg   .ini   .json   .yaml   .yml   .sh   .zsh   .py   .md
```

> **Safety Feature:** The preview is intentionally truncated to prevent dumping massive files into your terminal. Binary or non-text files are safely masked and will **not** display as raw garbled output.

---

## 🧩 Tool Completion

The project provides a dedicated module for tool-related completion enhancements (`widgets/tool-completion.zsh`).

* Works alongside Zsh's existing completion system rather than attempting to replace it.
* When completion data is available for a tool, its arguments and options complete via normal Zsh mechanisms.
* Tool-specific rules can be added or updated independently without breaking the filesystem preview widget.

---

## 🎨 Terminal Experience & Design Goal

The configuration brings together syntax highlighting, autosuggestions, `fzf-tab`, native completions, and aliases into a cohesive system.

### 🎯 Main Design Goal
> **"Make Zsh more useful without making it unnecessarily complicated."**

The focus remains strictly on practical improvements, clean organization, safe customization, and seamless portability across Debian/Kali systems without overloading the interface.

---

## 🧱 Modular Design & Maintenance

Features are strictly organized into dedicated files for maximum maintainability:

```text
config/
├── options.zsh
├── aliases.zsh
└── completion.zsh

widgets/
├── filesystem-preview.zsh
└── tool-completion.zsh
```

### 🔄 Maintenance Scripts
Included management scripts ensure you don't have to manually rebuild your shell environment when switching machines:
* `install.sh`: Automated setup and environment preparation.
* `update.sh`: Pulls and updates configuration changes seamlessly.
* `uninstall.sh`: Safely removes custom rules and restores backups.
* 
