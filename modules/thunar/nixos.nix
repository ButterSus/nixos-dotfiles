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

    # Support filesystems
    boot.supportedFilesystems = [ "ntfs" ];
    
    # Trash support
    services.gvfs.enable = true;
    
    # External drives
    services.udisks2.enable = true;
    services.devmon.enable = true;
  };
}
