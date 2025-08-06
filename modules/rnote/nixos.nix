{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.rnote;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      (symlinkJoin {
        inherit (rnote) pname version meta;
        name = "${rnote.name}-wrapped";
        nativeBuildInputs = [ makeWrapper ];
        paths = [ rnote ];

        # Isolate Rnote from gtk-theme (~/.config)

        # Do not use $HOME here, since this is ran in isolated environment
        postBuild = ''
          wrapProgram $out/bin/rnote \
            --run 'mkdir -p /home/${config.primaryUser}/.config/rnote-env/dconf' \
            --run 'ln -fs /home/${config.primaryUser}/.config/dconf/user /home/${config.primaryUser}/.config/rnote-env/dconf/user' \
            --set XDG_CONFIG_HOME "/home/${config.primaryUser}/.config/rnote-env"
        '';
      })
    ];
  };
}
