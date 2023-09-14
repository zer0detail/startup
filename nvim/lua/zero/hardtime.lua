
local status_ok, hardtime = pcall(require, "hardtime")
if not status_ok then
  return
end
local config = {
   max_time = 1000,
   max_count = 20,
   disable_mouse = false,
   hint = true,
   notification = true,
   allow_different_key = false,
   enabled = true,
   restriction_mode = "hint", -- block or hint
   restricted_keys = {
      ["-"] = { "n", "x" },
      ["+"] = { "n", "x" },
      ["gj"] = { "n", "x" },
      ["gk"] = { "n", "x" },
      ["<CR>"] = { "n", "x" },
      ["<C-M>"] = { "n", "x" },
      ["<C-N>"] = { "n", "x" },
      ["<C-P>"] = { "n", "x" },
   },
   disabled_keys = {
      ["<Up>"] = { "", "i" },
      ["<Down>"] = { "", "i" },
      ["<Left>"] = { "", "i" },
      ["<Right>"] = { "", "i" },
   },
   disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
 }

hardtime.setup(config)
