-- LSP keymaps
-- Nvim's default gr* family (grn/gra/grr/gri/grt) makes a bare `gr` wait out
-- timeoutlen, so those move to <leader>c* and `gr` fires immediately.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, { "n", "v", "x" }, "gra")

vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Go to references" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

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

-- ============================================================================
-- Rails navigation
--
-- Path sets are shared between the find (<leader>r*) and grep (<leader>g*)
-- pickers, so a new location is added in one place.
-- ============================================================================

local NO_TESTS = { "!**/test/**", "!**/*_test.rb" }
local NO_TEST_DIRS = { "!**/test/**" }
local NO_NODE_MODULES = { "!**/node_modules/**" }

local function concat(...)
  local out = {}
  for _, list in ipairs({ ... }) do
    vim.list_extend(out, list)
  end
  return out
end

local paths = {
  admin_components = { "engines/admin/app/components/**/*_component.{rb,erb}" },
  admin_controllers = { "engines/admin/app/controllers/**/*.rb" },
  api_controllers = { "engines/api/app/controllers/**/*.rb" },
  concerns = { "**/concerns/**/*.rb" },
  config = { "config/**/*.{rb,yml}", "engines/*/config/**/*.{rb,yml}", "packs/*/config/**/*.{rb,yml}" },
  controllers = { "engines/*/app/controllers/**/*.rb", "packs/*/app/controllers/**/*.rb" },
  engines = { "engines/**/*.rb" },
  factories = { "**/test/factories/**/*_factory.rb" },
  helpers = { "engines/*/app/helpers/**/*.rb", "packs/*/app/helpers/**/*.rb" },
  jobs = { "engines/*/app/jobs/**/*.rb", "packs/*/app/jobs/**/*.rb" },
  migrations = {
    "db/migrate/**/*.rb",
    "db/structure.sql",
    "engines/*/db/migrate/**/*.rb",
    "packs/*/db/migrate/**/*.rb",
  },
  models = { "app/models/**/*.rb", "engines/*/app/models/**/*.rb", "packs/*/app/models/**/*.rb" },
  packs = { "packs/**/*.rb" },
  serializers = { "engines/*/app/serializers/**/*.rb", "packs/*/app/serializers/**/*.rb" },
  services = { "engines/*/app/services/**/*.rb", "packs/*/app/services/**/*.rb" },
  test_files = { "test/**/*_test.rb", "engines/*/test/**/*_test.rb", "packs/*/test/**/*_test.rb" },
  tests_any = { "**/test/**/*.rb" },
  views = { "app/views/**/*.erb", "engines/*/app/views/**/*.erb", "packs/*/app/views/**/*.erb" },
}

local function rg_globs(include, exclude)
  local args = {}
  for _, pattern in ipairs(concat(include, exclude or {})) do
    table.insert(args, "--glob")
    table.insert(args, pattern)
  end
  return args
end

local function find_in(include, exclude)
  return function()
    Snacks.picker.files({
      cmd = "rg",
      hidden = true,
      args = vim.list_extend({ "--files" }, rg_globs(include, exclude)),
    })
  end
end

local function grep_in(include, exclude)
  return function()
    Snacks.picker.grep({ hidden = true, args = rg_globs(include, exclude) })
  end
end

local find_maps = {
  { "rc", "Find Rails controllers (no tests)", paths.controllers, concat(NO_TESTS, { "!**/javascript/**" }) },
  { "rca", "Find API controllers (no tests)", paths.api_controllers, NO_TESTS },
  { "rcc", "Find Admin controllers (no tests)", paths.admin_controllers, NO_TESTS },
  { "rcf", "Find config files", paths.config, NO_NODE_MODULES },
  { "rcn", "Find concerns (no tests)", paths.concerns, NO_TESTS },
  { "rdb", "Find migrations and schema", paths.migrations },
  { "re", "Find files in engines (no tests)", paths.engines, NO_TESTS },
  { "rf", "Find test factories", paths.factories },
  { "rh", "Find Rails helpers (no tests)", paths.helpers, NO_TESTS },
  { "rj", "Find Rails jobs (no tests)", paths.jobs, NO_TESTS },
  { "rm", "Find Rails models (no tests)", paths.models, concat(NO_TESTS, { "!**/factories/**" }) },
  { "rp", "Find files in packs (no tests)", paths.packs, NO_TESTS },
  { "rs", "Find Rails services (no tests)", paths.services, NO_TESTS },
  { "rt", "Find Rails tests (Minitest)", paths.test_files },
  { "rv", "Find Rails views/templates (no tests)", paths.views, concat(NO_TEST_DIRS, NO_NODE_MODULES) },
  { "rvc", "Find Admin ViewComponents (no tests)", paths.admin_components, NO_TEST_DIRS },
  { "rz", "Find Rails serializers (no tests)", paths.serializers, NO_TESTS },
}

for _, spec in ipairs(find_maps) do
  local key, desc, include, exclude = spec[1], spec[2], spec[3], spec[4]
  vim.keymap.set("n", "<leader>" .. key, find_in(include, exclude), { desc = desc })
end

local grep_maps = {
  { "gc", "Grep in controllers (no tests)", paths.controllers, concat(NO_TESTS, { "!**/javascript/**" }) },
  { "gcn", "Grep in concerns (no tests)", paths.concerns, NO_TESTS },
  { "gdb", "Grep in migrations and schema", paths.migrations },
  { "gj", "Grep in jobs (no tests)", paths.jobs, NO_TESTS },
  { "gm", "Grep in models (no tests)", paths.models, NO_TESTS },
  { "gs", "Grep in services (no tests)", paths.services, NO_TESTS },
  { "gt", "Grep in tests", paths.tests_any },
}

for _, spec in ipairs(grep_maps) do
  local key, desc, include, exclude = spec[1], spec[2], spec[3], spec[4]
  vim.keymap.set("n", "<leader>" .. key, grep_in(include, exclude), { desc = desc })
end

vim.keymap.set({ "n", "v" }, "<C-s>", function()
  Snacks.picker.grep_word({ hidden = true, args = rg_globs({}, NO_TESTS) })
end, { desc = "Search word under cursor" })
