{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types recursiveUpdate;
  cfg = config.modules.hyprland;

  inherit (inputs) hyprland Hyprspace;

  mainMod = "SUPER";

  moduleHomeConfig = recursiveUpdate {
    assertions = [
      {
        assertion = cfg.enable -> config.modules.wayland.enable;
        message = "Please enable wayland.";
      }
      {
        assertion = cfg.enable -> config.modules.wayland.activeCompositor == "hyprland";
        message = "Please set wayland.activeCompositor to 'hyprland'.";
      }
    ];

    home.packages = [ pkgs.bc ];

    home.file."/home/${config.primaryUser}/.local/bin/hypr_scale" = {
      text = ''
        #!/usr/bin/env bash
        # Script to adjust monitor scales safely

        # Get current scales
        eDP_scale=$(hyprctl monitors | grep -A 10 "Monitor eDP-1" | grep "scale:" | awk '{print $2}')
        HDMI_scale=$(hyprctl monitors | grep -A 10 "Monitor HDMI-A-1" | grep "scale:" | awk '{print $2}')

        # Function to adjust scale with more granular options
        adjust_scale() {
            local scale=$1
            local direction=$2
            # Scales with finer steps around 1.0 and 1.25
            scales=("0.70" "0.75" "0.80" "0.90" "1.00" "1.10" "1.20" "1.25" "1.30" "1.40" "1.50" "1.60" "1.75" "2.00")
            current_index=-1
            for i in "''${!scales[@]}"; do
                if [ "$scale" = "''${scales[$i]}" ]; then
                    current_index=$i
                    break
                fi
            done
            if [ $current_index -eq -1 ]; then
                # If not found, default to 1.0
                current_index=4  # index of 1.0
            fi
            if [ "$direction" = "up" ]; then
                if [ $current_index -lt $((''${#scales[@]}-1)) ]; then
                    echo "''${scales[$((current_index+1))]}"
                else
                    echo "$scale"
                fi
            elif [ "$direction" = "down" ]; then
                if [ $current_index -gt 0 ]; then
                    echo "''${scales[$((current_index-1))]}"
                else
                    echo "$scale"
                fi
            else
                echo "1.0"
            fi
        }

        if [ "$1" = "up" ]; then
            new_eDP=$(adjust_scale $eDP_scale up)
            new_HDMI=$(adjust_scale $HDMI_scale up)
        elif [ "$1" = "down" ]; then
            new_eDP=$(adjust_scale $eDP_scale down)
            new_HDMI=$(adjust_scale $HDMI_scale down)
        else
            new_eDP=${builtins.toString cfg.scale}
            new_HDMI=1.0
        fi

        hyprctl keyword monitor "eDP-1,preferred,auto,$new_eDP"
        hyprctl keyword monitor "HDMI-A-1,preferred,auto-up,$new_HDMI"

        # Reload hyprpaper to rescale wallpaper (common workaround from Hyprland issues)
        pkill hyprpaper; hyprpaper &
      '';
      executable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = cfg.xwayland.enable;
      systemd = {
        enable = true;
        # Fix systemd services
        variables = [ "--all" ];
      };
      settings = import ./config/settings.nix { inherit lib config cfg; } //
                 import ./config/windowrules.nix //
                 import ./config/keybinds.nix { inherit lib config cfg mainMod; };
      plugins = [
        Hyprspace.packages.${pkgs.system}.Hyprspace
      ];
    };
  } (import ./config/services.nix { inherit lib pkgs cfg; });

in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable Hyprland Wayland compositor";

    xwayland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable XWayland support";
      };
    };

    layouts = mkOption {
      type = types.listOf types.str;
      default = [ "us" ];
      description = "List of keyboard layouts";
    };

    backgrounds = {
      hyprpaper = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            url = mkOption {
              type = types.nullOr types.str;
              example = "https://wallpaperswide.com/download/just_chillin-wallpaper-1920x1080.jpg";
              description = "URL for the hyprpaper background image";
            };

            hash = mkOption {
              type = types.nullOr types.str;
              example = "sha256-quI/tSunJFmBpCEfHnWj6egfQN5rpOq/BSggDxb3mtc=";
              description = "SHA256 hash of the hyprpaper background image";
            };
          };
        });
        default = null;
        description = "Configuration for hyprpaper background";
      };

      hyprlock = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            url = mkOption {
              type = types.nullOr types.str;
              example = "https://wallpaperswide.com/download/spongebob_house_patrick-wallpaper-1920x1080.jpg";
              description = "URL for the hyprlock background image";
            };

            hash = mkOption {
              type = types.nullOr types.str;
              example = "sha256-E5mnXfyIiNW3QtWS9Hb1lhYDvTuDU5Edw965yoOTDZ8=";
              description = "SHA256 hash of the hyprlock background image";
            };
          };
        });
        default = null;
        description = "Configuration for hyprlock background";
      };
    };

    scale = mkOption {
      type = types.float;
      default = 1.0;
      description = "Scale for eDP-1 monitor";
    };

    cursor-size = mkOption {
      type = types.int;
      default = 16;
      description = "Cursor size";
    };
  };

  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}
