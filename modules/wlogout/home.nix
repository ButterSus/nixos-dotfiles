{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.wlogout;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.wlogout.enable = true;
    catppuccin.wlogout.enable = true;
  };

in {
  # Module Options
  options.modules.wlogout = {
    enable = mkEnableOption "Enable wlogout module";
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
    