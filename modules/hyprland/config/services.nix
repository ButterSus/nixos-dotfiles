{ lib, pkgs, cfg, ... }:

let
  # Tip: Use this prompt to get hash:
  # $ nix-prefetch-url <url> |
  # xargs nix hash convert --hash-algo sha256

  hyprpaperEnabled = cfg.backgrounds.hyprpaper ? url && cfg.backgrounds.hyprpaper ? hash;
  hyprlockEnabled = cfg.backgrounds.hyprlock ? url && cfg.backgrounds.hyprlock ? hash;
  
  hyprpaper-background = if hyprpaperEnabled then pkgs.fetchurl {
    url = cfg.backgrounds.hyprpaper.url;
    hash = cfg.backgrounds.hyprpaper.hash;
  } else null;
  
  hyprlock-background = if hyprlockEnabled then pkgs.fetchurl {
    url = cfg.backgrounds.hyprlock.url;
    hash = cfg.backgrounds.hyprlock.hash;
  } else null;
  
in {
  # Better hyprland cursor
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = cfg.cursor-size;
  };
  
  # Wallpaper manager
  services.hyprpaper = {
    enable = hyprpaperEnabled;
    settings = lib.optionalAttrs hyprpaperEnabled {
      splash = false;
      ipc = true; # Enable IPC for dynamic wallpaper changes if needed
      preload = [
        (builtins.toString hyprpaper-background)
      ];
      wallpaper = [
        ",${builtins.toString hyprpaper-background}"
      ];
    };
  };
  
  # Policy kit
  services.hyprpolkitagent.enable = true;

  # This cursor in my opinion is worse than bibata-cursors
  # catppuccin.cursors.enable = true;
  
  # Lock screen 
  programs.hyprlock = {
    enable = hyprlockEnabled;
    settings = lib.optionalAttrs hyprlockEnabled {
      background = [
        {
          path = builtins.toString hyprlock-background;
          blur_passes = 2;
          blur_size = 3;
        }
      ];
    };
  };

  catppuccin.hyprlock.enable = hyprlockEnabled;
}
