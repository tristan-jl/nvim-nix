return {
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "gruber-darker"
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup {
        style = "moon",
        transparent = false,
      }

      vim.cmd.colorscheme "tokyonight"
    end,
  },
  { "craftzdog/solarized-osaka.nvim", enabled = false },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
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
    end,
  },
}
