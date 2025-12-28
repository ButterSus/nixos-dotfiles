{ config, lib, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      iverilog
      surfer
      keepassxc
      typst
      zathura
      libreoffice-qt
      tigervnc
      remmina
      openvpn
      photoqt
      gvfs
      udisks2
      polkit

      # Python with Jupyter and math packages
      (python3.withPackages (ps: with ps; [
        jupyter
        ipykernel
        ipympl
        numpy
        scipy
        matplotlib
        pandas
        sympy
        scikit-learn
        seaborn
        plotly
      ]))
    ];
  };
}
