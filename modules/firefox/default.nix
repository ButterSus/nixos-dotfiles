# Firefox module
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.firefox;
in {
  imports = [
    ./config.nix  # Firefox configuration
  ];

  options.modules.firefox = {
    enable = mkEnableOption "Enable Firefox with configuration";
    # Add more options here as needed
  };
  
  config = mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}
