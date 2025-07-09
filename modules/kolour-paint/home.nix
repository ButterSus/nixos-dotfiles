{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.kolour-paint;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  # Module Options
  options.modules.kolour-paint = {
    enable = mkEnableOption "Enable Kolour Paint module";
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
    
