{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self inputs;} ({...}: {
      systems = ["x86_64-linux"];

      perSystem = {system, ...}: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        py3Packages = pkgs.python311Packages;

        awscdk-local = pkgs.callPackage ./awscdk {};
        awscli-local = py3Packages.callPackage ./awscli {};

        localstack-ext = py3Packages.callPackage ./localstack-ext {inherit localstack;};
        localstack-client = py3Packages.callPackage ./localstack-client {inherit localstack;};
        localstack = py3Packages.callPackage ./localstack {inherit localstack-client;};

        terraform-local = py3Packages.callPackage ./terraform {inherit localstack-client;};

        wordcloud = py3Packages.callPackage ./wordcloud {};
        visions = py3Packages.callPackage ./visions {};
        ydata-profiling = py3Packages.callPackage ./ydata-profiling {inherit wordcloud visions;};

        pyEnv = pkgs.python311.withPackages (ps: [localstack-client localstack-ext ydata-profiling]);
      in {
        devShells.default = pkgs.mkShell {
          name = "dev env";
          packages = [
            awscdk-local
            awscli-local
            localstack
            pyEnv
          ];
        };

        packages = {
          default = localstack;
          localstack-client = localstack-client;
          localstack-ext = localstack-ext;
          awscli-local = awscli-local;
          awscdk-local = awscdk-local;
          terraform-local = terraform-local;
          ydata-profiling = ydata-profiling;
        };
      };
    });
}
