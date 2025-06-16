{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.wayland;

  # Core home configuration for this module (empty for now)
  moduleHomeConfig = {};

in {
  options.modules.wayland = {
    enable = mkEnableOption "Enable base Wayland configuration and dependencies";
    activeCompositor = mkOption {
      type = types.nullOr (types.enum [ "hyprland" "sway" ]); # Allow null or specific compositors
      default = null;
      description = "Specifies the primary active Wayland compositor (e.g., hyprland, sway). Set by compositor modules.";
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
