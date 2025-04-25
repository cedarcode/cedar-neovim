-- LSP keymaps
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end)

-- Snacks keymaps
local opts = { hidden = true }

vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers({ hidden = true, cmd = "rg" }) end)
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep(opts) end)
vim.keymap.set("n", "<C-n>", function() Snacks.explorer(opts) end)
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files({ hidden = true, cmd = "rg" }) end)
vim.keymap.set("n", "<C-_>", "<C-/>", { remap = true })
