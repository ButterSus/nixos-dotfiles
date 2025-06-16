{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.template;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      someNixOSPackage
    ];
    
    # System Options
    services.someService = {
      enable = true;
      someOption = cfg.someOption;
    };
  };
}
