local catUtils = require "nixCatsUtils"

-- Diagnostic configuration
vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.ERROR] = " ",
    },
  },
}

-- LspInfo command
vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd "checkhealth vim.lsp"
end, { desc = "Check LSP health" })

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    require "custom.LSPs.on_attach"(client, args.buf)
  end,
})

-- Set up filetype fallback for lzextras.lsp handler
local old_ft_fallback = require("lze").h.lsp.get_ft_fallback()
require("lze").h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible { "allPlugins", "opt", "nvim-lspconfig" }
    or nixCats.pawsible { "allPlugins", "start", "nvim-lspconfig" }
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)

require("lze").load {
  {
    "nvim-lspconfig",
    for_cat = "full",
    on_require = { "lspconfig" },
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
  },
  {
    "lazydev.nvim",
    for_cat = "full",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup {
        library = {
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
        },
      }
    end,
  },
  {
    "SchemaStore.nvim",
    for_cat = "full",
    on_plugin = { "nvim-lspconfig" },
  },
  -- LSP Server configurations
  {
    "lua_ls",
    for_cat = "full",
    lsp = {
      filetypes = { "lua" },
      cmd = { "lua-language-server" },
      root_markers = { ".luarc.json", ".stylua.toml", "stylua.toml" },
      settings = {
        Lua = {
          hint = { enable = true },
          telemetry = { enable = false },
          diagnostics = { globals = { "vim", "nixCats" } },
          workspace = { checkThirdParty = false },
        },
      },
    },
  },
  {
    "nixd",
    for_cat = "full",
    enabled = catUtils.isNixCats,
    lsp = {
      filetypes = { "nix" },
      cmd = { "nixd" },
      root_markers = { "flake.nix", ".git" },
      settings = {
        nixd = {
          nixpkgs = {
            expr = nixCats.extra "nixdExtras.nixpkgs" or [[import <nixpkgs> {}]],
          },
          formatting = {
            command = { "nixfmt" },
          },
          diagnostic = {
            suppress = { "sema-escaping-with" },
          },
        },
      },
    },
  },
  {
    "gopls",
    for_cat = "full",
    lsp = {
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      cmd = { "gopls" },
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  },
  {
    "ts_ls",
    for_cat = "full",
    lsp = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      cmd = { "typescript-language-server", "--stdio" },
      root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      init_options = { hostInfo = "neovim", lint = true },
      commands = {
        -- Custom handler for showReferences - shows in quickfix list
        ["editor.action.showReferences"] = function(_, result)
          if result and #result > 0 then
            vim.fn.setqflist(vim.lsp.util.locations_to_items(result, "utf-8"))
            vim.cmd "copen"
          end
        end,
      },
      handlers = {
        -- Custom handler for _typescript.rename (used by extract refactorings)
        ["_typescript.rename"] = function(_, result, ctx)
          if not result then
            return
          end
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if not client then
            return
          end
          -- Apply the edit first
          if result.documentChanges then
            vim.lsp.util.apply_workspace_edit(result, client.offset_encoding or "utf-16")
          end
          -- Then trigger rename at the position if provided
          if result.position then
            vim.api.nvim_win_set_cursor(0, { result.position.line + 1, result.position.character })
            vim.lsp.buf.rename()
          end
        end,
      },
    },
    after = function(_)
      -- LspTypescriptSourceAction command for source-level code actions
      vim.api.nvim_create_user_command("LspTypescriptSourceAction", function()
        vim.lsp.buf.code_action {
          context = {
            only = { "source" },
            diagnostics = {},
          },
        }
      end, { desc = "TypeScript source actions (organize imports, fix all, etc.)" })
    end,
  },
  {
    "denols",
    for_cat = "full",
    lsp = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      cmd = { "deno", "lsp" },
      root_markers = { "deno.json", "deno.jsonc" },
      single_file_support = false,
      init_options = { lint = true },
    },
  },
  {
    "rust_analyzer",
    for_cat = "full",
    lsp = {
      filetypes = { "rust" },
      cmd = { "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            allFeatures = true,
            buildScripts = { enable = true },
          },
          procMacro = { enable = true },
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
    },
  },
  {
    "basedpyright",
    for_cat = "full",
    lsp = {
      filetypes = { "python" },
      cmd = { "basedpyright-langserver", "--stdio" },
      root_markers = { "pyproject.toml", "pyrightconfig.json", ".git" },
      settings = {
        basedpyright = {
          -- Disable import organization (ruff handles this)
          disableOrganizeImports = true,
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
            -- Type checking mode: off, basic, standard, strict, all
            typeCheckingMode = "strict",
            -- Disable diagnostics that ruff handles
            diagnosticSeverityOverrides = {
              reportUnusedImport = "none",
              reportUnusedVariable = "none",
              reportUnusedClass = "none",
              reportUnusedFunction = "none",
            },
          },
        },
      },
    },
  },
  {
    "ruff",
    for_cat = "full",
    lsp = {
      filetypes = { "python" },
      cmd = { "ruff", "server" },
      root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
      on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
      end,
    },
  },
  {
    "clangd",
    for_cat = "full",
    lsp = {
      filetypes = { "c" },
      init_options = { clangdFileStatus = true },
    },
  },
  {
    "svelte",
    for_cat = "full",
    lsp = {
      filetypes = { "svelte" },
      cmd = { "svelteserver", "--stdio" },
    },
  },
  {
    "tailwindcss",
    for_cat = "full",
    lsp = {
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      },
      cmd = { "tailwindcss-language-server", "--stdio" },
      root_markers = { "tailwind.config.js", "tailwind.config.ts", "postcss.config.js", ".git" },
      settings = {
        tailwindCSS = {
          validate = true,
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidScreen = "error",
            invalidVariant = "error",
            invalidConfigPath = "error",
            invalidTailwindDirective = "error",
            recommendedVariantOrder = "warning",
          },
          classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
        },
      },
    },
  },
  {
    "jsonls",
    for_cat = "full",
    lsp = {
      filetypes = { "json", "jsonc" },
      cmd = { "vscode-json-language-server", "--stdio" },
    },
    after = function(_)
      -- Configure with SchemaStore if available
      pcall(function()
        vim.lsp.config("jsonls", {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        })
      end)
    end,
  },
  {
    "qmlls",
    for_cat = "full",
    lsp = {
      filetypes = { "qml" },
    },
  },
}
