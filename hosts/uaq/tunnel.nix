{
  lib,
  config,
  ...
}: {
  services.cloudflared = {
    enable = true;
    tunnels."uaq" = {
      credentialsFile = "/run/secrets/cloudflare/tunnels/uaq";
      default = "http_status:404";
      ingress."codershq.ae" = let
        inherit (config.roles.matrix-homeserver.reverseProxy) virtualHost;
      in
        if lib.hasPrefix ":" virtualHost
        then "localhost${virtualHost}"
        else virtualHost;
    };
  };
}
