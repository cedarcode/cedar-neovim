# Lualine Statusline Design

**Date:** 2026-04-01  
**Status:** Approved

## Problem

The Neovim config uses the bare default statusline, showing no git info, diagnostics, LSP status, or mode indicator. It provides no useful context at a glance.

## Goal

Add a full, information-dense powerline-style statusline using lualine.nvim with the Catppuccin Mocha theme.

## Layout

```
 NORMAL  ⎇ main  filename.rb [+]          ✘ 2  ⚠ 1  ruby_lsp   Ruby   42:10  80% 
```

**Left side:**
- `lualine_a`: current mode (colored block, shifts per mode)
- `lualine_b`: git branch with branch icon
- `lualine_c`: filename (relative path, shows `[+]` when buffer is modified)

**Right side:**
- `lualine_x`: diagnostics (error/warn/hint counts from LSP) + active LSP client name
- `lualine_y`: filetype with icon (via mini.icons, already installed)
- `lualine_z`: cursor position (`line:col`) + scroll progress (`80%`)

**Separators:** Powerline-style ``, `` between sections; ``, `` between components within a section.

## Files Changed

### 1. `lua/plugins/lualine.lua` (new file)

New plugin spec for lualine.nvim:

```lua
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "catppuccin",
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
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return " " .. table.concat(names, ", ")
          end,
        },
      },
      lualine_y = { { "filetype", icon_only = false } },
      lualine_z = { "location", "progress" },
    },
    inactive_sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
    },
  },
}
```

Key decisions:
- `event = "VeryLazy"` — deferred load, does not affect startup time
- `globalstatus = true` — single statusline across all splits (Neovim 0.7+), cleaner look
- `path = 1` on filename — shows relative path, useful when navigating many files
- LSP client name rendered via a custom function using `vim.lsp.get_clients` (the current Neovim 0.10+ API, not the deprecated `get_active_clients`)

### 2. `lua/plugins/catppuccin.lua` (update)

Add `lualine = true` to the integrations table so Catppuccin generates lualine highlight groups:

```lua
integrations = {
  copilot_vim = true,
  gitgutter = true,
  lualine = true,
  snacks = true,
},
```

## What This Gives You

- Mode indicator with color-coded blocks (normal=blue, insert=green, visual=mauve, command=peach)
- Git branch always visible
- Relative filename with modified flag
- Inline error/warning/hint counts from LSP diagnostics
- Active LSP client name(s)
- Filetype with icon
- Cursor position and scroll progress

## What This Does Not Do

- No tabline / bufferline (out of scope)
- No custom per-project overrides
