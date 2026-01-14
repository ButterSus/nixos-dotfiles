{ lib, config, cfg, ... }:
{
  # Environment variables (env)
  env = [
    "XDG_SESSION_TYPE,wayland"
    "MOZ_ENABLE_WAYLAND,1"
    "_JAVA_AWT_WM_NONREPARENTING,1"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "QT_QPA_PLATFORM,wayland"
    "GDK_BACKEND,wayland"
  ];

  # Configure monitor layout
  monitor = [
    "eDP-1   , preferred, auto       , ${builtins.toString cfg.scale}"
    "HDMI-A-1, preferred, auto-up , 1.0"
  ];

  input = {
    kb_options = "grp:win_space_toggle, caps:escape";
    kb_layout = lib.concatStringsSep ", " cfg.layouts;
    follow_mouse = 1;
    touchpad = {
      natural_scroll = false;  # Sorry, not a fan of natural scroll
      disable_while_typing = false;  # I play games!
      tap-and-drag = true;
      drag_lock = 0;  # I hate you, "drag_lock = 2", you've been bullying me for 2 months.
    };
    touchdevice = {
      output = "eDP-1";
    };
    tablet = {
      output = "eDP-1";
    };
  };

  xwayland = {
    force_zero_scaling = true;
  };

  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    # Put this in quotes to prevent nixpkgs from parsing it
    "col.active_border" = "rgb(7287fd) rgb(04a5e5) rgb(1e66f5) rgb(8839ef) 360deg";
    "col.inactive_border" = "rgb(11111b)";
    layout = "master";
  };

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows         , 1, 7 , myBezier"
      "windowsOut      , 1, 7 , default, popin 80%"
      "border          , 1, 10, default"
      "fade            , 1, 7 , default"
      "workspaces      , 1, 6 , default"
      "specialWorkspace, 1, 6 , default, slidevert"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  debug = {
    disable_logs = false;
    disable_scale_checks = true;
  };

  misc = {
    disable_splash_rendering = true;
    # Anime girls prohibited
    disable_hyprland_logo = true;
  };

  exec-once = [ "iio-hyprland" ]
    ++ lib.optionals config.modules.waybar.enable [
      "waybar"
    ];

  workspace = [
    "special:scratchpad, gapsout:40"
  ];

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
  };
}
