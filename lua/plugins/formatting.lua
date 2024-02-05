return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        css = { "prettier" },
        go = { "goimports", "gofmt" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "reorder-python-imports", "black" },
        rust = { "rustfmt" },
        svelte = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end)
  end,
}

-- old null-ls config
-- local null_ls = require("null-ls")
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- null_ls.setup({
-- 	sources = {
-- 		null_ls.builtins.code_actions.proselint,
-- 		null_ls.builtins.diagnostics.eslint,
-- 		null_ls.builtins.diagnostics.fish,
-- 		null_ls.builtins.diagnostics.flake8,
-- 		null_ls.builtins.diagnostics.mypy,
-- 		null_ls.builtins.diagnostics.proselint,
-- 		null_ls.builtins.formatting.black,
-- 		null_ls.builtins.formatting.dart_format,
-- 		null_ls.builtins.formatting.just,
-- 		null_ls.builtins.formatting.prettier,
-- 		null_ls.builtins.formatting.rustfmt,
-- 		null_ls.builtins.formatting.stylua,
-- 	},
-- 	on_attach = function(client, bufnr)
-- 		if client.supports_method("textDocument/formatting") then
-- 			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
-- 			vim.api.nvim_create_autocmd("BufWritePre", {
-- 				group = augroup,
-- 				buffer = bufnr,
-- 				callback = function()
-- 					vim.lsp.buf.format({
-- 						bufnr = bufnr,
-- 						filter = function(_client)
-- 							return _client.name == "null-ls"
-- 						end,
-- 					})
-- 				end,
-- 			})
-- 		end
-- 	end,
-- })
