{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;

  # Core home configuration for user module
  moduleHomeConfig = {
    catppuccin.zathura.enable = true;
  };

in {
  # Conditionally apply the configuration
  config = if isHMStandaloneContext then moduleHomeConfig else {
    home-manager.users.${config.primaryUser} = moduleHomeConfig;
  };
}
    
