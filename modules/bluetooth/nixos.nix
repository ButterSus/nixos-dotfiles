{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.bluetooth;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      # GUI

      # (Overskride causes some trouble with NixOS, I've replaced it)
      kdePackages.bluedevil
      
      # TUI
      bluetui
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
