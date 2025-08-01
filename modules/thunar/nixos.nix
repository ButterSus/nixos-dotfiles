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
    environment.systemPackages = with pkgs; [
      kdePackages.ark
    ];

    programs.xfconf.enable = true;
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    
    # Set Thunar as default file manager
    xdg.mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };

    # Support filesystems
    boot.supportedFilesystems = [ "ntfs" ];
    
    # Mount, trash, and other functionalities
    services.gvfs.enable = true;

    # Thumnail support for images
    services.tumbler.enable = true;
    
    # External drives
    services.udisks2.enable = true;
    services.devmon.enable = true;
  };
}
