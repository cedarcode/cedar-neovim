return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local utils = require("utils")

    if not utils.executable("ruby-lsp") then
      utils.install_ruby_lsp()
    end

    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

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
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('lua_ls')

    local group = vim.api.nvim_create_augroup("RubyLspFormat", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Prefer LSP folds where the server offers them; treesitter is the global default
        if client and client:supports_method("textDocument/foldingRange") then
          vim.wo[0][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        if vim.bo[args.buf].filetype == "ruby" then
          vim.keymap.set("n", "<leader>rb", function()
            vim.lsp.buf.format({
              async = true,
              filter = function(c) return c.name == "ruby_lsp" end,
            })
          end, { buffer = args.buf, desc = "Format Ruby buffer (Rubocop)" })
        end
      end,
    })
  end,
}
