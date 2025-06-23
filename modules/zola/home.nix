{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.zola;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  # Module Options
  options.modules.zola = {
    enable = mkEnableOption "Enable Zola documentation engine module";
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
    