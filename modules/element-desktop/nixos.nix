{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.element-desktop;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      (symlinkJoin {
        inherit (element-desktop) pname version meta;
        name = "${element-desktop.name}-wrapped";
        nativeBuildInputs = [ makeWrapper ];
        paths = [ element-desktop ];

        # Fix gnome keyring:
        # https://github.com/NixOS/nixpkgs/issues/415765
        postBuild = ''
          wrapProgram $out/bin/element-desktop \
            --add-flags '--password-store=gnome-libsecret'
        '';
      })
    ];
  };
}
