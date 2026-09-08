return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 200,
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>g", group = "grep (rails contexts)" },
      { "<leader>h", group = "git hunks" },
      { "<leader>l", group = "loclist" },
      { "<leader>r", group = "rails (find)" },
      { "<leader>t", group = "test" },
    },
  },
}
