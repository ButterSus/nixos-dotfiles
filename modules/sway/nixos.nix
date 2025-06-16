{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.sway;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sway
      wl-clipboard
      mako
    ];

    services.seatd.enable = true;
    services.dbus.enable = true;
    services.gnome.gnome-keyring.enable = true;
    environment.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
    };
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
}
