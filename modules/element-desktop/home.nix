{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.element-desktop;
  
  # Core home configuration for this module
  moduleHomeConfig = {
    programs.element-desktop = {
      settings = {
        features = {
          feature_custom_themes = true;
        };
      };
    };

    catppuccin.element-desktop.enable = true;
  };

in {
  # Module Options
  options.modules.element-desktop = {
    enable = mkEnableOption "Enable Element desktop module";
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
    
