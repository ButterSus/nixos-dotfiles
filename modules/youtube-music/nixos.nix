# We want newest versions to support builtin adblocker.
{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.youtube-music;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      pkgs-recent.pear-desktop
      
      # MPRIS shortcuts
      playerctl
    ];
  };
}
