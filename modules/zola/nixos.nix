{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.zola;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      zola
    ];
  };
}
