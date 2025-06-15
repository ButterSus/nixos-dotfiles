# Base system configuration module with core system settings
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.system;
in {
  options.modules.system = {
    enableHomeManagerCli = mkEnableOption "Install the Home Manager CLI tool (home-manager) system-wide";
    enable = mkEnableOption "Enable base system configuration";

    userInformation = mkOption {
      type = types.listOf (types.submodule {
        options = {
          username = mkOption {
            type = types.str;
            description = "The username to create and configure.";
          };
          stateVersion = mkOption {
            type = types.str;
            default = "24.11";
            description = "Home Manager state version for the user.";
          };
          enableHomeManager = mkOption {
            type = types.bool;
            default = true;
            description = "Enable Home Manager for this user.";
          };
        };
      });
      description = "List of user information records for user and Home Manager setup.";
    };
    
    stateVersion = mkOption {
      type = types.str;
      default = "24.11";
      description = "The NixOS state version for this deployment";
    };
    
    hostName = mkOption {
      type = types.str;
      description = "The hostname for this system";
    };
    
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Moscow";
      description = "System timezone";
    };
    
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };
    
    networking = {
      enableNetworkManager = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable NetworkManager for network configuration";
      };
    };
  };
  
  config = mkIf cfg.enable {
    users.users = lib.mkMerge (
      map (user: {
        "${user.username}" = {
          isNormalUser = true;
          extraGroups = [ "wheel" ] ++ lib.optional cfg.networking.enableNetworkManager "networkmanager";
        };
      }) cfg.userInformation
    );

    home-manager.backupFileExtension = "hm-bak";

    home-manager.users = lib.mkMerge (
      map (user: lib.mkIf user.enableHomeManager {
        "${user.username}" = {
          home.username = user.username;
          home.homeDirectory = "/home/${user.username}";
          home.stateVersion = user.stateVersion or cfg.stateVersion;
          programs.home-manager.enable = true;
        };
      }) cfg.userInformation
    );
    # Set basic system configuration
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.networking.enableNetworkManager;
    };
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.locale;
    
    # Don't change this value on a running system
    system.stateVersion = cfg.stateVersion;
    
    # Basic system packages that should be available on any system
    environment.systemPackages = with pkgs; [
      # Basic utilities
      coreutils
      curl
      wget
    ] ++ lib.optional cfg.enableHomeManagerCli pkgs.home-manager;
    
    # Enable OpenSSH by default for remote management
    services.openssh.enable = true;
  };
}
