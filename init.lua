-- Set up lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set python path
vim.g.python3_host_prog = vim.env.HOME .. "/opt/venv/bin/python"
-- Set leader before plugins
vim.g.mapleader = " "

require("lazy").setup({ { import = "plugins" }, { import = "plugins.lsp" } }, {
  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- require("packer").startup(function(use)
-- 	-- use({ "catppuccin/nvim", as = "catppuccin" })
-- 	use("neovim/nvim-lspconfig")
-- 	use("hrsh7th/nvim-cmp")
-- 	use("hrsh7th/cmp-buffer")
-- 	use("hrsh7th/cmp-path")
-- 	use("hrsh7th/cmp-nvim-lua")
-- 	use("hrsh7th/cmp-nvim-lsp")
-- 	use("saadparwaiz1/cmp_luasnip")
-- 	use("L3MON4D3/LuaSnip")
-- 	use("onsails/lspkind-nvim")
-- 	use("simrat39/rust-tools.nvim")
-- 	use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })
-- 	use({ "akinsho/flutter-tools.nvim", requires = { "nvim-lua/plenary.nvim" } })
-- 	use("nvim-lua/lsp_extensions.nvim")
-- end)
-- use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
-- use("ellisonleao/glow.nvim")
