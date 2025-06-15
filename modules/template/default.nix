# Template module - Description of what this module does
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./config.nix  # Implementation details
  ];

  options.modules.template = {
    enable = mkEnableOption "Enable template module";
    
    # Simple string option example
    someStringOption = mkOption {
      type = types.str;
      default = "";
      example = "example-value";
      description = "Description of this option";
    };
    
    # Boolean option example
    someBoolOption = mkOption {
      type = types.bool;
      default = false;
      description = "Description of this boolean option";
    };
    
    # Integer option example
    someIntOption = mkOption {
      type = types.int;
      default = 0;
      example = 42;
      description = "Description of this integer option";
    };
    
    # Path option example
    somePathOption = mkOption {
      type = types.path;
      default = "/default/path";
      example = "/example/path";
      description = "Description of this path option";
    };
    
    # Package option example
    package = mkOption {
      type = types.package;
      default = pkgs.examplePackage;
      description = "The package to use for this module";
    };
    
    # List option example
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = "[ pkgs.example1 pkgs.example2 ]";
      description = "Additional packages to install";
    };
    
    # Submodule option example
    settings = mkOption {
      type = types.submodule {
        options = {
          nestedOption1 = mkOption {
            type = types.bool;
            default = true;
            description = "A nested boolean option";
          };
          
          nestedOption2 = mkOption {
            type = types.str;
            default = "default-value";
            description = "A nested string option";
          };
        };
      };
      default = {};
      description = "Nested settings for this module";
    };
    
    # Enum option example
    choiceOption = mkOption {
      type = types.enum [ "option1" "option2" "option3" ];
      default = "option1";
      description = "Select from predefined choices";
    };
  };
}
