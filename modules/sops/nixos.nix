{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.sops;
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    # System Packages
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

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
}
