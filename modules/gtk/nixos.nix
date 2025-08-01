{ config, lib, pkgs, ... }:

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
      magnetic-catppuccin-gtk
      
      # Icon theme
      papirus-icon-theme
      
      # Settings editor
      nwg-look
    ];
  };
}
