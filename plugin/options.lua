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

-- Sets how neovim will display certain whitespace characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live
opt.inccommand = "split"

-- Set completeopt for better completion experience
opt.completeopt = "menu,preview,noselect"

-- Netrw settings
vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

-- [[ Disable auto comment on enter ]]
vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
})

-- Text file type formatting
local fileTypeGroup = vim.api.nvim_create_augroup("FileTypeDetect", { clear = true })
for _, pattern in ipairs { "gitcommit", "tex", "text", "markdown" } do
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = pattern,
    command = "setlocal spell tw=80 colorcolumn=81",
    group = fileTypeGroup,
  })
end
