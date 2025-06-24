{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.intellij-community;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  # Module Options
  options.modules.intellij-community = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.java.enable;
        message = "Intellij Community IDE module requires Java module to be enabled";
      }
    ];

    enable = mkEnableOption "Enable Intellij Community IDE module";
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
    