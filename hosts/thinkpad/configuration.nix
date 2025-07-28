# configuration.nix
#
# This is the PRIMARY configuration file that contains
# all module settings. This file can't contain any code
# besides module options. 

{ config, pkgs, lib, ... }:

{
  primaryUser = "buttersus";

  ########################
  # SYSTEM CONFIGURATION #
  ########################

  # Basic system settings
  modules.system = {
    enable = true;
    hostName = "unixporn";
    timeZone = "Asia/Yakutsk";
    locale = "en_US.UTF-8";
    stateVersion = "24.11";
    extraCliTools.enable = true;

    # Boot configuration
    boot = {
      loaderType = "grub";
      useOSProber = true;
      useMineGrubWorldSelTheme = true;
    };

    # Network configuration
    networking = {
      enableNetworkManager = true;
    };
  };
  
  # Security & System Services
  modules.gnome-keyring.enable = true;
  modules.sops.enable = true;  # Enable secrets decryption
  modules.ssh = {
    enable = true;
    port = 22;
    permitRootLogin = "no";
    enableX11Forwarding = true;
    allowPasswordAuth = {
      local = false;   # Disable password auth for local connections
      remote = false;  # Disable password auth for remote connections
    };
  };
 
  # Audio & Bluetooth
  modules.pipewire.enable = true;
  modules.bluetooth.enable = true;
 
  ######################
  # HOME CONFIGURATION #
  ######################
  
  # Home Manager configuration
  modules.home = {
    enable = true;
    enableCli = true;
    stateVersion = "24.11";
  };
  
  # Development tools
  modules.git = {
    enable = true;
    userName = "Krivoshapkin Eduard";
    userEmail = "buttersus@mail.ru";
    enableGithubCli = true;
  };
  modules.nvim.enable = true;
  modules.vim.enable = true;
  
  ####################
  # DESKTOP & THEMES #
  ####################
  
  # Theme configuration
  catppuccin = {
    flavor = "mocha";
    accent = "mauve";
  };
  
  # # Font configuration
  modules.fonts = { enable = true; };
  
  # Display Manager
  modules.sddm.enable = true;
  # Commented out TUI greeter alternative
  # modules.tuigreet = {
  #   enable = true;
  #   settings = {
  #     showTime = true;
  #     rememberLastSession = true;
  #     rememberUser = true;
  #     extraArgs = [];
  #   };
  # };
  
  # Desktop Environment & Compositor
  modules.wayland = {
    enable = true;
    activeCompositor = "hyprland";
    enableWaypipe = true;
  };
  modules.hyprland = {
    enable = true;
    xwayland.enable = true;
    layouts = [ "us" "ru" ];
    backgrounds = {
      hyprpaper = {
        url = "https://wallpaperswide.com/download/just_chillin-wallpaper-2560x1440.jpg";
        hash = "sha256-ATpKJqN8PL/krB/bXPrsZM4cqjSmeFyJMs5surTdbQI=";
      };
      hyprlock = {
        url = "https://wallpaperswide.com/download/spongebob_house_patrick-wallpaper-2560x1440.jpg";
        hash = "sha256-p5Pr+w2XowwtLIwG+OW3UrnROlMHokj7DymO32K1d7o=";
      };
    };
  };
  modules.xdg.enable = true;
  
  # # Desktop UI Components
  modules.wlogout.enable = true;  # Wayland logout menu
  modules.fuzzel.enable = true;   # App launcher
  modules.waybar.enable = true;   # Status bar
  modules.cliphist.enable = true; # Clipboad Manager
  modules.thunar.enable = true;   # File manager
  modules.vlc.enable = true;      # Media Player
  
  # # Theme Integration
  modules.gtk.enable = true;      # GTK theming
  modules.qt.enable = true;       # Qt5/Qt6 theming
  
  ################
  # APPLICATIONS #
  ################
  
  # Internet & Communication
  modules.firefox = {
    enable = true;
  };
# modules.zapret.enable = false;
  modules.amnezia-vpn.enable = true;
# modules.vesktop.enable = true;       # Discord with Vencord
# modules.materialgram.enable = true;  # Telegram client
# modules.whatsie.enable = true;       # WhatsApp client
  modules.youtube-music.enable = true; # Music? Yes, please!
# modules.qbittorrent.enable = true;   # Torrent client
# modules.gparted.enable = true;
# 
# # Terminal
  modules.zsh = {
    enable = true;
#   extraPlugins = [ "gradle" "bazel" ];
  };
  modules.kitty.enable = true;  
#
  # Development & Gaming
# modules.windsurf.enable = true;
# modules.jetbrains-ide.enable = true;
  modules.zola.enable = true;
# modules.intellij-community = {
#   enable = true;
#   extraPlugins = [
#     "minecraft-development"
#   ];
# };
# modules.steam.enable = true;
# modules.kolour-paint.enable = true;
# modules.prism-launcher.enable = true;
# 
# # Minecraft Modding
# modules.java = {
#   enable = true;
#   packages = {
#     inherit (pkgs) jdk17 jdk21;
#   };
#   enableGradle = true;
# };
# 
# # Video Editing
# modules.obs-studio.enable = true;
# modules.kden-live.enable = true;
}
