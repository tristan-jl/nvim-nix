local lsp_dir = vim.fn.stdpath "config" .. "/lsp/"

for _, file in ipairs(vim.fn.globpath(lsp_dir, "*.lua", false, true)) do
  local server = vim.fn.fnamemodify(file, ":t:r")
  vim.lsp.enable(server)
end

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.ERROR] = " ",
    },
  },
}

local set = vim.keymap.set

-- Diagnostic keymaps
set("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end)
set("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end)
set("n", "<leader>e", vim.diagnostic.open_float)
set("n", "<leader>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    local builtin = require "telescope.builtin"

    set("n", "<leader>ee", builtin.diagnostics, { buffer = 0 })

    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
    set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
    set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
    set("n", "gr", builtin.lsp_references, { buffer = 0 })
    set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
    set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    set("n", "<leader>cs", builtin.lsp_document_symbols, { buffer = 0 })
  end,
})

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd "checkhealth vim.lsp"
end, { desc = "Check LSP health" })
