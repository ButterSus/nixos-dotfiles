{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.intellij-community;

  # Core home configuration for this module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.jetbrains-ide.enable;
        message = "Please enable JetBrains IDE module";
      }
      {
        assertion = cfg.enable -> config.modules.java.enable;
        message = "Intellij Community IDE module requires Java module to be enabled";
      }
    ];
  };

in {
  # Module Options
  options.modules.intellij-community = {
    enable = mkEnableOption "Enable Intellij Community IDE module";
    
    extraPlugins = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra plugins to add to the IDE";
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
    