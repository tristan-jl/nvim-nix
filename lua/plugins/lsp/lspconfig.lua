return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    --LSP settings
    require("neodev").setup({})
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    -- local rust_tools = require("rust-tools")

    local on_attach = function(_, bufnr)
      -- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
      )
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>so",
        [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
        opts
      )
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Enable the following language servers
    local servers = { "ansiblels", "clangd", "gopls", "tailwindcss" }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end

    lspconfig.denols.setup({
      single_file_support = false,
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern("deno.json"),
      init_options = {
        lint = true,
      },
    })

    lspconfig.tsserver.setup({
      single_file_support = false,
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern("package.json"),
      init_options = {
        lint = true,
      },
    })

    lspconfig.pyright.setup({
      cmd = { vim.env.HOME .. "/opt/venv/bin/pylsp" },
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      server = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            features = "all",
          },
          procMacro = {
            enable = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    })

    -- rust_tools.setup({
    -- 	server = {
    -- 		on_attach = on_attach,
    -- 		capabilities = capabilities,
    -- 		server = {
    -- 			["rust-analyzer"] = {
    -- 				assist = {
    -- 					importGranularity = "module",
    -- 					importPrefix = "self",
    -- 				},
    -- 				cargo = {
    -- 					loadOutDirsFromCheck = true,
    -- 					features = "all",
    -- 				},
    -- 				procMacro = {
    -- 					enable = true,
    -- 				},
    -- 				checkOnSave = {
    -- 					command = "clippy",
    -- 				},
    -- 			},
    -- 		},
    -- 	},
    -- })

    lspconfig.gopls.setup({
      cmd = { "gopls", "serve" },
      filetypes = { "go", "gomod" },
      root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    })
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    -- 	group = vim.api.nvim_create_augroup("tristan-jl", {}),
    -- 	pattern = "*.go",
    -- 	callback = function()
    -- 		local params = vim.lsp.util.make_range_params()
    -- 		params.context = { only = { "source.organizeImports" } }
    -- 		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    -- 		for cid, res in pairs(result or {}) do
    -- 			for _, r in pairs(res.result or {}) do
    -- 				if r.edit then
    -- 					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
    -- 					vim.lsp.util.apply_workspace_edit(r.edit, enc)
    -- 				end
    -- 			end
    -- 		end
    -- 	end,
    -- })

    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
          settings = { callSnippet = "Replace" },
        },
      },
    })
  end,
}
