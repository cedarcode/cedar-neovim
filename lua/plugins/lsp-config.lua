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

      -- Register nvim-cmp lsp capabilities
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "LSP References" })
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "LSP Format" })
      -- vim.keymap.set("v", "<leader>gf", vim.lsp.buf.format, { desc = "LSP Format" }) -- Does not work for some reason
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
      vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
    end,
  },
}
