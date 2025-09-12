{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.materialgram;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      pkgs-recent.materialgram
    ];
  };
}
