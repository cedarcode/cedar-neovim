return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = {
      -- make sure mason installs the server
      servers = {
        ts_ls = {
          enabled = true,
        },
        herb_ls = {
          enabled = true,
        },
      },
    },
    config = function()
      local utils = require("utils")

      if not utils.executable("ruby-lsp") then
        utils.install_ruby_lsp()
      end

      vim.lsp.config('ruby_lsp', {
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            }
          }
        }
      })

      vim.lsp.enable('ruby_lsp')
    end,
  },
}
