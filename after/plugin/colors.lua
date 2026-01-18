-- Set colorscheme (only when full is enabled, otherwise use default)
if nixCats "full" then
  vim.cmd.colorscheme "tokyonight-night"
end
