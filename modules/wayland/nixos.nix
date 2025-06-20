{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.wayland;
in
{
  # Import home.nix
  imports = [ ./home.nix ];
  
  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs;
      lib.optionals cfg.enableWaypipe [
        waypipe
      ];
    
    # Fix electron apps
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # You're like going to need these (though they are enabled by compositor usually)
    services.seatd.enable = true;
    services.dbus.enable = true;
  };
}
