{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # Modules are imported in flake.nix
  ];

  primaryUser = "buttersus";
  
  #############
  ## Modules ##
  #############

  # Enable the base system module
  modules.system = {
    enable = true;
    hostName = "unixporn";
    timeZone = "Europe/Moscow";
    locale = "en_US.UTF-8";
    stateVersion = "24.11";
    userInformation = [
      { username = config.primaryUser; stateVersion = "24.11"; enableHomeManager = true; }
    ];
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
    enableX11Forwarding = true;
    allowPasswordAuth = {
      local = true;    # Allow password auth for local connections
      remote = false;  # Disable password auth for remote connections
    };
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
