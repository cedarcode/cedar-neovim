# Ruby LSP Rubocop Integration Design

**Date:** 2026-04-01  
**Status:** Approved

## Problem

The Neovim config has no inline linting or manual formatting for Ruby files. Rubocop offenses are only visible when running the CLI manually, creating slow feedback loops during development.

## Goal

Add Rubocop diagnostics (inline offenses as you type) and a manual format keymap for Ruby buffers, with zero new plugins.

## Approach

Use the `ruby-lsp-rubocop` gem — an official ruby-lsp addon that activates Rubocop as an LSP source for both diagnostics and formatting. Since `ruby_lsp` is already configured, this requires only gem installation and a config update.

## Changes

### 1. `lua/utils/init.lua`

Add a new function `install_ruby_lsp_rubocop()` mirroring the existing `install_ruby_lsp()` pattern:

- Check if `ruby` is executable and version >= 3.0
- Run `gem install ruby-lsp-rubocop` as an async job via `vim.fn.jobstart`
- Notify on success or failure

### 2. `lua/plugins/lsp-config.lua`

**Auto-install:** At startup, call `utils.install_ruby_lsp_rubocop()` if the gem is not already present. Detection: check if `Gem::Specification.find_by_name('ruby-lsp-rubocop')` returns a result via `ruby -e`.

**Enable the addon:** Add `"Ruby LSP Rubocop"` to the existing `addonSettings` block in `vim.lsp.config('ruby_lsp', ...)`:

```lua
addonSettings = {
  ["Ruby LSP Rails"] = {
    enablePendingMigrationsPrompt = false,
  },
  ["Ruby LSP Rubocop"] = {
    -- uses project-local .rubocop.yml automatically
  },
}
```

**Format keymap:** In an `LspAttach` autocmd (scoped to `ruby` filetype), map `<leader>f` to `vim.lsp.buf.format({ async = true })`.

## What This Gives You

- Inline Rubocop offenses appear as LSP diagnostics (underlines + virtual text) as you edit
- `<leader>f` triggers Rubocop autocorrect on the current buffer on demand
- Project-local `.rubocop.yml` is respected automatically by ruby-lsp-rubocop
- No new Neovim plugins

## What This Does Not Do

- No auto-format on save (by design — user preference)
- No ESLint or JS/TS linting (out of scope)
- No Mason-managed Rubocop (relies on gem environment, consistent with existing ruby-lsp setup)

## Files Changed

| File | Change |
|------|--------|
| `lua/utils/init.lua` | Add `install_ruby_lsp_rubocop()` function |
| `lua/plugins/lsp-config.lua` | Call installer, add addon setting, add `<leader>f` keymap |
