-- LSP keymaps
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end)

-- Snacks keymaps
local opts = { hidden = true, ignored = true, cmd = "rg", exclude= { ".git", "tmp", "node_modules", "log", "coverage" } }
local opts2 = { hidden = true, ignored = true, exclude= { ".git", "tmp", "node_modules", "log", "coverage" } }

-- Pickers
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files(opts) end)
vim.keymap.set("n", "<M-c>", function() Snacks.picker.files({ cwd = "~/.config/nvim" }) end)
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers(opts) end)
vim.keymap.set("n", "<C-g>", function() Snacks.picker.git_status({ ignored = false, cmd = "rg" }) end)
vim.keymap.set("n", "<M-p>", function() Snacks.picker.pickers({ layout = { fullscreen = true } }) end)
vim.keymap.set("n", "<C-q>", function() Snacks.picker.qflist(opts) end)
vim.keymap.set({"n", "v"}, "<C-s>", function() Snacks.picker.grep_word(opts) end)

-- Grep
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep(opts2) end)
vim.keymap.set("n", "<C-_>", "<C-/>", { remap = true })

-- Git keymaps
vim.keymap.set({"n", "v"}, "gl", ":Git blame<CR>")
vim.keymap.set({"n", "v"}, "gb", ":GBrowse<CR>")

-- Diagnostics keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
