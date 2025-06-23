{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.vesktop;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
    ];
  };
}
