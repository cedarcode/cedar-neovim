return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      formatters = {
        file = {
          truncate = 100,
        },
      },
      win = {
        input = {
          keys = {
           ["<Esc>"] = { "close", mode = { "n", "i" } },
          }
        }
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["<C-n>"] = { "close", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
