{ config, lib, pkgs, inputs, hostname, username, ... }:

{
  imports = [
    ./base.nix     # Base system configuration
    ./nix.nix      # Nix package manager configuration
    ./boot.nix     # Boot configuration
  ];
}
