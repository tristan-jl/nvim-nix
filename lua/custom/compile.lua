require("lze").load {
  {
    "compile-mode.nvim",
    for_cat = "full",
    cmd = { "Compile", "Recompile" },
    keys = {
      { "<leader>xx", desc = "Compile" },
      { "<leader>xr", desc = "Recompile" },
    },
    before = function(_)
      vim.g.compile_mode = {
        default_command = "",
        auto_jump_to_first_error = false,
        ask_about_save = true,
        focus_compilation_buffer = true,
        error_threshold = vim.diagnostic.severity.WARN,
        error_regexp_table = {
          nix = {
            regex = "^\\s\\+at \\([^:]\\+\\):\\(\\d\\+\\):\\(\\d\\+\\):",
            filename = 1,
            row = 2,
            col = 3,
            type = vim.diagnostic.severity.ERROR,
          },
        },
      }
    end,
    after = function(_)
      vim.keymap.set("n", "<leader>xx", "<cmd>Compile<cr>", { desc = "Compile" })
      vim.keymap.set("n", "<leader>xr", "<cmd>Recompile<cr>", { desc = "Recompile" })
    end,
  },
}
