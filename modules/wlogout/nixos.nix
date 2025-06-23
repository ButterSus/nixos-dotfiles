{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.wlogout;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      wlogout
    ];

    # https://discourse.nixos.org/t/svg-icons-not-shown/32173
    programs.gdk-pixbuf.modulePackages = with pkgs; [ librsvg ];
  };
}
