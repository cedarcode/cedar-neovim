local autocmd = vim.api.nvim_create_autocmd

local cwd_stack = {}  -- Stack to track directory changes

-- Change the working directory only if the file is not in a subdirectory of the current one
autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    local file_dir = vim.fn.expand('%:p:h')  -- Get the directory of the currently opened file
    local cwd = vim.fn.getcwd()  -- Get the current working directory

    -- Check if the file is outside the current working directory
    if not file_dir:match("^" .. vim.pesc(cwd) .. "/") then
      vim.b.prev_cwd = cwd  -- Store the previous working directory in a buffer-local variable
      vim.cmd('lcd ' .. file_dir)   -- Change the working directory to the file's directory
    end
  end,
})

autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    -- Restore the previous working directory if it was stored in this buffer
    if vim.b.prev_cwd then
      vim.cmd('lcd ' .. vim.b.prev_cwd)  -- Change back to the previous working directory
      vim.b.prev_cwd = nil  -- Clear the buffer-local variable
    end
  end,
})
