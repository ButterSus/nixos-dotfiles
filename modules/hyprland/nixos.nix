{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.hyprland;
  
  inherit (inputs) hyprland;

in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      hyprpicker       # Color picker
      wl-clipboard     # Clipboard
      hyprpaper        # Wallpaper manager
      hyprpolkitagent  # Policy Kit
      brightnessctl    # Backlight control
      hyprshot         # Screenshot tool
      swappy           # Image editing tool
    ];

    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
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
