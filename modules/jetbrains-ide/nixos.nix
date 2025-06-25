{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.jetbrains-ide;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # ...
  };
}
