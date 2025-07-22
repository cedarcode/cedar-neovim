-- LSP keymaps
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end)

-- Files navigation keymaps
local opts = { hidden = true }

vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers({ hidden = true, cmd = "rg" }) end)
vim.keymap.set("n", "<C-n>", ":NvimTreeFindFileToggle<CR>")
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files({ hidden = true, cmd = "rg" }) end)

-- Fuzzy finder keymaps
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep(opts) end)
vim.keymap.set("n", "<C-_>", "<C-/>", { remap = true })
vim.keymap.set({"n", "v"}, "<C-s>", function() Snacks.picker.grep_word(opts) end)

-- Diagnostics keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- Git keymaps
vim.keymap.set({"n", "v"}, "gl", ":Git blame<CR>")
vim.keymap.set({"n", "v"}, "gb", ":GBrowse<CR>")
vim.keymap.set("n", "<C-g>", function() Snacks.picker.git_status({ ignored = false, cmd = "rg" }) end)
