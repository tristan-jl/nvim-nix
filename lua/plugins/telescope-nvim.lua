return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
        file_ignore_patterns = {
          ".git/",
          "node_modules",
          "target/",
          "venv/",
        },
      },
      extensions = {
        file_browser = {
          theme = "ivy",
          hidden = true,
          hijack_netrw = true,
        },
      },
    })
    telescope.load_extension("fzf")
    -- telescope.load_extension("file_browser")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sf", builtin.buffers, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader><space>", function()
      builtin.find_files({ previewer = true, hidden = true })
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>st", builtin.tags, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>so", function()
      builtin.tags({ only_current_buffer = true })
    end, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>sd", builtin.grep_string, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>sp", builtin.live_grep, { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>?", builtin.oldfiles, { noremap = true, silent = true })
  end,
}
