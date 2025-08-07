return {
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "tokyonight-night"
    end,
  },
  {
    "blazkowolf/gruber-darker.nvim",
    enabled = true,
    lazy = false,
  },
  { "craftzdog/solarized-osaka.nvim", enabled = true, lazy = false },
}
