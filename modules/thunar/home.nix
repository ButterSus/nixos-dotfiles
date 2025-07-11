{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.thunar;

  # Core home configuration for this module
  moduleHomeConfig = {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };

in {
  # Module Options
  options.modules.thunar = {
    enable = mkEnableOption "Enable Thunar module";
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
    