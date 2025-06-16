{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  # Fetch AstroNvim dotfiles
  astroNvim = builtins.fetchGit {
    url = "https://github.com/ButterSus/astronvim-dotfiles.git";
    rev = "bf36a1664dfb05555901eb8351f8d4c9f1cb64ec";
  };
  nvimFiles = builtins.attrNames (builtins.readDir astroNvim);
  nvimDotfiles = builtins.listToAttrs (map (name: {
    name = ".config/nvim/${name}";
    value = { source = "${astroNvim}/${name}"; };
  }) nvimFiles);

  # Core home configuration for this module
  moduleHomeConfig = {
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
