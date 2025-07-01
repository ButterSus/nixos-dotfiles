{ lib, config, cfg, mainMod, ... }:

{
  # Repetetive keybinds
  binde = [
    # Volume and Brightness
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
  ];

  # Keybinds
  bind = [
    # Volume and Brightness
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

    # Applications
    (lib.optionalString config.modules.kitty.enable
      "${mainMod}, Q, exec, kitty")
    (lib.optionalString config.modules.firefox.enable
      "${mainMod}, B, exec, firefox")
    (lib.optionalString config.modules.fuzzel.enable
      "${mainMod}, D, exec, fuzzel")
    (lib.optionalString config.modules.thunar.enable
      "${mainMod}, E, exec, thunar")
    (lib.optionalString config.modules.materialgram.enable
      "${mainMod}, T, exec, materialgram")
    (lib.optionalString config.modules.wlogout.enable
      "${mainMod}, Z, exec, wlogout")
    (lib.optionalString config.modules.cliphist.enable
      "${mainMod}, W, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")
    (lib.optionalString config.modules.youtube-music.enable
      "${mainMod}, Y, exec, youtube-music")
    
    (lib.optionalString config.modules.qbittorrent.enable
      "${mainMod} SHIFT, Q, exec, qbittorrent")
    (lib.optionalString config.modules.amnezia-vpn.enable
      "${mainMod} SHIFT, A, exec, AmneziaVPN")
    (lib.optionalString config.modules.vesktop.enable
      "${mainMod} SHIFT, D, exec, vesktop")
    (lib.optionalString config.modules.bluetooth.enable
      "${mainMod} SHIFT, O, exec, overskride")
    (lib.optionalString config.modules.whatsie.enable
      "${mainMod} SHIFT, W, exec, whatsie")
    (lib.optionalString config.modules.pipewire.enable
      "${mainMod} SHIFT, P, exec, pwvucontrol")
    (lib.optionalString config.modules.youtube-music.enable
      "${mainMod} SHIFT, Y, exec, youtube-music")

    # MPRIS: Youtube Music shortcuts
  ] ++ (lib.optionals config.modules.youtube-music.enable [
      "${mainMod} CTRL, M     , exec, playerctl --player=YoutubeMusic play-pause"
      "${mainMod} CTRL, comma , exec, playerctl --player=YoutubeMusic previous"
      "${mainMod} CTRL, period, exec, playerctl --player=YoutubeMusic next"
  ]) ++ [

    # Window Actions
    "${mainMod}      , P, pseudo"
    "${mainMod}      , V, togglefloating"
    "${mainMod}      , F, fullscreen, 1"
    "${mainMod} SHIFT, F, fullscreen, 2"
    "${mainMod}      , C, killactive"
    "${mainMod} SHIFT, C, forcekillactive"
    "${mainMod}      , N, togglesplit"
    
    # Hyprland Other Actions
    (lib.optionalString config.modules.waybar.enable
      "${mainMod}, O, exec, pkill waybar || waybar")

    "${mainMod}, M        , exit"
    "${mainMod}, X        , exec, hyprpicker --autocopy"
    "${mainMod}, G        , overview:toggle"
    "${mainMod}, Backspace, exec, hyprlock"
    "${mainMod}, S        , togglespecialworkspace"

    # Screenshot  
    ", PRINT, exec, hyprshot -m output"
    "${mainMod}, PRINT    , exec, hyprshot -m window"
    "${mainMod} SHIFT, PRINT, exec, hyprshot -m region"

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
    "${mainMod} SHIFT, S, movetoworkspacesilent, special"

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
