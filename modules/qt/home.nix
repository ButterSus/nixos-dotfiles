{ config, lib, pkgs, inputs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.qt;
  
  # This is also compatible with qt6ct
  inherit (inputs) catppuccin-qt5ct;
  
  # Get all files from themes directory
  themeFileNames = builtins.attrNames (builtins.readDir "${catppuccin-qt5ct}/themes");
  
  # Create home.file entries for each theme file
  qt5ctThemeFileConfigs = builtins.listToAttrs (map (fileName: {
    name = ".config/qt5ct/colors/${fileName}";
    value = { source = "${catppuccin-qt5ct}/themes/${fileName}"; };
  }) themeFileNames);
  
  qt6ctThemeFileConfigs = builtins.listToAttrs (map (fileName: {
    name = ".config/qt6ct/colors/${fileName}";
    value = { source = "${catppuccin-qt5ct}/themes/${fileName}"; };
  }) themeFileNames);

  themeFileConfigs = qt5ctThemeFileConfigs // qt6ctThemeFileConfigs;

  # Core home configuration for this module
  moduleHomeConfig = {
    # Catppuccin colorscheme
    home.file = themeFileConfigs;
    
    # Home manager's Qt configuration won't allow us to
    # set custom theme, so we won't use it here
    qt.enable = lib.mkForce false;

    home.sessionVariables = {
      # Instead of qt.platformTheme.name = "qtct"
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
    
    # Qt5ct config
    xdg.configFile."qt5ct/qt5ct.conf".text = 
      let
        template = builtins.readFile ./config/qt5ct.conf;
      in
        lib.replaceStrings [ "%USER%" ] [ config.primaryUser ] template;
    
    # Qt6ct config
    xdg.configFile."qt6ct/qt6ct.conf".text = 
      let
        template = builtins.readFile ./config/qt6ct.conf;
      in
        lib.replaceStrings [ "%USER%" ] [ config.primaryUser ] template;
  };

in {
  # Module Options
  options.modules.qt = {
    enable = mkEnableOption "Enable qt module";
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
    