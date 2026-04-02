# Minimal Neovim Config

A high-performance, lightweight Neovim configuration built from scratch with a focus on custom Lua wrappers and native speed. This setup prioritizes external tools like `fzf` and `ripgrep` over heavy plugin ecosystems, providing a professional IDE experience with minimal overhead.

## ✨ Key Features

- **Custom Reusable Picker:** A professional Telescope-style UI component (`lua/core/picker.lua`) with three panes: Search, Results, and Live Preview.
- **Dynamic Theme System:** Interactive colorscheme picker with live global preview and a rich code sample pane.
- **Lightning Fast Search:** Real-time file searching (`<leader>ff`) and live grep (`<leader>fw`) powered by `ripgrep`.
- **Integrated Preview:** Context-aware previews for themes, files, and grep matches (with visual match highlighting).
- **Lightweight Architecture:** Uses native Neovim APIs and Lua modules for core logic instead of large plugin suites.

## 🛠️ Setup

1. **Backup your current config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository:**
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

3. **Install Dependencies:**
   Ensure you have the required external tools installed (see below).

4. **Launch Neovim:**
   ```bash
   nvim
   ```

## 📦 Dependencies

This configuration relies on a few high-performance external tools:

| Dependency | Purpose | Recommended Installation |
| :--- | :--- | :--- |
| **Neovim 0.9+** | Core editor | `brew install neovim` |
| **Ripgrep (rg)** | Fast searching & grepping | `brew install ripgrep` |
| **Fzf** | External fuzzy finding power | `brew install fzf` |
| **Nerd Font** | Icons & UI symbols | [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) |
| **Bat** | (Optional) Syntax highlighted previews | `brew install bat` |

## 🚀 Performance

This project is engineered for maximum speed and zero lag:

- **Lazy Execution:** Core modules like the theme picker and search engine are only loaded when triggered via keymaps.
- **Native Lua:** By replacing heavy plugins with targeted Lua wrappers (`lua/core/*.lua`), startup time remains consistently under **20-30ms**.
- **External Power:** Heavy lifting (file discovery, string searching) is delegated to `ripgrep`, the fastest tool in its class.
- **Memory Efficient:** Uses Neovim's built-in floating windows and buffer management to keep memory usage low even during complex searches.

## ⌨️ Essential Keymaps

| Keymap | Action |
| :--- | :--- |
| `<leader>th` | Open Theme Picker (Live Preview) |
| `<leader>ff` | Find Files |
| `<leader>fw` | Live Grep (Real-time) |
| `\` | Toggle Custom Explorer |
| `<Tab>` / `<S-Tab>` | Navigate in Pickers (Recycles) |
| `<CR>` | Confirm Selection |
| `<Esc>` | Cancel / Clear Highlights |

---
*Created by Chris Nguyen*
