-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Scrolloff
vim.o.scrolloff = 8

-- Tab/indents
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Enable auto indenting
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 50
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.cmd.colorscheme("catppuccin-macchiato")
vim.o.termguicolors = true
vim.opt.cursorline = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Text file type formatting
local fileTypeGroup = vim.api.nvim_create_augroup("FileTypeDetect", { clear = true })
for _, pattern in ipairs({ "gitcommit", "tex", "text", "markdown" }) do
  vim.api.nvim_create_autocmd(
    "Filetype",
    { pattern = pattern, command = "setlocal spell tw=80 colorcolumn=81", group = fileTypeGroup }
  )
end
vim.api.nvim_create_autocmd(
  "Filetype",
  { pattern = "python", command = "setlocal colorcolumn=89", group = fileTypeGroup }
)
