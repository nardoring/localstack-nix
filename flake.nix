{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          python3 = prev.python311;
          python3Packages = prev.python311Packages;
        })
      ];
    };

    awscli-local = pkgs.python3Packages.callPackage ./awscli {};
    terraform-local = pkgs.python3Packages.callPackage ./terraform {};
    awscdk-local = pkgs.callPackage ./awscdk {};

    localstack-nix = pkgs.buildEnv {
      name = "localstack-nix";
      paths = [
        awscli-local
        awscdk-local
        terraform-local

        pkgs.awscli
        pkgs.localstack
        pkgs.terraform
      ];
    };
  in {
    inherit localstack-nix;
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        localstack-nix
      ];
    };

    packages."x86_64-linux".default = localstack-nix;
    formatter.${system} = pkgs.alejandra;
  };
}
