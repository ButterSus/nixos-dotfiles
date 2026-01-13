{ config, lib, pkgs, pkgs-recent, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.vscode;

  # Core home configuration for this module
  moduleHomeConfig = { lib, ... }: {
    programs.vscode = {
      enable = true;

      # Its config location actually depends on this package.
      package = cfg.package;

      # Let only NixOS manage extensions
      mutableExtensionsDir = false;

      profiles.default = {
        # List of extensions to install
        extensions = (with pkgs-recent.nix-vscode-extensions.vscode-marketplace; [
          bbenoist.nix
          asvetliakov.vscode-neovim
          catppuccin.catppuccin-vsc-icons
          catppuccin.catppuccin-vsc
          ms-toolsai.jupyter
          hediet.vscode-drawio
          nopeslide.vscode-drawio-plugin-rtl
          nopeslide.vscode-drawio-plugin-wavedrom
          kirozen.dokuwiki
          eamodio.gitlens
          esbenp.prettier-vscode
          usernamehw.errorlens
          gruntfuggly.todo-tree
          jdinhlife.gruvbox
        ]) ++ (with pkgs-recent.vscode-extensions; [
          # Otherwise these extensions require newer vscode version
          github.copilot
          github.copilot-chat
        ]);

        # Removed userSettings and keybindings to make config mutable
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

    # Smart vscode config activation:
    # - If vscode config doesn't exist, copy from dotfiles to ~/.config/vscode-config
    # - Symlink the files to VS Code's config dir
    # Therefore, config is fully mutable
    home.activation.vscodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      config_dir="$HOME/.config/${config.modules.vscode.configDir}/User"
      vscode_config_dir="$HOME/.config/vscode-config"
      dotfiles_dir="$HOME/.config/nixos-dotfiles"
      if [ ! -d "$vscode_config_dir" ]; then
        echo "No VS Code config found, copying from dotfiles..."
        mkdir -p "$vscode_config_dir"
        cp -r "$dotfiles_dir/vscode-config"/* "$vscode_config_dir"/
        chmod -R u+w "$vscode_config_dir"
      fi
      # Symlink the config files
      mkdir -p "$config_dir"
      ln -sf "$vscode_config_dir/settings.json" "$config_dir/settings.json"
      ln -sf "$vscode_config_dir/keybindings.json" "$config_dir/keybindings.json"
    '';
  };

in {
  # Module Options
  options.modules.vscode = {
    enable = mkEnableOption "Enable VsCode module";

    package = mkOption {
      default = pkgs-recent.vscode;
      type = types.package;
    };

    dataDirName = mkOption {
      type = types.str;
      default = ".vscode";
    };

    executableName = mkOption {
      type = types.str;
      default = "code";
    };

    configDir = mkOption {
      type = types.str;
      default = "Code";
      description = "The config directory name for the VS Code-like editor (e.g., 'Code' for VS Code, 'Cursor' for Cursor, 'Windsurf' for Windsurf).";
    };
  };

  # Conditionally apply the configuration
  config = mkIf cfg.enable (
    if isHMStandaloneContext then
      moduleHomeConfig { inherit lib; }
    else
      {
        home-manager.users.${config.primaryUser} = moduleHomeConfig;
      }
  );
}

