{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.firefox;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}
