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
    config = function()
      local lspconfig = require("lspconfig")
      local utils = require("utils")

      local function setup_ruby_lsp()
        lspconfig.ruby_lsp.setup({
          init_options = {
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
        })
      end

      if utils.executable("ruby-lsp") then
        setup_ruby_lsp()
      else
        utils.install_ruby_lsp(function() setup_ruby_lsp() end)
      end

      lspconfig.ts_ls.setup({})
    end,
  },
}
