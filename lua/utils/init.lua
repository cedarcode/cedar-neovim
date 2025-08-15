local M = {}

function M.directory_has_files(dir)
  local handle = vim.loop.fs_scandir(dir)
  return handle and vim.loop.fs_scandir_next(handle) ~= nil
end

function M.install_ruby_lsp(on_success)
  vim.fn.jobstart({ "gem", "install", "ruby-lsp" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("ruby-lsp installed successfully!", vim.log.levels.INFO)
        on_success()
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
