return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    highlight = { enable = true, disable = { "ruby", "yaml" } },
    indent = { enable = true, disable = { "ruby" } },
    ensure_installed = { "c", "lua", "vim", "vimdoc", "ruby", "javascript", "html", "embedded_template", "typescript", "tsx", "css", "json", "yaml", "glimmer" },
  },
  config = function(_, opts)
    local ts = require("nvim-treesitter")

    local installed = ts.get_installed and ts.get_installed()
    if not installed then
      vim.notify(
        "Please update nvim-treesitter to the main branch and run :TSUpdate",
        vim.log.levels.ERROR
      )
      return
    end

    ts.install(opts.ensure_installed or {})

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

        -- Helper to check if a feature is enabled for a language
        local function enabled(feat)
          local f = opts[feat] or {}
          return f.enable ~= false
            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
        end

        if enabled("highlight", lang) then
          pcall(vim.treesitter.start, ev.buf)
        end

        if enabled("indent", lang) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    vim.treesitter.language.register("yaml", { "eruby.yaml" })
  end,
}
