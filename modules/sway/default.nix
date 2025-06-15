# Minimal Sway (Wayland compositor) module for NixOS
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Minimal Sway (Wayland compositor) configuration";
    # Future: add options for extraPackages, enableGnomeKeyring, etc.
  };

  config = mkIf cfg.enable {
    # Install sway and recommended utilities for a functional session
    environment.systemPackages = with pkgs; [
      sway wl-clipboard mako
    ];
    # Enable seatd for input device management (required by sway)
    services.seatd.enable = true;
    # Enable dbus for session management
    services.dbus.enable = true;
    # Enable gnome-keyring for secrets management
    services.gnome.gnome-keyring.enable = true;
    # Set environment variable for Wayland
    environment.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
    };
    # Enable Sway via programs.sway, with GTK wrapper features
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
}
