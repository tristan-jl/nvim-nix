return {
  {
    "telescope.nvim",
    for_cat = "full",
    cmd = { "Telescope" },
    on_require = { "telescope" },
    keys = {
      {
        "<space>fd",
        function()
          return require("telescope.builtin").find_files()
        end,
        mode = { "n" },
        desc = "Find files",
      },
      {
        "<space>ft",
        function()
          return require("telescope.builtin").git_files()
        end,
        mode = { "n" },
        desc = "Git files",
      },
      {
        "<space>fh",
        function()
          return require("telescope.builtin").help_tags()
        end,
        mode = { "n" },
        desc = "Help tags",
      },
      {
        "<space>fb",
        function()
          return require("telescope.builtin").buffers()
        end,
        mode = { "n" },
        desc = "Buffers",
      },
      {
        "<space>fg",
        function()
          return require("telescope.builtin").live_grep()
        end,
        mode = { "n" },
        desc = "Live grep",
      },
      {
        "<space>/",
        function()
          return require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        mode = { "n" },
        desc = "Current buffer fuzzy find",
      },
      {
        "<space>gw",
        function()
          return require("telescope.builtin").grep_string()
        end,
        mode = { "n" },
        desc = "Grep string",
      },
    },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd "telescope-fzf-native.nvim"
      vim.cmd.packadd "telescope-ui-select.nvim"
    end,
    after = function(_)
      require("telescope").setup {
        extensions = {
          wrap_results = true,
          fzf = {},
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
    end,
  },
}
