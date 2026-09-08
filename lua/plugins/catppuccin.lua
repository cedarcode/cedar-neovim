return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,

  config = function()
    require("catppuccin").setup({
      transparent_background = true,
      integrations = {
        copilot_vim = true,
        gitsigns = true,
        snacks = true,
      },
    })
  end
}
