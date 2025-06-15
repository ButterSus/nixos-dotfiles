# TUI Greet module - Graphical login screen using greetd and tuigreet
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./config.nix  # Implementation details
  ];
  
  options.modules.tuigreet = {
    enable = mkEnableOption "Enable TUI Greet for login";
    
    sessions = mkOption {
      type = types.listOf types.path;
      default = [];
      example = [ "${pkgs.hyprland}/share/wayland-sessions" ];
      description = "Paths to session directories to be used by tuigreet";
    };
    
    settings = mkOption {
      type = types.submodule {
        options = {
          showTime = mkOption {
            type = types.bool;
            default = true;
            description = "Show time in tuigreet";
          };
          
          rememberLastSession = mkOption {
            type = types.bool;
            default = true;
            description = "Remember last session in tuigreet";
          };
          
          rememberUser = mkOption {
            type = types.bool;
            default = true;
            description = "Remember last user in tuigreet";
          };
          
          extraArgs = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Extra arguments to pass to tuigreet";
          };
        };
      };
      default = {};
      description = "Settings for tuigreet";
    };
  };
}
