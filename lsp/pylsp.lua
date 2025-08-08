---@type vim.lsp.Config
return {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = {
    ".git",
    "Pipfile",
    "pyproject.toml",
    "requirements.txt",
    "setup.cfg",
  },
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        autopep8 = { enabled = false },
        flake8 = {
          enabled = true,
        },
        jedi_completion = {
          include_params = true,
        },
        pycodestyle = {
          enabled = false,
        },
        rope_autoimport = {
          enabled = true,
          memory = false,
          completions = { enabled = true },
          code_actions = { enabled = true },
        },
        yapf = { enabled = false },
      },
    },
  },
}
