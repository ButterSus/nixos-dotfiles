{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption;
  cfg = config.modules.waybar;
in
{
  imports = [ ./home.nix ];
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.waybar ];
    # Add other NixOS specific configurations for Waybar here if needed in the future
    # NixOS specific configurations for Waybar would go here.
    # For Waybar, most configuration is done via Home Manager, so this might remain empty.
  };
}
