local autocmd = vim.api.nvim_create_autocmd

-- Change the working directory only if the file is not in a subdirectory of the current one
autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    local file_dir = vim.fn.expand('%:p:h')
    local cwd = vim.fn.getcwd()
    if not string.match(file_dir, "^" .. cwd) then
      vim.cmd('silent! lcd ' .. file_dir)
    end
  end,
})
