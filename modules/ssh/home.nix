{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.ssh;

  # Core home configuration for this module (empty for ssh)
  moduleHomeConfig = {
    programs.ssh = {
      enable = true;
      addKeysToAgent = if config.modules.gnome-keyring.enable then "no" else "yes";
    };

    services.ssh-agent.enable = !config.modules.gnome-keyring.enable;
  };

in {
  options.modules.ssh = {
    enable = mkEnableOption "Enable SSH server configuration";
    
    port = mkOption {
      type = types.port;
      default = 22;
      description = "The port the SSH daemon should listen on";
    };
    
    permitRootLogin = mkOption {
      type = types.enum [ "yes" "no" "without-password" "prohibit-password" ];
      default = "no";
      description = "Whether to allow root to login using SSH";
    };
    
    allowPasswordAuth = {
      local = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to allow password authentication for local connections";
      };
      
      remote = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to allow password authentication for remote connections";
      };
    };

    enableX11Forwarding = mkOption {
      type = types.bool;
      default = false;
      description = "Enable X11 forwarding for SSH sessions (sets X11Forwarding in sshd config).";
    };
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
