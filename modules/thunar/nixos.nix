{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.thunar;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      xfce.thunar
      
      # Extensions
      xfce.thunar-volman
      xfce.thunar-archive-plugin
    ];
    
    # Trash support
    services.gvfs.enable = true;
  };
}
