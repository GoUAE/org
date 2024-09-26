{
  perSystem = {
    l,
    pkgs,
    ...
  }: {
    treefmt.config.projectRootFile = "../flake.nix";
    treefmt.config.programs = {
      statix.enable = true;
      deadnix.enable = true;
      alejandra.enable = true;

      terraform.enable = true;
    };

    devShells.default = pkgs.mkShell {
      packages =
        l.attrValues {
          inherit
            (pkgs)
            sops
            ssh-to-age
            opentofu
            terraform-ls
            ;
        }
        ++ l.optional (pkgs.stdenv.isDarwin) [pkgs.nixos-rebuild];
    };
  };
}
