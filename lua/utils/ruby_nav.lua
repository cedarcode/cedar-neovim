local M = {}

local uv = vim.uv or vim.loop

local cycle_state = {
  key = nil,
  index = 0,
}

local function path_join(...)
  return (table.concat({ ... }, "/"):gsub("//+", "/"))
end

local function exists(p)
  return p and uv.fs_stat(p) ~= nil
end

local function find_root(start)
  start = start or vim.fn.expand("%:p:h")
  local dir = start
  while dir and dir ~= "" do
    if exists(path_join(dir, ".git")) or exists(path_join(dir, "Gemfile")) then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end
  return vim.fn.getcwd()
end

local function glob_one(pattern)
  local g = vim.fn.glob(pattern, true, true)
  if type(g) == "table" and #g > 0 then return g[1] end
  return nil
end

local function detect_kind(root)
  local is_rails = exists(path_join(root, "config", "application.rb")) and exists(path_join(root, "app"))
  local gemspec = glob_one(path_join(root, "*.gemspec"))
  local is_gem = gemspec ~= nil or exists(path_join(root, "lib"))
  return { root = root, rails = is_rails, gem = is_gem, gemspec = gemspec }
end

local function test_framework(root)
  if exists(path_join(root, "spec")) or exists(path_join(root, ".rspec")) then return "rspec" end
  if exists(path_join(root, "test")) then return "minitest" end
  return "rspec"
end

