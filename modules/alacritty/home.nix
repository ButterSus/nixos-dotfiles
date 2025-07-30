{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.alacritty;

  # Core home configuration for this module
  moduleHomeConfig = {
    home.sessionVariables = {
      TERMINAL = "alacritty";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 14;
          normal.family = "JetBrainsMono Nerd Font";
        };
      };
    };

    catppuccin.alacritty.enable = true;

    xdg.mimeApps.defaultApplications = {
      "application/x-terminal-emulator" = "alacritty.desktop";
      "x-scheme-handler/terminal" = "alacritty.desktop";
    };
  };

in {
  # Module Options
  options.modules.alacritty = {
    enable = mkEnableOption "Enable alacritty module";
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
    
