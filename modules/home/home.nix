{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.home;

  # Core home configuration for this module
  moduleHomeConfig = {
    home.username = config.primaryUser;
    home.homeDirectory = "/home/${config.primaryUser}";
    home.stateVersion = cfg.stateVersion;
    programs.home-manager.enable = true;
  };

in {
  # Keep primary user option here so it's compatible with standalone Home Manager
  options.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "The primary user of the system (used for primary-user-specific settings).";
  };

  options.modules.home = {
    enable = mkEnableOption "Enable Home Manager configuration";

    stateVersion = mkOption {
      type = types.str;
      default = "24.11";
      description = "The Home Manager state version for this deployment";
    };

    enableCli = mkEnableOption "Install the Home Manager CLI tool (home-manager)";
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
