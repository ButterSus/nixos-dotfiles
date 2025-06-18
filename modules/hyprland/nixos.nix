{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.hyprland;

in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = cfg.xwayland.enable;
    };
    
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
