{
  description = "Neovim configuration with nixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (inputs.nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        allowUnfree = true;
      };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            full = with pkgs; [
              # General tools
              ripgrep
              fd
              tree-sitter

              # LSP servers
              clang-tools
              deno
              go-tools
              gopls
              gotools
              lua-language-server
              nixd
              nodePackages.svelte-language-server
              nodePackages.vscode-json-languageserver
              basedpyright
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
          };

          startupPlugins = {
            full = with pkgs.vimPlugins; [
              lze
              lzextras
              nvim-web-devicons
              plenary-nvim

              # Colorscheme
              tokyonight-nvim
            ];
          };

          optionalPlugins = {
            full = with pkgs.vimPlugins; [
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
              markdown-preview-nvim
              vim-just
            ];
          };

          sharedLibraries = { };
          environmentVariables = { };
          extraWrapperArgs = { };
          extraLuaPackages = { };
          extraCats = { };
        };

      packageDefinitions = {
        nvim =
          { pkgs, ... }@misc:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              aliases = [
                "vi"
                "vim"
              ];
              wrapRc = true;
              configDirName = "nix-nvim";
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            categories = {
              full = true;
            };
            extra = {
              nixdExtras = {
                nixpkgs = "import ${pkgs.path} {}";
              };
            };
          };
        nvim-minimal =
          { pkgs, ... }@misc:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              configDirName = "nix-nvim";
            };
            categories = {
              full = false;
            };
            extra = { };
          };
      };

      defaultPackageName = "nvim";
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
          };
        };
      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
