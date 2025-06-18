{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.wayland;
in
{
  # Import home.nix
  imports = [ ./home.nix ];
  
  config = mkIf cfg.enable {};
}
