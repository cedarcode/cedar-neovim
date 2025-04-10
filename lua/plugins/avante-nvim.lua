return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"!
  opts = {
    provider = "airbnb",
    vendors = {
      ---@type AvanteProvider
      ["airbnb"] = {
        __inherited_from = "openai",
        endpoint = "https://devaigateway.a.musta.ch",
        api_key_name = "DEV_AI_API_KEY",
        model = "best_coding",
      },
    },
  },
  hints = { enabled = false },
  windows = {
    input = {
      border = "rounded",
      width = 100,
      height = 20,
    },
    output = {
      border = "rounded",
      width = 100,
      height = 20,
    },
    ask = {
      floating = true,
      border = "rounded",
      start_insert = true,
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons",
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
