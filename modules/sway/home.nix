{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.sway;

  # Core home configuration for this module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "Please enable wayland.";
      }
      {
        assertion = cfg.enable -> config.modules.wayland.activeCompositor == "sway";
        message = "Please set wayland.activeCompositor to 'sway'.";
      }
    ];
  };

in {
  options.modules.sway = {
    enable = mkEnableOption "Minimal Sway (Wayland compositor) configuration";
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
