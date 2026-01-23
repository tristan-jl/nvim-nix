-- Load plugin modules
require("lze").load {
  { import = "custom.plugins.telescope" },
  { import = "custom.plugins.treesitter" },
  { import = "custom.plugins.completion" },
  { import = "custom.plugins.database" },
  { import = "custom.plugins.copilot" },
}

-- Oil file explorer
vim.g.loaded_netrwPlugin = 1
require("lze").load {
  {
    "oil.nvim",
    for_cat = "full",
    lazy = false,
    load = function(name)
      vim.cmd.packadd(name)
    end,
    after = function(_)
      require("oil").setup {
        default_file_explorer = true,
        columns = { "icon" },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
          -- Disable defaults that conflict with window navigation
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = "Open parent directory" })
      vim.keymap.set("n", "<space>-", require("oil").toggle_float, { desc = "Toggle oil float" })
    end,
  },
}

-- General plugins
require("lze").load {
  {
    "lualine.nvim",
    for_cat = "full",
    event = "DeferredUIEnter",
    after = function(_)
      require("lualine").setup {
        options = {
          globalstatus = true,
          theme = "tokyonight",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_c = { { "filename", path = 1 } },
        },
      }
    end,
  },
  {
    "gitsigns.nvim",
    for_cat = "full",
    event = "DeferredUIEnter",
    after = function(_)
      require("gitsigns").setup {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      }
    end,
  },
  {
    "mini.ai",
    for_cat = "full",
    event = "DeferredUIEnter",
    after = function(_)
      require("mini.ai").setup()
    end,
  },
  {
    "vim-commentary",
    for_cat = "full",
    event = "DeferredUIEnter",
  },
  {
    "vim-tmux-navigator",
    for_cat = "full",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>" },
      { "<c-j>" },
      { "<c-k>" },
      { "<c-l>" },
    },
  },
  {
    "vim-just",
    for_cat = "full",
    event = { "BufReadPre", "BufNewFile" },
    ft = { "\\cjustfile", "*.just", ".justfile" },
  },
  {
    "nvim-surround",
    for_cat = "full",
    event = "DeferredUIEnter",
    after = function(_)
      require("nvim-surround").setup()
    end,
  },
  {
    "markdown-preview.nvim",
    for_cat = "full",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
  },
  {
    "crates.nvim",
    for_cat = "full",
    event = { "BufRead Cargo.toml" },
    after = function(_)
      require("crates").setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
  {
    "otter.nvim",
    for_cat = "full",
    ft = { "markdown", "quarto", "norg" },
    after = function(_)
      require("otter").setup()
    end,
  },
}
