{ config, lib, pkgs, ... }:

{
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = {
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      iverilog
      surfer
    ];

    # When pressing power key located on the right side,
    # it will hibernate on short press instead of shutting down.
    services.logind.powerKey = "hibernate";
  };
}
