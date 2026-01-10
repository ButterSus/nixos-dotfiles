# We want newest version for more recent AI features.
{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.vscode;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      cfg.package

      # For AI plugins
      nodejs
    ];
  };
}
