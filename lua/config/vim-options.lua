vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus"     -- Use system clipboard
vim.opt.confirm = true                -- Prompt instead of failing on unsaved changes
vim.opt.expandtab = true              -- Use spaces instead of tabs
vim.opt.foldmethod = "expr"
vim.opt.foldenable = true
vim.opt.foldlevel = 99                -- Start with folds open
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.ignorecase = true             -- Case-insensitive search
vim.opt.path:append("**")
vim.opt.scrolloff = 8                 -- Keep 8 lines of context around the cursor
vim.opt.softtabstop = 2               -- Number of spaces when hitting <Tab> in insert mode
vim.opt.shiftwidth = 2                -- Number of spaces for indentation
vim.opt.smartcase = true              -- ...unless the search contains a capital
vim.opt.splitbelow = true             -- Horizontal splits open below
vim.opt.splitright = true             -- Vertical splits open to the right
vim.opt.swapfile = false
vim.opt.tabstop = 2                   -- Number of spaces a tab counts for
vim.opt.timeoutlen = 400              -- Mapping sequence timeout
vim.opt.undofile = true               -- Enable persistent undo
vim.opt.updatetime = 200              -- Drives snacks.words and LSP document highlight
if vim.fn.has("nvim-0.11") == 1 then
  vim.opt.winborder = 'rounded'         -- Use rounded borders for windows
end

vim.wo.number = true
