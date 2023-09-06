local colour = "catppuccin"

require("catppuccin").setup({
  transparent_background = true
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colour)
if not status_ok then
  vim.notify("colorscheme " .. colour .. " not found!")
  return
end
