vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus"     -- Use system clipboard
vim.opt.expandtab = true              -- Use spaces instead of tabs
vim.opt.path:append("**")
vim.opt.softtabstop = 2               -- Number of spaces when hitting <Tab> in insert mode
vim.opt.shiftwidth = 2                -- Number of spaces for indentation
vim.opt.swapfile = false
vim.opt.tabstop = 2                   -- Number of spaces a tab counts for
vim.opt.undofile = true               -- Enable persistent undo

vim.wo.number = true

-- LSP keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", {})
vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
