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

      Host beget
        Hostname 85.198.85.154
        Port 22
        User root
        IdentityFile ~/.ssh/beget.com.id_rsa

      Host racknerd
        Hostname 23.94.209.181
        Port 3067
        User root
        IdentityFile ~/.ssh/racknerd.com.id_ed25519
    ";

    home.packages = [
      phpWithMbstring

      # Create an executable for the h-m-m script
      (pkgs.writeScriptBin "h-m-m" ''
        #!/usr/bin/env bash
        ${phpWithMbstring}/bin/php "${phpScript}" "$@"
      '')
    ];
  };

  # Fetch the GitHub repository containing h-m-m
  phpRepo = pkgs.fetchgit {
    url = "https://github.com/nadrad/h-m-m.git";
    rev = "f9ce96b719def746e7299d897ce43c9633b42c90";  # Commit hash
    sha256 = "sha256-2+oXGYpaCqQG6+yh3/pMwQxIC39M7XTDRIEqWboVo0c=";  # Checksum
  };

  # Path to the h-m-m PHP script
  phpScript = "${phpRepo}/h-m-m";

  # PHP with mbstring extension
  phpWithMbstring = pkgs.php.withExtensions ({ all, ... }: with all; [ mbstring ]);

in {
  # Conditionally apply the configuration
  config = if isHMStandaloneContext then moduleHomeConfig else {
    home-manager.users.${config.primaryUser} = moduleHomeConfig;
  };
}
    
