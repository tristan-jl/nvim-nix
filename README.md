# nvim-nix

A Neovim configuration using [nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules) for Nix-based package management. All dependencies (plugins, LSP servers, formatters, linters) are managed by Nix.

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

### Package Variants

- `nvim` (default) - Full configuration with all plugins and tools
- `nvim-minimal` - Minimal configuration without plugins
- `nvim-copilot` - Full configuration with GitHub Copilot support (binary: `nvim-copilot`, can be installed alongside `nvim`)

```bash
nix build .#nvim
nix build .#nvim-minimal
nix build .#nvim-copilot
```

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
