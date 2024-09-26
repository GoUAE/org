{
  lib,
  config,
  ...
}: let
  tunnel_id = "ad09e952-4d29-40a2-9d3c-74138084a1bc";
in {
  systemd.services."cloudflared-tunnel-${tunnel_id}".serviceConfig.Environment = "TUNNEL_ORIGIN_CERT=${config.sops.secrets."cloudflare/certs/chq".path}";

  services.cloudflared = {
    enable = true;
    tunnels.${tunnel_id} = {
      credentialsFile = "/run/secrets/cloudflare/tunnels/uaq";
      default = "http_status:404";
      ingress."codershq.ae" = let
        inherit (config.roles.matrix-homeserver.reverseProxy) virtualHost;
      in
        if lib.hasPrefix ":" virtualHost
        then "http://localhost${virtualHost}"
        else virtualHost;
    };
  };
}
