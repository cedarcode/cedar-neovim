return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      should_attach = function(_, bufname)
        for _, folder in ipairs(vim.g.copilot_disabled_folders or {}) do
          if vim.startswith(bufname, folder) then
            return false
          end
        end

        return true
      end
    })
  end,
}
