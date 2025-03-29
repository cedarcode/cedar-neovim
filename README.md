# cedar-neovim

## Prerequisites

- [Neovim](https://neovim.io/)

You can install Neovim using [Homebrew](https://brew.sh/):

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
- [vim-gitgutter](https://github.com/airblade/vim-gitgutter)
- [vim-rails](https://github.com/tpope/vim-rails)
- [vim-repeat](https://github.com/tpope/vim-repeat)
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

## Customization

### Add custom configuration

If you want to add custom keymaps or options, you can do so by creating a file at `~/.config/nvim/lua/config/user-customizations.lua` and adding your customizations there.

### Add custom plugins

If you want to add custom plugins (and not track them in this repository), you can do so by creating a file at `~/.config/nvim/lua/plugins/custom/` directory and adding your custom plugins there.
