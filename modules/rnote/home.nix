{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.rnote;

  inherit (inputs) dracula-gtk-theme-rnote;

  # Core home configuration for this module
  moduleHomeConfig = {
    xdg.configFile."rnote-env/gtk-4.0" = {
      source = dracula-gtk-theme-rnote + "/gtk-4.0";
    };

    # Feel free to extend it using this tool:
    # https://github.com/nix-community/dconf2nix
    dconf.settings = {
      "com/github/flxzt/rnote" = {
        color-scheme = "force-dark";
        engine-config = builtins.toJSON {
          document = {
            format = {
              show_borders = false;
              show_origin_indicator = false;
            };
            background = { 
              color = {
                r = 0.094;
                g = 0.094;
                b = 0.145;
                a = 1;
              };
              pattern = "grid";
              pattern_size = [ 32 32 ];
              pattern_color = {
                r = 0.118;
                g = 0.118;
                b = 0.18;
                a = 1;
              };
            };
            layout = "infinite";
            snap_positions = false;
          };
          pens_config = {
            brush_config = {
              style = "solid";
              solid_options = {
                stroke_width = 2.0;
              };
            };
            selector_config = {
              style = "polygon";
              resize_lock_aspectratio = true;
            };
            eraser_config = {
              width = 4.0;
            };
          };
          import_prefs = {
            pdf_import_prefs = {
              page_width_perc = 100;
              page_spacing = "continuous";
              pages_type = "vector";
              bitmap_scalefactor = 1.8;
              page_borders = true;
              adjust_document = false;
            };
          };
        };
        inertial-scrolling = true;
        show-scrollbars = false;

        # Brush sizes
        brush-width-1 = 2.0;
        brush-width-2 = 4.0;
        brush-width-3 = 6.0;

        eraser-width-1 = 4.0;
        eraser-width-2 = 9.0;
        eraser-width-3 = 24.0;
      };
    };
  };

in {
  # Module Options
  options.modules.rnote = {
    enable = mkEnableOption "Enable Rnote module";
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
    
