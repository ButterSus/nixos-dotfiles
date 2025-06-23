{ pkgs, ... }:

let
  # Tip: Use this prompt to get hash:
  # $ nix-prefetch-url <url> |
  # xargs nix hash convert --hash-algo sha256

  hyprpaper-background = pkgs.fetchurl {
    url = "https://wallpaperswide.com/download/just_chillin-wallpaper-1920x1080.jpg";
    hash = "sha256-quI/tSunJFmBpCEfHnWj6egfQN5rpOq/BSggDxb3mtc=";
  };
  
  hyprlock-background = pkgs.fetchurl {
    url = "https://wallpaperswide.com/download/spongebob_house_patrick-wallpaper-1920x1080.jpg";
    hash = "sha256-E5mnXfyIiNW3QtWS9Hb1lhYDvTuDU5Edw965yoOTDZ8=";
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
