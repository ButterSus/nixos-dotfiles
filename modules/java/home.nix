{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.java;
  
  # Helper function to create JDK symlinks
  createJdkLinks = packages: 
    lib.listToAttrs (map (pkg: {
      name = ".jdks/${pkg.name}";
      value = { source = pkg; };
    }) packages);

  # Core home configuration for this module
  moduleHomeConfig = {
    home.file = createJdkLinks cfg.packages;
  };

in {
  # Module Options
  options.modules.java = {
    enable = mkEnableOption "Enable java module";
    
    packages = mkOption {
      description = ''
        Java packages to install. Example:
        ```
          modules.java.packages = with pkgs; [ openjdk11 openjdk17 openjdk21 ];
        ```
      '';
      default = [];
      type = types.listOf types.package;
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
    