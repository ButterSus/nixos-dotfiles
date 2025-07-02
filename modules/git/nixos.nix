{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.git;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      git
      delta
    ] ++ lib.optionals cfg.enableGithubCli [
      gh
    ];
  };
}
