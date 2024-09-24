{
  description = "GoUAE/org: Documents and Infrastructure relating to the GoUAE organization.";

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake.nixosConfigurations.uaq = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs self;};
        modules = [./hosts/uaq ./users/rmu.nix];
      };

      flake.nixosModules = {
        roles-matrix-bridge = ./modules/roles/matrix-bridge.nix;
        roles-matrix-homeserver = ./modules/roles/matrix-homeserver.nix;
      };

      systems = ["x86_64-linux"];
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    disko.url = "github:nix-community/disko";
    srvos.url = "github:nix-community/srvos/63ea710b10c88f2158251d49eec7cc286cefbd68";
  };
}
