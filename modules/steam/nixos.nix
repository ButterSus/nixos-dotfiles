{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.steam;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      amdgpu.amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };
  };
}
