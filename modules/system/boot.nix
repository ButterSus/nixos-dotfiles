# Boot configuration module
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.system;
in {
  options.modules.system.boot = {
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
  };
  
  config = mkIf cfg.enable {
    # Configure bootloader based on chosen type
    boot = {
      # Loader-specific configuration
      loader = if cfg.boot.loaderType == "systemd-boot" then {
        timeout = 3;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false; # Disable editing kernel params for security
        };
        efi.canTouchEfiVariables = true;
      } else {
        timeout = 3;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = cfg.boot.useOSProber;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
