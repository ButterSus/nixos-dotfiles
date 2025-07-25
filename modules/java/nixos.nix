{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.java;

in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs;
      lib.attrValues cfg.packages
      ++ lib.optionals cfg.enableGradle [
        gradle
      ];
  };
}
