{ config, lib, pkgs, pkgs-recent, inputs, isHMStandaloneContext, ... }:

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
      package = pkgs-recent.vesktop;

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
          BetterFolders.enabled = true;
          BetterSettings.enabled = true;
          BlurNSFW.enabled = true;
          CrashHandler.enabled = true;
          CustomRPC.enabled = true;
          FakeNitro.enabled = true;
          FriendsSince.enabled = true;
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          NoF1.enabled = true;
          NoServerEmojis.enabled = true;
          PlainFolderIcon.enabled = true;
          ServerInfo.enabled = true;
          ServerListIndicators.enabled = true;
          ShikiCodeblocks.enabled = true;
          ShowHiddenChannels.enabled = true;
          ShowHiddenThings.enabled = true;
          SilentTyping.enabled = true;
          TypingIndicator.enabled = true;
          Unindent.enabled = true;
          UserVoiceShow.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
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
    
