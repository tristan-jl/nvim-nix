return {
  {
    "vim-dadbod-ui",
    for_cat = "full",
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    load = function(name)
      vim.cmd.packadd "vim-dadbod"
      vim.cmd.packadd(name)
      vim.cmd.packadd "vim-dadbod-completion"
    end,
    before = function(_)
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
