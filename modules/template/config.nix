#############################
# DELETE THIS COMMENT BLOCK #
#############################
# This file contains:       #
# - Home Manager packages   #
# - Home Manager options    #
# - NixOS options           #
#############################

{ config, lib, pkgs, isNixOS, ... }:

let
  inherit (lib) mkIf recursiveUpdate;
  cfg = config.modules.template;
in {
  config = recursiveUpdate mkIf cfg.enable {
    home-manager.users.${config.primaryUser} = {
      home.packages = with pkgs; [
        someNixOSPackage
      ];
    };
  } mkIf cfg.enable && isNixOS {
    services.someService.someOption = true;
  };
}
    