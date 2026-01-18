{
  description = "Neovim configuration with nixCats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
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
              lua-language-server
              nixd
              gopls
              gotools
              go-tools
              typescript-language-server
              rust-analyzer
              python3Packages.python-lsp-server
              clang-tools
              nodePackages.svelte-language-server
              tailwindcss-language-server
              nodePackages.vscode-json-languageserver
              deno
              # Formatters
              prettier
              stylua
              nixfmt
              black
              rustfmt
              python3Packages.reorder-python-imports
              # Linters
              golangci-lint
              nodePackages.eslint
              python3Packages.flake8
              mypy
              proselint
              fish
              # Debug
              lldb
            ];
          };

          startupPlugins = {
            full = with pkgs.vimPlugins; [
              lze
              lzextras
              plenary-nvim
              nvim-web-devicons
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
              telescope-ui-select-nvim
              telescope-nvim
              # Completion
              blink-cmp
              friendly-snippets
              # UI
              lualine-nvim
              gitsigns-nvim
              oil-nvim
              # Editing
              mini-ai
              vim-commentary
              vim-tmux-navigator
              # Database
              vim-dadbod
              vim-dadbod-ui
              vim-dadbod-completion
              # Format and Lint
              conform-nvim
              nvim-lint
              # Debug
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
              nvim-nio
              nvim-dap-python
              # LSP
              nvim-lspconfig
              SchemaStore-nvim
              lazydev-nvim
              # Filetype
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
              wrapRc = true;
              configDirName = "nix-nvim";
              aliases = [ "vim" ];
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
