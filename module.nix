inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:

{
  imports = [ wlib.wrapperModules.neovim ];

  # Expose spec enable states to Lua as settings.cats
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };

  config = {
    # Use neovim nightly from the overlay
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;

    settings = {
      config_directory = ./.;
      aliases = [
        "vi"
        "vim"
      ];
    };

    hosts = {
      python3.nvim-host.enable = true;
      node.nvim-host.enable = true;
    };

    info.nixdExtras.nixpkgs = "import ${pkgs.path} {}";

    # Add extraPackages field to all specs, collected into PATH
    specMods = _: {
      options.extraPackages = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
      };
    };

    extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

    # Core spec: always loaded at startup
    specs.core = {
      lazy = false;
      data = with pkgs.vimPlugins; [
        lze
        lzextras
        nvim-web-devicons
        plenary-nvim
        tokyonight-nvim
        gruber-darker-nvim
        solarized-osaka-nvim
      ];
    };
  };
}
