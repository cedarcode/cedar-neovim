return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "ruby", "javascript", "html", "embedded_template", "typescript", "tsx", "css", "json", "yaml" },
      highlight = {
        enable = true,
        disable = { "ruby" },
      },
      indent = {
        enable = true,
        disable = { "ruby" },
      },
    })
  end
}
