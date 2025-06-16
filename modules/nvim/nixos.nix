{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.nvim;
in {
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim
    ] ++ lib.optionals cfg.enableXorgClipboard [
      xclip
      xorg.xauth
      xorg.xorgserver
    ];

    programs.neovim.enable = true;
  };
}
