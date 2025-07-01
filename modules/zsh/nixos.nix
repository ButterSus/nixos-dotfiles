{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.zsh;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    programs.zsh.enable = true;

    # Set as the default shell for all users
    users.defaultUserShell = pkgs.zsh;
  };
}
