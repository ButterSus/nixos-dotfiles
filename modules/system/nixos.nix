{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.system;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
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
    
    catppuccin.grub.enable = !cfg.boot.useMineGrubWorldSelTheme;

    boot = {
      loader = if cfg.boot.loaderType == "systemd-boot" then {
        timeout = 3;
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
      } else if cfg.boot.loaderType == "grub" then {
        timeout = 3;
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = cfg.boot.useOSProber;
          minegrub-world-sel = lib.optionalAttrs cfg.boot.useMineGrubWorldSelTheme {
            enable = true;
            customIcons = [
              {
                name = "nixos";
                lineTop = "For enjoyers.";
                lineBottom = "Creative Mode, Cheats, Version: unstable";
                imgName = "nixos";
              }
              {
                name = "arch";
                lineTop = "For chads.";
                lineBottom = "Hardcore mode, No cheats, Version: rolling";
                imgName = "arch";
              }
              {
                name = "ubuntu";
                lineTop = "It just works.";
                lineBottom = "Average mode, No cheats, Version: old";
                imgName = "ubuntu";
              }
              {
                name = "windows";
                lineTop = "Brr-brr patapim.";
                lineBottom = "Weak mode, No cheats, Version: updates";
                imgName = "windows";
              }
              {
                name = "manjaro";
                lineTop = "Use Arch Linux instead.";
                lineBottom = "Weak mode, No cheats, Version: stable";
                imgName = "manjaro";
              }
            ];
          };
        };
        efi.canTouchEfiVariables = true;
      } else builtins.throw "Normally, this error should never occur";
    };
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Prevent closed lid from suspending
    services.logind.lidSwitchExternalPower = "ignore";
    
    # Write installed packages to file for debug
    environment.etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
        formatted;
  };
}
