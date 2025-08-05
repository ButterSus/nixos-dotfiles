{ lib, config, cfg, mainMod, ... }:

{
  # Repetetive keybinds
  binde = [
    # Volume and Brightness
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

    # Resize window
    "${mainMod} ALT, h, resizeactive, -10 0"
    "${mainMod} ALT, l, resizeactive,  10 0"
    "${mainMod} ALT, k, resizeactive, 0  10"
    "${mainMod} ALT, j, resizeactive, 0 -10"
  ];

  # Keybinds
  bind = [
    # Volume and Brightness
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    # Applications
  ] 
  ++ lib.optional config.modules.kitty.enable 
    "${mainMod}, Q, exec, kitty"
  ++ lib.optional config.modules.alacritty.enable 
    "${mainMod}, Q, exec, alacritty"
  ++ lib.optional config.modules.firefox.enable 
    "${mainMod}, B, exec, firefox"
  ++ lib.optional config.modules.fuzzel.enable 
    "${mainMod}, D, exec, fuzzel"
  ++ lib.optional config.modules.thunar.enable 
    "${mainMod}, E, exec, thunar"
  ++ lib.optional config.modules.materialgram.enable 
    "${mainMod}, T, exec, materialgram"
  ++ lib.optional config.modules.wlogout.enable 
    "${mainMod}, Z, exec, wlogout"
  ++ lib.optional config.modules.cliphist.enable 
    "${mainMod}, W, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
  ++ lib.optional config.modules.youtube-music.enable 
    "${mainMod}, Y, exec, youtube-music"
  
  ++ lib.optional config.modules.qbittorrent.enable 
    "${mainMod} SHIFT, Q, exec, qbittorrent"
  ++ lib.optional config.modules.amnezia-vpn.enable 
    "${mainMod} SHIFT, A, exec, AmneziaVPN"
  ++ lib.optional config.modules.vesktop.enable 
    "${mainMod} SHIFT, D, exec, vesktop"
  ++ lib.optional config.modules.bluetooth.enable 
    "${mainMod} SHIFT, B, exec, bluedevil-wizard"
  ++ lib.optional config.modules.whatsie.enable 
    "${mainMod} SHIFT, W, exec, whatsie"
  ++ lib.optional config.modules.pipewire.enable 
    "${mainMod} SHIFT, P, exec, pwvucontrol"
  ++ lib.optional config.modules.youtube-music.enable 
    "${mainMod} SHIFT, Y, exec, youtube-music"
  ++ lib.optional config.modules.steam.enable 
    "${mainMod} SHIFT, S, exec, steam"
  ++ lib.optional config.modules.nvim.enable 
    "${mainMod} SHIFT, N, exec, neovide"
  ++ lib.optional config.modules.kden-live.enable 
    "${mainMod} SHIFT, K, exec, kdenlive"
  ++ lib.optional config.modules.rnote.enable 
    "${mainMod} SHIFT, R, exec, rnote"
  ++ lib.optionals config.modules.youtube-music.enable [
    # MPRIS: Youtube Music shortcuts
    "${mainMod} CTRL, M     , exec, playerctl --player=YoutubeMusic play-pause"
    "${mainMod} CTRL, comma , exec, playerctl --player=YoutubeMusic previous"
    "${mainMod} CTRL, period, exec, playerctl --player=YoutubeMusic next"
  ]
  ++ [
    # Window Actions
    "${mainMod}      , P, pseudo"
    "${mainMod}      , V, togglefloating"
    "${mainMod}      , F, fullscreen, 1"
    "${mainMod} SHIFT, F, fullscreen, 2"
    "${mainMod}      , C, killactive"
    "${mainMod} SHIFT, C, forcekillactive"
    "${mainMod}      , N, togglesplit"
    
  ]
  ++ lib.optional config.modules.waybar.enable
    # Hyprland Other Actions
    "${mainMod}, O, exec, pkill waybar || waybar"
  ++ [
    "${mainMod}, M        , exit"
    "${mainMod}, X        , exec, hyprpicker --autocopy"
    "${mainMod}, G        , overview:toggle"
    "${mainMod}, Backspace, exec, hyprlock"
    "${mainMod}, S        , togglespecialworkspace, scratchpad"

    # Screenshot  
    ", PRINT, exec, hyprshot -m output --clipboard-only"
    "${mainMod}, PRINT    , exec, hyprshot -m window --clipboard-only"
    "${mainMod} SHIFT, PRINT, exec, hyprshot -m region --clipboard-only"

    "ALT, PRINT, exec, hyprshot -m output --raw | swappy -f -"
    "${mainMod} ALT, PRINT    , exec, hyprshot -m window --raw | swappy -f -"
    "${mainMod} ALT SHIFT, PRINT, exec, hyprshot -m region --raw | swappy -f -"

    # Move focus
    "${mainMod}, h, movefocus, l"
    "${mainMod}, l, movefocus, r"
    "${mainMod}, k, movefocus, u"
    "${mainMod}, j, movefocus, d"
    
    # Cycle through windows
    "${mainMod}      , Tab, cyclenext       ,"
    "${mainMod}      , Tab, bringactivetotop,"
    "${mainMod} SHIFT, Tab, cyclenext       , prev"
    "${mainMod} SHIFT, Tab, bringactivetotop,"
    
    # Move window
    "${mainMod} SHIFT, h, movewindow, l"
    "${mainMod} SHIFT, l, movewindow, r"
    "${mainMod} SHIFT, k, movewindow, u"
    "${mainMod} SHIFT, j, movewindow, d"

    # Switch to workspace
    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    # Move window to workspace
    "${mainMod} SHIFT, 1, movetoworkspacesilent, 1"
    "${mainMod} SHIFT, 2, movetoworkspacesilent, 2"
    "${mainMod} SHIFT, 3, movetoworkspacesilent, 3"
    "${mainMod} SHIFT, 4, movetoworkspacesilent, 4"
    "${mainMod} SHIFT, 5, movetoworkspacesilent, 5"
    "${mainMod} SHIFT, 6, movetoworkspacesilent, 6"
    "${mainMod} SHIFT, 7, movetoworkspacesilent, 7"
    "${mainMod} SHIFT, 8, movetoworkspacesilent, 8"
    "${mainMod} SHIFT, 9, movetoworkspacesilent, 9"
    "${mainMod} SHIFT, 0, movetoworkspacesilent, 10"
    
    # Move window to special workspace
    "${mainMod} SHIFT, S, movetoworkspacesilent, special:scratchpad"

    # Scroll through existing workspaces
    "${mainMod}, mouse_down, workspace, -1"
    "${mainMod}, mouse_up  , workspace, +1"
    
    # Switch to next/previous workspace
    "${mainMod}, comma , workspace, -1"
    "${mainMod}, period, workspace, +1"
    
    # Move window to next/previous workspace
    "${mainMod} SHIFT, comma , movetoworkspacesilent, -1"
    "${mainMod} SHIFT, period, movetoworkspacesilent, +1"
  ];

  # Mouse keybinds
  bindm = [
    # Move and resize windows
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];
}
