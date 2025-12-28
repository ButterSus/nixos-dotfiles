{ config, lib, pkgs, pkgs-recent, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.firefox;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Options
    programs.firefox = {
      enable = true;
      package = pkgs-recent.firefox;
    };

    xdg.mime.defaultApplications = {
      "application/pdf" = "firefox.desktop";
    };
  };
}
