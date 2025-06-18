{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.wayland;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  options.modules.wayland = {
    enable = mkEnableOption "Enable base Wayland configuration and dependencies";
    
    # This options helps to ensure that only one compositor is enabled
    activeCompositor = mkOption {
      type = types.string;
      default = "";
      description = "Specify the active Wayland compositor (e.g., hyprland, sway)";
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
