{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

# TODO: Fix lua5.1 and luarocks issues
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;

  inherit (inputs) astronvim-dotfiles;

  # Core home configuration for this module
  moduleHomeConfig = { lib, ... }: {
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

    # Smart nvim config activation:
    # - If nvim config doesn't exist, copy from flake
    # - If nvim config exists, skip
    # Therefore, config is fully mutable
    home.activation.nvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d /home/${config.primaryUser}/.config/nvim ]; then
        echo "No nvim config found, copying from flake..."
        mkdir -p /home/${config.primaryUser}/.config/nvim
        cp -r ${astronvim-dotfiles}/* /home/${config.primaryUser}/.config/nvim/
        chmod -R u+w /home/${config.primaryUser}/.config/nvim
      else
        echo "Nvim config already exists, skipping..."
      fi
    '';
    
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
