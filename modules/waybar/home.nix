{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.waybar;
  
  workspacesModule = if (config.modules.wayland.activeCompositor == "hyprland") then "hyprland/workspaces"
      else if (config.modules.wayland.activeCompositor == "sway") then "sway/workspaces"
      else builtins.throw "Unknown active compositor: ${config.modules.wayland.activeCompositor}";

  # Core home configuration for this module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "Please enable wayland.";
      }
    ];

    programs.waybar = {
      enable = true;
      style = builtins.readFile ./config/style.css;
      settings = [({
	      layer = "top";
	      position = "top";

	      # Layout
	      # ------

	      modules-left = [
		      workspacesModule
		      "custom/right-arrow-dark"
        ] ++ lib.optionals
          (config.modules.wayland.activeCompositor == "hyprland")
          [
		        "custom/right-arrow-light"
		        "hyprland/language"
		        "custom/right-arrow-dark"
	        ];
	      modules-center = [
		      "custom/left-arrow-dark"
		      "clock#1"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "clock#2"
		      "custom/right-arrow-dark"
		      "custom/right-arrow-light"
		      "clock#3"
		      "custom/right-arrow-dark"
	      ];
	      modules-right = [
		      "custom/left-arrow-dark"
		      "pulseaudio"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "memory"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "cpu"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "battery"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "disk"
		      "custom/left-arrow-light"
		      "custom/left-arrow-dark"
		      "tray"
	      ];

	      # Custom modules
	      # --------------

	      "custom/left-arrow-dark" = {
		      format = "";
		      tooltip = false;
	      };
	      "custom/left-arrow-light" = {
		      format = "";
		      tooltip = false;
	      };
	      "custom/right-arrow-dark" = {
		      format = "";
		      tooltip = false;
	      };
	      "custom/right-arrow-light" = {
		      format = "";
		      tooltip = false;
	      };

	      # Clock
	      # -----

	      "clock#1" = {
		      format = "{:%a}";
		      tooltip = false;
	      };
	      "clock#2" = {
		      format = "{:%H:%M}";
		      tooltip = false;
	      };
	      "clock#3" = {
		      format = "{:%m-%d}";
		      tooltip = false;
	      };

	      pulseaudio = {
		      format = "{icon} {volume:2}%";
		      format-bluetooth = "{icon}  {volume}%";
		      format-muted = "MUTE";
		      format-icons = {
			      headphones = "";
			      default = [ "" "" ];
		      };
		      scroll-step = 5;
		      on-click = "pamixer -t";
		      on-click-right = "pavucontrol";
	      };
	      memory = {
		      interval = 5;
		      format = "Mem {}%";
	      };
	      cpu = {
		      interval = 5;
		      format = "CPU {usage:2}%";
	      };
	      battery = {
		      states = {
			      good = 95;
			      warning = 30;
			      critical = 15;
		      };
		      format = "{icon} {capacity}%";
		      format-icons = [ "" "" "" "" "" ];
	      };
	      disk = {
		      interval = 5;
		      format = "Disk {percentage_used:2}%";
		      path = "/";
	      };
	      tray = {
		      icon-size = 20;
	      };
      } // lib.optionalAttrs
        (config.modules.wayland.activeCompositor == "hyprland")
        {
          "hyprland/language" = {
            format-en = "<span color='#a6e3a1'>en</span>";
            format-ru = "<span color='#74c7ec'>ru</span>";
          };
        }
        // lib.optionalAttrs
        (config.modules.wayland.activeCompositor == "sway")
        {
	        "sway/workspaces" = {
		        disable-scroll = true;
		        format = "{name}";
	        };
        })];
    };
  };

in {
  options.modules.waybar = {
    enable = mkEnableOption "Enable Waybar status bar";
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
