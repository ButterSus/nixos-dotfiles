{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.amnezia-vpn;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.amnezia-vpn = {
      package = pkgs-recent.amnezia-vpn;
      enable = true;
    };
  };
}
