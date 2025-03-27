-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})

-- Snacks keymaps
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers() end)
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep() end)
vim.keymap.set("n", "<C-n>", function() Snacks.explorer() end)
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files() end)
