{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

# TODO: Fix lua5.1 and luarocks issues
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  # Get AstroNvim dotfiles from flake inputs
  nvimFiles = builtins.attrNames (builtins.readDir inputs.astronvim-dotfiles);
  nvimDotfiles = builtins.listToAttrs (map (name: {
    name = ".config/nvim/${name}";
    value = { source = "${inputs.astronvim-dotfiles}/${name}"; };
  }) nvimFiles);

  # Core home configuration for this module
  moduleHomeConfig = {
    # User Specific Packages
    home.packages = with pkgs; [
      lazygit
      ripgrep
      python3
      bottom
      lua
      gnumake
      clang
      fd
      git
      luarocks
    ];
    # Symlink all files from AstroNvim
    home.file = nvimDotfiles;
  };

in {
  options.modules.nvim = {
    enable = mkEnableOption "Enable Neovim configuration";

    enableXorgClipboard = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Xorg clipboard support for Neovim (xclip, xorg.xauth, xorgserver).";
    };
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
