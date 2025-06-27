{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;

  fliteLibPath = pkgs.lib.makeLibraryPath [ pkgs.flite ];
  ideaDevShell = pkgs.writeShellApplication {
    name = "idea-env";
    runtimeInputs = with pkgs; [ flite ];
    text = ''
      #!/usr/bin/env bash
      export LD_LIBRARY_PATH="${fliteLibPath}:${"$"}{LD_LIBRARY_PATH:-}"
      exec idea-community "$@"
    '';
  };

  # Core home configuration for user module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = config.modules.intellij-community.enable;
        message = "Please enable Intellij Community module";
      }
    ];
    
    home.packages = [ ideaDevShell ];

    xdg.desktopEntries.idea-nix = {
      name = "Intellij IDEA CE (Nix)";
      comment = "Intellij IDEA Community Edition in Nix Shell Environment";
      exec = "${ideaDevShell}/bin/idea-env";
      icon = "idea-community";
      terminal = false;
      type = "Application";
      categories = [ "Development" "IDE" ];
    };
  };

in {
  # Conditionally apply the configuration
  config = if isHMStandaloneContext then moduleHomeConfig else {
    home-manager.users.${config.primaryUser} = moduleHomeConfig;
  };
}
    