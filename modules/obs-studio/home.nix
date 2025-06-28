{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.obs-studio;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.obs-studio = {
      enable = true;
      
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
      ] ++ lib.optionals config.modules.wayland.enable [
        wlrobs
      ];
    };
  };

in {
  # Module Options
  options.modules.obs-studio = {
    enable = mkEnableOption "Enable OBS Studio module";
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
    