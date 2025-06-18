{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.home;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      lib.optionals cfg.enableCli [
        home-manager
      ];
  };
}
