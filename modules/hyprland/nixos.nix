{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.hyprland;

in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      hyprpicker    # Color picker
      wl-clipboard  # Clipboard
      hyprpaper     # Wallpaper manager
    ];

    services.seatd.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = cfg.xwayland.enable;
    };
    
    programs.hyprlock.enable = true;

    # Idle daemon
    services.hypridle = {
      enable = true;
    };
  };
}
