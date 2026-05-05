-- LSP keymaps
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Go to references" })

-- Files navigation keymaps
vim.keymap.set("n", "<C-b>", function() Snacks.picker.buffers({ hidden = true, cmd = "rg" }) end, { desc = "Find buffers" })
vim.keymap.set("n", "<C-n>", ":NvimTreeFindFileToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files({ hidden = true, cmd = "rg" }) end, { desc = "Find files" })
vim.keymap.set("n", "<M-p>", function() Snacks.picker.pickers() end, { desc = "All pickers" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Fuzzy finder keymaps
vim.keymap.set("n", "<C-/>", function() Snacks.picker.grep({ hidden = true }) end, { desc = "Grep files" })
vim.keymap.set("n", "<C-_>", "<C-/>", { remap = true })

-- Diagnostics keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })

-- Git keymaps
vim.keymap.set({"n", "v"}, "gl", ":Git blame<CR>", { desc = "Git blame" })
vim.keymap.set({"n", "v"}, "gb", ":GBrowse<CR>", { desc = "Open in GitHub" })
vim.keymap.set("n", "<C-g>", function() Snacks.picker.git_status({ ignored = false, cmd = "rg" }) end, { desc = "Git status" })
vim.keymap.set("n", "gsh", function() vim.cmd("Git show " .. vim.fn.expand("<cword>")) end, { desc = "Git show commit" })

vim.api.nvim_create_user_command("GVsplitBranch", function(opts)
  local branch = opts.args ~= "" and opts.args or "main"
  local git_root = vim.fn.FugitiveWorkTree()
  if git_root == "" then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end
  local abs_path = vim.fn.expand("%:p")
  local rel_path = abs_path:sub(#git_root + 2)
  if rel_path == "" then
    vim.notify("Not a git-tracked file", vim.log.levels.ERROR)
    return
  end
  vim.cmd("Gvsplit " .. branch .. ":" .. rel_path)
end, {
  nargs = "?",
  complete = function(arglead)
    local branches = vim.fn.systemlist("git branch --all --format='%(refname:short)' 2>/dev/null")
    return vim.tbl_filter(function(b) return b:find(arglead, 1, true) end, branches)
  end,
  desc = "Open current file in vsplit at branch",
})

vim.keymap.set("n", "<leader>gv", ":GVsplitBranch ", { desc = "Vsplit file at branch" })

-- Quicker keymaps
vim.keymap.set("n", "<leader>q", function() require("quicker").toggle() end, { desc = "Toggle quickfix", })
vim.keymap.set("n", "<leader>l", function() require("quicker").toggle({ loclist = true }) end, { desc = "Toggle loclist", })

vim.keymap.set({"n", "v"}, "<leader>tf", ":TestFile<CR>", { desc = "Run test file" })
vim.keymap.set({"n", "v"}, "<leader>tn", ":TestNearest<CR>", { desc = "Run nearest test" })

-- Models (all locations: app, engines/*/app/models, packs/*/app/models)
-- Excludes: test directories, _test.rb files, factories
vim.keymap.set("n", "<leader>rm", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "app/models/**/*.rb",
      "--glob", "engines/*/app/models/**/*.rb",
      "--glob", "packs/*/app/models/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
      "--glob", "!**/factories/**",
    },
  })
end, { desc = "Find Rails models (no tests)" })

-- Controllers (engines: api, admin, internal, packs)
-- Excludes: test directories, javascript controllers, _test.rb files
vim.keymap.set("n", "<leader>rc", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/*/app/controllers/**/*.rb",
      "--glob", "packs/*/app/controllers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
      "--glob", "!**/javascript/**",
    },
  })
end, { desc = "Find Rails controllers (no tests)" })

-- API Controllers (engines/api)
vim.keymap.set("n", "<leader>rca", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/api/app/controllers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find API controllers (no tests)" })

-- Admin Controllers (engines/admin)
vim.keymap.set("n", "<leader>rcc", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/admin/app/controllers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find Admin controllers (no tests)" })

-- Services (engines/*/app/services, packs/*/app/services)
-- Excludes: test directories, _test.rb files
vim.keymap.set("n", "<leader>rs", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/*/app/services/**/*.rb",
      "--glob", "packs/*/app/services/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find Rails services (no tests)" })

-- Jobs (engines/*/app/jobs, packs/*/app/jobs)
-- Excludes: test directories, _test.rb files
vim.keymap.set("n", "<leader>rj", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/*/app/jobs/**/*.rb",
      "--glob", "packs/*/app/jobs/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find Rails jobs (no tests)" })

-- Serializers (engines/*/app/serializers, packs/*/app/serializers)
-- Excludes: test directories, _test.rb files
vim.keymap.set("n", "<leader>rz", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/*/app/serializers/**/*.rb",
      "--glob", "packs/*/app/serializers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find Rails serializers (no tests)" })

-- Components (Admin ViewComponents - .rb and .erb files)
-- Excludes: test directories
vim.keymap.set("n", "<leader>rvc", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/admin/app/components/**/*_component.{rb,erb}",
      "--glob", "!**/test/**",
    },
  })
