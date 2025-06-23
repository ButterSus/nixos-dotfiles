{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.kitty;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.kitty.enable = true;
    catppuccin.kitty.enable = true;
  };

in {
  # Module Options
  options.modules.kitty = {
    enable = mkEnableOption "Enable kitty module";
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
    