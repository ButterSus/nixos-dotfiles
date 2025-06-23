{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.amnezia-vpn;

  # Core home configuration for this module
  moduleHomeConfig = {
    sops = lib.optionalAttrs config.modules.sops.enable {
      secrets.amnezia_vpn_key = {
        mode = "0400";
      };
    };
  };

in {
  # Module Options
  options.modules.amnezia-vpn = {
    enable = mkEnableOption "Enable Amnezia VPN module";
  };
  
  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
    