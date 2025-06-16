{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.hyprland;

  # Core home configuration for this module
  moduleHomeConfig = {
    xdg.configFile."hypr/hyprland.conf".text = ''
      # Default Hyprland configuration file
      
      monitor=,preferred,auto,1
      
      # Environment variables
      env = XCURSOR_SIZE,24
      
      # Input configuration
      input {
          kb_layout = us
          follow_mouse = 1
          touchpad {
              natural_scroll = true
          }
      }
      
      # Appearance
      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = rgba(33ccffee)
          col.inactive_border = rgba(595959aa)
          layout = dwindle
      }
      
      # Animations
      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }
      
      # Layouts
      dwindle {
          pseudotile = true
          preserve_split = true
      }
      
      master {
          new_is_master = true
      }
      
      # Window rules
      windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
      
      # Key bindings
      $mainMod = SUPER
      
      # Program bindings
      bind = $mainMod, Return, exec, kitty
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, nautilus
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, P, pseudo,
      bind = $mainMod, F, fullscreen
      
      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      
      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      
      # Move active window to workspace
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      
      # Mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';

    # If Waybar is enabled, configure it
    programs.waybar.enable = cfg.enableWaybar;
    
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

    enableWaybar = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install and configure Waybar";
    };
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
