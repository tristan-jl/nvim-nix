local set = vim.keymap.set

--Remap space as leader key
set("", "<Space>", "<Nop>")
set("", "<C-c", "<Esc>")

-- Highlight on yank
local yankGroup = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { command = "silent! lua vim.hl.on_yank()", group = yankGroup })

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false
