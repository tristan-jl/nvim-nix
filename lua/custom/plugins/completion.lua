return {
  {
    "blink.cmp",
    for_cat = "full",
    event = "DeferredUIEnter",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd "friendly-snippets"
    end,
    after = function(_)
      require("blink.cmp").setup {
        keymap = { preset = "default" },
        appearance = {
          nerd_font_variant = "normal",
        },
        completion = {
          documentation = { auto_show = false },
        },
        signature = { enabled = true },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
          },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
      }
    end,
  },
}
