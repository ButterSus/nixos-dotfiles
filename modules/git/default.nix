# Git module
{ config, lib, pkgs, username, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.git;
in {
  imports = [
    ./config.nix  # Git configuration
  ];

  options.modules.git = {
    enable = mkEnableOption "Enable Git with configuration";
    
    userName = mkOption {
      type = types.str;
      default = "Krivoshapkin Eduard";
      description = "Git user name";
    };
    
    userEmail = mkOption {
      type = types.str;
      default = "buttersus@mail.ru";
      description = "Git user email";
    };
  };
  
  config = mkIf cfg.enable {
    # Install Git and dependencies system-wide
    environment.systemPackages = with pkgs; [
      git
      delta  # Required for the custom config (used as pager)
    ];
  };
}
