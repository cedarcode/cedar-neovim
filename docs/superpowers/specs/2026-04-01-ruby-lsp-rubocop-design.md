# Ruby LSP Rubocop Integration Design

**Date:** 2026-04-01  
**Status:** Approved

## Problem

The Neovim config has no inline linting or manual formatting for Ruby files. Rubocop offenses are only visible when running the CLI manually, creating slow feedback loops during development.

## Goal

Add Rubocop diagnostics (inline offenses as you type) and a manual format keymap (`<leader>rb`) for Ruby buffers, with zero new plugins.

## Approach

Use the `ruby-lsp-rubocop` gem — an official ruby-lsp addon that auto-activates when installed. Ruby LSP discovers addons automatically from the gem environment; no `addonSettings` entry is needed to enable it. This requires only gem installation and a format keymap.

## Changes

### 1. `lua/utils/init.lua`

Add a new function `install_ruby_lsp_rubocop()` using the same pattern as `install_ruby_lsp()` — duplicate the version check inline, run `gem install ruby-lsp-rubocop` as an async job via `vim.fn.jobstart`. No pre-check for whether the gem is already installed: `gem install` is idempotent and exits cleanly when the gem is already present, so no synchronous startup check is needed.

```lua
function M.install_ruby_lsp_rubocop()
  if not M.executable("ruby") then
    return
  end

  local ruby_version = vim.fn.systemlist("ruby -v")[1]
  if not ruby_version or #ruby_version == 0 then
    return
  end

  local major, minor = ruby_version:match("ruby (%d+)%.(%d+)")
  if not (tonumber(major) > 3 or (tonumber(major) == 3 and tonumber(minor) >= 1)) then
    return
  end

  vim.fn.jobstart({ "gem", "install", "ruby-lsp-rubocop" }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("ruby-lsp-rubocop installed successfully!", vim.log.levels.INFO)
      else
        vim.notify("Failed to install ruby-lsp-rubocop", vim.log.levels.ERROR)
      end
    end,
  })
end
```

### 2. `lua/plugins/lsp-config.lua`

**Auto-install:** Call `utils.install_ruby_lsp_rubocop()` unconditionally at the top of `config = function()`, after the existing `ruby-lsp` guard. The gem-idempotency approach (no outer guard) differs from the `ruby-lsp` pattern (which guards on `executable("ruby-lsp")`), because `ruby-lsp-rubocop` has no standalone executable to test.

**No addonSettings change needed.** Ruby LSP auto-discovers addons from the gem environment. Do not add a `"Ruby LSP RuboCop"` entry — there is no verified key string and no settings to pass.

**Format keymap:** At the bottom of `config = function()` (after all `vim.lsp.enable(...)` calls), add an `LspAttach` autocmd. Wrap it in an augroup to prevent duplicate registrations on re-source. Filter to `ruby_lsp` client specifically to ensure only Rubocop formats (not any future LSP that also supports formatting):

```lua
local group = vim.api.nvim_create_augroup("RubyLspFormat", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype == "ruby" then
      vim.keymap.set("n", "<leader>rb", function()
        vim.lsp.buf.format({
          async = true,
          filter = function(client) return client.name == "ruby_lsp" end,
        })
      end, { buffer = args.buf, desc = "Format Ruby buffer (Rubocop)" })
    end
  end,
})
```

`<leader>rb` is chosen because it fits the existing `<leader>r*` namespace for Ruby/Rails bindings and reads as "ruby/rubocop" format. It is currently unoccupied.

## What This Gives You

- Inline Rubocop offenses appear as LSP diagnostics (underlines + virtual text) as you edit
- `<leader>rb` triggers Rubocop autocorrect on the current Ruby buffer on demand
- Project-local `.rubocop.yml` is respected automatically
- No new Neovim plugins, no synchronous startup overhead

## What This Does Not Do

- No auto-format on save (by design — user preference)
- No ESLint or JS/TS linting (out of scope)
- No Mason-managed Rubocop (relies on gem environment, consistent with existing ruby-lsp setup)

## Deactivation

To disable: `gem uninstall ruby-lsp-rubocop` and restart Neovim. The addon will no longer be discovered by ruby-lsp. The `<leader>rb` keymap will silently do nothing until the gem is reinstalled.

## Files Changed

| File | Change |
|------|--------|
| `lua/utils/init.lua` | Add `install_ruby_lsp_rubocop()` function |
| `lua/plugins/lsp-config.lua` | Call installer unconditionally, add `LspAttach` autocmd with `<leader>rb` format keymap |
