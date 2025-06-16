# home.nix
#
# This is the PRIMARY configuration file that contains ALL settings required
# for Home Manager to run in standalone mode. This file can be used independently
# with home-manager or imported into a NixOS configuration.
#
# It includes:
# - primaryUser definition (required by both Home Manager and NixOS)
# - Home Manager module configuration
# - All user-specific modules compatible with Home Manager

{ config, pkgs, lib, ... }:

{
  primaryUser = "buttersus";

  # Home Manager configuration
  modules.home = {
    enable = true;
    enableCli = true;
    stateVersion = "24.11";
  };
  
  ######################
  ## Home-compatible ##
  ######################
  
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

  # Enable Hyprland Wayland compositor
  modules.hyprland = {
    enable = true;
    nvidia = false; # Set to true if you have an NVIDIA GPU
    enableWaybar = true;
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
  
  # Enable firefox
  modules.firefox = {
    enable = true;
  };
}
