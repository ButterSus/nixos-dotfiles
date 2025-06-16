{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.home;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # Make home-manager installed CLI tool available if enabled
    environment.systemPackages = lib.optional cfg.enableCli pkgs.home-manager;
  };
}
