return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
  config = function()
    require("oil").setup {
      keymaps = {
        ["<C-p>"] = false,
      },
      view_options = {
        show_hidden = true,
      },
    }
  end,
}
