{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.java;
  
  # Helper function to create JDK symlinks from attribute set
  createJdkLinks = packages: 
    lib.mapAttrs' (name: pkg: {
      name = ".jdks/${name}";
      value = { source = pkg; };
    }) packages;

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
        Java packages to install as an attribute set where the key becomes the symlink name.
        Example:
        ```
          modules.java.packages = with pkgs; {
            jdk11 = openjdk11;
            jdk17 = openjdk17;
            jdk21 = openjdk21;
            graalvm = graalvm-ce;
          };
        ```
      '';
      default = {};
      
      # We use attrsOf types.package to allow
      # using variable names as keys
      type = types.attrsOf types.package;
    };

    enableGradle = mkEnableOption "Enable gradle build tool";
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

