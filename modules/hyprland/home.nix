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
  } (import ./config/services.nix { inherit pkgs; });

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
