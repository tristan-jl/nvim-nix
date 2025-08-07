---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
      check = {
        allFeatures = true,
        command = "clippy",
        extraArgs = {
          "--",
          "--no-deps",
          "-Dclippy::correctness",
          "-Dclippy::complexity",
          "-Wclippy::perf",
          "-Wclippy::pedantic",
        },
      },
      checkOnSave = true,
    },
  },
}
