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
      overskride
      
      # TUI
      bluetui
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
