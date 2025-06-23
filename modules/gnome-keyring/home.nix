{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.gnome-keyring;

  # Core home configuration for this module
  moduleHomeConfig = {
    services.gnome-keyring.enable = true;
    home.packages = [ pkgs.gcr ]; # Provides org.gnome.keyring.SystemPrompter
  };

in {
  # Module Options
  options.modules.gnome-keyring = {
    enable = mkEnableOption "Enable gnome-keyring module";
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
    