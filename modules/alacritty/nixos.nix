{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.alacritty;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      alacritty
    ];

    xdg.mime.defaultApplications = {
      "application/x-terminal-emulator" = "alacritty.desktop";
      "x-scheme-handler/terminal" = "alacritty.desktop";
    };
  };
}
