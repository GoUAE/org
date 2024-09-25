{
  description = "GoUAE/org: Documents and Infrastructure relating to the GoUAE organization.";

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        {perSystem = {lib, ...}: {_module.args.l = lib // builtins;};}

        ./dev
        inputs.treefmt-nix.flakeModule
      ];

      flake.nixosConfigurations.uaq = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs self;};
        modules = [./hosts/uaq];
      };

      flake.nixosModules = {
        server = ./modules/server;

        roles-matrix-bridge = ./modules/roles/matrix-bridge.nix;
        roles-matrix-homeserver = ./modules/roles/matrix-homeserver.nix;
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    disko.url = "github:nix-community/disko";
    srvos.url = "github:nix-community/srvos/63ea710b10c88f2158251d49eec7cc286cefbd68";

    sops-nix.url = "github:Mic92/sops-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
}
