local utils = require("utils")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("config/vim-options")
require("config/keymaps")
require("config/autocmds")

local user_custom_file = vim.fn.expand("~/.config/nvim/lua/config/user-customizations.lua")

if vim.loop.fs_stat(user_custom_file) then
  require("config/user-customizations")
end

local specs = { { import = "plugins" } }

local custom_dir = vim.fn.stdpath("config") .. "/lua/plugins/custom"
if utils.directory_has_files(custom_dir) then
  table.insert(specs, { import = "plugins.custom" })
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = specs,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  -- ui config
    ui = {
      border = "rounded",
      size = {
        width = 0.8,
        height = 0.8,
      },
    },
})
