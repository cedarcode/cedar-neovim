-- LSP keymaps
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end)

-- Snacks keymaps
local opts = { hidden = true, ignored = true, cmd = "rg" }

-- Explorer
vim.keymap.set("n", "<C-n>", function() Snacks.explorer(opts) end)

-- Pickers
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files(opts) end)
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers(opts) end)
vim.keymap.set("n", "<C-g>", function() Snacks.picker.git_status({ ignored = false, cmd = "rg" }) end)
vim.keymap.set("n", "<C-q>", function() Snacks.picker.qflist(opts) end)
vim.keymap.set({"n", "v"}, "<C-s>", function() Snacks.picker.grep_word(opts) end)

-- Grep
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep(opts) end)
vim.keymap.set("n", "<C-_>", "<C-/>", { remap = true })

-- Git keymaps
vim.keymap.set({"n", "v"}, "gl", ":Git blame<CR>")
vim.keymap.set({"n", "v"}, "gb", ":GBrowse<CR>")
