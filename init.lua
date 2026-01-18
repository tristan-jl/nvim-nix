-- Setup nixCatsUtils for non-nix fallback
require("nixCatsUtils").setup {
  non_nix_value = true,
}

-- Load plugins when not using nix
require "custom.non_nix_download"

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load main configuration
require "custom"
