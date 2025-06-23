{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.vesktop;
  
  inherit (inputs) catppuccin-discord;

  # Get all files from the themes directory
  themeFileNames = builtins.attrNames (builtins.readDir "${catppuccin-discord}/themes");
  
  # Create home.file entries for each theme file
  themeFileConfigs = builtins.listToAttrs (map (fileName: {
    name = ".config/vesktop/themes/${fileName}";
    value = { source = "${catppuccin-discord}/themes/${fileName}"; };
  }) themeFileNames);

  # Core home configuration for this module
  moduleHomeConfig = {
    home.file = themeFileConfigs;

    programs.vesktop = {
      enable = true;

      settings = {
        arRPC = true;
        # Catppuccin colors
        splashBackground = "#181825";
        splashColor = "#cdd6f4";
      };
      
      # This is reduntant code, since vencord will find themes
      # automatically, no need to set them.

      # vencord.themes = builtins.listToAttrs (map (fileName: {
      #   name = fileName;
      #   value = "${catppuccin-discord}/themes/${fileName}";
      # }) themeFileNames);

      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        disableMinSize = true;
        plugins = {
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          FakeNitro.enabled = true;
        };

        # Catppuccin theme
        enabledThemes = [ "mocha.theme.css" ];
      };
    };
  };

in {
  # Module Options
  options.modules.vesktop = {
    enable = mkEnableOption "Enable Vesktop module";
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
    