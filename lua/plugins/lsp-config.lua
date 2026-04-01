return {
  "neovim/nvim-lspconfig",
  lazy = false,
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
    vim.lsp.enable('ts_ls')

    local group = vim.api.nvim_create_augroup("RubyLspFormat", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      pattern = "*",
      callback = function(args)
        if vim.bo[args.buf].filetype == "ruby" then
          vim.keymap.set("n", "<leader>rb", function()
            vim.lsp.buf.format({
              async = true,
              filter = function(client) return client.name == "ruby_lsp" end,
            })
          end, { buffer = args.buf, desc = "Format Ruby buffer (Rubocop)" })
        end
      end,
    })
  end,
}
