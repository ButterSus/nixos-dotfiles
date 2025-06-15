# Neovim (lazy.nvim) module
{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.nvim;
in {
  options.modules.nvim = {
    enable = mkEnableOption "Enable Neovim configuration";
    enableXorgClipboard = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Xorg clipboard support for Neovim (xclip, xorg.xauth, xorgserver).";
    };
  };

  config = mkIf cfg.enable (
    let
      xorgClipboardPkgs = [ pkgs.xclip pkgs.xorg.xauth pkgs.xorg.xorgserver ];
    in
    {
      # Home Manager user config for Neovim and dotfiles
      home-manager.users.${config.primaryUser} = import ./config.nix {
        inherit config lib pkgs;
        inherit (config.modules.nvim) enableXorgClipboard;
      };
      environment.systemPackages = mkIf cfg.enableXorgClipboard xorgClipboardPkgs;
    }
  );
}
