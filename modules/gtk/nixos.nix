{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.gtk;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      # Colour scheme
      pkgs-recent.magnetic-catppuccin-gtk
      
      # Icon theme
      papirus-icon-theme
      
      # Settings editor
      nwg-look
    ];

    # This service stores few application preferences
    programs.dconf.enable = true;
  };
}
