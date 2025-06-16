{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.wayland;
in
{
  imports = [ ./home.nix ];
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # Ensure not more than one primary compositor is enabled.
        # This relies on hyprland and (future) sway modules defining their enable options under config.modules.*
        assertion = let
          hyprlandEnabled = config.modules.hyprland.enable or false;
          # Check for sway module existence before trying to access its 'enable' option
          swayEnabled = (config.modules ? "sway") && (config.modules.sway.enable or false);
        in lib.count lib.id [ hyprlandEnabled swayEnabled ] <= 1;
        message = "Multiple Wayland compositors (e.g., Hyprland, Sway) are enabled in your configuration. Please choose only one.";
      }
      # Optional: Assertion to ensure activeCompositor is set if waybar (or other dependent module) is enabled.
      # {
      #   assertion = !(config.modules.waybar.enable && config.modules.wayland.activeCompositor == null);
      #   message = "Waybar is enabled, but no active Wayland compositor (hyprland or sway) is set in modules.wayland.activeCompositor.";
      # }
    ];

    # NixOS specific configurations for Wayland would go here.
    # This might include ensuring certain base packages are available system-wide if needed,
    # though often Wayland compositors or applications pull in their own dependencies.
    # Example: environment.systemPackages = [ pkgs.some-wayland-utility ];
  };
}
