return {
  "nvim-tree/nvim-tree.lua",
  version = "1.13.0",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
}
