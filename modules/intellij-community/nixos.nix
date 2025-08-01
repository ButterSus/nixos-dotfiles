{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.intellij-community;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      # Patched plugins can be found here: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json

      # This way of adding plugins can easily break.
      # If it breaks, please install plugins via jetbrains sync
      # and replace the whole content below with just idea-community
      (jetbrains.plugins.addPlugins jetbrains.idea-community-bin ([
        "ideavim"
        "catppuccin-theme"
        "catppuccin-icons"
      ] ++ cfg.extraPlugins))
    ];
  };
}
