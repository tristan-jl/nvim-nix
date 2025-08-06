local conform = require "conform"

conform.setup {
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
    nix = { "nixfmt" },
    python = { "reorder-python-imports", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    conform.format {
      bufnr = args.buf,
      lsp_fallback = true,
    }
  end,
})
