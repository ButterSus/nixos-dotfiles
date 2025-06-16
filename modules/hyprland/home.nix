{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.hyprland;

  # Core home configuration for this module
  moduleHomeConfig = {
    # Link the main hyprland.conf from our module's config directory
    xdg.configFile."hypr/hyprland.conf".source = ./config/hyprland.conf;

    # Conditionally link the waybar autostart snippet
    # This ensures ~/.config/hypr/conf.d/waybar.conf is created only if Waybar is enabled
    # and Hyprland will then source it due to the line in hyprland.conf
    xdg.configFile."hypr/conf.d/waybar.conf" = lib.mkIf config.modules.waybar.enable {
      source = ./config/conf.d/waybar.conf;
    };

    # Make sure required packages are available to the user
    home.packages = with pkgs; [
      # Terminal
      kitty
      
      # Application launcher
      wofi
      
      # File manager
      xfce.thunar
      
      # Screenshot utilities
      grim
      slurp
      
      # Clipboard
      wl-clipboard
    ];
  };

in {
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
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (lib.mkMerge [
    # 1. Assertions
    {
      assertions = [
        {
          assertion = cfg.enable -> config.modules.wayland.enable;
          message = "modules.wayland.enable must be true if modules.hyprland.enable is true. Please enable the Wayland module.";
        }
      ];
    }
    # 2. Set activeCompositor
    {
      modules.wayland.activeCompositor = "hyprland";
    }
    # 3. Apply moduleHomeConfig (conditionally for standalone vs NixOS)
    (if isHMStandaloneContext then
      # For standalone Home Manager, apply moduleHomeConfig at the top level of this module's config
      moduleHomeConfig
    else
      # For NixOS integration, apply moduleHomeConfig under home-manager.users.primaryUser
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
    )
  ]);
}
