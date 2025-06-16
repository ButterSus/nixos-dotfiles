# /mnt/modules/fonts/nixos.nix
{
  config,
  lib,
  pkgs,
  ... # Any other specialArgs or inputs if needed
}:

with lib;

let
  cfg = config.modules.fonts;
in
{
  imports = [ ./home.nix ];
  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      jetbrains-mono
      pkgs.nerd-fonts.jetbrains-mono
    ];

    # You could add other font-related system settings here in the future,
    # e.g., fontconfig settings, if desired.
  };
}
