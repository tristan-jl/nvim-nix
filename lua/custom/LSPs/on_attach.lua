return function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- Diagnostic keymaps
  nmap("]d", function()
    vim.diagnostic.jump { count = 1, float = true }
  end, "Next diagnostic")
  nmap("[d", function()
    vim.diagnostic.jump { count = -1, float = true }
  end, "Previous diagnostic")
  nmap("<leader>e", vim.diagnostic.open_float, "Open floating diagnostic")
  nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")

  -- LSP keymaps
  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("gT", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Telescope integration
  nmap("gr", function()
    require("telescope.builtin").lsp_references()
  end, "[G]oto [R]eferences")
  nmap("<leader>cs", function()
    require("telescope.builtin").lsp_document_symbols()
  end, "[D]ocument [S]ymbols")
  nmap("<leader>ws", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, "[W]orkspace [S]ymbols")
  nmap("<leader>ee", function()
    require("telescope.builtin").diagnostics { bufnr = 0 }
  end, "Buffer diagnostics")

  -- Workspace folder management
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Format command
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end
