{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.fonts;
in
{
  # Import home.nix
  imports = [ ./home.nix ];

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
  };
}
