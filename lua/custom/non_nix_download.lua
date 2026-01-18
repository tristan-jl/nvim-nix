-- Paq-nvim fallback for when not using nix
-- Only runs when nixCats was not used to install the config
require("nixCatsUtils.catPacker").setup {
  -- Core
  { "BirdeeHub/lze" },
  { "BirdeeHub/lzextras" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- Colorscheme
  { "folke/tokyonight.nvim" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opt = true },
  { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
  { "windwp/nvim-ts-autotag", opt = true },

  -- Telescope
  { "nvim-telescope/telescope.nvim", opt = true },
  { "nvim-telescope/telescope-fzf-native.nvim", build = ":!which make && make", opt = true },
  { "nvim-telescope/telescope-ui-select.nvim", opt = true },

  -- Completion
  { "Saghen/blink.cmp", opt = true },
  { "rafamadriz/friendly-snippets", opt = true },

  -- UI
  { "nvim-lualine/lualine.nvim", opt = true },
  { "lewis6991/gitsigns.nvim", opt = true },
  { "stevearc/oil.nvim" },

  -- Editing
  { "echasnovski/mini.ai", opt = true },
  { "tpope/vim-commentary", opt = true },
  { "christoomey/vim-tmux-navigator", opt = true },
  { "kylechui/nvim-surround", opt = true },

  -- Database
  { "tpope/vim-dadbod", opt = true },
  { "kristijanhusak/vim-dadbod-ui", opt = true },
  { "kristijanhusak/vim-dadbod-completion", opt = true },

  -- LSP
  { "neovim/nvim-lspconfig", opt = true },
  { "b0o/SchemaStore.nvim", opt = true },
  { "folke/lazydev.nvim", opt = true },
  { "williamboman/mason.nvim", opt = true },
  { "williamboman/mason-lspconfig.nvim", opt = true },

  -- Format and Lint
  { "stevearc/conform.nvim", opt = true },
  { "mfussenegger/nvim-lint", opt = true },

  -- Debug
  { "mfussenegger/nvim-dap", opt = true },
  { "rcarriga/nvim-dap-ui", opt = true },
  { "theHamsta/nvim-dap-virtual-text", opt = true },
  { "nvim-neotest/nvim-nio", opt = true },
  { "mfussenegger/nvim-dap-python", opt = true },
  { "leoluz/nvim-dap-go", opt = true },

  -- Filetype
  { "NoahTheDuke/vim-just", opt = true },
  { "iamcco/markdown-preview.nvim", build = ":call mkdp#util#install()", opt = true },
}
