{
  inputs,
  lib,
  ...
}: {
  imports = [
    ../secrets.nix

    ../../users/rmu.nix
    ../../users/shaher.nix
    ../../users/gaurav.nix

    inputs.srvos.nixosModules.server

    inputs.srvos.nixosModules.mixins-terminfo
    inputs.srvos.nixosModules.mixins-systemd-boot
  ];

  programs.fish.enable = true;

  services.openssh.settings = {
    MaxSessions = lib.mkDefault 4;
    PasswordAuthentication = false;
  };

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = ["--ssh"];
}
