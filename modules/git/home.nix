{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.git;

  # Core home configuration for this module
  moduleHomeConfig = {
    assertions = [
      {
        assertion = (cfg.enable && config.modules.sops.enable) -> config.modules.ssh.enable;
        message = "Please enable ssh module.";
      }
    ];

    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;

      # Git config in declarative format
      extraConfig = {
        # Pull configuration
        pull.rebase = true;

        # Rebase configuration
        rebase.missingCommitsCheck = "error";

        # Merge configuration
        merge.conflictstyle = "zdiff3";

        # Push configuration
        push = {
          default = "simple";
          followTags = true;
        };

        # Branch default configuration
        init.defaultBranch = "main";

        # Commit configuration
        commit.verbose = true;

        # Auto conflict resolution
        rerere.enabled = true;

        # Core configuration
        core = {
          pager = "delta";
          editor = if config.modules.nvim.enable then "nvim" else "nano";
          autocrlf = "input";
          excludeFiles = "~/.config/git/ignore";
        };

        # Branch sort configuration
        branch.sort = "-committerdate";

        # GitHub pushing configuration
        "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";

        # Fetch configuration
        fetch.prune = true;

        # Log configuration
        log.date = "iso";

        # Mergetool configuration
        mergetool = {
          keepBackup = false;
          tool = if config.modules.nvim.enable then "nvim" else "nano";
        };

        # HTTP buffer size
        http.postBuffer = 1048576000;

        # Aliases
        alias = {
          save = "!git stash store \"$(git stash create)\"";
          graph = "log --graph --decorate --pretty=oneline --abbrev-commit";
        };
      };

      # Global gitignore settings
      ignores = [
        ".idea"
        "*.orig"
      ];
    };

    # Secrets
    sops.secrets = 
      lib.optionalAttrs config.modules.sops.enable {
        github_id_ed25519 = {
          # Read-only for the user
          mode = "0400";
          path = "/home/${config.primaryUser}/.ssh/github_id_ed25519";
        };
      }
      // lib.optionalAttrs (config.modules.sops.enable && cfg.enableGithubCli) {
        github_pat = {
          mode = "0400";
          path = "/home/${config.primaryUser}/.config/git/github_pat";
        };
      };

    home.shellAliases = lib.optionalAttrs (config.modules.sops.enable && cfg.enableGithubCli) {
      gh = ''GITHUB_TOKEN="$(cat /home/${config.primaryUser}/.config/git/github_pat 2>/dev/null || echo \'\')" ${pkgs.gh}/bin/gh'';
    };

    # WARN: Very unsafe method below, since environment variables can be easily
    # exposed by random program in logs. You get it. You better not do it.

    # programs.bash.initExtra = lib.optionalString 
    #   (config.modules.sops.enable && cfg.enableGithubCli) ''
    #     if [ -f "/home/${config.primaryUser}/.config/git/github_pat" ]; then
    #       export GITHUB_TOKEN="$(cat "/home/${config.primaryUser}/.config/git/github_pat")"
    #     fi
    #   '';
    #
    # programs.zsh.initContent = lib.optionalString
    #   (config.modules.sops.enable && cfg.enableGithubCli && config.modules.zsh.enable) ''
    #     if [ -f "/home/${config.primaryUser}/.config/git/github_pat" ]; then
    #       export GITHUB_TOKEN="$(cat "/home/${config.primaryUser}/.config/git/github_pat")"
    #     fi
    #   '';

    # SSH Configuration
    programs.ssh.extraConfig = lib.optionalString config.modules.sops.enable
      ''
      Host github.com
        HostName github.com
        User git
        IdentityFile /home/${config.primaryUser}/.ssh/github_id_ed25519
        IdentitiesOnly yes
      '';

    # Make sure git config directory exists
    home.file.".config/git/.keep".text = "";
  };

in {
  # Module Options
  options.modules.git = {
    enable = mkEnableOption "Enable Git with configuration";

    userName = mkOption {
      type = types.str;
      default = "Krivoshapkin Eduard";
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      default = null;
      example = "user@example.com";
      description = "Git user email";
    };

    enableGithubCli = mkEnableOption "Enable Github CLI";
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
