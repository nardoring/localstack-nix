{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
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

        py3Packages = pkgs.python311Packages;

        awscdk-local = pkgs.callPackage ./awscdk {};
        awscli-local = py3Packages.callPackage ./awscli {};
        terraform-local = py3Packages.callPackage ./terraform {inherit localstack-client;};
        localstack-ext = py3Packages.callPackage ./localstack-ext {inherit localstack;};
        localstack-client = py3Packages.callPackage ./localstack-client {inherit localstack;};
        localstack = py3Packages.callPackage ./localstack {inherit localstack-client;};
      in {
        devShells.default = pkgs.mkShell {
          name = "Python dev env";
          packages = [
            awscdk-local
            awscli-local
            terraform-local
            localstack
            localstack-client
            # pkgs.localstack # use the version we build here, nixpkg broken
          ];
        };

        packages = {
          default = localstack;
          localstack-client = localstack-client;
          localstack-ext = localstack-ext;
          awscli-local = awscli-local;
          awscdk-local = awscdk-local;
          terraform-local = terraform-local;
        };
      };
    });
}
