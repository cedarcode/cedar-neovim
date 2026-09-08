return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = {
    options = {
      theme = "catppuccin-nvim",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = { error = " ✘ ", warn = " ⚠ ", hint = " " },
        },
        {
          function()
            local names = {}
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
              -- Copilot attaches to nearly every buffer, so it is noise here
              if client.name ~= "GitHub Copilot" then
                table.insert(names, client.name)
              end
            end
            if #names == 0 then return "" end
            return " " .. table.concat(names, ", ")
          end,
        },
      },
      lualine_y = { { "filetype", icon_only = false } },
      lualine_z = { "location", "progress" },
    },
  },
}
