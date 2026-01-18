# nvim-nix

A Neovim configuration using [nixCats-nvim](https://github.com/BirdeeHub/nixCats-nvim) for Nix-based package management. Supports both Nix-based installation (with all dependencies managed by Nix) and a fallback non-Nix installation using paq-nvim.

## Installation

### Nix Flake

```bash
# Run directly
nix run github:tristan/nvim-nix

# Or add to your flake inputs
{
  inputs.nvim-nix.url = "github:tristan/nvim-nix";
}
```

### NixOS Module

```nix
{
  imports = [ nvim-nix.nixosModules.default ];

  nvim = {
    enable = true;
    # Optional: override package definitions
  };
}
```

### Home Manager Module

```nix
{
  imports = [ nvim-nix.homeModules.default ];

  nvim = {
    enable = true;
  };
}
```

### Non-Nix Installation

For non-Nix systems, the configuration falls back to [paq-nvim](https://github.com/savq/paq-nvim) for plugin management. Clone the repository and open Neovim - plugins will be installed automatically.

```bash
git clone https://github.com/tristan/nvim-nix ~/.config/nvim
nvim
```

Note: You'll need to manually install LSP servers, formatters, and linters when not using Nix.

## Development

```bash
# allow direnv
direnv allow

# Build the package
nix build

# Format Lua files
stylua .

# Format Nix files
nixfmt flake.nix
```
