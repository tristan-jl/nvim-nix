-- Only load plugins if full category is enabled
if nixCats "full" then
  -- Register lze handlers
  require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)
  require("lze").register_handlers(require("lzextras").lsp)

  -- Load all plugin modules
  require "custom.plugins"
  require "custom.LSPs"
  require "custom.formatting"
  require "custom.linting"
  require "custom.debug"
  require "custom.compile"
end
