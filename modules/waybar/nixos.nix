{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.waybar;
in
{
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      waybar
    ];
  };
}
