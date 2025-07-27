{ pkgs, cfg, ... }:

let
  # Tip: Use this prompt to get hash:
  # $ nix-prefetch-url <url> |
  # xargs nix hash convert --hash-algo sha256

  hyprpaper-background = pkgs.fetchurl {
    url = cfg.backgrounds.hyprpaper.url;
    hash = cfg.backgrounds.hyprpaper.hash;
  };
  
  hyprlock-background = pkgs.fetchurl {
    url = cfg.backgrounds.hyprlock.url;
    hash = cfg.backgrounds.hyprlock.hash;
  };
  
in {
  # Better hyprland cursor
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  
  # Wallpaper manager
  services.hyprpaper = {
    enable = true;
    settings = {
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
    enable = true;
    settings = {
      background = [
        {
          path = builtins.toString hyprlock-background;
          blur_passes = 2;
          blur_size = 3;
        }
      ];
    };
  };
  catppuccin.hyprlock.enable = true;
}
