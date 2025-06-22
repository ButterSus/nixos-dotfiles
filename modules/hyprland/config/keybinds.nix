{ mainMod }:
{
  bind = [
    # Applications
    "${mainMod}, Q, exec, kitty"
    "${mainMod}, B, exec, firefox"
    "${mainMod}, D, exec, fuzzel"
    
    # Window Actions
    "${mainMod}      , P, pseudo"
    "${mainMod}      , V, togglefloating"
    "${mainMod}      , F, fullscreen, 1"
    "${mainMod} SHIFT, F, fullscreen, 2"
    "${mainMod}      , C, killactive"
    "${mainMod} SHIFT, C, forcekillactive"
    "${mainMod}      , N, togglesplit"
    
    # Hyprland Other Actions
    "${mainMod}, M        , exit"
    "${mainMod}, O        , exec, killall waybar || waybar"
    "${mainMod}, X        , exec, hyprpicker --autocopy"
    "${mainMod}, G        , overview:toggle"
    "${mainMod}, Backspace, exec, hyprlock"

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
  
  bindm = [
    # Move and resize windows
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];
}
