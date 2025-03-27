# cedar-neovim

## Prerequisites

- [Neovim](https://neovim.io/)

We recommend getting the lastest version of `Neovim` You can install it with Homebrew:

```sh
$ brew install neovim
```

Or upgrade it if you already have it installed:

```sh
$ brew upgrade neovim
```

## Installing

```
$ git clone https://github.com/cedarcode/cedar-neovim ~/.config/nvim
```

## Plugins

These are some of the plugins that are currently installed, we recommend you to read their documentation to get the most out of them:

- [catppuccin](https://github.com/catppuccin/nvim)
- [copilot.vim](https://github.com/github/copilot.vim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [vim-bundler](https://github.com/tpope/vim-bundler)
- [vim-endwise](https://github.com/tpope/vim-endwise)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [vim-rails](https://github.com/tpope/vim-rails)
- [vim-surround](https://github.com/tpope/vim-surround)
- [vim-unimpaired](https://github.com/tpope/vim-unimpaired)

## Keymaps

These are the keymaps that are currently defined:

### Navigation

- `Ctrl + p` - Open a file browser
- `Ctrl + n` - Open a file explorer
- `Ctrl + /` - Open grep search
- `Ctrl + b` - Open the current buffer

### LSP

- `gd` - Go to definition
- `gr` - Go to references

## Add custom configuration

If you want to add custom keymaps or options, you can do so by creating a file at `~/.config/nvim/lua/config/user-customizations.lua` and adding your customizations there.
