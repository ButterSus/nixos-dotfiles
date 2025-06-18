{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.fonts;

  # Core home configuration for this module
  moduleHomeConfig = {};

in
{
  options.modules.fonts = {
    enable = mkEnableOption "Enable user-specific font configurations (primarily for consistency with NixOS module)";
  };

  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
