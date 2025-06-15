# Hyprland module - Modern Wayland compositor
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./config.nix  # Implementation details
  ];

  options.modules.hyprland = {
    enable = mkEnableOption "Enable Hyprland Wayland compositor";
    
    package = mkOption {
      type = types.package;
      default = pkgs.hyprland;
      description = "The Hyprland package to use";
      example = "pkgs.hyprland";
    };
    
    xwayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support";
      };
    };
    
    nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA-specific configuration";
    };
    
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = "[ pkgs.waybar pkgs.rofi-wayland ]";
      description = "Additional packages to install with Hyprland";
    };
    
    enableWaybar = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install and configure Waybar";
    };
  };
}
