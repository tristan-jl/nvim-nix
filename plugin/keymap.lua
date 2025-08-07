local set = vim.keymap.set

--Remap space as leader key
set("", "<Space>", "<Nop>")
set("", "<C-c", "<Esc>")

-- Window jumps
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")
--Remap for dealing with word wrap
--set("n", "k", "v:count == 0 ? 'gk' : 'k'")
--set("n", "j", "v:count == 0 ? 'gj' : 'j'")

-- Highlight on yank
local yankGroup = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { command = "silent! lua vim.highlight.on_yank()", group = yankGroup })

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false
