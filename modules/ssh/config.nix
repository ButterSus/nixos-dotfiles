# SSH configuration module - implementation
{ config, lib, pkgs, username, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.ssh;
in {
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PermitRootLogin = cfg.permitRootLogin;
        # Global SSH security settings
        X11Forwarding = false;
        AllowAgentForwarding = true;
        TCPKeepAlive = true;
        Compression = true;
      };

      # Enable OpenSSH extra options
      extraConfig = ''
        Match Address 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.0/8,::1/128,fe80::/10,fd00::/8
          PasswordAuthentication ${if cfg.allowPasswordAuth.local then "yes" else "no"}
        Match Address *
          PasswordAuthentication ${if cfg.allowPasswordAuth.remote then "yes" else "no"}
      '';

      openFirewall = true;
    };
  };
}
