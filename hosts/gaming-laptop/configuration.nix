# configuration.nix
#
# This file EXTENDS home.nix to enable NixOS system configuration.
# It imports home.nix to ensure all Home Manager settings are included,
# then adds system-specific modules and configuration that wouldn't
# be compatible with standalone Home Manager.
#
# This separation allows you to use the same user configuration (home.nix)
# across multiple systems, including non-NixOS systems via standalone Home Manager.

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
    # Modules are imported in flake.nix
  ];

  # System configuration
  modules.system = {
    enable = true;
    hostName = "unixporn";
    timeZone = "Europe/Moscow";
    locale = "en_US.UTF-8";
    stateVersion = "24.11";

    # Boot configuration
    boot = {
      loaderType = "grub";
      useOSProber = true;
    };

    # Network configuration
    networking = {
      enableNetworkManager = true;
    };
  };
  
  # Enable the SSH module with local password authentication
  modules.ssh = {
    enable = true;
    port = 22; # Standard SSH port
    permitRootLogin = "no";
    enableX11Forwarding = true;
    allowPasswordAuth = {
      local = true;    # Allow password auth for local connections
      remote = false;  # Disable password auth for remote connections
    };
  };
  
  # Enable the TUI Greet module
  modules.tuigreet = {
    enable = true;
    # Include both Sway and Hyprland session directories
    sessions = [
      "${pkgs.hyprland}/share/wayland-sessions"
    ];
    settings = {
      showTime = true;
      rememberLastSession = true;
      rememberUser = true;
      # Let the user choose between Sway and Hyprland
      extraArgs = [];
    };
  };
}
