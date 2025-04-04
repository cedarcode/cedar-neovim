-- LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})

-- Snacks keymaps
local opts = { hidden = true }

vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers({ hidden = true, cmd = "rg" }) end)
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep(opts) end)
vim.keymap.set("n", "<C-n>", function() Snacks.explorer(opts) end)
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files({ hidden = true, cmd = "rg" }) end)
