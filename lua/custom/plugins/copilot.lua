return {
  {
    "copilot.lua",
    for_cat = "copilot",
    event = "InsertEnter",
    after = function(_)
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
}
