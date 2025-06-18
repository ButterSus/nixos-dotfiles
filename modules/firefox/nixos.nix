{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.firefox;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Options
    programs.firefox.enable = true;
  };
}
