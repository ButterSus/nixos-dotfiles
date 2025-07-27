{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types recursiveUpdate;
  cfg = config.modules.hyprland;
  
  inherit (inputs) hyprland Hyprspace;
  
  mainMod = "SUPER";

  moduleHomeConfig = recursiveUpdate {
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

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = cfg.xwayland.enable;
      systemd = {
        enable = true;
        # Fix systemd services
        variables = [ "--all" ];
      };
      settings = import ./config/settings.nix { inherit lib config cfg; } //
                 import ./config/windowrules.nix //
                 import ./config/keybinds.nix { inherit lib config cfg mainMod; };
      plugins = [
        Hyprspace.packages.${pkgs.system}.Hyprspace
      ];
    };
  } (import ./config/services.nix { inherit pkgs cfg; });

in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable Hyprland Wayland compositor";

    xwayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support";
      };
    };
    
    layouts = mkOption {
      type = types.listOf types.str;
      default = [ "us" ];
      description = "List of keyboard layouts";
    };
    
    backgrounds = {
      hyprpaper = mkOption {
        type = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              example = "https://wallpaperswide.com/download/just_chillin-wallpaper-1920x1080.jpg";
              description = "URL for the hyprpaper background image";
            };
            
            hash = mkOption {
              type = types.str;
              example = "sha256-quI/tSunJFmBpCEfHnWj6egfQN5rpOq/BSggDxb3mtc=";
              description = "SHA256 hash of the hyprpaper background image";
            };
          };
        };
        default = {};
        description = "Configuration for hyprpaper background";
      };
      
      hyprlock = mkOption {
        type = types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              example = "https://wallpaperswide.com/download/spongebob_house_patrick-wallpaper-1920x1080.jpg";
              description = "URL for the hyprlock background image";
            };
            
            hash = mkOption {
              type = types.str;
              example = "sha256-E5mnXfyIiNW3QtWS9Hb1lhYDvTuDU5Edw965yoOTDZ8=";
              description = "SHA256 hash of the hyprlock background image";
            };
          };
        };
        default = {};
        description = "Configuration for hyprlock background";
      };
    };
  };

  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
