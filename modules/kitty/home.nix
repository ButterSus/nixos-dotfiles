{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.kitty;

  # Core home configuration for this module
  moduleHomeConfig = {
    home.sessionVariables = {
      TERMINAL = "kitty";
    };

    programs.kitty = {
      enable = true;
      font = {
        size = 14;
        name = "JetBrainsMono Nerd Font";
      };
      settings = {
        placement_strategy = "top-left";
      };
    };

    catppuccin.kitty.enable = true;

    xdg.mimeApps.defaultApplications = {
      "application/x-terminal-emulator" = "kitty.desktop";
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };

in {
  # Module Options
  options.modules.kitty = {
    enable = mkEnableOption "Enable kitty module";
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
    