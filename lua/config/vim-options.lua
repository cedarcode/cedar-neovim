vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus"     -- Use system clipboard
vim.opt.expandtab = true              -- Use spaces instead of tabs
vim.opt.foldmethod = "syntax"
vim.opt.foldenable = false            -- Start with folds open
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.path:append("**")
vim.opt.softtabstop = 2               -- Number of spaces when hitting <Tab> in insert mode
vim.opt.shiftwidth = 2                -- Number of spaces for indentation
vim.opt.swapfile = false
vim.opt.tabstop = 2                   -- Number of spaces a tab counts for
vim.opt.undofile = true               -- Enable persistent undo

vim.wo.number = true
