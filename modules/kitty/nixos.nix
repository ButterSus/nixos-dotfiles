{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.kitty;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      kitty
    ];

    xdg.mime.defaultApplications = {
      "application/x-terminal-emulator" = "kitty.desktop";
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };
}
