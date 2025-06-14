# Nix package manager configuration
{ config, lib, pkgs, ... }:

let 
  inherit (lib) mkIf mkDefault;
  cfg = config.modules.system;
in {
  config = mkIf cfg.enable {
    # Enable flakes and nix-command
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
    # Optimize store automatically
    nix.settings.auto-optimise-store = true;
    
    # Configure garbage collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
