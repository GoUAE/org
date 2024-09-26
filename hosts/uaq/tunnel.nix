{config, ...}: let
  tunnel = "uaq_tunnel";
in {
  systemd.services."cloudflared-tunnel-${tunnel}".serviceConfig.Environment = "TUNNEL_ORIGIN_CERT=${config.sops.secrets."cloudflare/certs/chq".path}";

  services.cloudflared = {
    enable = true;
    tunnels.${tunnel} = {
      credentialsFile = "/run/secrets/cloudflare/tunnels/uaq";
      default = "http_status:404";
      ingress."codershq.ae" = "http://localhost${config.roles.matrix-homeserver.reverseProxy.virtualHost}";
    };
  };
}
