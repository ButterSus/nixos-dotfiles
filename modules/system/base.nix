# Base system configuration module with core system settings
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.system;
in {
  options.modules.system = {
    enable = mkEnableOption "Enable base system configuration";
    
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
  };
  
  config = mkIf cfg.enable {
    # Set basic system configuration
    networking.hostName = cfg.hostName;
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
    ];
    
    # Enable OpenSSH by default for remote management
    services.openssh.enable = true;
  };
}
