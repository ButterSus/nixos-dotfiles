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
        plugins = [ "gradle" ];
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
    
