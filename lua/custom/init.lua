-- Only load plugins if full category is enabled
if nixInfo(false, "settings", "cats", "full") then
  -- Register lze handlers
  require("lze").register_handlers {
    {
      spec_field = "for_cat",
      set_lazy = false,
      modify = function(plugin)
        if type(plugin.for_cat) == "string" then
          plugin.enabled = nixInfo(false, "settings", "cats", plugin.for_cat)
        end
        return plugin
      end,
    },
  }
  require("lze").register_handlers(require("lzextras").lsp)

  -- Load all plugin modules
  require "custom.plugins"
  require "custom.LSPs"
  require "custom.formatting"
  require "custom.linting"
  require "custom.debug"
  require "custom.compile"
end
