{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;

  # Core home configuration for user module
  moduleHomeConfig = {
    catppuccin.zathura.enable = true;

    programs.ssh.extraConfig = "
      Host miet
        Hostname 82.179.188.226
        Port 23
        User buttersus
        IdentityFile ~/.ssh/borisblade.ru.id_rsa
    ";
  };

in {
  # Conditionally apply the configuration
  config = if isHMStandaloneContext then moduleHomeConfig else {
    home-manager.users.${config.primaryUser} = moduleHomeConfig;
  };
}
    
