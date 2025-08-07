---@type vim.lsp.Config
return {
  -- on_init = function(client)
  --   local path = client.workspace_folders[1].name
  --   if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
  --     return
  --   end

  --   client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
  --     runtime = {
  --       version = "LuaJIT",
  --     },
  --     path = {
  --       "lua/?.lua",
  --       "lua/?/init.lua",
  --     },
  --   })
  -- end,
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".stylua.toml",
    "stylua.toml",
  },
  settings = {
    Lua = {
      hint = { enable = true },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
}
