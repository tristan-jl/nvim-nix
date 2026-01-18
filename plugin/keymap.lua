local set = vim.keymap.set

-- Remap space as leader key
set("", "<Space>", "<Nop>")
set("", "<C-c", "<Esc>")

-- [[ Highlight on yank ]]
local yankGroup = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  command = "silent! lua vim.hl.on_yank()",
  group = yankGroup,
})

-- Move lines in visual mode
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })

-- Center cursor when scrolling
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
set("n", "n", "nzzzv", { desc = "Next Search Result" })
set("n", "N", "Nzzzv", { desc = "Previous Search Result" })

-- Buffer navigation
set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = "Previous buffer" })
set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = "Last buffer" })
set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = "delete buffer" })

-- Sticky keys commands
vim.cmd [[command! W w]]
vim.cmd [[command! Wq wq]]
vim.cmd [[command! WQ wq]]
vim.cmd [[command! Q q]]

-- Remap for dealing with word wrap
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clipboard keymaps (don't override system clipboard by default)
set({ "v", "x", "n" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
set({ "n", "v", "x" }, "<leader>Y", '"+yy', { noremap = true, silent = true, desc = "Yank line to clipboard" })
set({ "n", "v", "x" }, "<C-a>", "gg0vG$", { noremap = true, silent = true, desc = "Select all" })
set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
set(
  "i",
  "<C-p>",
  "<C-r><C-p>+",
  { noremap = true, silent = true, desc = "Paste from clipboard from within insert mode" }
)
set(
  "x",
  "<leader>P",
  '"_dP',
  { noremap = true, silent = true, desc = "Paste over selection without erasing unnamed register" }
)

-- Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_show_trailing_blankline_indent = false
