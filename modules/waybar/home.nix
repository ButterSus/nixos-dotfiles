{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.waybar;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.waybar.enable = true;

    # Dynamically generate the config by replacing placeholders in the template
    xdg.configFile."waybar/config".text = 
      let
        template = builtins.readFile ./config/config;
        # Determine the correct workspaces module based on the active Wayland compositor
        workspacesModule = 
          if config.modules.wayland.activeCompositor == "hyprland" then "hyprland/workspaces"
          else if config.modules.wayland.activeCompositor == "sway" then "sway/workspaces"
          else "disabled/workspaces";
      in
        lib.replaceStrings [ "%WORKSPACES_MODULE%" ] [ workspacesModule ] template;

    # style.css can still be sourced directly if it doesn't need dynamic content
    xdg.configFile."waybar/style.css".source = ./config/style.css;
  };

in {
  options.modules.waybar = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "Please enable wayland.";
      }
    ];

    enable = mkEnableOption "Enable Waybar status bar";
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
