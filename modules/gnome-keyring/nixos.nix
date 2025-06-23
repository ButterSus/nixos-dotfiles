{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.gnome-keyring;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
  };
}
