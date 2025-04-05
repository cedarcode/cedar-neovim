local autocmd = vim.api.nvim_create_autocmd

local root_names = { '.git', 'LICENSE', 'LICENSE.txt', 'MIT-LICENSE' }

local root_cache = {}

local function find_root(path)
  local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
  if not root_file then return nil end

  local root = vim.fs.dirname(root_file)
  root_cache[path] = root

  return root
end

autocmd({ "BufWinEnter", "BufWinLeave" }, {
  pattern = "*",
  callback = function()
    -- Skip snacks windows
    if vim.bo.filetype:match("^snacks") then return end

    local path = vim.fn.expand('%:p:h')

    local root = root_cache[path] or find_root(path)

    if root then
      vim.cmd('silent! cd ' .. root)
    end
  end,
})
