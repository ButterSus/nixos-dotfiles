{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.sway;

  # Core home configuration for this module (empty for sway)
  moduleHomeConfig = {};

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
