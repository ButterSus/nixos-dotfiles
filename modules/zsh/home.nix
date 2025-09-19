{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.zsh;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      oh-my-zsh = {
        enable = true;
        plugins = cfg.extraPluginsOhMyZsh;
        theme = "ys";
        extraConfig = ''
          zstyle ':completion:*' insert-tab false
        '';
      };
    };
  };

in {
  # Module Options
  options.modules.zsh = {
    enable = mkEnableOption "Enable ZShell module";

    extraPlugins = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "Extra plugins to add to zsh";
    };

    extraPluginsOhMyZsh = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra plugins to add to oh-my-zsh";
    };
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
    
