local opt = vim.opt

-- Set highlight on search
opt.hlsearch = false

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = "a"

-- Scrolloff
opt.scrolloff = 8

-- Tab/indents
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- Enable auto indenting
opt.smartindent = true
opt.shiftwidth = 4

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Decrease update time
opt.updatetime = 50
opt.signcolumn = "yes"

-- Set colorscheme
opt.termguicolors = true
opt.cursorline = true

-- Text file type formatting
local fileTypeGroup = vim.api.nvim_create_augroup("FileTypeDetect", { clear = true })
for _, pattern in ipairs { "gitcommit", "tex", "text", "markdown" } do
  vim.api.nvim_create_autocmd(
    "Filetype",
    { pattern = pattern, command = "setlocal spell tw=80 colorcolumn=81", group = fileTypeGroup }
  )
end

-- Disable multiline diagnostics
vim.diagnostic.config { virtual_lines = false }
