{
  lib,
  self,
  config,
  ...
}: {
  imports = [
    ./tunnel.nix

    self.nixosModules.server
    # self.nixosModules.roles-matrix-bridge
    self.nixosModules.roles-matrix-homeserver
  ];

  services.caddy.enable = true;

  roles.matrix-homeserver.domain = "codershq.ae";
  roles.matrix-homeserver.reverseProxy.enable = true;

  time.timeZone = "Asia/Dubai";

  # TODO(Installation): Enable
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "uaq";
  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "eno1";
    networkConfig.DHCP = "ipv4";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c1fd00f1-9eee-4081-96d8-daee263f0bd2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AA29-543C";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  boot.initrd.systemd.network.networks."10-uplink" =
    config.systemd.network.networks."10-uplink";

  boot.kernelModules = ["kvm-intel"];
  boot.initrd.availableKernelModules = [
    "ahci"
    "ehci_pci"
    "megaraid_sas"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "24.05";
}
