{ config, lib, pkgs, isHMStandaloneContext, ... }:

# TODO: Remake this module, add hyprpaper
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.hyprland;
  
  mainMod = "SUPER";

  # Core home configuration for this module
  moduleHomeConfig = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = cfg.xwayland.enable;
      systemd = {
        enable = true;
        # Fix systemd services
        variables = [ "--all" ];
      };
    };
    
    # Main configuration
    wayland.windowManager.hyprland.settings = {
      monitor = [ "preferred,auto,1" ];
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
        
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        col.active_border = "rgba(33ccffee)";
        col.inactive_border = "rgba(595959aa)";
        layout = "dwindle";
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
        
      dwingle = {
        pseudotile = true;
        preserve_split = true;
      };
        
      master = {
        new_is_master = true;
      };

      windowrulev2 = [
        "opacity 0.8 0.8,class:^(kitty)$"
      ];

      bind = [
        "${mainMod}, Return, exec, kitty"
        "${mainMod}, Q, killactive"
        "${mainMod}, M, exit"
        "${mainMod}, E, exec, nautilus"
        "${mainMod}, V, togglefloating"
        "${mainMod}, R, exec, wofi --show drun"
        "${mainMod}, P, pseudo"
        "${mainMod}, F, fullscreen"

        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"
          
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"

        "${mainMod}, 1, movetoworkspace, 1"
        "${mainMod}, 2, movetoworkspace, 2"
        "${mainMod}, 3, movetoworkspace, 3"
        "${mainMod}, 4, movetoworkspace, 4"
        "${mainMod}, 5, movetoworkspace, 5"
        "${mainMod}, 6, movetoworkspace, 6"
        "${mainMod}, 7, movetoworkspace, 7"
        "${mainMod}, 8, movetoworkspace, 8"
        "${mainMod}, 9, movetoworkspace, 9"
        "${mainMod}, 0, movetoworkspace, 10"
          
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];
      
      exec-once = lib.optionals config.modules.waybar.enable [
        "waybar"
      ];
    };

    # TODO: Move packages to modules
    # User Specific Packages
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
    
    # Better hyprland cursor
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    # TODO: Move this to gtk module
    gtk = {
      enable = true;
      
      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      font = {
        name = "Sans";
        size = 11;
      };
    };
  };

in {
  options.modules.hyprland = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "Please enable wayland.";
      }
      {
        assertion = cfg.enable -> config.modules.wayland.activeCompositor == "hyprland";
        message = "Please set wayland.activeCompositor to 'hyprland'.";
      }
    ];

    enable = mkEnableOption "Enable Hyprland Wayland compositor";

    xwayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support";
      };
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
