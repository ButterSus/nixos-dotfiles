{ config, lib, pkgs, ... }:

{
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = {
    services.flatpak.enable = true;

    networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

    environment.systemPackages = with pkgs; [
      iverilog
      surfer
      jupyter
      python3
      python3Packages.numpy
      python3Packages.scipy
      python3Packages.matplotlib
      python3Packages.pandas
      python3Packages.sympy
      python3Packages.ipykernel
      keepassxc
      typst
      zathura
      libreoffice-qt
    ];

    # When pressing power key located on the right side,
    # it will hibernate on short press instead of shutting down.
    services.logind.powerKey = "hibernate";
  };
}
