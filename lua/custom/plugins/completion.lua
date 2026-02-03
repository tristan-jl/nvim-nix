local function get_sources()
  local default = { "lsp", "path", "snippets", "buffer" }
  if nixInfo(false, "settings", "cats", "copilot") then
    table.insert(default, 2, "copilot")
  end
  return default
end

local function get_providers()
  local providers = {
    dadbod = {
      name = "Dadbod",
      module = "blink.compat.source",
    },
  }
  if nixInfo(false, "settings", "cats", "copilot") then
    providers.copilot = {
      name = "copilot",
      module = "blink-cmp-copilot",
      async = true,
    }
  end
  return providers
end

return {
  {
    "blink.compat",
    for_cat = "full",
    lazy = true,
  },
  {
    "blink.cmp",
    for_cat = "full",
    event = "DeferredUIEnter",
    load = function(name)
      vim.cmd.packadd "blink.compat"
      vim.cmd.packadd(name)
      vim.cmd.packadd "friendly-snippets"
      if nixInfo(false, "settings", "cats", "copilot") then
        vim.cmd.packadd "blink-cmp-copilot"
      end
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
          default = get_sources(),
          per_filetype = {
            sql = { "dadbod", "snippets", "buffer" },
          },
          providers = get_providers(),
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
      }
    end,
  },
}
