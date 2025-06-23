{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.qt;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      libsForQt5.qt5ct
      kdePackages.qt6ct
      
      # Darkly style
      darkly-qt5
      darkly
    ];

    # See home.nix for more details why
    qt.enable = lib.mkForce false;
  };
}
