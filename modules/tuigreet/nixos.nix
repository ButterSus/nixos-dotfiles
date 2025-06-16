{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.tuigreet;
in {
  imports = [
    ./home.nix
  ];
  
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      greetd.tuigreet
    ];

    # Configure proper VT allocation
    services.getty.autologinUser = lib.mkForce null; # Disable any autologin
    
    # Set up greetd service
    services.greetd = {
      enable = true;
      vt = 7; # Use virtual terminal 7 (traditional display manager VT)
      settings = {
        default_session = {
          command = let
            tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
            # Create a list of all arguments, filtering out empty ones
            args = lib.filter (arg: arg != "") [
              # Base tuigreet binary path
              tuigreet
              # Optional flags based on settings
              (if cfg.settings.showTime then "--time" else "")
              (if cfg.settings.rememberUser then "--remember" else "")
              (if cfg.settings.rememberLastSession then "--remember-session" else "")
              # Sessions argument if provided
              (if cfg.sessions != [] then "--sessions ${lib.concatStringsSep ":" cfg.sessions}" else "")
            ] 
            # Append any extra args from the config
            ++ cfg.settings.extraArgs;
          in
          # Join all args with spaces, just like Python's " ".join(args)
          lib.concatStringsSep " " args;
          user = "greeter";
        };
      };
    };

    # Fix systemd service configuration as per the reference config
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Prevent errors from spamming on screen
      # Prevent bootlogs from spamming on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
