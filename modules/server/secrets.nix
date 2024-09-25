{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../secrets/server.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets."tailscale/authKey" = {};
    secrets."cloudflare/tunnels/uaq" = {};

    secrets."matrix/slidingSync" = {};
    secrets."matrix/registrationKey" = {};
    secrets."matrix/privateKey" = {};
  };
}
