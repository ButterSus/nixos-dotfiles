{ config, lib, pkgs, pkgs-recent, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.vscode;

  # Core home configuration for this module
  moduleHomeConfig = {
    programs.vscode = {
      enable = true;

      # Its config location actually depends on this package.
      package = cfg.package;
      
      # Let only NixOS manage extensions
      mutableExtensionsDir = false;

      profiles.default = {
        # List of extensions to install
        extensions = with pkgs-recent.vscode-extensions; [
          bbenoist.nix
          asvetliakov.vscode-neovim
          catppuccin.catppuccin-vsc-icons
          catppuccin.catppuccin-vsc
        ];
      
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
        };

        keybindings = [
          # Replace <ctrl-F> with <ctrl-alt-F> in terminal
          {
            key = "ctrl+alt+f";
            command = "workbench.action.terminal.focusFind";
            when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocusInAny && terminalHasBeenCreated || terminalFocusInAny && terminalProcessSupported";
          }
          {
            key = "ctrl+f";
            command = "-workbench.action.terminal.focusFind";
            when = "terminalFindFocused && terminalHasBeenCreated || terminalFindFocused && terminalProcessSupported || terminalFocusInAny && terminalHasBeenCreated || terminalFocusInAny && terminalProcessSupported";
          }
        ];
      };
    };
    
    # OS-Keyring fix: https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://medium.com/%40logins_39559/visual-studio-code-gnome-keyring-fix-for-codeium-and-probably-other-things-d3815217ef54&ved=2ahUKEwjjgorb34mOAxXCZ0EAHe6GHMQQFnoECBQQAQ&usg=AOvVaw1YYWRg8vb7N3DV2UsrETky
    home.file."${cfg.dataDirName}/argv.json".text = builtins.toJSON ({
      # This field is needed to prevent error from vscode
      enable-crash-reporter = true;
    } // lib.optionalAttrs config.modules.gnome-keyring.enable {
      # This is the actual fix
      password-store = "gnome-libsecret";
    });
  };

in {
  # Module Options
  options.modules.vscode = {
    enable = mkEnableOption "Enable VsCode module";

    package = mkOption {
      default = pkgs.vscode;
      type = types.package;
    };

    dataDirName = mkOption {
      type = types.str;
      default = ".vscode";
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

