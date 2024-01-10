{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self inputs;} ({withSystem, ...}: {
      systems = ["x86_64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        py3 = pkgs.python311;
        py3Packages = pkgs.python311Packages;


        awscdk-local = pkgs.callPackage ./awscdk {};
        awscli-local = py3Packages.callPackage ./awscli {};
        terraform-local = py3Packages.callPackage ./terraform {};

        pyEnv =
          py3.withPackages (ps:
            with py3Packages; [
              awscdk-local
              awscli-local
              terraform-local
              cryptography
            ]);
      in {
        devShells.default = pkgs.mkShell {
          name = "Python dev env";
          buildInputs = [
            pyEnv
            pkgs.localstack
          ];
        };

        packages = {
          default = awscli-local;

          awscdk-local = awscdk-local;
          terraform-local = terraform-local;
        };
      };
    });
}
