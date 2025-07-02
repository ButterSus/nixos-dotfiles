{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.nvim;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System packages
    environment.systemPackages = with pkgs; [
      neovim
    ] ++ lib.optionals cfg.enableXorgClipboard [
      xclip
      xorg.xauth
      xorg.xorgserver
    ];

    programs.neovim.enable = true;

    # Some LSPs require runtime libraries
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      glibc
      gcc
      icu
    ];
  };
}
