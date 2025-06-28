{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.fuzzel;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          horizontal-pad = 4;
          vertical-pad = 4;
        };
        
        border = {
          radius = 0;
          width = 2;
        };
      };
    };

    catppuccin.fuzzel.enable = true;
  };

in {
  # Module Options
  options.modules.fuzzel = {
    enable = mkEnableOption "Enable fuzzel module";
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
    