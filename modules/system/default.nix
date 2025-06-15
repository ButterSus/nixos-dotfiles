{ config, lib, pkgs, ... }:

{
  options.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "The primary user of the system (used for primary-user-specific settings).";
  };

  imports = [
    ./base.nix     # Base system configuration
    ./nix.nix      # Nix package manager configuration
    ./boot.nix     # Boot configuration
  ];
}
