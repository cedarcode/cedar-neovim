local autocmd = vim.api.nvim_create_autocmd

local root_names = { '.git' }

local root_cache = {}

local function find_root(path)
  local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
  if not root_file then return nil end

  local root = vim.fs.dirname(root_file)
  root_cache[path] = root

  return root
end

autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    -- Skip special buffer types (quickfix, terminal, prompt, etc.)
    if vim.bo.buftype ~= "" then return end

    -- Skip special filetypes
    if vim.bo.filetype:match("^snacks") then return end
    if vim.bo.filetype == "oil" then return end

    local path = vim.fn.expand('%:p:h')
    if path == "" then return end

    local root = root_cache[path] or find_root(path)

    if root and root ~= vim.fn.getcwd() then
      vim.cmd('silent! cd ' .. vim.fn.fnameescape(root))
    end
  end,
})
