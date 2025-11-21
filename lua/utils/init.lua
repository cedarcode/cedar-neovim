local M = {}

function M.directory_has_files(dir)
  local handle = vim.loop.fs_scandir(dir)
  return handle and vim.loop.fs_scandir_next(handle) ~= nil
end

function M.install_ruby_lsp()
  if not M.executable("ruby") then
    return
  end

  local ruby_version = vim.fn.systemlist("ruby -v")[1]
  if not ruby_version or #ruby_version == 0 then
    return
  end

  local major, minor = ruby_version:match("ruby (%d+)%.(%d+)")
  if not (tonumber(major) > 3 or (tonumber(major) == 3 and tonumber(minor) >= 0)) then
    return
  end

  vim.fn.jobstart({ "gem", "install", "ruby-lsp" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("ruby-lsp installed successfully!", vim.log.levels.INFO)
      else
        vim.notify("Failed to install ruby-lsp", vim.log.levels.ERROR)
      end
    end,
  })
end

function M.executable(cmd)
  return vim.fn.executable(cmd) == 1
end

return M