end, { desc = "Find Admin ViewComponents (no tests)" })

-- Views/Templates (all .erb files in app/views and engines/*/app/views)
-- Excludes: test directories, node_modules
vim.keymap.set("n", "<leader>rv", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "app/views/**/*.erb",
      "--glob", "engines/*/app/views/**/*.erb",
      "--glob", "packs/*/app/views/**/*.erb",
      "--glob", "!**/test/**",
      "--glob", "!**/node_modules/**",
    },
  })
end, { desc = "Find Rails views/templates (no tests)" })

-- Helpers (engines/*/app/helpers, packs/*/app/helpers)
-- Excludes: test directories
vim.keymap.set("n", "<leader>rh", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/*/app/helpers/**/*.rb",
      "--glob", "packs/*/app/helpers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find Rails helpers (no tests)" })

-- Tests (all test files: _test.rb in test/ directories)
-- Note: This project uses Minitest, not RSpec (no *_spec.rb files)
vim.keymap.set("n", "<leader>rt", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "test/**/*_test.rb",
      "--glob", "engines/*/test/**/*_test.rb",
      "--glob", "packs/*/test/**/*_test.rb",
    },
  })
end, { desc = "Find Rails tests (Minitest)" })

-- Test Factories (test/factories/*_factory.rb)
vim.keymap.set("n", "<leader>rf", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "**/test/factories/**/*_factory.rb",
    },
  })
end, { desc = "Find test factories" })

-- Packs (navigate pack files, excluding tests)
vim.keymap.set("n", "<leader>rp", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "packs/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find files in packs (no tests)" })

-- Engines (navigate engine files, excluding tests)
vim.keymap.set("n", "<leader>re", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "engines/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find files in engines (no tests)" })

-- Migrations (db/migrate/*.rb and structure.sql)
vim.keymap.set("n", "<leader>rdb", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "db/migrate/**/*.rb",
      "--glob", "db/structure.sql",
      "--glob", "engines/*/db/migrate/**/*.rb",
      "--glob", "packs/*/db/migrate/**/*.rb",
    },
  })
end, { desc = "Find migrations and schema" })

-- Config files (routes, initializers, locales)
vim.keymap.set("n", "<leader>rcf", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "config/**/*.{rb,yml}",
      "--glob", "engines/*/config/**/*.{rb,yml}",
      "--glob", "packs/*/config/**/*.{rb,yml}",
      "--glob", "!**/node_modules/**",
    },
  })
end, { desc = "Find config files" })

-- Concerns (models/concerns, controllers/concerns, jobs/concerns)
vim.keymap.set("n", "<leader>rcn", function()
  Snacks.picker.files({
    cmd = "rg",
    hidden = true,
    args = {
      "--files",
      "--glob", "**/concerns/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Find concerns (no tests)" })

-- ============================================================================
-- Grep within specific Rails contexts (excluding tests)
-- ============================================================================

-- Grep only in models (excluding test files)
vim.keymap.set("n", "<leader>gm", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "app/models/**/*.rb",
      "--glob", "engines/*/app/models/**/*.rb",
      "--glob", "packs/*/app/models/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Grep in models (no tests)" })

-- Grep only in controllers (excluding test files)
vim.keymap.set("n", "<leader>gc", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "engines/*/app/controllers/**/*.rb",
      "--glob", "packs/*/app/controllers/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
      "--glob", "!**/javascript/**",
    },
  })
end, { desc = "Grep in controllers (no tests)" })

-- Grep only in services (excluding test files)
vim.keymap.set("n", "<leader>gs", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "engines/*/app/services/**/*.rb",
      "--glob", "packs/*/app/services/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Grep in services (no tests)" })

-- Grep only in tests
vim.keymap.set("n", "<leader>gt", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "**/test/**/*.rb",
    },
  })
end, { desc = "Grep in tests" })

-- Grep only in jobs (excluding test files)
vim.keymap.set("n", "<leader>gj", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "engines/*/app/jobs/**/*.rb",
      "--glob", "packs/*/app/jobs/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Grep in jobs (no tests)" })

-- Grep only in concerns (excluding tests)
vim.keymap.set("n", "<leader>gcn", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "**/concerns/**/*.rb",
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Grep in concerns (no tests)" })

-- Migrations (db/migrate/*.rb and structure.sql)
vim.keymap.set("n", "<leader>gdb", function()
  Snacks.picker.grep({
    hidden = true,
    args = {
      "--glob", "db/migrate/**/*.rb",
      "--glob", "db/structure.sql",
      "--glob", "engines/*/db/migrate/**/*.rb",
      "--glob", "packs/*/db/migrate/**/*.rb",
    },
  })
end, { desc = "Find migrations and schema" })

vim.keymap.set({"n", "v"}, "<C-s>", function()
  Snacks.picker.grep_word({
    hidden = true,
    args = {
      "--glob", "!**/test/**",
      "--glob", "!**/*_test.rb",
    },
  })
end, { desc = "Search word under cursor" })
