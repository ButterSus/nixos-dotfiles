{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable the base system module
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
  
  # Enable the git module
  modules.git = {
    enable = true;
    userName = "Krivoshapkin Eduard";
    userEmail = "buttersus@mail.ru";
  };
  
  # Enable the SSH module with local password authentication
  modules.ssh = {
    enable = true;
    port = 22; # Standard SSH port
    permitRootLogin = "no";
    allowPasswordAuth = {
      local = true;    # Allow password auth for local connections
      remote = false;  # Disable password auth for remote connections
    };
  };

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
