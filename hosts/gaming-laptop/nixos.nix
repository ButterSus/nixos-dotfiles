{ config, lib, pkgs, ... }:

{
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      iverilog
    ];

    # My internal partition
    fileSystems."/media/recordings" = {
      device = "/dev/disk/by-uuid/2eb3790e-d83f-4ecc-9e4a-675a88b9d5c5";
      fsType = "ext4";
      options = [ # If you don't have this options attribute, it'll default to "defaults" 
        # boot options for fstab. Search up fstab mount options you can use
        "users" # Allows any user to mount and unmount
        "nofail" # Prevent system from failing if this drive doesn't mount
      ];
    };

    # Allow user to write to internal partition
    systemd.services.fix-recordings-ownership = {
      description = "Set ownership of recordings directory";
      after = [ "media-recordings.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/chown ${config.primaryUser}:users /media/recordings";
        RemainAfterExit = true;
      };
    };
  };
}
