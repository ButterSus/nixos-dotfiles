{ config, lib, pkgs, isHMStandaloneContext, ... }:

# TODO: Automatically set catppuccin theme
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.materialgram;

  # Core home configuration for this module
  moduleHomeConfig = {};

in {
  # Module Options
  options.modules.materialgram = {
    enable = mkEnableOption "Enable MaterialGram module";
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
    