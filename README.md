# Dockerized Neovim (VSCode-like)

A powerful, containerized Neovim environment designed to replicate VSCode features (Themes, File Explorer, Tabs, Intellisense) while providing the speed of Vim.

## 🚀 Quick Start (User Friendly)

To install **dvim** on your system (Linux/macOS), simply run this one-liner in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/mohamadkhoshnava/dvim/main/dvim.sh -o dvim.sh && chmod +x dvim.sh && sudo ./dvim.sh install && rm dvim.sh
```
*(Assuming the repo is named `dvim`. If locally, just run `sudo ./dvim.sh install`)*

Once installed, you can open any folder with:

```bash
dvim
```

## 🛠 Usage Guide

### Opening Projects
| Command | Description |
|Args|---|
| `dvim` | Open current directory in Neovim |
| `dvim run /path/to/app` | Open a specific folder |

### Managing the Tool
| Command | Description |
|---|---|
| `dvim update` | Update to the latest version (pulls from Docker Hub) |
| `dvim build` | Build the image locally (for advanced users) |
| `dvim remove` | Delete the Docker image from your system |

## ✨ Features & Key Mappings

This setup mimics VSCode's best features.

| Feature | Description | Key Binding |
|---|---|---|
| **Explorer** | Toggle file tree sidebar | `Ctrl+b` |
| **Find File** | Fuzzy find files (like Cmd+P) | `Ctrl+p` |
| **Global Search** | Search text across all files | `Ctrl+f` |
| **Command Palette** | Slick command menu | `:` (Noice UI) |
| **Themes** | Switch themes (VSCode, TokyoNight, etc) | `<Space>th` |
| **Tabs** | Switch open buffers | `Tab` / `Shift+Tab` |
| **Close Tab** | Close current file | `Ctrl+w` |
| **Terminal** | Open integrated terminal | `Ctrl+\` |
| **Comments** | Toggle line comment | `Ctrl+/` |
| **Problems** | View diagnostics/errors | `<Space>xx` |
| **Save** | Save file | `Ctrl+s` |

## 🏗 Advanced (For Developers)

If you want to modify the source code or build your own image:

1. **Clone the repo**:
   ```bash
   git clone https://github.com/mohamadkhoshnava/dvim.git
   cd dvim
   ```

2. **Modify Configuration**:
   - `config/nvim/init.lua`: Main Neovim configuration.
   - `Dockerfile`: The container definition.

3. **Build Locally**:
   ```bash
   ./dvim.sh build
   ```

4. **Publish to Docker Hub**:
   Update `dvim.sh` with your username and run:
   ```bash
   ./publish.sh
   ```

---
*Plugins and state are persisted to `~/.dvim-data` on your host machine.*
