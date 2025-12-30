{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.xdg;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      xdg-user-dirs
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs;
        lib.mkForce [
          xdg-desktop-portal-hyprland

          # Needed to run Display Manager (+fallback)
          xdg-desktop-portal-gtk
        ];

      # TODO: Make it adapt depending on desktop environment
      # (for now it's hardcoded as hyprland)
      config.common = {
        default = [ "hyprland" "gtk" ];
      };
    };

    environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
  };
}
