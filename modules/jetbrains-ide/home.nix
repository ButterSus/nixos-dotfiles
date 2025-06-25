{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.jetbrains-ide;

  # Core home configuration for this module
  moduleHomeConfig = {
    home.file.".ideavimrc".source = ./config/.ideavimrc;
  };

in {
  # Module Options
  options.modules.jetbrains-ide = {
    enable = mkEnableOption "Enable JetBrains IDE module";
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
    