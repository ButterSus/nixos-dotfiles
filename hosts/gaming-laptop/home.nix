# home.nix
#
# This is the PRIMARY configuration file that contains ALL settings required
# for Home Manager to run in standalone mode. This file can be used independently
# with home-manager or imported into a NixOS configuration.

{ config, pkgs, lib, ... }:

{
  primaryUser = "buttersus";

  # Home Manager configuration
  modules.home = {
    enable = true;
    enableCli = true;
    stateVersion = "24.11";
  };

  # System configuration
  modules.fonts = { enable = true; };
  modules.system = {
    enable = true;
    hostName = "unixporn";
    timeZone = "Europe/Moscow";
    locale = "en_US.UTF-8";
    stateVersion = "24.11";
    extraCliTools.enable = true;

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
  
  # Enable the git module
  modules.git = {
    enable = true;
    userName = "Krivoshapkin Eduard";
    userEmail = "buttersus@mail.ru";
  };
  
  # Enable the Neovim module
  modules.nvim = {
    enable = true;   
    enableXorgClipboard = true;
  };

  # Enable base Wayland utilities
  modules.wayland.enable = true;

  # Enable Hyprland Wayland compositor
  modules.hyprland = {
    enable = true;
    nvidia = false; # Set to true if you have an NVIDIA GPU
    extraPackages = with pkgs; [
      # Media and screenshots
      grimblast
      swappy
      
      # System utilities
      networkmanagerapplet
      
      # Theming
      bibata-cursors
      gtk3
    ];
  };
  
  # Enable Waybar status bar
  modules.waybar.enable = true;

  # Enable firefox
  modules.firefox = {
    enable = true;
  };
}
