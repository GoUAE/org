{
  users.users.gaurav = {
    isNormalUser = true;
    description = "Gaurav Gosain";
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keys = [];
  };
}
