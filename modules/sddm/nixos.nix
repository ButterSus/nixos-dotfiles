# Theme: https://github.com/Keyitdev/sddm-astronaut-theme
{ config, lib, pkgs, inputs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.sddm;

  inherit (inputs) sddm-astronaut-theme;
  
  sddm-astronaut-theme-pkg = pkgs.stdenv.mkDerivation {
    name = "sddm-astronaut-theme";
    src = sddm-astronaut-theme;
    
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
      cp -r * $out/share/sddm/themes/sddm-astronaut-theme/
      
      # Set jake_the_dog as the theme
      sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/jake_the_dog.conf|' \
        $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
    '';
  };
  
  astronaut-fonts = pkgs.stdenv.mkDerivation {
    name = "sddm-astronaut-fonts";
    src = sddm-astronaut-theme;
    installPhase = ''
      mkdir -p $out/share/fonts
      cp -r Fonts/* $out/share/fonts/
    '';
  };
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    fonts.packages = [ astronaut-fonts ];

    environment.systemPackages = with pkgs; [
      sddm-astronaut-theme-pkg
    ];

    # Enable X11
    services.xserver.enable = true;

    # Set keyboard layout
    services.xserver.xkb = {
      layout = "us,ru";
      options = "grp:win_space_toggle, caps:escape";
    };

    services.displayManager.sddm = {
      enable = true;

      # Update sddm to use qt6
      package = pkgs.kdePackages.sddm;

      extraPackages = with pkgs; [
        # Theme-specific dependencies
        qt6.qtmultimedia
        qt6.qtvirtualkeyboard
        qt6.qtsvg
      ];
      
      # Set theme
      theme = "sddm-astronaut-theme";
      settings = {
        General = {
          InputMethod = "qtvirtualkeyboard";
          MinimumVT = 7;  # Unfortunately, it's ignored since sddm v0.20
        };
      };
      
      # Wayland is not supported, I tested it and it doesn't work
      wayland.enable = false;
    };
  };
}