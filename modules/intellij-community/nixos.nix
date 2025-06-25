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

      # It seems jetbrains.plugins.addPlugins is currently unstable,
      # so we are not able to use it properly.
      # Recommended approach: Use builtin idea-community sync
      jetbrains.idea-community
    ];
  };
}
