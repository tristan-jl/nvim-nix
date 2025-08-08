return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  enable = true,
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
}
