#############################
# DELETE THIS COMMENT BLOCK #
#############################
# This file contains:       #
# - Options for the module  #
# - Import the config file  #
# - System packages         #
#############################

{ config, lib, pkgs, isNixOS, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.template;
in {
  options.modules.template = {
    enable = mkEnableOption "Enable template module";
    
    someOption = mkOption {
      type = types.bool;
      default = false;
      description = "Some option";
    };
  };
  
  imports = [
    ./config.nix
  ];

  config = mkIf cfg.enable && isNixOS {
    environment.systemPackages = with pkgs; [
      someNixOSPackage
    ];
  };
}
    