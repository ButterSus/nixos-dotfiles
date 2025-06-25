{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.sddm;

  # Core home configuration for this module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = cfg.enable -> !config.modules.tuigreet.enable;
        message = "Please disable tuigreet.";
      }
    ];
  };

in {
  # Module Options
  options.modules.sddm = {
    enable = mkEnableOption "Enable sddm module";
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
    