require("lze").load {
  {
    "conform.nvim",
    for_cat = "full",
    event = "BufWritePre",
    keys = {
      {
        "<leader>FF",
        function()
          require("conform").format {
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          }
        end,
        desc = "[F]ormat [F]ile",
      },
    },
    after = function(_)
      local conform = require "conform"

      conform.setup {
        formatters_by_ft = {
          bash = { "shfmt" },
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
          python = { "ruff_organize_imports", "ruff_format" },
          rust = { "rustfmt", lsp_format = "fallback" },
          sh = { "shfmt" },
          svelte = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "prettier" },
          zsh = { "shfmt" },
        },
      }

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          conform.format {
            bufnr = args.buf,
            lsp_fallback = true,
          }
        end,
      })
    end,
  },
}
