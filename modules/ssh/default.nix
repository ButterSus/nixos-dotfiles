# SSH module
{ config, lib, pkgs, username, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.ssh;
in {
  imports = [
    ./config.nix  # SSH configuration
  ];

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
  };
  
  config = mkIf cfg.enable {
    # Make sure OpenSSH is installed
    environment.systemPackages = with pkgs; [
      openssh
    ];
  };
}
