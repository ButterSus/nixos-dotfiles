{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.kden-live;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  # Module Options
  options.modules.kden-live = {
    enable = mkEnableOption "Enable KDEnLive module";
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
    