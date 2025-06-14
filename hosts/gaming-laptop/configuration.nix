{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable the base system module
  modules.system = {
    enable = true;
    hostName = "gaming-laptop";
    timeZone = "Europe/Moscow";
    locale = "en_US.UTF-8";
    stateVersion = "24.11";
    
    # Boot configuration
    boot = {
      loaderType = "grub";
      useOSProber = true;
    };
  };
  
  # Enable the git module
  modules.git = {
    enable = true;
    userName = "Krivoshapkin Eduard";
    userEmail = "buttersus@mail.ru";
  };

  # User configuration
  users.users.buttersus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Home Manager configuration - kept minimal
  home-manager.users.buttersus = {
    # Home Manager needs a bit of information about the user
    home.username = "buttersus";
    home.homeDirectory = "/home/buttersus";
    home.stateVersion = "24.11";
    
    # Let Home Manager manage itself
    programs.home-manager.enable = true;
  };
}
