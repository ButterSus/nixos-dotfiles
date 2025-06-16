{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.template;

  # Core home configuration for this module
  moduleHomeConfig = {
    # User Specific Packages
    home.packages = with pkgs; [
      someUserPackage # Placeholder for user-specific packages
    ];

    # Home Manager Options for this module
    programs.someProgram = {
      enable = true;
      someOption = cfg.someOption;
    };
  };

in {
  # Module Options
  options.modules.template = {
    enable = mkEnableOption "Enable template module";
    
    someOption = mkOption {
      type = types.bool;
      default = false;
      description = "Some option";
    };
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
    