local function current_rel(root)
  local p = vim.fn.expand("%:p")
  if p == "" then return nil end
  p = p:gsub("\\", "/")
  root = root:gsub("\\", "/")
  if p:sub(1, #root) ~= root then return nil end
  return p:sub(#root + 2)
end

local function edit_if_exists(target)
  if not target or target == "" then return false end
  if not exists(target) then return false end
  vim.cmd("edit " .. vim.fn.fnameescape(target))
  return true
end

-- ---------- Rails: :A ----------
local function rails_alternate(kind, rel)
  local tf = test_framework(kind.root)

  -- model <-> model spec/test
  if rel:match("^app/models/(.+)%.rb$") then
    local base = rel:match("^app/models/(.+)%.rb$")
    if tf == "rspec" then
      return path_join(kind.root, "spec/models", base .. "_spec.rb")
    else
      return path_join(kind.root, "test/models", base .. "_test.rb")
    end
  end
  if rel:match("^spec/models/(.+)_spec%.rb$") then
    return path_join(kind.root, "app/models", rel:match("^spec/models/(.+)_spec%.rb$") .. ".rb")
  end
  if rel:match("^test/models/(.+)_test%.rb$") then
    return path_join(kind.root, "app/models", rel:match("^test/models/(.+)_test%.rb$") .. ".rb")
  end

  -- controller <-> request spec / controller test
  if rel:match("^app/controllers/(.+)_controller%.rb$") then
    local base = rel:match("^app/controllers/(.+)_controller%.rb$")
    if tf == "rspec" then
      return path_join(kind.root, "spec/requests", base .. "_spec.rb")
    else
      return path_join(kind.root, "test/controllers", base .. "_controller_test.rb")
    end
  end
  if rel:match("^spec/requests/(.+)_spec%.rb$") then
    return path_join(kind.root, "app/controllers", rel:match("^spec/requests/(.+)_spec%.rb$") .. "_controller.rb")
  end
  if rel:match("^test/controllers/(.+)_controller_test%.rb$") then
    return path_join(kind.root, "app/controllers", rel:match("^test/controllers/(.+)_controller_test%.rb$") .. "_controller.rb")
  end

  -- factory <-> model (useful as alternate too)
  if rel:match("^spec/factories/(.+)%.rb$") then
    local base = rel:match("^spec/factories/(.+)%.rb$")
    return path_join(kind.root, "app/models", base .. ".rb")
  end
  if rel:match("^app/models/(.+)%.rb$") then
    local base = rel:match("^app/models/(.+)%.rb$")
    return path_join(kind.root, "spec/factories", base .. ".rb")
  end

  return nil
end

-- ---------- Gem: :A ----------
local function gem_alternate(kind, rel)
  local tf = test_framework(kind.root)

  if rel:match("^lib/(.+)%.rb$") then
    local base = rel:match("^lib/(.+)%.rb$")
    if tf == "rspec" then
      return path_join(kind.root, "spec", base .. "_spec.rb")
    else
      return path_join(kind.root, "test", base .. "_test.rb")
    end
  end

  if rel:match("^spec/(.+)_spec%.rb$") then
    return path_join(kind.root, "lib", rel:match("^spec/(.+)_spec%.rb$") .. ".rb")
  end

  if rel:match("^test/(.+)_test%.rb$") then
    return path_join(kind.root, "lib", rel:match("^test/(.+)_test%.rb$") .. ".rb")
  end

  return nil
end

-- ---------- Rails/Gem: :R related lists ----------
local function rails_related(kind, rel)
  local out = {}
  local tf = test_framework(kind.root)

  if rel:match("^app/models/(.+)%.rb$") then
    local base = rel:match("^app/models/(.+)%.rb$")
    table.insert(out, path_join(kind.root, "spec/factories", base .. ".rb"))
    table.insert(out, tf == "rspec"
      and path_join(kind.root, "spec/models", base .. "_spec.rb")
       or path_join(kind.root, "test/models", base .. "_test.rb"))
  end

  if rel:match("^spec/factories/(.+)%.rb$") then
    local base = rel:match("^spec/factories/(.+)%.rb$")
    table.insert(out, path_join(kind.root, "app/models", base .. ".rb"))
    table.insert(out, tf == "rspec"
      and path_join(kind.root, "spec/models", base .. "_spec.rb")
       or path_join(kind.root, "test/models", base .. "_test.rb"))
  end

  if rel:match("^spec/models/(.+)_spec%.rb$") then
    local base = rel:match("^spec/models/(.+)_spec%.rb$")
    table.insert(out, path_join(kind.root, "app/models", base .. ".rb"))
    table.insert(out, path_join(kind.root, "spec/factories", base .. ".rb"))
  end

  if rel:match("^test/models/(.+)_test%.rb$") then
    local base = rel:match("^test/models/(.+)_test%.rb$")
    table.insert(out, path_join(kind.root, "app/models", base .. ".rb"))
    table.insert(out, path_join(kind.root, "spec/factories", base .. ".rb"))
  end

  -- Controller: related = views dir + request spec/test (NO routes)
  if rel:match("^app/controllers/(.+)_controller%.rb$") then
    local base = rel:match("^app/controllers/(.+)_controller%.rb$")
    table.insert(out, path_join(kind.root, "app/views", base))
    table.insert(out, tf == "rspec"
      and path_join(kind.root, "spec/requests", base .. "_spec.rb")
       or path_join(kind.root, "test/controllers", base .. "_controller_test.rb"))
  end

  if rel:match("^spec/requests/(.+)_spec%.rb$") then
    local base = rel:match("^spec/requests/(.+)_spec%.rb$")
    table.insert(out, path_join(kind.root, "app/controllers", base .. "_controller.rb"))
    table.insert(out, path_join(kind.root, "app/views", base))
  end

  if rel:match("^test/controllers/(.+)_controller_test%.rb$") then
    local base = rel:match("^test/controllers/(.+)_controller_test%.rb$")
    local ctrl = base:gsub("_controller$", "")
    table.insert(out, path_join(kind.root, "app/controllers", ctrl .. "_controller.rb"))
    table.insert(out, path_join(kind.root, "app/views", ctrl))
  end

  if rel:match("^app/views/([^/]+)/") then
    local scope = rel:match("^app/views/([^/]+)/")
    table.insert(out, path_join(kind.root, "app/controllers", scope .. "_controller.rb"))
    table.insert(out, path_join(kind.root, "app/helpers", scope .. "_helper.rb"))
  end

  -- keep only existing targets; de-dupe
  local seen, existing = {}, {}
  for _, p in ipairs(out) do
    if exists(p) and not seen[p] then
      seen[p] = true
      table.insert(existing, p)
    end
  end

  return existing
end

local function gem_related(kind, rel)
  local out = {}
  local tf = test_framework(kind.root)

  if rel:match("^lib/(.+)%.rb$") then
    local base = rel:match("^lib/(.+)%.rb$")
    table.insert(out, path_join(kind.root, "README.md"))
    table.insert(out, kind.gemspec or glob_one(path_join(kind.root, "*.gemspec")) or "")
    table.insert(out, path_join(kind.root, "lib", base .. "/version.rb"))
    table.insert(out, tf == "rspec"
      and path_join(kind.root, "spec", base .. "_spec.rb")
       or path_join(kind.root, "test", base .. "_test.rb"))
  end

  if rel:match("^spec/(.+)_spec%.rb$") then
    local base = rel:match("^spec/(.+)_spec%.rb$")
    table.insert(out, path_join(kind.root, "lib", base .. ".rb"))
    table.insert(out, path_join(kind.root, "README.md"))
  end

  if rel:match("^test/(.+)_test%.rb$") then
    local base = rel:match("^test/(.+)_test%.rb$")
    table.insert(out, path_join(kind.root, "lib", base .. ".rb"))
    table.insert(out, path_join(kind.root, "README.md"))
  end

  local seen, existing = {}, {}
  for _, p in ipairs(out) do
    if p ~= "" and exists(p) and not seen[p] then
      seen[p] = true
      table.insert(existing, p)
    end
  end
  return existing
end

local function cycle_key(paths)
  local sorted = vim.deepcopy(paths)
  table.sort(sorted)
  return table.concat(sorted, "\n")
end

local function rotate_to_next(paths)
  if #paths == 0 then return nil end

  local key = cycle_key(paths)
  if cycle_state.key ~= key then
    cycle_state.key = key
    cycle_state.index = 0
  end

  cycle_state.index = (cycle_state.index % #paths) + 1
  return paths[cycle_state.index]
end

function M.setup()
  local function ctx()
    return detect_kind(find_root())
  end

  vim.api.nvim_create_user_command("A", function()
    local k = ctx()
    local rel = current_rel(k.root)
    if not rel then
      vim.notify("No file", vim.log.levels.WARN)
      return
    end

    local target
    if k.rails then target = rails_alternate(k, rel) end
    if (not target) and k.gem then target = gem_alternate(k, rel) end

    if not target then
      vim.notify("No alternate found for " .. rel, vim.log.levels.WARN)
      return
    end

    if not edit_if_exists(target) then
      vim.notify("Target does not exist: " .. target, vim.log.levels.WARN)
    end
  end, {})

  vim.api.nvim_create_user_command("R", function()
    local k = ctx()
    local rel = current_rel(k.root)
    if not rel then
      vim.notify("No file", vim.log.levels.WARN)
      return
    end

    local related = {}
    if k.rails then related = rails_related(k, rel) end
    if (#related == 0) and k.gem then related = gem_related(k, rel) end

    if #related == 0 then
      vim.notify("No related found for " .. rel, vim.log.levels.WARN)
      return
    end

    local target = rotate_to_next(related)
    if not edit_if_exists(target) then
      vim.notify("Target does not exist: " .. tostring(target), vim.log.levels.WARN)
    end
  end, {})
end

return M
