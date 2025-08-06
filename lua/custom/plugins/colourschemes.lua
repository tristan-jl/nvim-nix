return {
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "tokyonight-night"
      require "custom.colourscheme_swap"
    end,
  },
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = true,
    enabled = true,
  },
  { "craftzdog/solarized-osaka.nvim", enabled = true, lazy = true },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    lazy = true,
    config = function()
      require("catppuccin").setup {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        float = {
          transparent = false,
          solid = false,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          mini = false,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          notify = false,
          nvimtree = true,
          telescope = { enable = true },
          treesitter = true,
        },
      }

      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
