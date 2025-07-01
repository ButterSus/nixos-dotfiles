{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.amnezia-vpn;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.amnezia-vpn.enable = true;
  };
}
