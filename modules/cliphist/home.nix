{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.cliphist;

  # Core home configuration for this module
  moduleHomeConfig = {
    services.cliphist = {
      enable = true;
      allowImages = false;
    };
  };

in {
  # Module Options
  options.modules.cliphist = {
    enable = mkEnableOption "Enable Cliphist module";
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
    