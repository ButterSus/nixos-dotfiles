{ config, lib, pkgs, isHMStandaloneContext, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.sops;

  # Core home configuration for this module
  moduleHomeConfig = {
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    sops.defaultSopsFile = cfg.defaultSopsFile;
    # This will automatically import SSH keys as age keys
    # sops.age.sshKeyPaths = [ ];
    # This is using an age key that is expected to already be in the filesystem
    sops.age.keyFile = "/home/${config.primaryUser}/.config/sops/age/keys.txt";
    # This will generate a new key if the key specified above does not exist
    sops.age.generateKey = true;
  };

in {
  options.modules.sops = {
    enable = mkEnableOption "Enable sops module";
    
    # This option is a workaround to resolve an issue
    # of using absolute paths in flakes
    defaultSopsFile = mkOption {
      type = types.path;
      description = "Default sops file";
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
    