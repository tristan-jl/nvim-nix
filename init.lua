-- Set up lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Set python path
local python_venv_path = vim.env.HOME .. "/opt/venv"
if vim.loop.fs_stat(python_venv_path) then
  vim.g.python3_host_prog = python_venv_path .. "/bin/python"
end
-- Set leader before plugins
vim.g.mapleader = " "

require("lazy").setup({ import = "custom/plugins" }, { change_detection = { notify = false } })
