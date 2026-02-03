return {
  {
    "copilot.lua",
    for_cat = "copilot",
    cmd = { "Copilot" },
    event = "InsertEnter",
    after = function(_)
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
  },
}
