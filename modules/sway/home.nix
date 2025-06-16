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
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "modules.wayland.enable must be true if modules.sway.enable is true. Please enable the Wayland module.";
      }
    ];
    # For sway, moduleHomeConfig is empty. If it had content, it would be part of the structure below.
  } // (
    # This merges the actual home configuration based on context.
    # It's separate to ensure assertions are part of the primary mkIf cfg.enable block.
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
