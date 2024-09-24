{
  users.users.rmu = {
    isNormalUser = true;
    description = "Rashid Almheiri";
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEIniejxbTn4cW/0iTk2eLin7ZTQfpCIP3hiNP318kS8 uaq"
    ];
  };
}
