{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.gtk;

  # Core home configuration for this module
  moduleHomeConfig = {
    # Enable cursor theme for gtk
    home.pointerCursor = {
      gtk.enable = true;
    };

    # Enable gtk
    gtk.enable = true;
    
    # Gtk is deprecated for catppuccin
    # catppuccin.gtk.enable = true;
  };

in {
  # Module Options
  options.modules.gtk = {
    enable = mkEnableOption "Enable gtk module";
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
    