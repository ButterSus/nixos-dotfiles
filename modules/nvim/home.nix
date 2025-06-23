{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

# TODO: Fix lua5.1 and luarocks issues
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  inherit (inputs) astronvim-dotfiles;

  # Get AstroNvim dotfiles from flake inputs
  nvimFileNames = builtins.attrNames (builtins.readDir astronvim-dotfiles);
  nvimFileConfigs = builtins.listToAttrs (map (name: {
    name = ".config/nvim/${name}";
    value = { source = "${astronvim-dotfiles}/${name}"; };
  }) nvimFileNames);

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # Runtime dependencies
        gnumake
        ripgrep
        fzf  # Just in case, though not used in my config
        clang  # Is better than gcc imho
        luajit  # Faster than lua5_1
        (python3.withPackages (ps: with ps; [ pip ]))
        bottom
        unzip
        git
        fd
        luarocks
        
        # Tools (optional)
        lazygit
        
        # Language servers
        stylua
        nixd
        deadnix
        statix
      ];
    };

    # Symlink all files from AstroNvim
    home.file = nvimFileConfigs;
    
    # For conditional nix-specific fragment of NeoVim config
    home.sessionVariables = {
      "NIX_NEOVIM" = 1;
    };
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
