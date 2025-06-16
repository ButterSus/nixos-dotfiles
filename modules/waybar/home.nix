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
          else if config.modules.wayland.activeCompositor == "sway" then "sway/workspaces" # For when a sway module is added
          else "disabled/workspaces"; # Fallback if no known compositor is active or if it's not set.
                                   # Consider an assertion here if Waybar requires a specific compositor.
      in
        lib.replaceStrings [ "%WORKSPACES_MODULE%" ] [ workspacesModule ] template;

    # style.css can still be sourced directly if it doesn't need dynamic content
    xdg.configFile."waybar/style.css".source = ./config/style.css;
  };

in {
  options.modules.waybar = {
    enable = mkEnableOption "Enable Waybar status bar";
    # Add more options here later, e.g., for different styles or modules
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (lib.mkMerge [
    # First attribute set: assertions
    {
      assertions = [
        {
          assertion = cfg.enable -> config.modules.wayland.enable;
          message = "modules.wayland.enable must be true if modules.waybar.enable is true. Please enable the Wayland module.";
        }
        # We could also add an assertion here to check if either sway or hyprland is enabled, e.g.:
        # {
        #   assertion = cfg.enable -> (config.modules.sway.enable || config.modules.hyprland.enable);
        #   message = "Either sway or hyprland must be enabled to use waybar.";
        # }
      ];
    }
    # Second attribute set: conditional home configuration
    (if isHMStandaloneContext then
      # For standalone Home Manager, apply moduleHomeConfig at the top level of this module's config
      moduleHomeConfig
    else
      # For NixOS integration, apply moduleHomeConfig under home-manager.users.primaryUser
      # Ensure primaryUser is correctly available in this module's scope (e.g., from specialArgs)
      { home-manager.users.${config.primaryUser} = moduleHomeConfig; }
    )
  ]);
}
