{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.modules.zapret;
  
in {
  # Import home.nix
  imports = [
    ./home.nix
  ];

  config = mkIf cfg.enable {
    services.zapret = {
      enable = true;
      params = [
        # Discord voice channels & screen sharing
        "--filter-udp=50000-65535"
        "--filter-l7=discord,stun"
        "--dpi-desync=fake,tamper"
        "--dpi-desync-any-protocol"
        "--new"

        # TCP port 80 filter (HTTP) - Youtube & Discord
        "--filter-tcp=80"
        "--dpi-desync=fake,split2"
        "--dpi-desync-autottl=2"
        "--dpi-desync-fooling=md5sig"
        "--new"

        # TCP port 443 filter (HTTPS) - Youtube & Discord
        "--filter-tcp=443"
        "--dpi-desync=fake"
        "--dpi-desync-autottl=2"
        "--dpi-desync-fooling=badseq"
        "--dpi-desync-fake-tls-mod=rnd,rndsni,padencap"

        # UDP port 443 filter (QUIC) - Youtube
        "--filter-udp=443"
        "--dpi-desync=fake"
        "--dpi-desync-udplen-increment=10"
        "--dpi-desync-repeats=6"
        "--dpi-desync-udplen-pattern=0xDEADBEEF"
      ];
      udpSupport = true;
      udpPorts = [
        "50000:65535"
        "443"
      ];
      configureFirewall = true;
    };
  };
}
