# Template module - Implementation
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.template;
in {
  config = mkIf cfg.enable {
    # ===== System-level configuration =====
    
    # Add system packages if needed
    environment.systemPackages = with pkgs; [
      cfg.package
    ] ++ cfg.extraPackages;
    
    # Example service configuration
    services.someService = {
      enable = true;
      # Other service settings
    };
    
    # Example program configuration
    programs.someProgram = {
      enable = true;
      # Other program settings
    };
    
    # Example of conditional configuration
    systemd.services.conditionalService = lib.mkIf cfg.someBoolOption {
      description = "Example Conditional Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/some-binary";
        Restart = "on-failure";
      };
    };
    
    # ===== User-level (Home Manager) configuration =====
    
    # Primary user configuration through home-manager
    home-manager.users.${config.primaryUser} = { pkgs, ... }: {
      # Add user packages if needed
      home.packages = with pkgs; [
        # User-specific packages
      ];
      
      # Configure user programs
      programs.someProgram = {
        enable = true;
        settings = {
          # Use values from the module configuration
          setting1 = cfg.settings.nestedOption1;
          setting2 = cfg.settings.nestedOption2;
        };
      };
      
      # Create user config files
      xdg.configFile = {
        "someapp/config.json".text = ''
          {
            "setting": "${cfg.someStringOption}",
            "value": ${toString cfg.someIntOption}
          }
        '';
      };
    };
  };
}
