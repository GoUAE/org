{
  lib,
  config,
  ...
}: let
  l = lib;
  cfg = config.roles.matrix-homeserver;
in {
  options.roles.matrix-homeserver = {
    domain = l.mkOption {
      description = "The root domain of the server";
      type = l.type.str;
      example = "codershq.ae";
    };

    reverseProxy = {
      enable = l.mkEnableOption "Reverse proxy using Caddy";
      virtualHost = l.mkOption {
        description = "If you are using cloudflare tunnels, leave it as a port. Otherwise, set the domain to be the value.";
        type = l.type.str;
        default = ":26524";
        example = "codershq.ae";
      };
    };
  };

  config = {
    services.matrix-sliding-sync = {
      enable = true;
      environmentFile = config.sops.secrets."matrix/slidingSync".path;
      settings.SYNCV3_SERVER = cfg.domain;
    };

    services.dendrite = {
      enable = true;

      environmentFile = config.sops.secrets."matrix/registrationKey".path;

      settings = {
        global = {
          server_name = cfg.domain;
          private_key = config.sops.secrets."matrix/privateKey".path;
        };

        sync_api.search.enabled = true;
        client_api.registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
      };
    };

    services.caddy.virtualHosts.${cfg.reverseProxy.virtualHost}.extraConfig = l.mkIf cfg.reversProxy.enable ''
      header /.well-known/matrix/* Content-Type application/json
      header /.well-known/matrix/* Access-Control-Allow-Origin *

      reverse_proxy /_matrix/* localhost:8008
      reverse_proxy /sliding-sync/* localhost:8009

      respond /.well-known/matrix/server `{"m.server": "${cfg.domain}:443"}`
      respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://${cfg.domain}"}, "org.matrix.msc3575.proxy": {"url": "https://${cfg.domain}/sliding-sync"}}`
    '';
  };
}
