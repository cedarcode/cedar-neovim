local chosen_splash

return {
  "folke/snacks.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
    "amansingh-afk/milli.nvim",
  },
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = function()
    local milli = require("milli")
    local names = milli.list()
    math.randomseed(os.time())
    chosen_splash = names[math.random(#names)]
    local splash = milli.load({ splash = chosen_splash })
    return {
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = table.concat(splash.frames[1], "\n"),
      },
    },
    explorer = { enabled = false },
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
      layout = {
        fullscreen = true,
      },
      win = {
        input = {
          keys = {
           ["<Esc>"] = { "close", mode = { "n", "i" } },
           ["<M-Down>"] = { "history_forward", mode = { "i", "n" } },
           ["<M-Up>"] = { "history_back", mode = { "i", "n" } },
          }
        }
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    }
  end,
  config = function(_, opts)
    require("snacks").setup(opts)
    require("milli").snacks({ splash = chosen_splash, loop = true })
  end,
}
