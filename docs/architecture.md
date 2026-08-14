# 🏗️ Architecture

**Kali Zsh Config** is organized as a modular Zsh configuration rather than keeping everything inside a single `.zshrc` file. 

The main goal is to keep the configuration easy to understand, maintain, debug, customize, and reuse on another Linux machine.

---

## 📂 Project Structure

```text
kali-zsh-config/
│
├── config/
│   ├── zshrc
│   ├── options.zsh
│   ├── aliases.zsh
│   └── completion.zsh
│
├── widgets/
│   ├── filesystem-preview.zsh
│   └── tool-completion.zsh
│
├── setup/
│   ├── packages.sh
│   ├── directories.sh
│   └── plugins.sh
│
├── docs/
│   ├── installation.md
│   ├── features.md
│   ├── troubleshooting.md
│   ├── customization.md
│   └── architecture.md
│
├── screenshots/
│
├── install.sh
├── uninstall.sh
├── update.sh
├── README.md
└── LICENSE
```

---

## 🔄 Configuration Flow

The configuration is loaded through a simple hierarchy:

```text
Zsh
 │
 └── config/zshrc
       │
       ├── options.zsh
       ├── aliases.zsh
       ├── completion.zsh
       │
       └── widgets/
             ├── filesystem-preview.zsh
             └── tool-completion.zsh
```

* **`config/zshrc` acts as the main loader.** 
* Instead of containing every configuration directly, it loads the individual modules when Zsh starts. 
* This keeps the main configuration small and makes individual components easier to modify or disable.

---

## ⚙️ Configuration Modules

### `config/zshrc`
The main configuration entry point. It is responsible for loading the project's configuration modules and widgets. This file should generally remain lightweight.

### `config/options.zsh`
Contains general Zsh behavior and shell options. Examples include:
* History behavior
* Shell interaction options
* Globbing behavior
* Other Zsh-specific settings

### `config/aliases.zsh`
Contains command aliases and small command-line shortcuts. Keeping aliases separate prevents the main configuration from becoming cluttered.

### `config/completion.zsh`
Contains the main Zsh completion configuration. Normal Zsh completion remains the foundation of the completion system. This includes things such as:
* `compinit`
* Completion styles
* Matching behavior
* Completion menus
* Completion display settings

---

## 🧩 Widgets

Custom interactive functionality is kept in the `widgets/` directory.

### `filesystem-preview.zsh`
Provides the interactive filesystem browser/preview functionality. It can work with filesystem paths and show useful information such as:
* Files & Directories
* Permissions & Ownership
* File type & Size
* Modification time
* Symbolic-link targets
* Limited text-file content

> **Note:** The widget is intentionally kept separate from normal `Tab` completion. This helps prevent custom filesystem browsing from interfering with the standard Zsh completion system.

### `tool-completion.zsh`
Contains optional enhancements related to command and tool completion. 
* The design goal is to work with Zsh's existing completion system rather than replacing it. 
* This separation also makes it possible to disable tool-specific enhancements without removing the main completion system.

---

## 🧰 Setup Scripts

The `setup/` directory contains environment preparation scripts. Keeping these tasks separate from the Zsh configuration means the shell configuration itself does not need to perform system setup every time Zsh starts.

```text
setup/
├── packages.sh     # Handles required or recommended packages.
├── directories.sh  # Creates directories required by the configuration.
└── plugins.sh      # Handles plugin-related setup.
```

---

## 🚀 Installation Scripts

The repository contains three main management scripts:
* `install.sh`
* `uninstall.sh`
* `update.sh`

Their purpose is to separate system management from the actual Zsh configuration. This makes the repository easier to deploy on another machine and easier to maintain over time.

---

## 🎯 Design Principles

The project follows a few simple principles:
* **Modular:** Different responsibilities are kept in separate files.
* **Non-destructive:** Existing user configuration should be backed up before installation or replacement.
* **Compatible:** Normal Zsh functionality should continue to work alongside the custom features.
* **Maintainable:** A feature should be easy to locate, modify, test, or disable.
* **Portable:** The configuration primarily targets Kali Linux but avoids unnecessary distribution-specific assumptions where possible.

---

## 💡 Why Not One Large `.zshrc`?

A single large `.zshrc` can become difficult to understand and troubleshoot. With a modular structure, a problem can usually be isolated to one component instead of searching through the entire configuration. 

| Feature | Module Location |
| :--- | :--- |
| **Options** | `options.zsh` |
| **Aliases** | `aliases.zsh` |
| **Completion** | `completion.zsh` |
| **Preview** | `filesystem-preview.zsh` |
| **Tools** | `tool-completion.zsh` |

This also makes future development easier because new features can be added as separate modules rather than continually expanding one large file.

