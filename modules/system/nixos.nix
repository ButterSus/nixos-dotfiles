{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.system;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      coreutils
      curl
      wget
    ] ++ (lib.optionals cfg.extraCliTools.enable [
      tree
      ncdu
    ]);

    users.users.${config.primaryUser} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ] ++ lib.optional cfg.networking.enableNetworkManager "networkmanager";
    };
    
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.networking.enableNetworkManager;
    };
    
    time.timeZone = cfg.timeZone;
    i18n.defaultLocale = cfg.locale;
    
    system.stateVersion = cfg.stateVersion;
    
    boot = {
      loader = if cfg.boot.loaderType == "systemd-boot" then {
        timeout = 3;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
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
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
