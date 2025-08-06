vim.api.nvim_create_user_command("CycleColours", function()
  local colours = { "tokyonight-night", "gruber-darker", "catppuccin-macchiato", "solarized-osaka" }
  local current = vim.g.colors_name

  for k, v in ipairs(colours) do
    if v == current then
      local colour = colours[k % table.getn(colours) + 1]
      vim.cmd.colorscheme(colour)
      print("Set colourscheme to", colour)
      return
    end
  end
end, {})
