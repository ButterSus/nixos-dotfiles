{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.git;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      delta
    ];
  };
}
