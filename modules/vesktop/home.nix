{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.vesktop;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.vesktop = {
      enable = true;
      # Catppuccin colors
      settings = {
        arRPC = true;
        splashBackground = "#181825";
        splashColor = "#cdd6f4";
      };
    };
  };

in {
  # Module Options
  options.modules.vesktop = {
    enable = mkEnableOption "Enable Vesktop module";
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
    