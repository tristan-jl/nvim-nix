-- Set colorscheme (only when full is enabled, otherwise use default)
if nixInfo(false, "settings", "cats", "full") then
  vim.cmd.colorscheme "tokyonight-night"
end
