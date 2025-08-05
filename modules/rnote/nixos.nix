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
        postBuild = ''
          wrapProgram $out/bin/rnote --set XDG_CONFIG_HOME "$HOME/.config/rnote"
        '';
      })
    ];
  };
}
