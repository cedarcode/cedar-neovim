return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "ruby", "javascript", "html", "embedded_template", "typescript", "tsx", "css", "json", "yaml" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby", "embedded_template" }
      },
      indent = { enable = true },
    })
  end
}
