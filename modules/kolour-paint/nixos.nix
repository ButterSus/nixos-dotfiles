{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.kolour-paint;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      kdePackages.kolourpaint
    ];
  };
}
