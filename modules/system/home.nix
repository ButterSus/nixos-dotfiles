{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.system;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  options.modules.system = {
    enable = mkEnableOption "Enable base system configuration";
    
    stateVersion = mkOption {
      type = types.str;
      example = "24.11";
      description = "The NixOS state version for this deployment";
    };
    
    hostName = mkOption {
      type = types.str;
      description = "The hostname for this system";
    };
    
    timeZone = mkOption {
      type = types.str;
      example = "Europe/Moscow";
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
        example = true;
        description = "Whether to enable NetworkManager for network configuration";
      };
    };
    
    extraCliTools = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to install additional useful CLI tools like tree, ncdu.";
      };
    };

    boot = {
      loaderType = mkOption {
        type = types.enum [ "systemd-boot" "grub" ];
        default = "systemd-boot";
        description = "The boot loader to use (systemd-boot or grub)";
      };
      
      useOSProber = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable os-prober for GRUB to detect other operating systems";
      };
      
      useMineGrubWorldSelTheme = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use mine grub world sel theme";
      };
    };
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
