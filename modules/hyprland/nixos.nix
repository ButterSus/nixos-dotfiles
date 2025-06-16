{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.hyprland;

  # Build list of packages based on configuration
  hyprlandPackages = [
    cfg.package
  ] ++ cfg.extraPackages
    ++ lib.optional cfg.enableWaybar pkgs.waybar;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = hyprlandPackages;

    # Enable Hyprland in NixOS
    programs.hyprland = {
      enable = true;
      package = cfg.package;
      xwayland.enable = cfg.xwayland.enable;
    };
    
    # Required Hyprland environment variables
    environment.sessionVariables = {
      # Wayland-specific
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      
      # Toolkit backend variables
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      
      # XDG paths
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      
      # For NVIDIA GPUs if enabled
    } // lib.optionalAttrs cfg.nvidia {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
