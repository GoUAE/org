{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets/server.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets."tailscale/authKey" = {};

    secrets."cloudflare/tunnels/uaq" = {
      owner = "cloudflared";
    };

    secrets."cloudflare/certs/chq" = {
      owner = "cloudflared";
    };

    secrets."matrix/registrationKey" = {};
    secrets."matrix/privateKey" = {};

    secrets."matrix/slidingSync" = {};
  };
}
