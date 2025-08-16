{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;

  # Core home configuration for user module
  moduleHomeConfig = {};

in {
  # Conditionally apply the configuration
  config = if isHMStandaloneContext then moduleHomeConfig else {
    home-manager.users.${config.primaryUser} = moduleHomeConfig;
  };
}
    
