local M = {}

function M.directory_has_files(dir)
  local handle = vim.loop.fs_scandir(dir)
  return handle and vim.loop.fs_scandir_next(handle) ~= nil
end

return M
