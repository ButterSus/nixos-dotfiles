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
      jetbrains.idea-community-bin  # Source will take forever to build, use binary please!
    ];
  };
}
