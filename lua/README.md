### Pre-requisites

- [Neovim 0.10.3](https://github.com/neovim/neovim/releases/tag/v0.10.3)
- [Nerd Font](https://www.nerdfonts.com) Set it in your terminal emulator.
- [Ripgrep](https://github.com/BurntSushi/ripgrep)
```
  brew install ripgrep
```
- [Vim Dadbod UI](https://github.com/kristijanhusak/vim-dadbod-ui)
```
  brew install libpq
```
- [Cspell](https://github.com/davidmh/cspell.nvim)
```
:MasonInstall cspell 
```

### Install

`git clone https://github.com/dev-beat/nvim.git ~/.config/nvim --depth 1 && nvim`

### Uninstall

```
  #Linux / Macos (unix)
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
```

### [LSP](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md "LSP")

uncomment lsp under nvconfig.lua



