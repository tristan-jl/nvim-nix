{
  description = "Neovim configuration with nix-wrapper-modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    compile_mode = {
      url = "github:ej-shafran/compile-mode.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      wrappers,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      # Core module with shared config (no optional specs)
      coreModule = lib.modules.importApply ./module.nix inputs;

      # Optional spec modules - only imported by variants that need them
      fullSpecModule =
        { config, pkgs, ... }:
        {
          config.specs.full = {
            after = [ "core" ];
            lazy = true;
            extraPackages = with pkgs; [
              ripgrep
              fd
              tree-sitter
              # LSP servers
              basedpyright
              clang-tools
              deno
              go-tools
              gopls
              gotools
              kdePackages.qtdeclarative
              lua-language-server
              nixd
              nodePackages.svelte-language-server
              nodePackages.vscode-json-languageserver
              rust-analyzer
              tailwindcss-language-server
              typescript-language-server
              # Formatters
              nixfmt
              prettier
              ruff
              rustfmt
              stylua
              # Linters
              fish
              golangci-lint
              mypy
              nodePackages.eslint
              proselint
              selene
              shfmt
              statix
              # Debug
              delve
              lldb
            ];
            data = with pkgs.vimPlugins; [
              # Treesitter
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
              nvim-ts-autotag
              # Telescope
              telescope-fzf-native-nvim
              telescope-nvim
              telescope-ui-select-nvim
              # Completion
              blink-cmp
              blink-compat
              friendly-snippets
              # UI
              gitsigns-nvim
              lualine-nvim
              oil-nvim
              # Editing
              mini-ai
              nvim-surround
              vim-commentary
              vim-tmux-navigator
              # Database
              vim-dadbod
              vim-dadbod-completion
              vim-dadbod-ui
              # Format and Lint
              conform-nvim
              nvim-lint
              # Debug
              nvim-dap
              nvim-dap-go
              nvim-dap-python
              nvim-dap-ui
              nvim-dap-virtual-text
              nvim-nio
              # LSP
              SchemaStore-nvim
              lazydev-nvim
              nvim-lspconfig
              # Filetype
              crates-nvim
              markdown-preview-nvim
              otter-nvim
              vim-just
            ];
          };

          config.specs.compile-mode = {
            lazy = true;
            data = [
              (pkgs.vimUtils.buildVimPlugin {
                pname = "compile-mode.nvim";
                version = "latest";
                src = inputs.compile_mode;
                doCheck = false;
              })
            ];
          };
        };

      copilotSpecModule =
        { pkgs, ... }:
        {
          config.specs.copilot = {
            lazy = true;
            data = with pkgs.vimPlugins; [
              copilot-lua
              blink-cmp-copilot
            ];
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = lib.platforms.all;

      imports = [ wrappers.flakeModules.wrappers ];

      perSystem =
        { system, self', ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          wrappers.pkgs = pkgs;

          packages = {
            default = self'.packages.nvim;
          };

          devShells.default = pkgs.mkShell {
            name = "nvim";
            packages = [ self'.packages.nvim ];
          };
        };

      flake = {
        overlays.default = final: _: {
          neovim = self.packages.${final.stdenv.hostPlatform.system}.default;
        };

        wrapperModules.default = coreModule;

        wrappers = {
          nvim =
            { wlib, ... }:
            {
              imports = [
                wlib.wrapperModules.neovim
                coreModule
                fullSpecModule
              ];
            };

          nvim-minimal =
            { wlib, lib, ... }:
            {
              imports = [
                wlib.wrapperModules.neovim
                coreModule
              ];
              config.settings.aliases = lib.mkForce [ ];
              config.hosts.python3.nvim-host.enable = lib.mkForce false;
              config.hosts.node.nvim-host.enable = lib.mkForce false;
            };

          nvim-copilot =
            { wlib, lib, ... }:
            {
              imports = [
                wlib.wrapperModules.neovim
                coreModule
                fullSpecModule
                copilotSpecModule
              ];
              config.binName = "nvim-copilot";
              config.settings.aliases = lib.mkForce [ ];
              config.settings.dont_link = true;
            };
        };
      };
    };
}
